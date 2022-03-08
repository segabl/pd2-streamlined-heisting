local level_id = Global.game_settings and Global.game_settings.level_id


-- Disable reinforce points on No Mercy (it's already crowded enough and they tend to get stuck in the ceiling)
if level_id == "nmh" then
	function ElementAreaMinPoliceForce:operation_add() end
end


-- Add custom reinforce locations to specific levels (trigger that has just a name disables previously enabled reinforcement with that id)
local level_reinforce_triggers = {
	des = {
		[100304] = {
			{ name = "main_hall", force = 9, position = Vector3(-120, -2400, 100) }
		},
		[100286] = {
			{ name = "main_hall" }
		}
	},
	sah = {
		[101400] = {
			{ name = "auction_room", force = 5, position = Vector3(0, 2000, -100) }
		}
	},
	chas = {
		[101190] = {
			{ name = "store_front1", force = 3, position = Vector3(-2000, 300, -10) },
			{ name = "store_front2", force = 3, position = Vector3(-1000, 300, -10) }
		},
		[101647] = {
			{ name = "store_front2" },
			{ name = "back_alley", force = 3, position = Vector3(-1400, 4900, 540) }
		}
	}
}
local reinforce_triggers = level_reinforce_triggers[level_id]
if not reinforce_triggers then
	return
end

local function hook_element(mission_manager, element_id, data)
	local element = mission_manager:get_element_by_id(element_id)
	if element then
		Hooks:PostHook(element, "on_executed", "sh_on_executed_" .. element_id, function ()
			StreamHeist:log("Mission script element", string.format("%u (%s)", element_id, element:editor_name()), "executed, toggled", #data, "reinforce point(s)")
			for _, v in pairs(data) do
				managers.groupai:state():set_area_min_police_force(v.name, v.force, v.position)
			end
		end)
		StreamHeist:log("Mission script element", string.format("%u (%s)", element_id, element:editor_name()), "hooked as reinforce trigger for", #data, "area(s)")
	else
		StreamHeist:log("[Error] Mission script element", element_id, "could not be found")
	end
end

Hooks:PostHook(MissionManager, "_activate_mission", "sh__activate_mission", function (self)
	for element_id, data in pairs(reinforce_triggers) do
		hook_element(self, element_id, data)
	end
end)
