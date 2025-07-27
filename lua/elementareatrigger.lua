if Network:is_client() then
	return
end


-- When an escape or loot secure zone is activated, mark that area for reinforcement spawngroups
-- This is done by checking the list of elements an ElementAreaTrigger executes for ElementMissionEnd or ElementCarry,
-- If it contains any of these, it is considered the escape zone/loot secure trigger
local function check_executed_objects(trigger, current, checked)
	if not current or checked[current] then
		return
	end

	checked[current] = true

	if (trigger._values.enabled and true or false) == (trigger._reinforce_point_enabled and true or false) then
		return
	end

	for _, params in pairs(current._values.on_executed) do
		local element = current:get_mission_element(params.id)
		local element_class = getmetatable(element)
		if element_class == ElementMissionEnd or element_class == ElementCarry and element._values.operation == "secure" then
			local force = trigger._values.enabled and 3 or nil
			trigger._reinforce_point_enabled = trigger._values.enabled
			if trigger._values.use_shape_element_ids then
				for _, shape_element in pairs(trigger._shape_elements) do
					if shape_element._values.enabled then
						managers.groupai:state():set_area_min_police_force(shape_element._id, force, shape_element._values.position)
					end
				end
			else
				managers.groupai:state():set_area_min_police_force(trigger._id, force, trigger._values.position)
			end
			local type = element_class == ElementMissionEnd and "Escape" or "Loot secure"
			if trigger._values.enabled then
				StreamHeist:log("%s zone activated, enabling reinforce groups in its area", type)
			else
				StreamHeist:log("%s zone deactivated, disabling reinforce groups in its area", type)
			end
			return true
		elseif check_executed_objects(trigger, element, checked) then
			return true
		end
	end
end

Hooks:PostHook(ElementAreaTrigger, "on_set_enabled", "sh_on_set_enabled", function(self)
	check_executed_objects(self, self, {})
end)
