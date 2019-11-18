if false then
  return
end

local function based_on(preset, values)
  local p = deep_clone(preset)
  if not values then
    return p
  end
  for _, weapon in pairs(p) do
    for val_name, val in pairs(values) do
      weapon[val_name] = type(val) == "function" and val(weapon[val_name]) or val
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

local lower_preset_users = {
  heavy_swat = true,
  fbi_heavy_swat = true,
  medic = true
}
local function set_characters_weapon_preset(self, preset, preset_lower)
  CASS:log("Setting presets to", preset, preset_lower)
  for k, v in pairs(self._default_preset_users) do
    v.weapon = lower_preset_users[k] and self.presets.weapon[preset_lower] or self.presets.weapon[preset]
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
    melee_dmg = 2
  })
  for _, w in pairs(presets.weapon.cass_easy) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 0.1 end)
    manipulate_entries(w.FALLOFF, "acc", function (val) return { val[1] * 0.8, val[2] * 0.8 } end)
  end

  presets.weapon.cass_normal = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 2,
    aim_delay = { 0, 0.35 },
    melee_dmg = 2
  })
  for _, w in pairs(presets.weapon.cass_normal) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 0.2 end)
    manipulate_entries(w.FALLOFF, "acc", function (val) return { val[1] * 0.85, val[2] * 0.85 } end)
  end
  
  presets.weapon.cass_hard = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 1.5,
    aim_delay = { 0, 0.3 },
    melee_dmg = 4
  })
  for _, w in pairs(presets.weapon.cass_hard) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 0.4 end)
    manipulate_entries(w.FALLOFF, "acc", function (val) return { val[1] * 0.9, val[2] * 0.9 } end)
  end
  
  presets.weapon.cass_overkill = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 1.25,
    aim_delay = { 0, 0.25 },
    melee_dmg = 7
  })
  for _, w in pairs(presets.weapon.cass_overkill) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 0.7 end)
    manipulate_entries(w.FALLOFF, "acc", function (val) return { val[1] * 0.95, val[2] * 0.95 } end)
  end

  presets.weapon.cass_easywish = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 0.75,
    aim_delay = { 0, 0.15 },
    melee_dmg = 13
  })
  for _, w in pairs(presets.weapon.cass_easywish) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 2 end)
    manipulate_entries(w.FALLOFF, "acc", function (val) return { val[1] * 1.25, val[2] * 1.25 } end)
  end

  presets.weapon.cass_overkill_290 = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 0.5,
    aim_delay = { 0, 0.1 },
    melee_dmg = 16
  })
  for _, w in pairs(presets.weapon.cass_overkill_290) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 4 end)
    manipulate_entries(w.FALLOFF, "acc", function (val) return { val[1] * 1.5, val[2] * 1.5 } end)
  end

  presets.weapon.cass_sm_wish = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 0.25,
    aim_delay = { 0, 0.05 },
    melee_dmg = 20
  })
  for _, w in pairs(presets.weapon.cass_sm_wish) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 6 end)
    manipulate_entries(w.FALLOFF, "acc", function (val) return { val[1] * 2, val[2] * 2 } end)
  end

  presets.weapon.sniper.is_rifle.focus_delay = 20
  presets.weapon.sniper.is_rifle.FALLOFF = {
    { dmg_mul = 9, r = 0, acc = { 0, 0.5 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 9, r = 1000, acc = { 0.5, 1 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 7, r = 10000, acc = { 0.25, 0.5 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } }
  }
  presets.weapon.heavy_sniper = deep_clone(presets.weapon.sniper)
  presets.weapon.heavy_sniper.is_rifle.FALLOFF = {
    { dmg_mul = 4.5, r = 0, acc = { 0, 0.5 }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 4.5, r = 1000, acc = { 0.5, 1 }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3.5, r = 10000, acc = { 0.25, 0.5 }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } }
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
  
  self._default_preset_users = {}
  for _, name in ipairs(self._enemy_list) do
    if self[name].weapon == self.presets.weapon.normal or self[name].weapon == self.presets.weapon.good then
      self._default_preset_users[name] = self[name]
    end
  end

  self.heavy_swat_sniper.weapon = self.presets.weapon.heavy_sniper
  self.heavy_swat_sniper.damage.hurt_severity = self.presets.hurt_severities.light_hurt_fire_poison
  self.heavy_swat.damage.hurt_severity = self.presets.hurt_severities.light_hurt_fire_poison
  self.fbi_heavy_swat.damage.hurt_severity = self.presets.hurt_severities.light_hurt_fire_poison
end)


Hooks:PostHook(CharacterTweakData, "_set_normal", "cass__set_normal", function(self)
  set_characters_weapon_preset(self, "cass_normal", "cass_easy")

  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 0.7 end)
  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 1.3, val[2] * 1.3 } end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 0.7 end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 1.3, val[2] * 1.3 } end)
end)

Hooks:PostHook(CharacterTweakData, "_set_hard", "cass__set_hard", function(self)
  set_characters_weapon_preset(self, "cass_hard", "cass_normal")

  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 0.8 end)
  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 1.2, val[2] * 1.2 } end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 0.8 end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 1.2, val[2] * 1.2 } end)
end)

Hooks:PostHook(CharacterTweakData, "_set_overkill", "cass__set_overkill", function(self)
  set_characters_weapon_preset(self, "cass_overkill", "cass_hard")

  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 0.9 end)
  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 1.1, val[2] * 1.1 } end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 0.9 end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 1.1, val[2] * 1.1 } end)
end)

Hooks:PostHook(CharacterTweakData, "_set_overkill_145", "cass__set_overkill_145", function(self)
  set_characters_weapon_preset(self, "cass_overkill_145", "cass_overkill")

  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 1 end)
  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 1, val[2] * 1 } end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 1 end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 1, val[2] * 1 } end)
end)

Hooks:PostHook(CharacterTweakData, "_set_easy_wish", "cass__set_easy_wish", function(self)
  set_characters_weapon_preset(self, "cass_easywish", "cass_overkill_145")

  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 1.1 end)
  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 0.9, val[2] * 0.9 } end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 1.1 end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 0.9, val[2] * 0.9 } end)
end)

Hooks:PostHook(CharacterTweakData, "_set_overkill_290", "cass__set_overkill_290", function(self)
  set_characters_weapon_preset(self, "cass_overkill_290", "cass_easywish")

  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 1.2 end)
  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 0.8, val[2] * 0.8 } end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 1.2 end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 0.8, val[2] * 0.8 } end)
end)

Hooks:PostHook(CharacterTweakData, "_set_sm_wish", "cass__set_sm_wish", function(self)
  set_characters_weapon_preset(self, "cass_sm_wish", "cass_overkill_290")

  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 1.3 end)
  manipulate_entries(self.sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 0.7, val[2] * 0.7 } end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "dmg_mul", function (val) return val * 1.3 end)
  manipulate_entries(self.heavy_swat_sniper.weapon.is_rifle.FALLOFF, "recoil", function (val) return { val[1] * 0.7, val[2] * 0.7 } end)
end)



