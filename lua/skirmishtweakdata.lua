-- Scale assault duration based on wave number and shorten time in between assaults
Hooks:PostHook(SkirmishTweakData, "init", "sh_init", function (self, tweak_data)
	local skirmish_data = tweak_data.group_ai.skirmish
	skirmish_data.assault.build_duration = 10
	skirmish_data.assault.fade_duration = 0
	skirmish_data.assault.delay = { 15, 15, 15 }
	skirmish_data.assault.sustain_duration_min = nil
	skirmish_data.assault.sustain_duration_max = nil

	local skirmish_assault_meta = getmetatable(skirmish_data.assault)
	local __index_original = skirmish_assault_meta.__index

	skirmish_assault_meta.__index = function (t, key)
		if key == "sustain_duration_min" or key == "sustain_duration_max" then
			local sustain_duration = 60 + 7.5 * (managers.skirmish:current_wave_number() - 1)
			return { sustain_duration, sustain_duration, sustain_duration }
		else
			return __index_original(t, key)
		end
	end
end)


-- Set custom scaling special limits
Hooks:PostHook(SkirmishTweakData, "_init_special_unit_spawn_limits", "sh__init_special_unit_spawn_limits", function (self)
	for i, _ in ipairs(self.special_unit_spawn_limits) do
		self.special_unit_spawn_limits[i] = {
			shield = math.floor(3 + 0.25 * i),
			medic = math.floor(1 + 0.5 * i),
			taser = math.floor(2 + 0.25 * i),
			tank = math.floor(1 + 0.25 * i),
			spooc = math.floor(1 + 0.25 * i)
		}
	end
end)


-- Reduce the amount of enemies in Holdout as the mission area is small and it is wave based
Hooks:PostHook(SkirmishTweakData, "_init_group_ai_data", "sh__init_group_ai_data", function (self, tweak_data)
	local skirmish_data = tweak_data.group_ai.skirmish
	skirmish_data.assault.force = { 8, 8, 8 }
	skirmish_data.assault.force_pool = { 100, 100, 100 }
	skirmish_data.recon.force = { 0, 0, 0 }
end)


-- Start damage/health scaling at 1 and scale health lower (nobody likes bullet sponges)
Hooks:PostHook(SkirmishTweakData, "_init_wave_modifiers", "sh__init_wave_modifiers", function (self)
	for i, wave_data in ipairs(self.wave_modifiers[1][1].data.waves) do
		wave_data.damage = 1 + (i - 1) * 0.5
		wave_data.health = 1 + (i - 1) * 0.375
	end
end)


-- Create custom wave group weights
Hooks:PostHook(SkirmishTweakData, "_init_spawn_group_weights", "sh__init_spawn_group_weights", function (self, tweak_data)
	local base_groups = deep_clone(tweak_data.group_ai.besiege.assault.groups)
	local special_weights = { 3, 4.5, 6 }
	base_groups.tac_shield_wall_ranged = special_weights
	base_groups.tac_shield_wall_charge = special_weights
	base_groups.tac_tazer_flanking = special_weights
	base_groups.tac_tazer_charge = special_weights
	base_groups.tac_bull_rush = special_weights
	base_groups.FBI_spoocs = special_weights

	for i, _ in ipairs(self.assault.groups) do
		local f = math.min((i - 1) / 8, 1)
		local w1, w2
		if f <= 0.5 then
			f = f * 2
			w1 = 1
			w2 = 2
		else
			f = (f - 0.5) * 2
			w1 = 2
			w2 = 3
		end

		local groups = deep_clone(base_groups)
		for _, weights in pairs(groups) do
			local w = math.lerp(weights[w1], weights[w2], f)
			for k, _ in pairs(weights) do
				weights[k] = w
			end
		end
		self.assault.groups[i] = groups
	end
end)
