local interval = {
	values = {
		interval = 30
	}
}
local vis_blockers = {}
local vis_blocker_ids = Idstring("units/dev_tools/level_tools/dev_ai_vis_blocker/dev_ai_vis_blocker_005x2x2m")
for i = 0, 11 do
	local y = 1300 - (i * 200)
	table.insert(vis_blockers, {
		name = vis_blocker_ids,
		pos = Vector3(-4240, y, 1060),
		visible = false
	})
	table.insert(vis_blockers, {
		name = vis_blocker_ids,
		pos = Vector3(-2365, y, 1060),
		visible = false
	})
end
return {
	-- Slow down vault group spawns
	[100722] = interval,
	[100723] = interval,
	[104821] = interval,
	[104822] = interval,
	-- Add vis blockers
	[100000] = {
		spawn = vis_blockers
	}
}