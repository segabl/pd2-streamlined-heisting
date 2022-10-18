local mvec_add = mvector3.add
local mvec_dir = mvector3.direction
local mvec_mul = mvector3.multiply
local mvec_set = mvector3.set
local mvec_set_z = mvector3.set_z
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local offset_vec = Vector3(0, 0, 30)

-- Fix fire damage update resetting DoT grace and not triggering DoT damage until no more fire DoT is added
-- Instead of updating the damage received time, update the DoT duration with the difference between new and old received time
Hooks:OverrideFunction(FireManager, "_add_doted_enemy", function (self, enemy_unit, fire_damage_received_time, weapon_unit, dot_length, dot_damage, user_unit, is_molotov)
	if not self._doted_enemies then
		return
	end

	local dot_info = nil
	for _, cur_dot_info in ipairs(self._doted_enemies) do
		if cur_dot_info.enemy_unit == enemy_unit then
			dot_info = cur_dot_info
			break
		end
	end

	if dot_info then
		dot_info.weapon_unit = weapon_unit
		dot_info.user_unit = user_unit
		dot_info.is_molotov = is_molotov
		dot_info.dot_damage = dot_damage
		dot_info.dot_length = dot_length + fire_damage_received_time - dot_info.fire_damage_received_time
	else
		dot_info = {
			fire_dot_counter = 0,
			enemy_unit = enemy_unit,
			fire_damage_received_time = fire_damage_received_time,
			weapon_unit = weapon_unit,
			dot_length = dot_length,
			dot_damage = dot_damage,
			user_unit = user_unit,
			is_molotov = is_molotov
		}

		table.insert(self._doted_enemies, dot_info)

		local has_delayed_info = false
		for index, delayed_dot in pairs(self.predicted_dot_info) do
			if enemy_unit == delayed_dot.enemy_unit then
				dot_info.sound_source = delayed_dot.sound_source
				dot_info.fire_effects = delayed_dot.fire_effects
				table.remove(self.predicted_dot_info, index)
				has_delayed_info = true
			end
		end

		if not has_delayed_info then
			self:_start_enemy_fire_effect(dot_info)
			self:start_burn_body_sound(dot_info)
		end
	end

	self:check_achievemnts(enemy_unit, fire_damage_received_time)
end)


-- Remove splinter calculation (not really needed for fire) and optimize function
Hooks:OverrideFunction(FireManager, "detect_and_give_dmg", function (self, params)
	local hit_pos = params.hit_pos
	local slotmask = params.collision_slotmask
	local user_unit = params.user
	local dmg = params.damage
	local player_dmg = params.player_damage or dmg
	local range = params.range
	local damage_range = params.damage_range or range
	local alert_filter = params.alert_filter or managers.groupai:state():get_unit_type_filter("civilians_enemies")
	local owner = params.owner
	local fire_dot_data = params.fire_dot_data
	local alert_radius = params.alert_radius or 3000
	local is_molotov = params.is_molotov
	local obstruction_slotmask = managers.slot:get_mask("molotov_raycasts")
	local count_cops = 0
	local count_gangsters = 0
	local count_civilians = 0
	local count_cop_kills = 0
	local count_gangster_kills = 0
	local count_civilian_kills = 0
	local results = {}
	local characters_hit = {}
	local hit_units = {}
	local splinters = {
		hit_pos
	}

	local player = managers.player:player_unit()
	if alive(player) and player_dmg ~= 0 then
		player:character_damage():damage_fire({
			variant = "fire",
			position = hit_pos,
			range = damage_range,
			damage = player_dmg,
			ignite_character = params.ignite_character
		})
	end

	local alert_unit = user_unit
	if alive(alert_unit) and alert_unit:base() and alert_unit:base().thrower_unit then
		alert_unit = alert_unit:base():thrower_unit()
	end

	managers.groupai:state():propagate_alert({
		"fire",
		hit_pos,
		alert_radius,
		alert_filter,
		alert_unit
	})

	mvec_set(tmp_vec1, hit_pos)
	mvec_set(tmp_vec2, hit_pos)
	mvec_set_z(tmp_vec1, tmp_vec1.z - damage_range)
	mvec_set_z(tmp_vec2, tmp_vec2.z + range)
	local bodies = World:find_bodies("intersect", "cylinder", tmp_vec1, tmp_vec2, damage_range, slotmask)

	local dir, hit_pos_clamped = tmp_vec1, tmp_vec2
	local do_self_damage = not alive(user_unit) or not user_unit:base() or not user_unit:base()._tweak_table
	for _, hit_body in pairs(bodies) do
		local hit_unit = hit_body:unit()
		local hit_unit_key = hit_unit:key()
		local character = not characters_hit[hit_unit_key] and hit_unit:character_damage() and hit_unit:character_damage().damage_fire
		local apply_dmg = hit_body:extension() and hit_body:extension().damage

		if (character or apply_dmg) and (do_self_damage or hit_unit ~= user_unit) then
			local body_pos = hit_body:center_of_mass()
			mvec_add(body_pos, offset_vec)
			local len = mvec_dir(dir, body_pos, hit_pos)
			mvec_set(hit_pos_clamped, dir)
			mvec_mul(hit_pos_clamped, math.max(0, len - math.min(range, 100)))
			mvec_add(hit_pos_clamped, body_pos)
			mvec_set_z(hit_pos_clamped, hit_pos.z)

			if not World:raycast("ray", body_pos, hit_pos_clamped, "slot_mask", obstruction_slotmask, "report") then
				hit_units[hit_unit_key] = hit_unit

				if apply_dmg then
					self:_apply_body_damage(true, hit_body, user_unit, dir, dmg)
				end

				if character then
					characters_hit[hit_unit_key] = true

					if hit_unit:base() and hit_unit:base()._tweak_table and not hit_unit:character_damage():dead() then
						local tweak_id = hit_unit:base()._tweak_table
						if CopDamage.is_civilian(tweak_id) then
							count_civilians = count_civilians + 1
						elseif CopDamage.is_gangster(tweak_id) then
							count_gangsters = count_gangsters + 1
						elseif managers.enemy:is_enemy(hit_unit) then
							count_cops = count_cops + 1
						end
					end

					local dead_before = hit_unit:character_damage():dead()
					hit_unit:character_damage():damage_fire({
						variant = "fire",
						damage = math.max(dmg, 1),
						attacker_unit = user_unit,
						weapon_unit = owner,
						ignite_character = params.ignite_character,
						col_ray = self._col_ray or {
							position = hit_body:position(),
							ray = dir
						},
						is_fire_dot_damage = false,
						fire_dot_data = fire_dot_data,
						is_molotov = is_molotov
					})

					if not dead_before and hit_unit:base() and hit_unit:base()._tweak_table and hit_unit:character_damage():dead() then
						local tweak_id = hit_unit:base()._tweak_table
						if CopDamage.is_civilian(tweak_id) then
							count_civilian_kills = count_civilian_kills + 1
						elseif CopDamage.is_gangster(tweak_id) then
							count_gangster_kills = count_gangster_kills + 1
						elseif managers.enemy:is_enemy(hit_unit) then
							count_cop_kills = count_cop_kills + 1
						end
					end
				end
			end
		end
	end

	if owner then
		results.count_cops = count_cops
		results.count_gangsters = count_gangsters
		results.count_civilians = count_civilians
		results.count_cop_kills = count_cop_kills
		results.count_gangster_kills = count_gangster_kills
		results.count_civilian_kills = count_civilian_kills
	end

	return hit_units, splinters, results
end)
