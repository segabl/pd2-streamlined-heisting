if false then
  return
end

-- Clones a weapon preset and optionally sets values for all weapons contained in that preset
-- if the value is a function, it calls the function with the data of the value name instead
local function based_on(preset, values)
  local p = deep_clone(preset)
  if not values then
    return p
  end
  for _, entry in pairs(p) do
    for val_name, val in pairs(values or {}) do
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


local character_map_original = CharacterTweakData.character_map
function CharacterTweakData:character_map(...)
  local char_map = character_map_original(self, ...)
  table.insert(char_map.basic.list, "ene_fbi_heavy_r870")
  table.insert(char_map.basic.list, "ene_swat_3")
  table.insert(char_map.basic.list, "ene_fbi_swat_3")
  return char_map
end


local _presets_original = CharacterTweakData._presets
function CharacterTweakData:_presets(...)
  local presets = _presets_original(self, ...)
  
  CASS:log("Setting up presets")

  -- base everything on overkill preset
  presets.weapon.cass_overkill_145 = based_on(presets.weapon.expert, {
    focus_delay = 1,
    aim_delay = { 0, 0.2 },
    melee_dmg = 10
  })
  presets.weapon.cass_overkill_145.is_pistol.FALLOFF = {
    { dmg_mul = 4, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.15, 0.25 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2, r = 3000, acc = { 0.1, 0.3 }, recoil = { 0.4, 1 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.cass_overkill_145.akimbo_pistol.FALLOFF = {
    { dmg_mul = 4, r = 0, acc = { 0.5, 0.8 }, recoil = { 0.1, 0.2 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2, r = 3000, acc = { 0, 0.2 }, recoil = { 0.2, 0.8 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.cass_overkill_145.is_revolver.FALLOFF = {
    { dmg_mul = 4, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2, r = 3000, acc = { 0.1, 0.4 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.cass_overkill_145.is_shotgun_pump.FALLOFF = {
    { dmg_mul = 2, r = 0, acc = { 0.8, 1 }, recoil = { 0.75, 1 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1.5, r = 1000, acc = { 0.5, 0.8 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 0.01, r = 3000, acc = { 0.1, 0.6 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.cass_overkill_145.is_shotgun_mag = deep_clone(presets.weapon.cass_overkill_145.is_shotgun_pump)
  presets.weapon.cass_overkill_145.is_rifle.autofire_rounds = { 3, 9 }
  presets.weapon.cass_overkill_145.is_rifle.FALLOFF = {
    { dmg_mul = 3, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.3, 0.6 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1, r = 3000, acc = { 0.1, 0.3 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.cass_overkill_145.is_smg.autofire_rounds = { 6, 18 }
  presets.weapon.cass_overkill_145.is_smg.FALLOFF = {
    { dmg_mul = 5, r = 0, acc = { 0.5, 0.8 }, recoil = { 0.1, 0.3 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 0.5, r = 3000, acc = { 0, 0 }, recoil = { 1, 1.5 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.cass_overkill_145.mini.autofire_rounds = { 50, 200 }
  presets.weapon.cass_overkill_145.mini.FALLOFF = {
    { dmg_mul = 4, r = 0, acc = { 0.5, 0.8 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3, r = 1000, acc = { 0.4, 0.6 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2, r = 3000, acc = { 0, 0.35 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.cass_overkill_145.is_lmg.autofire_rounds = { 10, 40 }
  presets.weapon.cass_overkill_145.is_lmg.FALLOFF = {
    { dmg_mul = 2, r = 0, acc = { 0.5, 0.8 }, recoil = { 0.4, 0.8 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1.5, r = 1000, acc = { 0.4, 0.6 }, recoil = { 0.5, 1 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1, r = 3000, acc = { 0, 0.35 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
  }

  presets.weapon.cass_easy = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 2.5,
    aim_delay = { 0, 0.4 },
    melee_dmg = 2,
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 0.1 end)
      manipulate_entries(falloff, "acc", function (val) return { val[1] * 0.8, val[2] * 0.8 } end)
    end
  })

  presets.weapon.cass_normal = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 2,
    aim_delay = { 0, 0.35 },
    melee_dmg = 2,
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 0.2 end)
      manipulate_entries(falloff, "acc", function (val) return { val[1] * 0.85, val[2] * 0.85 } end)
    end
  })
  
  presets.weapon.cass_hard = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 1.5,
    aim_delay = { 0, 0.3 },
    melee_dmg = 4,
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 0.4 end)
      manipulate_entries(falloff, "acc", function (val) return { val[1] * 0.9, val[2] * 0.9 } end)
    end
  })
  
  presets.weapon.cass_overkill = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 1.25,
    aim_delay = { 0, 0.25 },
    melee_dmg = 7,
    FALLOFF = function(falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 0.7 end)
      manipulate_entries(falloff, "acc", function (val) return { val[1] * 0.95, val[2] * 0.95 } end)
    end
  })

  presets.weapon.cass_easywish = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 0.75,
    aim_delay = { 0, 0.15 },
    melee_dmg = 13,
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 2 end)
      manipulate_entries(falloff, "acc", function (val) return { val[1] * 1.25, val[2] * 1.25 } end)
    end
  })

  presets.weapon.cass_overkill_290 = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 0.5,
    aim_delay = { 0, 0.1 },
    melee_dmg = 16,
    FALLOFF = function(falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 4 end)
      manipulate_entries(falloff, "acc", function (val) return { val[1] * 1.5, val[2] * 1.5 } end)
    end
  })

  presets.weapon.cass_sm_wish = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 0.25,
    aim_delay = { 0, 0.05 },
    melee_dmg = 20,
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * 6 end)
      manipulate_entries(falloff, "acc", function (val) return { val[1] * 2, val[2] * 2 } end)
    end
  })

  presets.weapon.cass_tank = based_on(presets.weapon.cass_overkill_145, {
    melee_dmg = 25
  })
  presets.weapon.cass_tank.is_shotgun_pump.FALLOFF = {
    { dmg_mul = 5, r = 0, acc = { 0.6, 0.9 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2, r = 1000, acc = { 0.2, 0.75 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 0.1, r = 3000, acc = { 0.05, 0.35 }, recoil = { 1.5, 2 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.cass_tank.is_shotgun_mag.RELOAD_SPEED = 0.5
  presets.weapon.cass_tank.is_shotgun_mag.autofire_rounds = { 1, 7 }
  presets.weapon.cass_tank.is_shotgun_mag.FALLOFF = {
    { dmg_mul = 2, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 6, 7 } },
    { dmg_mul = 1.5, r = 1000, acc = { 0.4, 0.8 }, recoil = { 0.45, 8 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 2, 3 } },
    { dmg_mul = 0.01, r = 3000, acc = { 0.1, 0.35 }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 1, 1 } }
  }
  presets.weapon.cass_tank.is_rifle.focus_dis = 800
  presets.weapon.cass_tank.is_rifle.RELOAD_SPEED = 0.5
  presets.weapon.cass_tank.is_rifle.autofire_rounds = { 20, 40 }
  presets.weapon.cass_tank.is_rifle.FALLOFF = {
    { dmg_mul = 4, r = 0, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3, r = 1000, acc = { 0.4, 0.6 }, recoil = { 0.45, 0.8 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2, r = 3000, acc = { 0.1, 0.35 }, recoil = { 1, 1.2 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.cass_tank.mini.focus_dis = 800
  presets.weapon.cass_tank.mini.RELOAD_SPEED = 1
  presets.weapon.cass_tank.mini.autofire_rounds = { 40, 700 }
  presets.weapon.cass_tank.mini.FALLOFF = {
    { dmg_mul = 4, r = 0, acc = { 0.1, 0.15 }, recoil = { 2, 2 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 500, 700 } },
    { dmg_mul = 3, r = 1000, acc = { 0.04, 0.075 }, recoil = { 1.2, 1.5 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 300, 500 } },
    { dmg_mul = 2, r = 3000, acc = { 0.01, 0.025 }, recoil = { 0.5, 0.7 }, mode = { 1, 0, 0, 0 }, autofire_rounds = { 40, 100 } }
  }

  presets.weapon.cass_sniper = based_on(presets.weapon.sniper, {
    focus_delay = 20
  })
  presets.weapon.cass_sniper.is_rifle.FALLOFF = {
    { dmg_mul = 9, r = 0, acc = { 0, 0.5 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 9, r = 1000, acc = { 0.5, 1 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 7, r = 10000, acc = { 0.25, 0.5 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } }
  }

  -- reduce team AI damage because else the improved accuracy calculation for npcs makes them even stronger
  for _, w in pairs(presets.weapon.gang_member) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 0.5 end)
  end

  return presets
end


function CharacterTweakData:_multiply_weapon_delay(weap_usage_table, mul)
  -- wtf was that function overkill, always called with 0 values
end


Hooks:PostHook(CharacterTweakData, "init", "cass_init", function(self)
  table.insert(self.weap_ids, "spas12")
  table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_spas12/wpn_npc_spas12"))
  table.insert(self.weap_ids, "mp7")
  table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_mp7/wpn_npc_mp7"))
  table.insert(self.weap_ids, "amcar")
  table.insert(self.weap_unit_names, Idstring("units/payday2/weapons/wpn_npc_amcar/wpn_npc_amcar"))
  
  self._default_preset_users = {}
  for _, name in ipairs(self._enemy_list) do
    if self[name].weapon == self.presets.weapon.normal or self[name].weapon == self.presets.weapon.good then
      self._default_preset_users[name] = self[name]
    end
  end

  self.heavy_swat_sniper.damage.hurt_severity = self.presets.hurt_severities.light_hurt_fire_poison
  self.heavy_swat.damage.hurt_severity = self.presets.hurt_severities.light_hurt_fire_poison
  self.fbi_heavy_swat.damage.hurt_severity = self.presets.hurt_severities.light_hurt_fire_poison
end)


Hooks:PostHook(CharacterTweakData, "_init_tank", "cass__init_tank", function(self)
  -- restore entrance announcement
  self.tank.spawn_sound_event = self.tank.spawn_sound_event or self.tank.speech_prefix_p1 .. "_entrance"
  self.tank_hw.spawn_sound_event = self.tank_hw.spawn_sound_event or self.tank_hw.speech_prefix_p1 .. "_entrance"
  self.tank_medic.spawn_sound_event = self.tank_medic.spawn_sound_event or self.tank_medic.speech_prefix_p1 .. "_entrance"
  self.tank_mini.spawn_sound_event = self.tank_mini.spawn_sound_event or self.tank_mini.speech_prefix_p1 .. "_entrance"
end)

Hooks:PostHook(CharacterTweakData, "_init_taser", "cass__init_taser", function(self)
  -- restore entrance announcement
  self.taser.spawn_sound_event = self.taser.spawn_sound_event or self.taser.speech_prefix_p1 .. "_entrance"
end)


local lower_preset_users = {
  heavy_swat = true,
  fbi_heavy_swat = true,
  medic = true
}
local function set_cops_weapon_preset(self, preset, preset_lower)
  CASS:log("Setting presets to", preset, preset_lower)

  self._active_presets = { self.presets.weapon[preset], self.presets.weapon[preset_lower] }

  for k, v in pairs(self._default_preset_users) do
    v.weapon = lower_preset_users[k] and self._active_presets[2] or self._active_presets[1]
  end
  self.taser.weapon.is_rifle = deep_clone(self._active_presets[1].is_rifle)
  self.taser.weapon.tase_sphere_cast_radius = 30
  self.taser.weapon.tase_distance = 1500
end

local function set_tank_weapon_preset(self, dmg_mul)
  local tank_weapon = based_on(self.presets.weapon.cass_tank, {
    aim_delay = self._active_presets[1].is_rifle.aim_delay,
    focus_delay = self._active_presets[1].is_rifle.focus_delay,
    FALLOFF = function (falloff)
      manipulate_entries(falloff, "dmg_mul", function (val) return val * dmg_mul end)
    end
  })
  self.tank.weapon = tank_weapon
  self.tank_hw.weapon = tank_weapon
  self.tank_medic.weapon = tank_weapon
  self.tank_mini.weapon = tank_weapon
end

local function set_sniper_weapon_preset(self, dmg_mul, recoil_mul)
  self.sniper.weapon = self.presets.weapon.cass_sniper
  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * dmg_mul end)
  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * recoil_mul, val[2] * recoil_mul } end)
  self.heavy_swat_sniper.weapon = based_on(self.sniper.weapon)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 0.5 end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 0.5, val[2] * 0.5 } end)
end

Hooks:PostHook(CharacterTweakData, "_set_normal", "cass__set_normal", function(self)
  set_cops_weapon_preset(self, "cass_normal", "cass_easy")
  set_tank_weapon_preset(self, 0.7)
  set_sniper_weapon_preset(self, 0.7, 1.3)
end)

Hooks:PostHook(CharacterTweakData, "_set_hard", "cass__set_hard", function(self)
  set_cops_weapon_preset(self, "cass_hard", "cass_normal")
  set_tank_weapon_preset(self, 0.8)
  set_sniper_weapon_preset(self, 0.8, 1.2)
end)

Hooks:PostHook(CharacterTweakData, "_set_overkill", "cass__set_overkill", function(self)
  set_cops_weapon_preset(self, "cass_overkill", "cass_hard")
  set_tank_weapon_preset(self, 0.9)
  set_sniper_weapon_preset(self, 0.9, 1.1)
end)

Hooks:PostHook(CharacterTweakData, "_set_overkill_145", "cass__set_overkill_145", function(self)
  set_cops_weapon_preset(self, "cass_overkill_145", "cass_overkill")
  set_tank_weapon_preset(self, 1)
  set_sniper_weapon_preset(self, 1, 1)
end)

Hooks:PostHook(CharacterTweakData, "_set_easy_wish", "cass__set_easy_wish", function(self)
  set_cops_weapon_preset(self, "cass_easywish", "cass_overkill_145")
  set_tank_weapon_preset(self, 1.1)
  set_sniper_weapon_preset(self, 1.1, 0.9)
end)

Hooks:PostHook(CharacterTweakData, "_set_overkill_290", "cass__set_overkill_290", function(self)
  set_cops_weapon_preset(self, "cass_overkill_290", "cass_easywish")
  set_tank_weapon_preset(self, 1.2)
  set_sniper_weapon_preset(self, 1.2, 0.8)
end)

Hooks:PostHook(CharacterTweakData, "_set_sm_wish", "cass__set_sm_wish", function(self)
  set_cops_weapon_preset(self, "cass_sm_wish", "cass_overkill_290")
  set_tank_weapon_preset(self, 1.3)
  set_sniper_weapon_preset(self, 1.3, 0.7)
end)



