-- When an escape zone is activated, mark that area for reinforcement spawngroups
-- This is done by checking if an ElementAreaTrigger executes an ElementMissionEnd,
-- if it does, it is considered the escape zone trigger
Hooks:PostHook(ElementAreaTrigger, "on_set_enabled", "sh_on_set_enabled", function (self)
	for _, params in pairs(self._values.on_executed) do
		if getmetatable(self:get_mission_element(params.id)) == ElementMissionEnd then
			if self._values.enabled then
				managers.groupai:state():set_area_min_police_force(self._id, 1, self._values.position)
			else
				managers.groupai:state():set_area_min_police_force(self._id)
			end
			return
		end
	end
end)
