if false then
  return
end

local function _set_orig_npc_dmg(self)
  for k, v in pairs(self._orig_npc_dmg) do
    self[k].DAMAGE = v
  end
end

local function _copy_crew_values(weap, crew_weap)
  weap.sounds.prefix = crew_weap.sounds.prefix
  weap.muzzleflash = crew_weap.muzzleflash
  weap.shell_ejection = crew_weap.shell_ejection
  weap.hold = crew_weap.hold
end

Hooks:PostHook(WeaponTweakData, "init", "cass_init", function(self)
  self.ak47_npc.DAMAGE = 2
  self.mac11_npc.DAMAGE = 2

  -- Fix existing weapons sounds
  self.mac11_npc.sounds.prefix = self.mac10_crew.sounds.prefix
  self.akmsu_smg_npc.sounds.prefix = self.akmsu_crew.sounds.prefix
  self.asval_smg_npc.sounds.prefix = self.asval_crew.sounds.prefix
  --self.ump_npc.sounds.prefix = self.schakal_crew.sounds.prefix
  self.benelli_npc.sounds.prefix = self.ben_crew.sounds.prefix
  self.sr2_smg_npc.sounds.prefix = self.sr2_crew.sounds.prefix
  self.rpk_lmg_npc.sounds.prefix = self.rpk_crew.sounds.prefix

  self.scar_npc = deep_clone(self.m4_npc)
  _copy_crew_values(self.scar_npc, self.scar_crew)
  self.spas12_npc = deep_clone(self.r870_npc)
  _copy_crew_values(self.spas12_npc, self.spas12_crew)
  self.mp7_npc = deep_clone(self.mp5_npc)
  _copy_crew_values(self.mp7_npc, self.mp7_crew)
  self.amcar_npc = deep_clone(self.m4_npc)
  _copy_crew_values(self.amcar_npc, self.amcar_crew)
  self.g36_npc = deep_clone(self.m4_npc)
  _copy_crew_values(self.g36_npc, self.g36_crew)

  self.saiga_npc.CLIP_AMMO_MAX = 20 -- makes blackdozer not useless
  self.saiga_npc.auto.fire_rate = 0.18 -- original is incorrect

  self._orig_npc_dmg = {}
  for k, v in pairs(self) do
    if k:sub(-4) == "_npc" then
      self._orig_npc_dmg[k] = v.DAMAGE
    end
  end
end)

Hooks:PostHook(WeaponTweakData, "_set_normal", "cass__set_normal", function(self)
  _set_orig_npc_dmg(self)
end)

Hooks:PostHook(WeaponTweakData, "_set_hard", "cass__set_hard", function(self)
  _set_orig_npc_dmg(self)
end)

Hooks:PostHook(WeaponTweakData, "_set_overkill", "cass__set_overkill", function(self)
  _set_orig_npc_dmg(self)
end)

Hooks:PostHook(WeaponTweakData, "_set_overkill_145", "cass__set_overkill_145", function(self)
  _set_orig_npc_dmg(self)
end)

Hooks:PostHook(WeaponTweakData, "_set_easy_wish", "cass__set_easy_wish", function(self)
  _set_orig_npc_dmg(self)
end)

Hooks:PostHook(WeaponTweakData, "_set_overkill_290", "cass__set_overkill_290", function(self)
  _set_orig_npc_dmg(self)
end)

Hooks:PostHook(WeaponTweakData, "_set_sm_wish", "cass__set_sm_wish", function(self)
  _set_orig_npc_dmg(self)
end)