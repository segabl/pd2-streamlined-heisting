-- Remove some of the strict conditions for enemies shooting while on the move
-- This will result in enemies opening fire more likely while moving
-- Also greatly simplified the function
function CopLogicAttack._upd_aim(data, my_data)
	local shoot, aim
	local focus_enemy = data.attention_obj
	local verified = focus_enemy and focus_enemy.verified
	local nearly_visible = focus_enemy and focus_enemy.nearly_visible
	local expected_pos = focus_enemy and (focus_enemy.last_verified_pos or focus_enemy.verified_pos or focus_enemy.criminal_record and focus_enemy.criminal_record.pos)

	if focus_enemy and AIAttentionObject.REACT_AIM <= focus_enemy.reaction then

		local advancing = my_data.advancing and not my_data.advancing:stopping()
		local running = data.unit:anim_data().run or advancing and my_data.advancing._cur_vel and my_data.advancing._cur_vel > 300
		local time_since_verification = focus_enemy.verified_t and data.t - focus_enemy.verified_t or math.huge
		local weapon_range = data.internal_data.weapon_range or { close = 1000, far = 4000 }
		local firing_range = running and weapon_range.close or weapon_range.far

		if verified or nearly_visible then
			if AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction then
				local last_sup_t = data.unit:character_damage():last_suppression_t()

				if last_sup_t and data.t - last_sup_t < 7 * (running and 0.5 or 1) * (verified and 1 or 0.5) then
					shoot = true
				elseif verified and focus_enemy.verified_dis < firing_range then
					shoot = true
				elseif verified and focus_enemy.criminal_record and focus_enemy.criminal_record.assault_t and data.t - focus_enemy.criminal_record.assault_t < (running and 2 or 4) then
					shoot = true
				elseif my_data.attitude == "engage" and my_data.firing and time_since_verification < 4 then
					shoot = true
				end
			end

			aim = shoot or focus_enemy.verified_dis < firing_range
		elseif expected_pos then
			aim = not advancing or time_since_verification < math.lerp(4, 1, focus_enemy.verified_dis / firing_range)
			shoot = aim and my_data.shooting and AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction and time_since_verification < (running and 2 or 4)
		end
	end

	if not aim and data.char_tweak.always_face_enemy and focus_enemy and AIAttentionObject.REACT_COMBAT <= focus_enemy.reaction then
		aim = true
	end

	if aim or shoot then
		if verified or nearly_visible then
			if my_data.attention_unit ~= focus_enemy.u_key then
				CopLogicBase._set_attention(data, focus_enemy)
				my_data.attention_unit = focus_enemy.u_key
			end
		elseif expected_pos then
			if my_data.attention_unit ~= expected_pos then
				CopLogicBase._set_attention_on_pos(data, mvector3.copy(expected_pos))
				my_data.attention_unit = mvector3.copy(expected_pos)
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
			CopLogicAttack._chk_request_action_turn_to_enemy(data, my_data, data.m_pos, (verified or nearly_visible) and focus_enemy.m_pos or expected_pos)
		end

		if my_data.shooting then
			data.unit:brain():action_request({
				body_part = 3,
				type = data.unit:anim_data().reload and "reload" or "idle"
			})
		end

		if my_data.attention_unit then
			CopLogicBase._reset_attention(data)
			my_data.attention_unit = nil
		end
	end

	CopLogicAttack.aim_allow_fire(shoot, aim, data, my_data)
end
