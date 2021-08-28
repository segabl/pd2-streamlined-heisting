-- When an escape or loot secure zone is activated, mark that area for reinforcement spawngroups
-- This is done by checking the list of elements an ElementAreaTrigger executes for ElementMissionEnd or ElementCarry,
-- If it contains any of these, it is considered the escape zone/loot secure trigger
Hooks:PostHook(ElementAreaTrigger, "on_set_enabled", "sh_on_set_enabled", function (self)
	if managers.groupai:state():whisper_mode() then
		return
	end
	for _, params in pairs(self._values.on_executed) do
		local element = self:get_mission_element(params.id)
		local element_meta = getmetatable(element)
		if element_meta == ElementMissionEnd or element_meta == ElementCarry and element._values.operation == "secure" then
			if self._values.enabled then
				managers.groupai:state():set_area_min_police_force(self._id, 3, self._values.position)
				StreamHeist:log(element_meta == ElementMissionEnd and "Escape" or "Loot secure", "zone activated, enabling reinforce groups in its area")
			else
				managers.groupai:state():set_area_min_police_force(self._id)
				StreamHeist:log(element_meta == ElementMissionEnd and "Escape" or "Loot secure", "zone deactivated, disabling reinforce groups in its area")
			end
			return
		end
	end
end)
