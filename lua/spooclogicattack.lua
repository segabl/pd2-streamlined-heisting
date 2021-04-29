-- More consistent Cloaker attacks. Why would Cloakers not be allowed to start a sprint attack when another cop is in the way?
function SpoocLogicAttack._upd_spooc_attack(data, my_data)
	local focus_enemy = data.attention_obj

	if focus_enemy.nav_tracker and focus_enemy.is_person and focus_enemy.criminal_record and not focus_enemy.criminal_record.status and not my_data.spooc_attack and AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction and data.spooc_attack_timeout_t < data.t and focus_enemy.verified_dis < (my_data.want_to_take_cover and 1500 or 2500) and not data.unit:movement():chk_action_forbidden("walk") and not SpoocLogicAttack._is_last_standing_criminal(focus_enemy) and not focus_enemy.unit:movement():zipline_unit() and focus_enemy.unit:movement():is_SPOOC_attack_allowed() then
		local flying_strike

		if ActionSpooc.chk_can_start_flying_strike(data.unit, focus_enemy.unit) then
			flying_strike = true
		elseif focus_enemy.verified and ActionSpooc.chk_can_start_spooc_sprint(data.unit, focus_enemy.unit) then
			flying_strike = false
		end

		if flying_strike ~= nil then
			if my_data.attention_unit ~= focus_enemy.u_key then
				CopLogicBase._set_attention(data, focus_enemy)
				my_data.attention_unit = focus_enemy.u_key
			end

			local action = SpoocLogicAttack._chk_request_action_spooc_attack(data, my_data, flying_strike)
			if action then
				my_data.spooc_attack = {
					start_t = data.t,
					target_u_data = focus_enemy,
					action = action
				}
				return true
			end
		end
	end
end


-- Force Cloakers to stand up before starting an attack
Hooks:PreHook(SpoocLogicAttack, "_chk_request_action_spooc_attack", "sh___chk_request_action_spooc_attack", function (data)
	data.unit:movement():action_request({
		body_part = 4,
		type = "stand"
	})
end)
