local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_dot = mvector3.dot
local mvec3_norm = mvector3.normalize
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()

-- Remove some of the strict conditions for enemies shooting while on the move
-- This will result in enemies opening fire more likely while moving
function CopLogicAttack._upd_aim(data, my_data)
	local shoot, aim, expected_pos
	local focus_enemy = data.attention_obj
	local verified = focus_enemy and focus_enemy.verified
	local nearly_visible = focus_enemy and focus_enemy.nearly_visible

	if focus_enemy and AIAttentionObject.REACT_AIM <= focus_enemy.reaction then

		-- The original running check was inaccurate, it returned true if haste was set to run, not if the character was actually currently running
		local running = data.unit:anim_data().run or my_data.advancing and my_data.advancing._cur_vel and my_data.advancing._cur_vel > 300
		local time_since_verification = focus_enemy.verified_t and data.t - focus_enemy.verified_t or math.huge

		if verified or nearly_visible then
			if AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction then
				local last_sup_t = data.unit:character_damage():last_suppression_t()
				local weapon_range = data.internal_data.weapon_range or { close = 1000, far = 4000 }
				local firing_range = running and weapon_range.close or weapon_range.far

				if last_sup_t and data.t - last_sup_t < 7 * (running and 0.5 or 1) * (verified and 1 or 0.5) then
					shoot = true
				elseif verified and focus_enemy.verified_dis < firing_range then
					shoot = true
				elseif verified and focus_enemy.criminal_record and focus_enemy.criminal_record.assault_t and data.t - focus_enemy.criminal_record.assault_t < 2 then
					shoot = true
				end

				if not shoot and my_data.attitude == "engage" then
					if my_data.firing and time_since_verification < 4 then
						shoot = true
					elseif alive(focus_enemy.unit) and focus_enemy.unit.movement and focus_enemy.unit:movement() and focus_enemy.unit:movement():nav_tracker() then
						data.brain:search_for_path_to_unit("hunt" .. tostring(my_data.key), focus_enemy.unit)
					end
				end

				aim = aim or shoot or focus_enemy.verified_dis < firing_range
			else
				aim = true
			end
		else
			aim = not running or time_since_verification < math.lerp(5, 1, math.max(0, focus_enemy.verified_dis - 500) / 600)
			if aim and my_data.shooting and AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction and time_since_verification < (running and 2 or 4) then
				shoot = true
			end

			if not shoot then
				expected_pos = CopLogicAttack._get_expected_attention_position(data, my_data)
			end

			if not aim and expected_pos then
				mvec3_set(temp_vec1, expected_pos)
				mvec3_sub(temp_vec1, data.m_pos)
				mvec3_set_z(temp_vec1, 0)
				local watch_pos_dis = mvec3_norm(temp_vec1)
				if watch_pos_dis < 500 then
					aim =  true
				elseif watch_pos_dis < 1000 then
					local walk_to_pos = data.unit:movement():get_walk_to_pos()
					local walk_vec = temp_vec2
					mvec3_set(walk_vec, walk_to_pos)
					mvec3_sub(walk_vec, data.m_pos)
					mvec3_set_z(walk_vec, 0)
					mvec3_norm(walk_vec)
					aim = mvec3_dot(temp_vec1, walk_vec) > 0.85
				end
			end
		end
	end

	if not aim and data.char_tweak.always_face_enemy and focus_enemy and AIAttentionObject.REACT_COMBAT <= focus_enemy.reaction then
		aim = true
	end

	if aim or shoot then
		if expected_pos then
			if my_data.attention_unit ~= expected_pos then
				CopLogicBase._set_attention_on_pos(data, mvector3.copy(expected_pos))
				my_data.attention_unit = mvector3.copy(expected_pos)
			end
		elseif verified or nearly_visible then
			if my_data.attention_unit ~= focus_enemy.u_key then
				CopLogicBase._set_attention(data, focus_enemy)
				my_data.attention_unit = focus_enemy.u_key
			end
		else
			local look_pos = focus_enemy.last_verified_pos or focus_enemy.verified_pos
			if my_data.attention_unit ~= look_pos then
				CopLogicBase._set_attention_on_pos(data, mvector3.copy(look_pos))
				my_data.attention_unit = mvector3.copy(look_pos)
			end
		end

		if not my_data.shooting and not my_data.spooc_attack and not data.unit:anim_data().reload and not data.unit:movement():chk_action_forbidden("action") then
			local shoot_action = {
				body_part = 3,
				type = "shoot"
			}
			if data.unit:brain():action_request(shoot_action) then
				my_data.shooting = true
			end
		end
	else
		if (focus_enemy or expected_pos) and data.logic.chk_should_turn(data, my_data) then
			CopLogicAttack._chk_request_action_turn_to_enemy(data, my_data, data.m_pos, expected_pos or (verified or nearly_visible) and focus_enemy.m_pos or focus_enemy.verified_pos)
		end

		if my_data.shooting then
			local new_action
			if data.unit:anim_data().reload then
				new_action = {
					body_part = 3,
					type = "reload"
				}
			else
				new_action = {
					body_part = 3,
					type = "idle"
				}
			end
			data.unit:brain():action_request(new_action)
		end

		if my_data.attention_unit then
			CopLogicBase._reset_attention(data)
			my_data.attention_unit = nil
		end
	end

	CopLogicAttack.aim_allow_fire(shoot, aim, data, my_data)
end
