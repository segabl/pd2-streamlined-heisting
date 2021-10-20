-- Reduce the amount of enemies in Holdout as the mission area is small and it is wave based
Hooks:PostHook(SkirmishTweakData, "_init_group_ai_data", "sh__init_group_ai_data", function (self, tweak_data)
	local skirmish_data = tweak_data.group_ai.skirmish
	skirmish_data.assault.force = { 7, 7, 7 }
	skirmish_data.assault.force_pool = { 200, 200, 200 }
	skirmish_data.recon.force = { 0, 0, 0 }
end)


-- Start damage/health scaling at 1 and scale health lower (nobody likes bullet sponges)
Hooks:PostHook(SkirmishTweakData, "_init_wave_modifiers", "sh__init_wave_modifiers", function (self)
	local wave_data = {}
	for i = 0, 20 do
		table.insert(wave_data, {
			damage = 1 + i * 0.5,
			health = 1 + i * 0.5
		})
	end
	self.wave_modifiers[1][1].data.waves = wave_data
end)
