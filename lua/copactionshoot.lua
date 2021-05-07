local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_set_l = mvector3.set_length
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_cross = mvector3.cross
local mvec3_rot = mvector3.rotate_with
local mrot_axis_angle = mrotation.set_axis_angle
local temp_vec1 = Vector3()
local temp_rot1 = Rotation()
local math_min = math.min
local math_max = math.max
local math_lerp = math.lerp


function CopActionShoot:_stop_firing()
	self._is_single_shot = nil
	if not self._autofiring then
		return
	end
	self._autofiring = nil
	self._autoshots_fired = nil
	self._weapon_base:stop_autofire()
	self._ext_movement:play_redirect("up_idle")
end


Hooks:PostHook(CopActionShoot, "on_attention", "sh_on_attention", function (self)
	self._clear_los = false
	self._next_vis_ray_t = -100
	self._common_data._line_of_sight_t = self._common_data._line_of_sight_t or -100
	local same_att = self._attention and self._common_data._old_att_unit == self._attention.unit
	if not same_att and not self._w_usage_tweak.no_autofire_stop then
		-- Stop autofiring on target change so aim delay isn't skipped
		self:_stop_firing()
	end
	if self._attention and self._attention.unit then
		-- Preserve old line of sight timer and attention unit to avoid redoing focus and aim delay on target change to same unit
		self._common_data._line_of_sight_t = same_att and self._common_data._line_of_sight_t or -100
		self._common_data._old_att_unit = self._attention.unit
		if self._shoot_history then
			self._shoot_history.focus_delay = nil
		end
	end
	self._verif_slotmask = managers.slot:get_mask("AI_visibility")
end)


