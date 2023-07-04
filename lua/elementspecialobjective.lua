-- Keep position saved for AI SOs to fix some older map scripting
Hooks:PreHook(ElementSpecialObjective, "_finalize_values", "sh__finalize_values", function (self, values)
	if self:value("so_action"):begins("AI") and values.path_style == "destination" then
		self._AI_SO_pos = values.position
	end
end)


-- Keep hunt and search as actual objective types instead of making it defend_area
-- This is done to be able to differentiate between those objectives and make hunt work properly (search is currently unused)
local get_objective_original = ElementSpecialObjective.get_objective
function ElementSpecialObjective:get_objective(...)
	local objective = get_objective_original(self, ...)

	if objective and (self._is_AI_SO or string.begins(self._values.so_action, "AI")) then
		local objective_type = self._values.so_action:sub(4)
		if objective_type == "hunt" or objective_type == "search" then
			objective.type = objective_type
		end

		if not objective.nav_seg and self._AI_SO_pos then
			objective.nav_seg = managers.navigation:get_nav_seg_from_pos(self._AI_SO_pos)
			objective.area = managers.groupai:state():get_area_from_nav_seg_id(objective.nav_seg)
		end
	end

	return objective
end
