if false then
  return
end

local function _set_orig_npc_dmg(self)
  for k, v in pairs(self._orig_npc_dmg) do
    self[k].DAMAGE = v
  end
end

Hooks:PostHook(WeaponTweakData, "init", "cass_init", function(self)
  self.g36_npc.DAMAGE = 1
  self.ak47_npc.DAMAGE = 2
  self.mac11_npc.DAMAGE = 2
  self._orig_npc_dmg = {}
  for k, v in pairs(self) do
    if k:sub(-4) == "_npc" then
      self._orig_npc_dmg[k] = v.DAMAGE
    end
  end

  self.benelli_npc.sounds.prefix = self.ben_crew.sounds.prefix
  self.spas12_npc = deep_clone(self.r870_npc)
  self.spas12_npc.sounds.prefix = self.spas12_crew.sounds.prefix
  self.mp7_npc = deep_clone(self.mp5_npc)
  self.mp7_npc.sounds.prefix = self.mp7_crew.sounds.prefix
  self.mp7_npc.hold = self.mp7_crew.hold
  self.amcar_npc = deep_clone(self.m4_npc)
  self.amcar_npc.sounds.prefix = self.amcar_crew.sounds.prefix
  self.g36_npc = deep_clone(self.m4_npc)
  self.g36_npc.sounds.prefix = self.g36_crew.sounds.prefix
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