-- Clones a weapon preset and optionally sets values for all weapons contained in that preset
-- if the value is a function, it calls the function with the data of the value name instead
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
        entry[val_name] = val
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
  local dmg_mul_tbl = { 0.1, 0.2, 0.4, 0.7, 1, 2, 4, 7 }
  local acc_mul_tbl = { 0.825, 0.85, 0.875, 0.9, 0.925, 0.95, 0.975, 1.0 }
  local focus_delay_tbl = { 1.8, 1.6, 1.4, 1.2, 1, 0.8, 0.6, 0.4 }
  local aim_delay_tbl = { 0.75, 0.65, 0.55, 0.45, 0.35, 0.25, 0.15, 0.05 }
  local melee_dmg_tbl = { 1, 2, 4, 7, 10, 13, 16, 20 }

  local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
  local diff_i_norm = (diff_i - 1) / (#tweak_data.difficulties - 1)
  local dmg_mul = dmg_mul_tbl[diff_i]
  local acc_mul = acc_mul_tbl[diff_i]

  -- Setup weapon presets
  presets.weapon.sh_base = based_on(presets.weapon.expert, {
    focus_delay = focus_delay_tbl[diff_i],
    aim_delay = { 0, aim_delay_tbl[diff_i] },
    melee_dmg = melee_dmg_tbl[diff_i]
  })
  presets.weapon.sh_base.is_pistol.FALLOFF = {
    { dmg_mul = 4.5 * dmg_mul, r = 0, acc = { 0.6 * acc_mul, 0.9 * acc_mul }, recoil = { 0.2, 0.3 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2.5 * dmg_mul, r = 3000, acc = { 0.1 * acc_mul, 0.4 * acc_mul }, recoil = { 0.4, 1 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_base.akimbo_pistol.FALLOFF = {
    { dmg_mul = 6 * dmg_mul, r = 0, acc = { 0.5 * acc_mul, 0.8 * acc_mul }, recoil = { 0.05, 0.1 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3 * dmg_mul, r = 3000, acc = { 0, 0.3 * acc_mul }, recoil = { 0.2, 0.6 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_base.is_revolver.FALLOFF = {
    { dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.8 * acc_mul, 1 * acc_mul }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1.5 * dmg_mul, r = 3000, acc = { 0.3 * acc_mul, 0.6 * acc_mul }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_base.is_sniper = deep_clone(presets.weapon.sh_base.is_revolver)
  presets.weapon.sh_base.is_sniper.FALLOFF = {
    { dmg_mul = 6 * dmg_mul, r = 0, acc = { 0, 0.5 * acc_mul }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 6 * dmg_mul, r = 1000, acc = { 0.5 * acc_mul, 1 * acc_mul }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 4 * dmg_mul, r = 10000, acc = { 0.25 * acc_mul, 0.5 * acc_mul }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_base.is_shotgun_pump.FALLOFF = {
    { dmg_mul = 1.5 * dmg_mul, r = 0, acc = { 0.8 * acc_mul, 1.2 * acc_mul }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1 * dmg_mul, r = 1000, acc = { 0.5 * acc_mul, 0.9 * acc_mul }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 0.01 * dmg_mul, r = 3000, acc = { 0.1 * acc_mul, 0.5 * acc_mul }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_base.is_shotgun_pump.range = { optimal = 1000, far = 3000, close = 500 }
  presets.weapon.sh_base.is_shotgun_mag = deep_clone(presets.weapon.sh_base.is_shotgun_pump)
  presets.weapon.sh_base.is_rifle.autofire_rounds = { 3, 9 }
  presets.weapon.sh_base.is_rifle.FALLOFF = {
    { dmg_mul = 3 * dmg_mul, r = 0, acc = { 0.6 * acc_mul, 0.9 * acc_mul }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1 * dmg_mul, r = 3000, acc = { 0.1 * acc_mul, 0.3 * acc_mul }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_base.is_bullpup = deep_clone(presets.weapon.sh_base.is_rifle)
  presets.weapon.sh_base.is_smg = deep_clone(presets.weapon.sh_base.is_rifle)
  presets.weapon.sh_base.is_smg.autofire_rounds = { 4, 13 }
  presets.weapon.sh_base.is_smg.range = { optimal = 1500, far = 4000, close = 750 }
  presets.weapon.sh_base.mini.autofire_rounds = { 50, 200 }
  presets.weapon.sh_base.mini.FALLOFF = {
    { dmg_mul = 4 * dmg_mul, r = 0, acc = { 0.5 * acc_mul, 0.8 * acc_mul }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3 * dmg_mul, r = 1000, acc = { 0.4 * acc_mul, 0.6 * acc_mul }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2 * dmg_mul, r = 3000, acc = { 0, 0.35 * acc_mul }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_base.is_lmg.autofire_rounds = { 20, 50 }
  presets.weapon.sh_base.is_lmg.FALLOFF = {
    { dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.5 * acc_mul, 0.8 * acc_mul }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1.5 * dmg_mul, r = 1000, acc = { 0.4 * acc_mul, 0.6 * acc_mul }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1 * dmg_mul, r = 3000, acc = { 0, 0.1 * acc_mul }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
  }

  -- Heavy preset (deal less damage in exchange for being bulkier)
  presets.weapon.sh_heavy = based_on(presets.weapon.sh_base, {
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 0.8 end)
    end
  })

  -- Stronger preset (for gangsters and basic cops)
  presets.weapon.sh_strong = based_on(presets.weapon.sh_base, {
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 1.35 end)
    end
  })

  -- Bulldozer preset
  dmg_mul = math.lerp(0.6, 1.3, diff_i_norm)
  presets.weapon.sh_tank = based_on(presets.weapon.sh_base, {
    melee_dmg = 25
  })
  presets.weapon.sh_tank.is_shotgun_pump.RELOAD_SPEED = 1
  presets.weapon.sh_tank.is_shotgun_pump.FALLOFF = {
    { dmg_mul = 5 * dmg_mul, r = 0, acc = { 0.6 * acc_mul, 0.9 * acc_mul }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2 * dmg_mul, r = 1000, acc = { 0.4 * acc_mul, 0.8 * acc_mul }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 0.1 * dmg_mul, r = 3000, acc = { 0.1 * acc_mul, 0.2 * acc_mul }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_tank.is_shotgun_mag.RELOAD_SPEED = 0.5
  presets.weapon.sh_tank.is_shotgun_mag.autofire_rounds = { 1, 7 }
  presets.weapon.sh_tank.is_shotgun_mag.FALLOFF = {
    { dmg_mul = 2 * dmg_mul, r = 0, acc = { 0.6 * acc_mul, 0.9 * acc_mul }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 3, 4 } },
    { dmg_mul = 1.5 * dmg_mul, r = 1000, acc = { 0.3 * acc_mul, 0.6 * acc_mul }, recoil = { 0.45, 0.8 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 1, 3 } },
    { dmg_mul = 0.5 * dmg_mul, r = 3000, acc = { 0.1 * acc_mul, 0.2 * acc_mul }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 1, 1 } }
  }
  presets.weapon.sh_tank.is_rifle.focus_dis = 800
  presets.weapon.sh_tank.is_rifle.RELOAD_SPEED = 0.5
  presets.weapon.sh_tank.is_rifle.autofire_rounds = { 20, 50 }
  presets.weapon.sh_tank.is_rifle.FALLOFF = {
    { dmg_mul = 4 * dmg_mul, r = 0, acc = { 0.6 * acc_mul, 0.9 * acc_mul }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3 * dmg_mul, r = 1000, acc = { 0.4 * acc_mul, 0.6 * acc_mul }, recoil = { 0.45, 0.8 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2 * dmg_mul, r = 3000, acc = { 0.1 * acc_mul, 0.35 * acc_mul }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_tank.mini.focus_dis = 800
  presets.weapon.sh_tank.mini.RELOAD_SPEED = 1
  presets.weapon.sh_tank.mini.autofire_rounds = { 40, 700 }
  presets.weapon.sh_tank.mini.FALLOFF = {
    { dmg_mul = 4 * dmg_mul, r = 0, acc = { 0.1 * acc_mul, 0.15 * acc_mul }, recoil = { 2, 2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 500, 700 } },
    { dmg_mul = 3 * dmg_mul, r = 1000, acc = { 0.04 * acc_mul, 0.075 * acc_mul }, recoil = { 1.2, 1.5 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 300, 500 } },
    { dmg_mul = 2 * dmg_mul, r = 3000, acc = { 0.01 * acc_mul, 0.025 * acc_mul }, recoil = { 0.5, 0.7 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 40, 100 } }
  }

  -- Taser preset
  presets.weapon.sh_taser = based_on(presets.weapon.sh_base, {
    tase_sphere_cast_radius = 30,
    tase_distance = 1500,
    aim_delay_tase = { 0, 0 }
  })

  -- Sniper presets
  dmg_mul = math.lerp(0.6, 1.3, diff_i_norm)
  presets.weapon.sh_sniper = based_on(presets.weapon.sniper, {
    focus_delay = focus_delay_tbl[diff_i],
    aim_delay = { 0, aim_delay_tbl[diff_i] * 4 },
  })
  presets.weapon.sh_sniper.is_rifle.FALLOFF = {
    { dmg_mul = 9 * dmg_mul, r = 0, acc = { 0, 0.5 * acc_mul }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 9 * dmg_mul, r = 1000, acc = { 0.5 * acc_mul, 1 * acc_mul }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 7 * dmg_mul, r = 4000, acc = { 0.5 * acc_mul, 1 * acc_mul }, recoil = { 3, 4 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.sh_sniper_heavy = based_on(presets.weapon.sh_sniper, {
    focus_delay = focus_delay_tbl[diff_i],
    aim_delay = { 0, aim_delay_tbl[diff_i] * 2 },
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 0.5 end)
      manipulate_entries(falloff, "recoil", function (val) return { val[1] * 0.5, val[2] * 0.5 } end)
    end
  })

  -- Give team ai more reasonable preset values
  presets.weapon.gang_member = based_on(presets.weapon.sh_base, {
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return (val / falloff[1].dmg_mul) * diff_i * 0.5 end)
    end
  })

  -- Setup surrender presets
  local surrender_factors = {
    unaware_of_aggressor = 0.1,
    enemy_weap_cold = 0.1,
    flanked = 0.05,
    isolated = 0.1,
    aggressor_dis = {
      [300.0] = 0.2,
      [1000.0] = 0
    }
  }
  presets.surrender.easy = {
    base_chance = 0.3,
    significant_chance = 0.35,
    factors = surrender_factors,
    reasons = {
      pants_down = 1,
      weapon_down = 0.5,
      health = {
        [1.0] = 0,
        [0.8] = 0.8
      }
    }
  }
  presets.surrender.normal = {
    base_chance = 0.3,
    significant_chance = 0.3,
    factors = surrender_factors,
    reasons = {
      pants_down = 0.9,
      weapon_down = 0.4,
      health = {
        [0.8] = 0,
        [0.6] = 0.6
      }
    }
  }
  presets.surrender.hard = {
    base_chance = 0.3,
    significant_chance = 0.25,
    factors = surrender_factors,
    reasons = {
      pants_down = 0.8,
      weapon_down = 0.3,
      health = {
        [0.6] = 0,
        [0.4] = 0.4
      }
    }
  }

  return presets
end


function CharacterTweakData:_add_weapon(id, unit_name)
  table.insert(self.weap_ids, id)
  table.insert(self.weap_unit_names, Idstring(unit_name))
end


Hooks:PostHook(CharacterTweakData, "init", "sh_init", function(self)
  self:_add_weapon("shepheard", "units/payday2/weapons/wpn_npc_shepheard/wpn_npc_shepheard")
  self:_add_weapon("spas12", "units/payday2/weapons/wpn_npc_spas12/wpn_npc_spas12")
  self:_add_weapon("ksg", "units/payday2/weapons/wpn_npc_ksg/wpn_npc_ksg")

  -- Set hurt severities for heavies
  self.heavy_swat.damage.hurt_severity = self.presets.hurt_severities.light_hurt_fire_poison
  self.fbi_heavy_swat.damage.hurt_severity = self.presets.hurt_severities.light_hurt_fire_poison
  self.heavy_swat_sniper.damage.hurt_severity = self.presets.hurt_severities.light_hurt_fire_poison

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
end)


local access_presets = {
  cop = "sh_strong",
  fbi = "sh_strong",
  gangster = "sh_strong",
  security = "sh_strong",
  shield = "sh_heavy",
  sniper = "sh_sniper",
  spooc = "sh_base",
  swat = "sh_base",
  tank = "sh_tank",
  taser = "sh_taser"
}
local preset_overrides = {
  fbi_heavy_swat = "sh_heavy",
  heavy_swat = "sh_heavy",
  heavy_swat_sniper = "sh_sniper_heavy",
  medic = "sh_heavy",
  tank_medic = "sh_heavy"
}
local function assign_weapon_presets(char_tweak_data)
  local char_preset, weapon_preset_name
  for _, name in ipairs(char_tweak_data._enemy_list) do
    char_preset = char_tweak_data[name]
    weapon_preset_name = preset_overrides[name] or access_presets[char_preset.access]
    if weapon_preset_name then
      char_preset.weapon = char_tweak_data.presets.weapon[weapon_preset_name]
      StreamHeist:log("Using " .. weapon_preset_name .. " weapon preset for " .. name)
    end
  end
end

-- Weapon presets are assigned to the enemies here because the vanilla difficulty functions mess with the
-- currently assigned presets so we assign our custom presets AFTER the vanilla presets have been changed
Hooks:PostHook(CharacterTweakData, "_set_normal", "sh__set_normal", assign_weapon_presets)
Hooks:PostHook(CharacterTweakData, "_set_hard", "sh__set_hard", assign_weapon_presets)
Hooks:PostHook(CharacterTweakData, "_set_overkill", "sh__set_overkill", assign_weapon_presets)
Hooks:PostHook(CharacterTweakData, "_set_overkill_145", "sh__set_overkill_145", assign_weapon_presets)
Hooks:PostHook(CharacterTweakData, "_set_easy_wish", "sh__set_easy_wish", assign_weapon_presets)
Hooks:PostHook(CharacterTweakData, "_set_overkill_290", "sh__set_overkill_290", assign_weapon_presets)
Hooks:PostHook(CharacterTweakData, "_set_sm_wish", "sh__set_sm_wish", assign_weapon_presets)
