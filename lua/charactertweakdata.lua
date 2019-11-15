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
    v[value_name] = func(v[value_name])
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
    { dmg_mul = 5, r = 0, acc = { 0.5, 0.8 }, recoil = { 0.1, 0.25 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 1, r = 3000, acc = { 0, 0.1 }, recoil = { 0.5, 1.5 }, mode = { 1, 0, 0, 0 } }
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
  presets.weapon.cass_easy.is_smg = presets.weapon.cass_easy.is_rifle -- normal spawns blue swats wich use smgs that are fairly different from regular rifle units
  

  presets.weapon.cass_normal = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 2,
    aim_delay = { 0, 0.35 },
    melee_dmg = 2
  })
  for _, w in pairs(presets.weapon.cass_normal) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 0.2 end)
    manipulate_entries(w.FALLOFF, "acc", function (val) return { val[1] * 0.85, val[2] * 0.85 } end)
  end
  presets.weapon.cass_normal.is_smg = presets.weapon.cass_normal.is_rifle -- normal spawns blue swats wich use smgs that are fairly different from regular rifle units
  
  
  presets.weapon.cass_hard = based_on(presets.weapon.cass_overkill_145, {
    focus_delay = 1.5,
    aim_delay = { 0, 0.3 },
    melee_dmg = 4
  })
  for _, w in pairs(presets.weapon.cass_hard) do
    manipulate_entries(w.FALLOFF, "dmg_mul", function (val) return val * 0.4 end)
    manipulate_entries(w.FALLOFF, "acc", function (val) return { val[1] * 0.9, val[2] * 0.9 } end)
  end
  presets.weapon.cass_hard.is_smg = presets.weapon.cass_hard.is_rifle -- hard spawns blue swats wich use smgs that are fairly different from regular rifle units
  
  
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
  presets.weapon.heavy_sniper = deep_clone(presets.weapon.sniper)

  return presets
end

function CharacterTweakData:_multiply_weapon_delay(weap_usage_table, mul)
  -- wtf was that function overkill, always called with 0 values
end

Hooks:PostHook(CharacterTweakData, "init", "cass_init", function(self)
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

  self.sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 6, r = 0, acc = { 0, 0.5 }, recoil = { 5, 7 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 6, r = 1000, acc = { 0.5, 1 }, recoil = { 5, 7 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 4, r = 10000, acc = { 0.25, 0.5 }, recoil = { 5, 7 }, mode = { 1, 0, 0, 0 } }
  }
  self.heavy_swat_sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 3, r = 0, acc = { 0, 0.5 }, recoil = { 2.5, 3.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3, r = 1000, acc = { 0.5, 1 }, recoil = { 2.5, 3.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2, r = 10000, acc = { 0.25, 0.5 }, recoil = { 2.5, 3.5 }, mode = { 1, 0, 0, 0 } }
  }
end)

Hooks:PostHook(CharacterTweakData, "_set_hard", "cass__set_hard", function(self)
  set_characters_weapon_preset(self, "cass_hard", "cass_normal")

  self.sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 7, r = 0, acc = { 0, 0.5 }, recoil = { 4, 6 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 7, r = 1000, acc = { 0.5, 1 }, recoil = { 4, 6 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 5, r = 10000, acc = { 0.25, 0.5 }, recoil = { 4, 6 }, mode = { 1, 0, 0, 0 } }
  }
  self.heavy_swat_sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 3.5, r = 0, acc = { 0, 0.5 }, recoil = { 2, 3 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3.5, r = 1000, acc = { 0.5, 1 }, recoil = { 2, 3 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 2.5, r = 10000, acc = { 0.25, 0.5 }, recoil = { 2, 3 }, mode = { 1, 0, 0, 0 } }
  }
end)

Hooks:PostHook(CharacterTweakData, "_set_overkill", "cass__set_overkill", function(self)
  set_characters_weapon_preset(self, "cass_overkill", "cass_hard")

  self.sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 8, r = 0, acc = { 0, 0.5 }, recoil = { 4, 6 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 8, r = 1000, acc = { 0.5, 1 }, recoil = { 4, 6 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 6, r = 10000, acc = { 0.25, 0.5 }, recoil = { 4, 6 }, mode = { 1, 0, 0, 0 } }
  }
  self.heavy_swat_sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 4, r = 0, acc = { 0, 0.5 }, recoil = { 2, 3 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 4, r = 1000, acc = { 0.5, 1 }, recoil = { 2, 3 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3, r = 10000, acc = { 0.25, 0.5 }, recoil = { 2, 3 }, mode = { 1, 0, 0, 0 } }
  }
end)

Hooks:PostHook(CharacterTweakData, "_set_overkill_145", "cass__set_overkill_145", function(self)
  set_characters_weapon_preset(self, "cass_overkill_145", "cass_overkill")

  self.sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 9, r = 0, acc = { 0, 0.5 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 9, r = 1000, acc = { 0.5, 1 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 7, r = 10000, acc = { 0.25, 0.5 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } }
  }
  self.heavy_swat_sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 4.5, r = 0, acc = { 0, 0.5 }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 4.5, r = 1000, acc = { 0.5, 1 }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 3.5, r = 10000, acc = { 0.25, 0.5 }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } }
  }
end)

Hooks:PostHook(CharacterTweakData, "_set_easy_wish", "cass__set_easy_wish", function(self)
  set_characters_weapon_preset(self, "cass_easywish", "cass_overkill_145")

  self.sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 10, r = 0, acc = { 0, 0.5 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 10, r = 1000, acc = { 0.5, 1 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 8, r = 10000, acc = { 0.25, 0.5 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } }
  }
  self.heavy_swat_sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 5, r = 0, acc = { 0, 0.5 }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 5, r = 1000, acc = { 0.5, 1 }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 4, r = 10000, acc = { 0.25, 0.5 }, recoil = { 1.5, 2.5 }, mode = { 1, 0, 0, 0 } }
  }
end)

Hooks:PostHook(CharacterTweakData, "_set_overkill_290", "cass__set_overkill_290", function(self)
  set_characters_weapon_preset(self, "cass_overkill_290", "cass_easywish")

  self.sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 11, r = 0, acc = { 0, 0.5 }, recoil = { 2, 4 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 11, r = 1000, acc = { 0.5, 1 }, recoil = { 2, 4 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 9, r = 10000, acc = { 0.25, 0.5 }, recoil = { 2, 4 }, mode = { 1, 0, 0, 0 } }
  }
  self.heavy_swat_sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 5.5, r = 0, acc = { 0, 0.5 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 5.5, r = 1000, acc = { 0.5, 1 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 4.5, r = 10000, acc = { 0.25, 0.5 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
  }
end)

Hooks:PostHook(CharacterTweakData, "_set_sm_wish", "cass__set_sm_wish", function(self)
  set_characters_weapon_preset(self, "cass_sm_wish", "cass_overkill_290")

  self.sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 12, r = 0, acc = { 0, 0.5 }, recoil = { 2, 4 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 12, r = 1000, acc = { 0.5, 1 }, recoil = { 2, 4 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 10, r = 10000, acc = { 0.25, 0.5 }, recoil = { 2, 4 }, mode = { 1, 0, 0, 0 } }
  }
  self.heavy_swat_sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 6, r = 0, acc = { 0, 0.5 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 6, r = 1000, acc = { 0.5, 1 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 5, r = 10000, acc = { 0.25, 0.5 }, recoil = { 1, 2 }, mode = { 1, 0, 0, 0 } }
  }
end)



