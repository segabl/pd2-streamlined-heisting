-- Only allow positioning when group is fully spawned
local _chk_request_action_walk_to_optimal_pos_original = ShieldLogicAttack._chk_request_action_walk_to_optimal_pos
function ShieldLogicAttack._chk_request_action_walk_to_optimal_pos(data, ...)
	if not data.group or data.group.has_spawned then
		_chk_request_action_walk_to_optimal_pos_original(data, ...)
	end
end


-- Stop current optimal positioning attempt when receiving new logic
Hooks:PreHook(ShieldLogicAttack, "exit", "sh_exit", function (data)
	ShieldLogicAttack._cancel_optimal_attempt(data, data.internal_data)
end)
