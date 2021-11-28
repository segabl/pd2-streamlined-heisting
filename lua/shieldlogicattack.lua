-- Fix incorrect path starting position
Hooks:PreHook(ShieldLogicAttack, "_chk_request_action_walk_to_optimal_pos", "sh__chk_request_action_walk_to_optimal_pos", function (data, my_data)
	CopLogicAttack._correct_path_start_pos(data, my_data.optimal_path)
end)
