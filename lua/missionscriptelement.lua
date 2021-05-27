local level_reinforce_triggers = {
	sah = {
		[101400] = {
			id = "main_room",
			force = 3,
			position = Vector3(0, 2000, -100)
		}
	}
}
local reinforce_triggers = level_reinforce_triggers[Global.game_settings and Global.game_settings.level_id]
if not reinforce_triggers then
	return
end

Hooks:PostHook(MissionScriptElement, "on_executed", "sh_on_executed", function(self, ...)
	local data = reinforce_triggers[self._id]
	if not data then
		return
	end
	StreamHeist:log("Mission script", self._id, "executed,", data.force and "added" or "removed", data.id, "reinforce point")
	managers.groupai:state():set_area_min_police_force(data.id, data.force, data.position)
end)
