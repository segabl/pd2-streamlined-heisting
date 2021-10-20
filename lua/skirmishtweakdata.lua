-- Reduce the amount of enemies in Holdout as the mission area is small and it is wave based
Hooks:PostHook(SkirmishTweakData, "_init_group_ai_data", "sh__init_group_ai_data", function (self, tweak_data)
	local skirmish_data = tweak_data.group_ai.skirmish
	skirmish_data.assault.force = { 7, 7, 7 }
	skirmish_data.assault.force_pool = { 200, 200, 200 }
end)
