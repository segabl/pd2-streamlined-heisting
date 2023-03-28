-- Clones a weapon preset and optionally sets values for all weapons contained in that preset
-- if the value is a function, it calls the function with the data of the value name instead
local nil_value = {}
local function based_on(preset, values)
	local p = deep_clone(preset)
	if not values then
		return p
	end
	for _, entry in pairs(p) do
		for val_name, val in pairs(values) do
			if type(val) == "function" then
				val(entry[val_name])
			else
				entry[val_name] = val ~= nil_value and val
			end
		end
	end
	return p
end


local function manipulate_entries(tbl, value_name, func)
	for _, v in pairs(tbl) do
		if type(v) == "table" then
			v[value_name] = func(v[value_name])
		end
	end
end


local _presets_original = CharacterTweakData._presets
function CharacterTweakData:_presets(tweak_data, ...)
	local presets = _presets_original(self, tweak_data, ...)

	-- Difficulty specific values (from easy to death sentence)
	local dmg_mul_tbl = { 0.3, 0.4, 0.55, 0.75, 1, 1.5, 3, 6 }
	local dmg_mul_str_tbl = { 0.8125, 0.875, 1, 1.25, 1.75, 2.5, 3.5, 5 }
	local dmg_mul_lin_tbl = { 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 }
	local focus_delay_tbl = { 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2 }
	local aim_delay_tbl = { 1.6, 1.4, 1.2, 1.0, 0.8, 0.6, 0.4, 0.2 }
	local melee_dmg_tbl = { 6, 8, 10, 12, 14, 16, 18, 20 }

	local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
	local focus_delay = focus_delay_tbl[diff_i]
	local aim_delay = aim_delay_tbl[diff_i]
	local dmg_mul = dmg_mul_tbl[diff_i]
	local dmg_mul_str = dmg_mul_str_tbl[diff_i]
	local dmg_mul_lin = dmg_mul_lin_tbl[diff_i]

	-- Setup weapon presets
	presets.weapon.sh_base = based_on(presets.weapon.expert, {
		focus_delay = focus_delay,
		aim_delay = { 0, aim_delay },
		melee_dmg = melee_dmg_tbl[diff_i],
		melee_speed = 1,
		melee_retry_delay = { 1, 2 },
		RELOAD_SPEED = 1
	})

	presets.weapon.sh_base.is_pistol.range = { optimal = 1500, far = 3000, close = 750 }
	presets.weapon.sh_base.is_pistol.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.1, 0.2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1.5 * dmg_mul, r = 3000, acc = { 0.1, 0.4 }, recoil = { 0.3, 0.6 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.akimbo_pistol.melee_dmg = nil
	presets.weapon.sh_base.akimbo_pistol.melee_speed = nil
	presets.weapon.sh_base.akimbo_pistol.melee_retry_delay = nil
	presets.weapon.sh_base.akimbo_pistol.RELOAD_SPEED = 0.8
	presets.weapon.sh_base.akimbo_pistol.range = { optimal = 1500, far = 3000, close = 750 }
	presets.weapon.sh_base.akimbo_pistol.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.1, 0.2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1.5 * dmg_mul, r = 3000, acc = { 0.1, 0.4 }, recoil = { 0.2, 0.4 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_revolver.RELOAD_SPEED = 0.9
	presets.weapon.sh_base.is_revolver.range = { optimal = 2000, far = 4000, close = 1000 }
	presets.weapon.sh_base.is_revolver.FALLOFF = {
		{ dmg_mul = 5 * dmg_mul_str, r = 0, acc = { 0.8, 1 }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul_str, r = 3000, acc = { 0.3, 0.6 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_sniper = deep_clone(presets.weapon.sh_base.is_revolver)
	presets.weapon.sh_base.is_sniper.range = { optimal = 10000, far = 15000, close = 5000 }
	presets.weapon.sh_base.is_sniper.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul_str, r = 0, acc = { 0, 0.5 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul_str, r = 2000, acc = { 0.5, 1 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul_str, r = 4000, acc = { 0.5, 1 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_shotgun_pump.RELOAD_SPEED = 1.5
	presets.weapon.sh_base.is_shotgun_pump.range = { optimal = 1000, far = 2000, close = 500 }
	presets.weapon.sh_base.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 5 * dmg_mul_str, r = 0, acc = { 0.8, 1 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul_str, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.5 * dmg_mul_str, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.2, 1.8 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_shotgun_mag = deep_clone(presets.weapon.sh_base.is_shotgun_pump)
	presets.weapon.sh_base.is_shotgun_mag.RELOAD_SPEED = 1
	presets.weapon.sh_base.is_shotgun_mag.autofire_rounds = { 1, 3 }
	presets.weapon.sh_base.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 3 * dmg_mul_str, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul_str, r = 1000, acc = { 0.5, 0.8 }, recoil = { 0.45, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.5 * dmg_mul_str, r = 2000, acc = { 0.3, 0.6 }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_double_barrel = deep_clone(presets.weapon.sh_base.is_shotgun_pump)
	presets.weapon.sh_base.is_double_barrel.FALLOFF = {
		{ dmg_mul = 5 * dmg_mul_str, r = 0, acc = { 0.8, 1 }, recoil = { 0.8, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 3 * dmg_mul_str, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1, 1.4 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_rifle.range = { optimal = 1500, far = 3000, close = 750 }
	presets.weapon.sh_base.is_rifle.autofire_rounds = { 1, 5 }
	presets.weapon.sh_base.is_rifle.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.5, 0.8 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1 * dmg_mul, r = 3000, acc = { 0.2, 0.5 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_smg = deep_clone(presets.weapon.sh_base.is_rifle)
	presets.weapon.sh_base.is_smg.autofire_rounds = { 2, 8 }
	presets.weapon.sh_base.is_smg.FALLOFF = {
		{ dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.4, 0.7 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 1 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_lmg = deep_clone(presets.weapon.sh_base.is_smg)
	presets.weapon.sh_base.is_lmg.autofire_rounds = { 15, 30 }
	presets.weapon.sh_base.is_lmg.FALLOFF = {
		{ dmg_mul = 1 * dmg_mul, r = 0, acc = { 0.3, 0.7 }, recoil = { 0.7, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.7 * dmg_mul, r = 1000, acc = { 0.2, 0.6 }, recoil = { 0.8, 1.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.1 * dmg_mul, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.mini = deep_clone(presets.weapon.sh_base.is_lmg)
	presets.weapon.sh_base.mini.autofire_rounds = { 50, 200 }
	presets.weapon.sh_base.mini.FALLOFF = {
		{ dmg_mul = 1 * dmg_mul, r = 0, acc = { 0.15, 0.35 }, recoil = { 0.7, 1.4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.7 * dmg_mul, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.8, 1.6 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.1 * dmg_mul, r = 3000, acc = { 0, 0.15 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_flamethrower.melee_dmg = nil
	presets.weapon.sh_base.is_flamethrower.melee_speed = nil
	presets.weapon.sh_base.is_flamethrower.melee_retry_delay = nil
	presets.weapon.sh_base.is_flamethrower.range = { optimal = 900, far = 1800, close = 450 }
	presets.weapon.sh_base.is_flamethrower.FALLOFF = {
		{ dmg_mul = 1 * dmg_mul_str, r = 0, acc = { 0.15, 0.35 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0.65 * dmg_mul_str, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 0, r = 2000, acc = { 0, 0.15 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
	}

	presets.weapon.sh_base.is_bullpup = deep_clone(presets.weapon.sh_base.is_rifle)
	presets.weapon.sh_base.bow = deep_clone(presets.weapon.sh_base.is_sniper)

	-- Heavy preset (deal less damage in exchange for being bulkier)
	presets.weapon.sh_heavy = based_on(presets.weapon.sh_base, {
		FALLOFF = function (falloff)
			manipulate_entries(falloff, "dmg_mul", function (val) return val * 0.85 end)
		end
	})

	-- Stronger preset (for gangsters and basic cops)
	presets.weapon.sh_strong = based_on(presets.weapon.sh_base, {
		FALLOFF = function (falloff)
			manipulate_entries(falloff, "dmg_mul", function (val) return val * 1.25 end)
		end
	})

	-- Bulldozer preset
	presets.weapon.sh_tank = based_on(presets.weapon.sh_base, {
		melee_dmg = 40 * dmg_mul_lin
	})
	presets.weapon.sh_tank.is_shotgun_pump.RELOAD_SPEED = 1
	presets.weapon.sh_tank.is_shotgun_pump.FALLOFF = {
		{ dmg_mul = 40 * dmg_mul_lin, r = 0, acc = { 0.8, 1 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 20 * dmg_mul_lin, r = 1000, acc = { 0.7, 0.9 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul_lin, r = 2000, acc = { 0.6, 0.8 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } }
	}
	presets.weapon.sh_tank.is_shotgun_mag.RELOAD_SPEED = 0.9
	presets.weapon.sh_tank.is_shotgun_mag.FALLOFF = {
		{ dmg_mul = 10 * dmg_mul_lin, r = 0, acc = { 0.7, 0.9 }, recoil = { 0.4, 0.6 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 3, 6 } },
		{ dmg_mul = 7 * dmg_mul_lin, r = 1000, acc = { 0.5, 0.7 }, recoil = { 0.6, 0.9 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 2, 4 } },
		{ dmg_mul = 4 * dmg_mul_lin, r = 2000, acc = { 0.3, 0.5 }, recoil = { 0.8, 1.2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 1, 2 } }
	}
	presets.weapon.sh_tank.is_lmg.RELOAD_SPEED = 0.5
	presets.weapon.sh_tank.is_lmg.autofire_rounds = { 20, 50 }
	presets.weapon.sh_tank.is_lmg.FALLOFF = {
		{ dmg_mul = 7 * dmg_mul_lin, r = 0, acc = { 0.6, 0.8 }, recoil = { 0.5, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 6 * dmg_mul_lin, r = 1000, acc = { 0.4, 0.6 }, recoil = { 0.6, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul_lin, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1, 1.8 }, mode = { 1, 0, 0, 0 } }
	}
	presets.weapon.sh_tank.mini.no_autofire_stop = true
	presets.weapon.sh_tank.mini.RELOAD_SPEED = 0.2
	presets.weapon.sh_tank.mini.autofire_rounds = { 50, 500 }
	presets.weapon.sh_tank.mini.FALLOFF = {
		{ dmg_mul = 5 * dmg_mul_lin, r = 0, acc = { 0.15, 0.35 }, recoil = { 0.5, 0.8 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 4 * dmg_mul_lin, r = 1000, acc = { 0.1, 0.3 }, recoil = { 0.6, 1 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 2 * dmg_mul_lin, r = 3000, acc = { 0, 0.15 }, recoil = { 1, 1.8 }, mode = { 1, 0, 0, 0 } }
	}

	-- Sniper presets
	presets.weapon.sh_sniper = based_on(presets.weapon.sh_base, {
		use_laser = true,
		focus_delay = focus_delay,
		aim_delay = { 0, aim_delay * 3 },
		range = { optimal = 10000, far = 15000, close = 5000 }
	})
	presets.weapon.sh_sniper.is_rifle.FALLOFF = {
		{ dmg_mul = 23 * dmg_mul_lin, r = 0, acc = { 0, 0.5 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 23 * dmg_mul_lin, r = 1000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 23 * dmg_mul_lin, r = 4000, acc = { 0.5, 1 }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } }
	}
	presets.weapon.sh_sniper_heavy = based_on(presets.weapon.sh_sniper, {
		aim_delay = { 0, aim_delay * 1.5 },
		range = { optimal = 2000, far = 4000, close = 1000 },
		FALLOFF = function (falloff)
			manipulate_entries(falloff, "dmg_mul", function (val) return val * 0.5 end)
			manipulate_entries(falloff, "recoil", function (val) return { val[1] * 0.5, val[2] * 0.5 } end)
		end
	})

	-- Taser preset
	presets.weapon.sh_taser = based_on(presets.weapon.sh_base, {
		tase_sphere_cast_radius = 15,
		tase_distance = 1200,
		aim_delay_tase = { 0, aim_delay }
	})

	-- Shield preset
	presets.weapon.sh_shield = based_on(presets.weapon.sh_base, {
		melee_speed = nil_value,
		melee_dmg = nil_value,
		melee_retry_delay = nil_value,
		range = { optimal = 1000, far = 2000, close = 500 },
		FALLOFF = function (falloff)
			manipulate_entries(falloff, "dmg_mul", function (val) return val * 0.75 end)
		end
	})

	-- Marshal preset
	presets.weapon.sh_marshal = based_on(presets.weapon.sh_base, {
		FALLOFF = function (falloff)
			manipulate_entries(falloff, "recoil", function (val) return { val[1] * 2, val[2] * 2 } end)
		end
	})
	presets.weapon.sh_marshal.is_rifle.aim_delay = { 0, aim_delay * 1.5 }
	presets.weapon.sh_marshal.is_rifle.range = { optimal = 2000, far = 4000, close = 1000 }
	presets.weapon.sh_marshal.is_rifle.FALLOFF = {
		{ dmg_mul = 12 * dmg_mul_lin, r = 0, acc = { 0, 0.5 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 12 * dmg_mul_lin, r = 1000, acc = { 0.5, 1 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
		{ dmg_mul = 12 * dmg_mul_lin, r = 4000, acc = { 0.5, 1 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } }
	}
	presets.weapon.sh_marshal.is_pistol.melee_speed = nil
	presets.weapon.sh_marshal.is_pistol.melee_dmg = nil
	presets.weapon.sh_marshal.is_pistol.melee_retry_delay = nil
	presets.weapon.sh_marshal.is_pistol.range = { optimal = 1000, far = 2000, close = 500 }

	-- Give team AI more reasonable preset values based on enemy HP multipliers
	local dmg_mul_team_tbl = { 1, 1, 1.5, 2, 3, 4, 6, 8 }
	local dmg_mul_team = dmg_mul_team_tbl[diff_i] * 5
	presets.weapon.gang_member = deep_clone(presets.weapon.sh_base)
	for _, v in pairs(presets.weapon.gang_member) do
		v.melee_dmg = dmg_mul_team
		v.FALLOFF = {
			{ dmg_mul = dmg_mul_team, r = 0, acc = { 0.5, 1 }, recoil = v.FALLOFF[1].recoil, mode = { 1, 0, 0, 0 } },
			{ dmg_mul = dmg_mul_team * 0.75, r = 1500, acc = { 0.25, 0.75 }, recoil = v.FALLOFF[1].recoil, mode = { 1, 0, 0, 0 } },
			{ dmg_mul = dmg_mul_team * 0.5, r = 3000, acc = { 0, 0.5 }, recoil = v.FALLOFF[1].recoil, mode = { 1, 0, 0, 0 } }
		}
	end
	presets.weapon.gang_member.is_flamethrower.no_autofire_stop = true
	presets.weapon.gang_member.is_lmg.no_autofire_stop = true
	presets.weapon.gang_member.mini.no_autofire_stop = true
	presets.gang_member_damage.HEALTH_INIT = 100 + 50 * diff_i
	presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.25
	presets.gang_member_damage.REGENERATE_TIME = 2
	presets.gang_member_damage.REGENERATE_TIME_AWAY = 2

	-- Setup surrender presets
	presets.surrender.easy = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 1,
			weapon_down = 0.7,
			flanked = 0.6,
			unaware_of_aggressor = 0.4,
			isolated = 0.3
		},
		factors = {
			health = {
				[1.0] = 0,
				[0.0] = 1
			},
			aggressor_dis = {
				[100] = 0.3,
				[1000] = 0
			}
		}
	}
	presets.surrender.normal = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 0.9,
			weapon_down = 0.5,
			flanked = 0.5,
			unaware_of_aggressor = 0.3,
			isolated = 0.2
		},
		factors = {
			health = {
				[0.75] = 0,
				[0.0] = 0.75
			},
			aggressor_dis = {
				[100] = 0.2,
				[1000] = 0
			}
		}
	}
	presets.surrender.hard = {
		base_chance = 0,
		significant_chance = 0,
		reasons = {
			pants_down = 0.8,
			weapon_down = 0.3,
			flanked = 0.4,
			unaware_of_aggressor = 0.2,
			isolated = 0.1
		},
		factors = {
			health = {
				[0.5] = 0,
				[0.0] = 0.5
			},
			aggressor_dis = {
				[100] = 0.1,
				[1000] = 0
			}
		}
	}

	-- Tweak movement speed presets
	presets.move_speed.very_slow = deep_clone(presets.move_speed.slow)
	for _, pose in pairs(presets.move_speed.very_slow) do
		for _, stance in pairs(pose.walk) do
			for dir, speed in pairs(stance) do
				stance[dir] = speed * 0.85
			end
		end
		pose.run = deep_clone(pose.walk)
	end

	-- Tweak hurt severities
	presets.hurt_severities.base.melee.zones = {
		{
			health_limit = 0.2,
			light = 1
		},
		{
			health_limit = 0.5,
			light = 0.5,
			moderate = 0.5
		},
		{
			health_limit = 0.8,
			moderate = 0.5,
			heavy = 0.5
		},
		{
			heavy = 1
		}
	}
	presets.hurt_severities.base.explosion.zones = {
		{
			health_limit = 0.2,
			light = 0.5,
			moderate = 0.5
		},
		{
			health_limit = 0.5,
			moderate = 0.5,
			heavy = 0.5
		},
		{
			health_limit = 0.8,
			heavy = 0.5,
			explode = 0.5
		},
		{
			explode = 1
		}
	}

	presets.hurt_severities.no_heavy_hurt = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.no_heavy_hurt.bullet.zones = {
		{
			health_limit = 0.4,
			none = 0.5,
			light = 0.5
		},
		{
			health_limit = 0.7,
			light = 0.7,
			moderate = 0.3
		},
		{
			light = 0.5,
			moderate = 0.5
		}
	}
	presets.hurt_severities.no_heavy_hurt.melee.zones = {
		{
			health_limit = 0.2,
			none = 0.2,
			light = 0.8
		},
		{
			health_limit = 0.5,
			light = 0.8,
			moderate = 0.2
		},
		{
			health_limit = 0.8,
			light = 0.2,
			moderate = 0.8
		},
		{
			moderate = 0.8,
			heavy = 0.2
		}
	}
	presets.hurt_severities.no_heavy_hurt.explosion.zones = {
		{
			health_limit = 0.2,
			light = 1,
		},
		{
			health_limit = 0.5,
			light = 0.5,
			moderate = 0.5
		},
		{
			health_limit = 0.8,
			moderate = 0.5,
			heavy = 0.5
		},
		{
			heavy = 0.5,
			explode = 0.5
		}
	}

	-- Tweak dodge presets
	presets.dodge.heavy.occasions.preemptive.chance = 0.25
	presets.dodge.athletic.occasions.preemptive.chance = 0.5

	presets.dodge.ninja.speed = 2
	for _, occasion in pairs(presets.dodge.ninja.occasions) do
		occasion.chance = 1
		if occasion.variations.side_step then
			occasion.variations.side_step.chance = 1
		end
	end

	-- Tweak suppression presets
	presets.suppression.easy.panic_chance_mul = 1
	presets.suppression.easy.duration = { 7, 9 }
	presets.suppression.easy.react_point = { 0, 2 }
	presets.suppression.easy.brown_point = { 3, 5 }

	presets.suppression.hard_def.panic_chance_mul = 0.8
	presets.suppression.hard_def.duration = { 5, 7 }
	presets.suppression.hard_def.react_point = { 2, 4 }
	presets.suppression.hard_def.brown_point = { 5, 7 }

	presets.suppression.hard_agg.panic_chance_mul = 0.6
	presets.suppression.hard_agg.duration = { 3, 5 }
	presets.suppression.hard_agg.react_point = { 4, 6 }
	presets.suppression.hard_agg.brown_point = { 7, 9 }

	-- Enemy chatter
	presets.enemy_chatter.swat.push = true
	presets.enemy_chatter.swat.flash_grenade = true

	return presets
end


-- Add new enemies to the character map
local character_map_original = CharacterTweakData.character_map
function CharacterTweakData:character_map(...)
	local char_map = character_map_original(self, ...)

	table.insert(char_map.basic.list, "ene_sniper_3")
	table.insert(char_map.gitgud.list, "ene_zeal_swat_2")
	table.insert(char_map.gitgud.list, "ene_zeal_swat_heavy_2")
	table.insert(char_map.gitgud.list, "ene_zeal_medic_m4")
	table.insert(char_map.gitgud.list, "ene_zeal_medic_r870")
	table.insert(char_map.gitgud.list, "ene_zeal_sniper")

	return char_map
end


-- Add new weapons
Hooks:PostHook(CharacterTweakData, "_create_table_structure", "sh__create_table_structure", function (self)
	table.insert(self.weap_ids, "shepheard")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_shepheard/wpn_npc_shepheard"))

	table.insert(self.weap_ids, "spas12")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_spas12/wpn_npc_spas12"))

	table.insert(self.weap_ids, "ksg")
	table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_ksg/wpn_npc_ksg"))
end)


-- Tweak bosses
Hooks:PostHook(CharacterTweakData, "_init_biker_boss", "sh__init_biker_boss", function (self, presets)
	self.biker_boss.HEALTH_INIT = 400
	self.biker_boss.player_health_scaling_mul = 1.5
	self.biker_boss.headshot_dmg_mul = 0.5
	self.biker_boss.no_headshot_add_mul = true
	self.biker_boss.damage.explosion_damage_mul = 0.5
	self.biker_boss.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.biker_boss.move_speed = presets.move_speed.slow
	self.biker_boss.no_run_start = true
	self.biker_boss.no_run_stop = true
	self.biker_boss.throwable = "concussion"
	self.biker_boss.throwable_cooldown = 10
end)

Hooks:PostHook(CharacterTweakData, "_init_chavez_boss", "sh__init_chavez_boss", function (self, presets)
	self.chavez_boss.HEALTH_INIT = 300
	self.chavez_boss.player_health_scaling_mul = 1.5
	self.chavez_boss.headshot_dmg_mul = 0.75
	self.chavez_boss.no_headshot_add_mul = true
	self.chavez_boss.damage.explosion_damage_mul = 0.5
	self.chavez_boss.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.chavez_boss.move_speed = presets.move_speed.fast
	self.chavez_boss.no_run_start = true
	self.chavez_boss.no_run_stop = true
end)

Hooks:PostHook(CharacterTweakData, "_init_drug_lord_boss", "sh__init_drug_lord_boss", function (self, presets)
	self.drug_lord_boss.HEALTH_INIT = 400
	self.drug_lord_boss.player_health_scaling_mul = 1.5
	self.drug_lord_boss.headshot_dmg_mul = 0.75
	self.drug_lord_boss.no_headshot_add_mul = true
	self.drug_lord_boss.damage.explosion_damage_mul = 0.5
	self.drug_lord_boss.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.drug_lord_boss.move_speed = presets.move_speed.normal
	self.drug_lord_boss.no_run_start = true
	self.drug_lord_boss.no_run_stop = true
	self.drug_lord_boss.throwable = "launcher_m203"
	self.drug_lord_boss.throwable_target_verified = true
	self.drug_lord_boss.throwable_cooldown = 10
end)

Hooks:PostHook(CharacterTweakData, "_init_hector_boss", "sh__init_hector_boss", function (self, presets)
	self.hector_boss.HEALTH_INIT = 400
	self.hector_boss.player_health_scaling_mul = 1.5
	self.hector_boss.headshot_dmg_mul = 0.5
	self.hector_boss.no_headshot_add_mul = true
	self.hector_boss.damage.explosion_damage_mul = 0.5
	self.hector_boss.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.hector_boss.move_speed = presets.move_speed.slow
	self.hector_boss.no_run_start = true
	self.hector_boss.no_run_stop = true
	self.hector_boss.throwable = "frag"
	self.hector_boss.throwable_cooldown = 15
end)

Hooks:PostHook(CharacterTweakData, "_init_mobster_boss", "sh__init_mobster_boss", function (self, presets)
	self.mobster_boss.HEALTH_INIT = 300
	self.mobster_boss.player_health_scaling_mul = 1.5
	self.mobster_boss.headshot_dmg_mul = 0.75
	self.mobster_boss.no_headshot_add_mul = true
	self.mobster_boss.damage.explosion_damage_mul = 0.5
	self.mobster_boss.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.mobster_boss.move_speed = presets.move_speed.fast
	self.mobster_boss.no_run_start = true
	self.mobster_boss.no_run_stop = true
end)

Hooks:PostHook(CharacterTweakData, "_init_triad_boss", "sh__init_triad_boss", function (self, presets)
	self.triad_boss.HEALTH_INIT = 400
	self.triad_boss.player_health_scaling_mul = 1.5
	self.triad_boss.headshot_dmg_mul = 0.5
	self.triad_boss.no_headshot_add_mul = true
	self.triad_boss.damage.explosion_damage_mul = 0.5
	self.triad_boss.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.triad_boss.move_speed = presets.move_speed.slow
	self.triad_boss.no_run_start = true
	self.triad_boss.no_run_stop = true
	self.triad_boss.bullet_damage_only_from_front = nil
	self.triad_boss.invulnerable_to_slotmask = nil
	self.triad_boss.throwable_target_verified = false
	self.triad_boss.throwable_cooldown = 20
end)


-- Set specific character preset settings
Hooks:PostHook(CharacterTweakData, "init", "sh_init", function(self)
	-- Set hurt severities
	self.heavy_swat.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.fbi_heavy_swat.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.heavy_swat_sniper.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.spooc.damage.hurt_severity = self.presets.hurt_severities.no_hurts
	self.shadow_spooc.damage.hurt_severity = self.presets.hurt_severities.no_hurts
	self.medic.damage.hurt_severity = self.presets.hurt_severities.only_light_hurt
	self.marshal_marksman.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt
	self.marshal_shield_break.damage.hurt_severity = self.presets.hurt_severities.no_heavy_hurt

	-- Set custom surrender chances (default is "easy", like vanilla)
	self.swat.surrender = self.presets.surrender.normal
	self.heavy_swat.surrender = self.presets.surrender.hard
	self.fbi_swat.surrender = self.presets.surrender.normal
	self.fbi_heavy_swat.surrender = self.presets.surrender.hard
	self.city_swat.surrender = self.presets.surrender.normal
	self.heavy_swat_sniper.surrender = self.presets.surrender.hard

	-- Restore special entrance announcements
	self.tank.spawn_sound_event = self.tank.speech_prefix_p1 .. "_entrance"
	self.tank_hw.spawn_sound_event = self.tank_hw.speech_prefix_p1 .. "_entrance"
	self.tank_medic.spawn_sound_event = self.tank_medic.speech_prefix_p1 .. "_entrance"
	self.tank_mini.spawn_sound_event = self.tank_mini.speech_prefix_p1 .. "_entrance"
	self.taser.spawn_sound_event = self.taser.speech_prefix_p1 .. "_entrance"

	-- Fix gangster speech prefixes
	self.gangster.speech_prefix_p1 = "lt"
	self.gangster.speech_prefix_p2 = nil
	self.gangster.speech_prefix_count = 2
	self.mobster.speech_prefix_p1 = "rt"
	self.mobster.speech_prefix_p2 = nil
	self.mobster.speech_prefix_count = 2
	self.biker.speech_prefix_p1 = "bik"
	self.biker.speech_prefix_p2 = nil
	self.biker.speech_prefix_count = 2

	-- Tweak some health values for better scaling
	self.tank.HEALTH_INIT = 200
	self.tank_hw.HEALTH_INIT = 200
	self.tank_medic.HEALTH_INIT = 200
	self.tank_mini.HEALTH_INIT = 400
	self.phalanx_minion.HEALTH_INIT = 100
	self.phalanx_vip.HEALTH_INIT = 200
	self.hector_boss_no_armor.HEALTH_INIT = 8
	self.drug_lord_boss_stealth.HEALTH_INIT = 8
	self.triad_boss_no_armor.HEALTH_INIT = 8
	self.fbi.HEALTH_INIT = 4
	self.marshal_marksman.HEALTH_INIT = 24
	self.marshal_shield.HEALTH_INIT = 24
	self.marshal_shield_break.HEALTH_INIT = 48

	-- Tweak headshot multipliers
	self.fbi_swat.headshot_dmg_mul = 2
	self.phalanx_minion.headshot_dmg_mul = 3
	self.phalanx_vip.headshot_dmg_mul = 3
	self.tank.headshot_dmg_mul = 4
	self.tank_hw.headshot_dmg_mul = 4
	self.tank_medic.headshot_dmg_mul = 4
	self.tank_mini.headshot_dmg_mul = 4

	-- Fix/set explosion damage multipliers
	self.fbi_heavy_swat.damage.explosion_damage_mul = 1
	self.tank.damage.explosion_damage_mul = 0.85
	self.tank_hw.damage.explosion_damage_mul = 0.85
	self.tank_medic.damage.explosion_damage_mul = 0.85
	self.tank_mini.damage.explosion_damage_mul = 0.85
	self.shield.damage.explosion_damage_mul = 1
	self.phalanx_minion.damage.explosion_damage_mul = 1
	self.phalanx_vip.damage.explosion_damage_mul = 1
	self.marshal_shield.damage.explosion_damage_mul = 1

	-- Fix/tweak suppression settings
	self.medic.suppression = nil
	self.fbi.suppression = self.presets.suppression.easy
	self.gensec.suppression = self.presets.suppression.easy
	self.swat.suppression = self.presets.suppression.hard_def
	self.heavy_swat_sniper.suppression = self.presets.suppression.hard_agg

	-- Allow arrests
	self.fbi.no_arrest = nil
	self.swat.no_arrest = nil
	self.fbi_swat.no_arrest = nil

	-- Tweak move speeds
	self.tank_mini.move_speed = self.presets.move_speed.very_slow
	self.swat.move_speed = self.presets.move_speed.very_fast
	self.cop.move_speed = self.presets.move_speed.fast

	-- Set custom objective interrupt distance
	self.taser.min_obj_interrupt_dis = 1000
	self.spooc.min_obj_interrupt_dis = 800
	self.shadow_spooc.min_obj_interrupt_dis = 800
	self.tank.min_obj_interrupt_dis = 600
	self.tank_hw.min_obj_interrupt_dis = 600
	self.tank_medic.min_obj_interrupt_dis = 600
	self.tank_mini.min_obj_interrupt_dis = 600
	self.shield.min_obj_interrupt_dis = 600

	-- Set melee weapons
	self.biker.melee_weapon = "knife_1"
	self.spooc.melee_weapon = "baton"
	self.tank.melee_weapon = "weapon"
	self.tank_hw.melee_weapon = "weapon"
	self.tank_medic.melee_weapon = "weapon"
	self.tank_mini.melee_weapon = "weapon"

	-- Disable cloaker smoke drop after attack (they already have a chance to drop one when they dodge)
	self.spooc.spooc_attack_use_smoke_chance = 0

	-- Reduce invulnerability duration
	self.marshal_shield_break.tmp_invulnerable_on_tweak_change = 2
end)


-- Create a preset scaling function that assigns the correct weapon presets and handles HP scaling
local access_presets = {
	cop = "sh_strong",
	fbi = "sh_strong",
	gangster = "sh_strong",
	security = "sh_strong",
	shield = "sh_shield",
	sniper = "sh_sniper",
	tank = "sh_tank",
	taser = "sh_taser"
}
local preset_overrides = {
	fbi_heavy_swat = "sh_heavy",
	heavy_swat = "sh_heavy",
	heavy_swat_sniper = "sh_sniper_heavy",
	marshal_marksman = "sh_marshal",
	marshal_shield = "sh_marshal",
	marshal_shield_break = "sh_marshal",
	medic = "sh_heavy",
	tank_medic = "sh_heavy"
}
local hp_muls = { 1, 1, 1.5, 2, 3, 4, 6, 8 }
local function set_presets(char_tweak_data)
	local diff_i = char_tweak_data.tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
	local diff_i_norm = math.max(0, diff_i - 2) / (#char_tweak_data.tweak_data.difficulties - 2)
	local hp_mul = hp_muls[diff_i]

	for _, name in pairs(char_tweak_data._enemy_list) do
		local char_preset = char_tweak_data[name]

		char_preset.BASE_HEALTH_INIT = char_preset.BASE_HEALTH_INIT or char_preset.HEALTH_INIT
		char_preset.HEALTH_INIT = char_preset.BASE_HEALTH_INIT * hp_mul

		-- Remove damage clamps, they are not a fun or intuitive mechanic
		char_preset.DAMAGE_CLAMP_BULLET = nil
		char_preset.DAMAGE_CLAMP_EXPLOSION = nil

		if char_preset.headshot_dmg_mul then
			char_preset.base_headshot_dmg_mul = char_preset.base_headshot_dmg_mul or char_preset.headshot_dmg_mul
			char_preset.headshot_dmg_mul = char_preset.base_headshot_dmg_mul * 2
		end

		char_preset.weapon = char_tweak_data.presets.weapon[preset_overrides[name] or access_presets[char_preset.access] or "sh_base"]
	end

	-- Flashbanged duration
	char_tweak_data.flashbang_multiplier = math.lerp(0.9, 1.5, diff_i_norm)

	-- Cloaker attack timeout
	char_tweak_data.spooc.spooc_attack_timeout = { math.lerp(8, 3, diff_i_norm), math.lerp(10, 4, diff_i_norm) }
	char_tweak_data.shadow_spooc.shadow_spooc_attack_timeout = char_tweak_data.spooc.spooc_attack_timeout
end

CharacterTweakData._set_easy = set_presets
CharacterTweakData._set_normal = set_presets
CharacterTweakData._set_hard = set_presets
CharacterTweakData._set_overkill = set_presets
CharacterTweakData._set_overkill_145 = set_presets
CharacterTweakData._set_easy_wish = set_presets
CharacterTweakData._set_overkill_290 = set_presets
CharacterTweakData._set_sm_wish = set_presets
