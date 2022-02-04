local mrot_set_axis_angle = mrotation.set_axis_angle
local mvec_add = mvector3.add
local mvec_copy = mvector3.copy
local mvec_dis_sq = mvector3.distance_sq
local mvec_mul = mvector3.multiply
local mvec_norm = mvector3.normalize
local mvec_rot = mvector3.rotate_with
local mvec_set = mvector3.set
local mvec_set_static = mvector3.set_static
local mvec_sub = mvector3.subtract
local tmp_rot = Rotation()
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()
local tmp_vec4 = Vector3()
local offset_vec = Vector3(0, 0, 30)
local floor_vec = Vector3(0, 0, -1000)

-- Improve the fire placement and visuals to match the damage range more accurately
-- Fire effect placement is now properly based on radius and weird fire generation on walls should be fixed
-- Added performance optimizations regarding updating effect positions, no need to check effect position every frame
function EnvironmentFire:on_spawn(data, normal, user_unit, added_time, range_multiplier)
	self._unit:set_visible(false)

	local custom_params = {
		camera_shake_max_mul = 4,
		sound_muffle_effect = true,
		effect = data.effect_name,
		sound_event = data.sound_event,
		feedback_range = data.range * 2,
		sound_event_burning = data.sound_event_burning,
		sound_event_impact_duration = data.sound_event_impact_duration,
		sound_event_duration = data.burn_duration + added_time
	}
	self._data = data
	self._normal = normal
	self._added_time = added_time
	self._range_multiplier = range_multiplier
	self._user_unit = user_unit
	self._burn_duration = data.burn_duration + added_time
	self._burn_tick_counter = 0
	self._burn_tick_period = data.burn_tick_period
	-- In vanilla this is set to the actual range of the fire, however, it is used to check damage at every individual fire effect, which makes no sense
	self._range = 100
	self._curve_pow = data.curve_pow
	self._damage = data.damage
	self._player_damage = data.player_damage
	self._fire_dot_data = deep_clone(data.fire_dot_data)
	self._fire_alert_radius = data.fire_alert_radius
	self._is_molotov = data.is_molotov
	-- Vanilla code spawns fire effect at 2 times the actual range defined in data, so accommodate for that
	local radius = data.range * range_multiplier * 2
	self._damage_radius = radius + self._range
	local effect_spacing = math.sqrt(4 * (self._range ^ 2))
	local needed_effects = math.ceil(radius / effect_spacing)
	local effect_offset = radius / needed_effects
	local slotmask = managers.slot:get_mask("molotov_raycasts")

	local floor_ray = World:raycast("ray", self._unit:position(), self._unit:position() - math.UP * 1000, "slot_mask", slotmask)
	if not floor_ray then
		self._burn_duration = 0
		return
	end

	self:_spawn_effect(floor_ray.position, floor_ray.normal, floor_ray.unit, floor_ray.body, custom_params)

	local rotation_offset = tmp_rot
	local tangent, offset, from, to = tmp_vec1, tmp_vec2, tmp_vec3, tmp_vec4

	mvec_set_static(tangent, floor_ray.normal.z, floor_ray.normal.z, -floor_ray.normal.x - floor_ray.normal.y)
	if tangent.x == 0 and tangent.z == 0 then
		mvec_set_static(tangent, -floor_ray.normal.y - floor_ray.normal.z, floor_ray.normal.x, floor_ray.normal.x)
	end
	mvec_norm(tangent)

	for i = 1, needed_effects do
		mvec_set(offset, tangent)
		mvec_mul(offset, effect_offset * i)

		local num_effects = 5 + i * 2
		mrot_set_axis_angle(rotation_offset, floor_ray.normal, 360 / num_effects)
		for j = 1, num_effects do
			mvec_rot(offset, rotation_offset)

			mvec_set(from, floor_ray.position)
			mvec_add(from, offset_vec)

			mvec_set(to, from)
			mvec_add(to, offset)

			local ray = World:raycast("ray", from, to, "slot_mask", slotmask)
			if not ray then
				mvec_set(from, to)

				mvec_set(to, from)
				mvec_add(to, floor_vec)

				ray = World:raycast("ray", from, to, "slot_mask", slotmask)
			end

			if ray then
				self:_spawn_effect(ray.position, ray.normal, ray.unit, ray.body, custom_params)
			end
		end
	end

	self._floor_ray = floor_ray
end

-- Helper function to spawn a fire patch
function EnvironmentFire:_spawn_effect(pos, normal, unit, body, custom_params)
	managers.fire:play_sound_and_effects(pos, normal, self._range, custom_params, self._molotov_damage_effect_table)

	local i = #self._molotov_damage_effect_table
	self._molotov_damage_effect_table[i].body = body
	self._molotov_damage_effect_table[i].body_initial_position = body and body:position()
	self._molotov_damage_effect_table[i].effect_initial_position = pos
	self._molotov_damage_effect_table[i].effect_current_position = mvec_copy(pos)
	self._molotov_damage_effect_table[i].check_position = alive(unit) and unit:anim_state_machine() and true
end

function EnvironmentFire:update(unit, t, dt)
	if self._burn_duration <= 0 then
		self._unit:set_slot(0)
	else
		self._burn_duration = self._burn_duration - dt
		self._burn_tick_counter = self._burn_tick_counter + dt

		for _, damage_effect_entry in pairs(self._molotov_damage_effect_table) do
			if damage_effect_entry.check_position and alive(damage_effect_entry.body) then
				local body_pos = damage_effect_entry.body:position()
				if mvec_dis_sq(body_pos, damage_effect_entry.effect_initial_position) >= 0.01 then
					mvec_sub(body_pos, damage_effect_entry.body_initial_position)

					local effect_new_location = damage_effect_entry.effect_current_position
					mvec_set(effect_new_location, damage_effect_entry.effect_initial_position)
					mvec_add(effect_new_location, body_pos)

					World:effect_manager():move(damage_effect_entry.effect_id, effect_new_location)
				end
			end
		end

		if self._burn_tick_period < self._burn_tick_counter then
			self:_do_damage()
		end
	end
end

-- Optimize this, no need to check every single fire effect, check from the initial fire origin
-- Since fire spreads equally from the center in all directions, and detect_and_give_dmg already checks for obstructions,
-- we can just use the general radius instead of checking every single fire effect individually
function EnvironmentFire:_do_damage()
	local player_damage
	local slot_mask = managers.slot:get_mask("explosion_targets")

	local player_pos = managers.player:player_unit() and managers.player:player_unit():position()
	local pos = tmp_vec1
	mvec_set(pos, self._floor_ray.position)
	mvec_add(pos, offset_vec)

	if player_pos and mvec_dis_sq(pos, player_pos) <= self._damage_radius ^ 2 then
		local obstructed = World:raycast("ray", pos, player_pos, "slot_mask", slot_mask)
		if obstructed then
			mvec_add(player_pos, offset_vec)
			obstructed = World:raycast("ray", pos, player_pos, "slot_mask", slot_mask)
		end
		player_damage = not obstructed and self._player_damage
	end

	if player_damage then
		managers.fire:give_local_player_dmg(pos, self._damage_radius, player_damage)
	end

	if Network:is_server() then
		managers.fire:detect_and_give_dmg({
			player_damage = 0,
			push_units = false,
			hit_pos = pos,
			range = self._damage_radius,
			collision_slotmask = slot_mask,
			damage = self._damage,
			user = self._user_unit,
			owner = self._unit,
			alert_radius = self._fire_alert_radius,
			fire_dot_data = self._fire_dot_data,
			is_molotov = self._is_molotov
		})
	end

	self._burn_tick_counter = 0
end
