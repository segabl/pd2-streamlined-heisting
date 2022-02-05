-- Registering all phalanx units as soon as they spawn breaks this code
-- since it relies on the current registered amount to determine the initial phalanx position.
-- Instead of relying on that we just use a simple counter that we increment each time the function is called
CopLogicPhalanxMinion.initial_pos_count = 0

function CopLogicPhalanxMinion.calc_initial_phalanx_pos(own_pos, objective)
	if not objective.angle then
		local center_pos = managers.groupai:state()._phalanx_center_pos
		local total_minion_amount = tweak_data.group_ai.phalanx.minions.amount
		local fixed_angle = (own_pos:angle(center_pos) + 180) % 360
		local angle_to_move_to = CopLogicPhalanxMinion._get_next_neighbour_angle(CopLogicPhalanxMinion.initial_pos_count, total_minion_amount, fixed_angle)
		objective.angle = angle_to_move_to
		objective.pos = CopLogicPhalanxMinion._calc_pos_on_phalanx_circle(center_pos, angle_to_move_to, total_minion_amount)

		CopLogicPhalanxMinion.initial_pos_count = (CopLogicPhalanxMinion.initial_pos_count + 1) % total_minion_amount
	end

	return objective.pos
end