-- Thanks to the messy implementation of this function, we have to replace it completely, no hook can save us here
function CopActionShoot:update(t)
	local vis_state = self._ext_base:lod_stage() or 4
	if vis_state ~= 1 then
		if self._skipped_frames < vis_state * 3 then
			self._skipped_frames = self._skipped_frames + 1
			return
		else
			self._skipped_frames = 1
		end
	end

	local shoot_from_pos = self._shoot_from_pos
	local ext_anim = self._ext_anim
	local target_vec, target_dis, autotarget, target_pos

	if self._attention then
		target_pos, target_vec, target_dis, autotarget = self:_get_target_pos(shoot_from_pos, self._attention, t)
		local tar_vec_flat = temp_vec1
		mvec3_set(tar_vec_flat, target_vec)
		mvec3_set_z(tar_vec_flat, 0)
		mvec3_norm(tar_vec_flat)
		local fwd = self._common_data.fwd
		local fwd_dot = mvec3_dot(fwd, tar_vec_flat)
		if self._turn_allowed then
			local active_actions = self._common_data.active_actions
			local queued_actions = self._common_data.queued_actions
			if (not active_actions[2] or active_actions[2]:type() == "idle") and (not queued_actions or not queued_actions[1] and not queued_actions[2]) and not self._ext_movement:chk_action_forbidden("walk") then
				local fwd_dot_flat = mvec3_dot(tar_vec_flat, fwd)
				if fwd_dot_flat < 0.96 then
					local spin = tar_vec_flat:to_polar_with_reference(fwd, math.UP).spin
					local new_action_data = {
						body_part = 2,
						type = "turn",
						angle = spin
					}
					self._ext_movement:action_request(new_action_data)
				end
			end
		end
		target_vec = self:_upd_ik(target_vec, fwd_dot, t)
	end

	if not ext_anim.reload and not ext_anim.equip and not ext_anim.melee then
		if self._weapon_base:clip_empty() then
			self:_stop_firing()

			if not ext_anim.base_no_reload then
				local res = CopActionReload._play_reload(self)
				if res then
					self._machine:set_speed(res, self._reload_speed)
				end
				if Network:is_server() then
					managers.network:session():send_to_peers("reload_weapon_cop", self._unit)
				end
			end
		elseif self._autofiring then
			if not target_vec or not self._common_data.allow_fire then
				self:_stop_firing()
			else
				local falloff, i_range = self:_get_shoot_falloff(target_dis, self._falloff)
				local dmg_buff = self._unit:base():get_total_buff("base_damage")
				local dmg_mul = (1 + dmg_buff) * falloff.dmg_mul

				local new_target_pos = self._shoot_history and self:_get_unit_shoot_pos(t, target_pos, target_dis, self._w_usage_tweak, falloff, i_range, autotarget)
				mvec3_dir(target_vec, shoot_from_pos, new_target_pos or target_pos)

				local fired
				if self._is_single_shot then
					fired = self._weapon_base:singleshot(shoot_from_pos, target_vec, dmg_mul, self._shooting_player, nil, nil, nil, self._attention.unit)
				else
					fired = self._weapon_base:trigger_held(shoot_from_pos, target_vec, dmg_mul, self._shooting_player, nil, nil, nil, self._attention.unit)
				end

				if fired then
					if fired.hit_enemy and fired.hit_enemy.type == "death" and self._unit:unit_data().mission_element then
						self._unit:unit_data().mission_element:event("killshot", self._unit)
					end
					if (self._is_single_shot or not ext_anim.recoil) and vis_state == 1 and not ext_anim.base_no_recoil and not ext_anim.move then
						self._ext_movement:play_redirect(self._is_single_shot and "recoil_single" or "recoil_auto")
					end
					if not self._autofiring or self._autoshots_fired >= self._autofiring - 1 then
						self:_stop_firing()
						self._shoot_t = t + (self._common_data.is_suppressed and 1.5 or 1) * math_lerp(falloff.recoil[1], falloff.recoil[2], self:_pseudorandom())
					else
						self._autoshots_fired = self._autoshots_fired + 1
					end
				end
			end
		elseif target_vec and self._common_data.allow_fire and self._shoot_t < t and self._mod_enable_t < t then
			-- The original code didn't really do what it was supposed to do, as the target_pos gets updated to the
			-- last seen pos after a while of no line of sight to the target. This breaks focus_delay and aim_delay as it only makes
			-- sense to apply them based on line of sight to the real target position
			local shoot = true
			if autotarget or self._shooting_husk_player or Network:is_server() then
				if self._next_vis_ray_t < t then
					if self._shooting_husk_player then
						self._next_vis_ray_t = t + 2
					end

					self._clear_los = self._attention.unit and true

					local shoot_hist = self._shoot_history
					local no_los_dur = t - self._common_data._line_of_sight_t
					if self._clear_los and shoot_hist then
						-- Apply focus delay after 2 seconds of no los
						if no_los_dur > 2 and not shoot_hist.focus_delay then
							shoot_hist.focus_start_t = t
							shoot_hist.focus_delay = self._w_usage_tweak.focus_delay
						end
						-- Apply aim delay after 4 seconds of no los
						if no_los_dur > 4 and not self._waiting_for_aim_delay then
							local aim_delay_minmax = self._w_usage_tweak.aim_delay
							local lerp_dis = math_min(1, target_dis / self._falloff[#self._falloff].r)
							local aim_delay = math_lerp(aim_delay_minmax[1], aim_delay_minmax[2], lerp_dis)
							if self._common_data.is_suppressed then
								aim_delay = aim_delay * 1.5
							end
							self._shoot_t = t + aim_delay
							self._waiting_for_aim_delay = true
							if self._shooting_husk_player then
								self._next_vis_ray_t = self._shoot_t
							end
							shoot = false
						end
					end
					self._last_vis_check_status = shoot
				else
					shoot = self._last_vis_check_status
				end
			end

			if self._common_data.char_tweak.no_move_and_shoot and self._common_data.ext_anim and self._common_data.ext_anim.move then
				shoot = false
				self._shoot_t = t + (self._common_data.char_tweak.move_and_shoot_cooldown or 1)
			end

			if shoot then
				self._waiting_for_aim_delay = false

				local melee

				if autotarget and (not self._common_data.melee_countered_t or t - self._common_data.melee_countered_t > 15) and target_dis < 130 and self._w_usage_tweak.melee_speed and self._melee_timeout_t < t then
					melee = self:_chk_start_melee(target_vec, target_dis, autotarget, target_pos)
				end

				if not melee then
					local number_of_rounds
					local falloff = self:_get_shoot_falloff(target_dis, self._falloff)
					local autofire_rounds = falloff.autofire_rounds or self._w_usage_tweak.autofire_rounds
					if self._automatic_weap and falloff.autofire_rounds then
						local diff = autofire_rounds[2] - autofire_rounds[1]
						number_of_rounds = math.ceil(autofire_rounds[1] + self:_pseudorandom() * diff)
					elseif self._automatic_weap and self._w_usage_tweak.autofire_rounds then
						local f = math_min(1, math_max(0, (target_dis - self._falloff[1].r) / (self._falloff[#self._falloff].r - self._falloff[1].r) - 0.15 + self:_pseudorandom() * 0.3))
						number_of_rounds = math.ceil(math_lerp(autofire_rounds[2], autofire_rounds[1], f))
					else
						number_of_rounds = 1
					end

					self._is_single_shot = number_of_rounds == 1
					self._autofiring = number_of_rounds
					self._autoshots_fired = 0
					if number_of_rounds > 1 then
						self._weapon_base:start_autofire(number_of_rounds < 4 and number_of_rounds)
					end
				end
			end
		end
	end

	if self._clear_los then
		self._common_data._line_of_sight_t = t
	end

	if self._ext_anim.base_need_upd then
		self._ext_movement:upd_m_head_pos()
	end
end


function CopActionShoot:_get_unit_shoot_pos(t, pos, dis, w_tweak, falloff, i_range, shooting_local_player)
	local shoot_hist = self._shoot_history
	local focus_delay, focus_prog

	if shoot_hist.focus_delay then
		focus_delay = (shooting_local_player and self._attention.unit:character_damage():focus_delay_mul() or 1) * shoot_hist.focus_delay
		focus_prog = focus_delay > 0 and (t - shoot_hist.focus_start_t) / focus_delay
		if not focus_prog or focus_prog >= 1 then
			shoot_hist.focus_delay = nil
			focus_prog = 1
		end
	else
		focus_prog = 1
	end

	local hit_chances = falloff.acc
	local hit_chance = math_lerp(hit_chances[1], hit_chances[2], focus_prog) * self._unit:character_damage():accuracy_multiplier()

	if self._common_data.is_suppressed then
		hit_chance = hit_chance * 0.5
	end

	if self._common_data.active_actions[2] and self._common_data.active_actions[2]:type() == "dodge" then
		hit_chance = hit_chance * self._common_data.active_actions[2]:accuracy_multiplier()
	end

	if math.random() < hit_chance then
		mvec3_set(shoot_hist.m_last_pos, pos)
	else
		mvec3_set(temp_vec1, pos)
		mvec3_sub(temp_vec1, self._shoot_from_pos)

		local error_vec = Vector3()

		mvec3_cross(error_vec, temp_vec1, math.UP)
		mrot_axis_angle(temp_rot1, temp_vec1, math.random(360))
		mvec3_rot(error_vec, temp_rot1)

		local miss_min_dis = shooting_local_player and 31 or 150
		local error_vec_len = miss_min_dis + w_tweak.spread * math.random() + w_tweak.miss_dis * math.random() * (1 - focus_prog)

		mvec3_set_l(error_vec, error_vec_len)
		mvec3_add(error_vec, pos)
		mvec3_set(shoot_hist.m_last_pos, error_vec)

		return error_vec
	end
end


-- Interpolate between entries in the FALLOFF table to prevent sudden changes in damage etc
function CopActionShoot:_get_shoot_falloff(target_dis, falloff)
	local i = #falloff
	local data = falloff[i]
	for i_range, range_data in ipairs(falloff) do
		if target_dis < range_data.r then
			i = i_range
			data = range_data
			break
		end
	end
	if i == 1 or target_dis > data.r then
		return data, i
	else
		local prev_data = falloff[i - 1]
		local t = (target_dis - prev_data.r) / (data.r - prev_data.r)
		local n_data = {
			dmg_mul = math_lerp(prev_data.dmg_mul, data.dmg_mul, t),
			r = target_dis,
			acc = { math_lerp(prev_data.acc[1], data.acc[1], t), math_lerp(prev_data.acc[2], data.acc[2], t) },
			recoil = { math_lerp(prev_data.recoil[1], data.recoil[1], t), math_lerp(prev_data.recoil[2], data.recoil[2], t) },
			autofire_rounds = prev_data.autofire_rounds and data.autofire_rounds and {
				math_lerp(prev_data.autofire_rounds[1], data.autofire_rounds[1], t),
				math_lerp(prev_data.autofire_rounds[2], data.autofire_rounds[2], t)
			},
			mode = data.mode
		}
		return n_data, i
	end
end
