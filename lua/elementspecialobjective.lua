-- Keep hunt objective type
local get_objective_original = ElementSpecialObjective.get_objective
function ElementSpecialObjective:get_objective(...)
	local objective = get_objective_original(self, ...)

	if objective and (self._is_AI_SO or string.begins(self._values.so_action, "AI")) then
		local objective_type = string.sub(self._values.so_action, 4)
		if objective_type == "hunt" then
			objective.type = objective_type
		end
	end

	return objective
end
