-- Add custom reinforce locations to specific levels
local level_reinforce_triggers = {
	des = {
		[100304] = { name = "main_hall", force = 3, position = Vector3(-120, -2400, 100), disable_id = 100286 }
	},
	sah = {
		[101400] = { name = "main_room", force = 3, position = Vector3(0, 2000, -100) }
	}
}
local reinforce_triggers = level_reinforce_triggers[Global.game_settings and Global.game_settings.level_id]
if not reinforce_triggers then
	return
end

local function hook_element(mission_manager, element_id, name, force, position, disable_id)
	local element = mission_manager:get_element_by_id(element_id)
	if element then
		Hooks:PostHook(element, "on_executed", "sh_on_executed_" .. element_id, function ()
			StreamHeist:log("Mission script element", element_id, "executed,", force and "enabled" or "disabled", name, "reinforce point")
			managers.groupai:state():set_area_min_police_force(name, force, position)
		end)
		StreamHeist:log("Mission script element", element_id, "hooked as", name, "reinforce", force and "activation" or "deactivation", "trigger")
		if disable_id then
			hook_element(mission_manager, disable_id, name)
		end
	else
		StreamHeist:log("[Error] Mission script element", element_id, "could not be found")
	end
end

Hooks:PostHook(MissionManager, "_activate_mission", "sh__activate_mission", function (self)
	for element_id, data in pairs(reinforce_triggers) do
		hook_element(self, element_id, data.name, data.force, data.position, data.disable_id)
	end
end)
