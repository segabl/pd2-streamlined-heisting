Hooks:PostHook(PlayerTweakData, "_set_easy", "sh__set_easy", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.525
end)

Hooks:PostHook(PlayerTweakData, "_set_normal", "sh__set_normal", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.5
end)

Hooks:PostHook(PlayerTweakData, "_set_hard", "sh__set_hard", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.475
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill", "sh__set_overkill", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.45
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_145", "sh__set_overkill_145", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.425
end)

Hooks:PostHook(PlayerTweakData, "_set_easy_wish", "sh__set_easy_wish", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.4
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_290", "sh__set_overkill_290", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.375
end)

Hooks:PostHook(PlayerTweakData, "_set_sm_wish", "sh__set_sm_wish", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.35
end)

Hooks:PostHook(PlayerTweakData, "init", "sh_init", function (self)
  -- give a base dodge chance as new cop firing mechanics lead to more hit checks which would penalize dodge builds
  self.damage.DODGE_INIT = 0.05
end)