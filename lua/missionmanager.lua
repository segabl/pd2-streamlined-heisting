if Global.editor_mode then
	StreamHeist:log("Editor mode is active, mission script changes disabled")
	return
end


-- Add custom mission script changes and triggers for specific levels
MissionManager.mission_script_patch_funcs = {
	values = function(self, element, data)
		for k, v in pairs(data) do
			element._values[k] = v
			StreamHeist:log("%s value \"%s\" has been set to \"%s\"", element:editor_name(), k, tostring(v))
		end
	end,

	on_executed = function(self, element, data)
		for _, v in pairs(data) do
			local new_element = self:get_element_by_id(v.id)
			if new_element then
				local val, i = table.find_value(element._values.on_executed, function(val) return val.id == v.id end)
				if v.remove then
					if val then
						table.remove(element._values.on_executed, i)
						StreamHeist:log("Removed element %s from on_executed of %s", new_element:editor_name(), element:editor_name())
					end
				elseif val then
					val.delay = v.delay or 0
					val.delay_rand = v.delay_rand or 0
					StreamHeist:log("Modified element %s in on_executed of %s", new_element:editor_name(), element:editor_name())
				else
					table.insert(element._values.on_executed, v)
					StreamHeist:log("Added element %s to on_executed of %s", new_element:editor_name(), element:editor_name())
				end
			else
				StreamHeist:error("Mission script element %u could not be found", v.id)
			end
		end
	end,

	pre_func = function(self, element, data)
		Hooks:PreHook(element, "on_executed", "sh_on_executed_pre_func_" .. element:id(), data)
		StreamHeist:log("%s hooked as pre function call trigger", element:editor_name())
	end,

	func = function(self, element, data)
		Hooks:PostHook(element, "on_executed", "sh_on_executed_func_" .. element:id(), data)
		StreamHeist:log("%s hooked as function call trigger", element:editor_name())
	end,

	reinforce = function(self, element, data)
		if Network:is_client() then
			return
		end
		Hooks:PostHook(element, "on_executed", "sh_on_executed_reinforce_" .. element:id(), function()
			StreamHeist:log("%s executed, toggled %u reinforce point(s)", element:editor_name(), #data)
			for _, v in pairs(data) do
				managers.groupai:state():set_area_min_police_force(v.name, v.force, v.position)
			end
		end)
		StreamHeist:log("%s hooked as reinforce trigger for %u area(s)", element:editor_name(), #data)
	end,

	difficulty = function(self, element, data)
		if Network:is_client() then
			return
		end
		Hooks:PostHook(element, "on_executed", "sh_on_executed_difficulty_" .. element:id(), function()
			StreamHeist:log("%s executed, set difficulty to %.2g", element:editor_name(), data)
			managers.groupai:state():set_difficulty(data)
		end)
		StreamHeist:log("%s hooked as difficulty change trigger", element:editor_name())
	end,

	flashlight = function(self, element, data)
		Hooks:PostHook(element, "on_executed", "sh_on_executed_flashlight_" .. element:id(), function()
			StreamHeist:log("%s executed, changing flashlight state to %s", element:editor_name(), data and "true" or "false")
			managers.game_play_central:set_flashlights_on(data)
		end)
		StreamHeist:log("%s hooked as flashlight state trigger", element:editor_name())
	end,

	groups = function(self, element, data)
		if Network:is_client() then
			return
		end
		local new_groups = table.list_to_set(element._values.preferred_spawn_groups)
		for group_name, enabled in pairs(data) do
			new_groups[group_name] = enabled or nil
		end
		element._values.preferred_spawn_groups = table.map_keys(new_groups)
		StreamHeist:log("Changed %u preferred group(s) of %s", table.size(data), element:editor_name())
	end,

	ai_area = function(self, element, data)
		Hooks:PostHook(element, "on_executed", "sh_on_executed_ai_area_" .. element:id(), function()
			StreamHeist:log("%s executed, creating %d AI area(s)", element:editor_name(), #data)
			for _, nav_segs in ipairs(data) do
				local area_pos = Vector3()
				for _, nav_seg_id in ipairs(nav_segs) do
					local nav_seg = managers.navigation._nav_segments[nav_seg_id]
					if not nav_seg then
						StreamHeist:error("Nav segment %u could not be found", nav_seg_id)
						return
					end
					mvector3.add_scaled(area_pos, nav_seg.pos, 1 / #nav_segs)
				end
				self._ai_area_id = (self._ai_area_id or 10000) + 1
				managers.groupai:state():add_area(self._ai_area_id, nav_segs, area_pos)
			end
		end)
		StreamHeist:log("%s hooked as AI area trigger", element:editor_name())
	end,

	spawn = function(self, element, data)
		Hooks:PostHook(element, "on_executed", "sh_on_executed_spawn_unit_" .. element:id(), function()
			StreamHeist:log("%s executed, spawning %d unit(s)", element:editor_name(), #data)
			for _, u_data in ipairs(data) do
				local unit = World:spawn_unit(u_data.name, u_data.pos or Vector3(), u_data.rot or Rotation())
				if u_data.visible ~= nil then
					unit:set_visible(u_data.visible)
				end
			end
		end)
		StreamHeist:log("%s hooked as unit spawn trigger", element:editor_name())
	end
}

Hooks:PreHook(MissionManager, "_activate_mission", "sh__activate_mission", function(self)
	local mission_script_elements = StreamHeist:mission_script_patches()
	if not mission_script_elements then
		return
	end

	for element_id, data in pairs(mission_script_elements) do
		local element = self:get_element_by_id(element_id)
		if not element then
			StreamHeist:error("Mission script element %u could not be found", element_id)
		else
			for patch_name, patch_data in pairs(data) do
				if self.mission_script_patch_funcs[patch_name] then
					self.mission_script_patch_funcs[patch_name](self, element, patch_data)
				else
					StreamHeist:warn("MissionManager.mission_script_patch_funcs.%s does not exist", patch_name)
				end
			end
		end
	end
end)
