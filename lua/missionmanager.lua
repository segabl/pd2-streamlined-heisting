local level_id = Global.game_settings and Global.game_settings.level_id
if Global.editor_mode then
	StreamHeist:log("Editor mode is active, mission script changes disabled")
	return
end


-- Add custom mission script changes and triggers for specific levels
-- Execution of mission scripts can trigger reinforce locations (trigger that has just a name disables previously enabled reinforcement with that id)
-- Mission script elements can be disabled or enabled
local level_mission_script_elements = {
	des = {
		[100304] = {
			reinforce = {
				{ name = "main_hall", force = 9, position = Vector3(-120, -2400, 100) }
			}
		},
		[100286] = {
			reinforce = {
				{ name = "main_hall" }
			}
		}
	},
	sah = {
		[101400] = {
			reinforce = {
				{ name = "auction_room", force = 5, position = Vector3(0, 2000, -100) }
			}
		}
	},
	chas = {
		[101190] = {
			reinforce = {
				{ name = "store_front1", force = 3, position = Vector3(-2000, 300, -10) },
				{ name = "store_front2", force = 3, position = Vector3(-1000, 300, -10) }
			}
		},
		[101647] = {
			reinforce = {
				{ name = "store_front2" },
				{ name = "back_alley", force = 3, position = Vector3(-1400, 4900, 540) }
			}
		}
	},
	pent = {
		[103595] = {
			reinforce = {
				{ name = "main_room", force = 3, position = Vector3(300, -1600, 12100) }
			}
		},
		[103831] = {
			reinforce = {
				{ name = "main_room" },
				{ name = "helipad", force = 3, position = Vector3(1600, -1600, 13100) }
			}
		}
	},
	friend = {
		[101612] = {
			enabled = false -- Sosa retreat spot SO selection
		}
	},
	nmh = { -- Disable most reinforce points on No Mercy
		[103706] = {
			enabled = false
		},
		[103707] = {
			enabled = false
		},
		[103847] = {
			enabled = false
		}
	}
}
local mission_script_elements = level_mission_script_elements[level_id]
if not mission_script_elements then
	return
end

Hooks:PostHook(MissionManager, "_activate_mission", "sh__activate_mission", function (self)
	for element_id, data in pairs(mission_script_elements) do
		local element = self:get_element_by_id(element_id)
		if not element then
			StreamHeist:log("[Error] Mission script element", element_id, "could not be found")
		else
			-- Check if this element is supposed to trigger reinforce points
			if data.reinforce then
				Hooks:PostHook(element, "on_executed", "sh_on_executed_" .. element_id, function ()
					StreamHeist:log(string.format("Mission script element %u (%s) executed, toggled %u reinforce point(s)", element_id, element:editor_name(), #data.reinforce))
					for _, v in pairs(data.reinforce) do
						managers.groupai:state():set_area_min_police_force(v.name, v.force, v.position)
					end
				end)
				StreamHeist:log(string.format("Mission script element %u (%s) hooked as reinforce trigger for %u area(s)", element_id, element:editor_name(), #data.reinforce))
			end

			-- Check if this element is supposed to be turned on or off
			if data.enabled ~= nil then
				element:set_enabled(data.enabled)
				StreamHeist:log(string.format("Mission script element %u (%s) has been %s", element_id, element:editor_name(), data.enabled and "enabled" or "disabled"))
			end
		end
	end
end)
