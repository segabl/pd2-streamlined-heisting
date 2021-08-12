-- Update this function with the changes made in CopLogicAttack._upd_aim
function TaserLogicAttack._upd_aim(data, my_data, reaction)
	if my_data.tasing then
		return
	end

	local focus_enemy = data.attention_obj
	local verified = focus_enemy and focus_enemy.verified
	local nearly_visible = focus_enemy and focus_enemy.nearly_visible
	local expected_pos = focus_enemy and (focus_enemy.last_verified_pos or focus_enemy.verified_pos or focus_enemy.criminal_record and focus_enemy.criminal_record.pos)
	local tase = focus_enemy and focus_enemy.reaction == AIAttentionObject.REACT_SPECIAL_ATTACK

	local aim, shoot = true, true
	if not tase then
		aim, shoot = CopLogicAttack._check_aim_shoot(data, my_data, focus_enemy, verified, nearly_visible, expected_pos)
	elseif not data.unit:movement():chk_action_forbidden("walk") then
		-- Stop moving when we're about to tase
		data.unit:brain():action_request({
			body_part = 2,
			type = "idle"
		})
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

		if not data.unit:anim_data().reload and not data.unit:movement():chk_action_forbidden("action") then
			if tase and not focus_enemy.unit:movement():zipline_unit() then
				local tase_action = {
					body_part = 3,
					type = "tase"
				}

				if data.unit:brain():action_request(tase_action) then
					my_data.tasing = {
						target_u_data = focus_enemy,
						target_u_key = focus_enemy.u_key,
						start_t = data.t
					}

					CopLogicAttack._cancel_charge(data, my_data)
					managers.groupai:state():on_tase_start(data.key, focus_enemy.u_key)
				end
			elseif not my_data.shooting then
				my_data.shooting = data.unit:brain():action_request({
					body_part = 3,
					type = "shoot"
				})
			end
		end
	else
		if my_data.shooting then
			my_data.shooting = not data.unit:brain():action_request({
				body_part = 3,
				type = "idle"
			})
		end

		if my_data.attention_unit then
			CopLogicBase._reset_attention(data)
			my_data.attention_unit = nil
		end
	end

	CopLogicAttack.aim_allow_fire(shoot, aim, data, my_data)
end
