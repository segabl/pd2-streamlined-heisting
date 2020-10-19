-- Give each difficulty a unique grace period time and revive health

Hooks:PostHook(PlayerTweakData, "_set_easy", "sh__set_easy", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.55
  self.damage.REVIVE_HEALTH_STEPS = { 0.8 }
end)

Hooks:PostHook(PlayerTweakData, "_set_normal", "sh__set_normal", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.5
  self.damage.REVIVE_HEALTH_STEPS = { 0.7 }
end)

Hooks:PostHook(PlayerTweakData, "_set_hard", "sh__set_hard", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.45
  self.damage.REVIVE_HEALTH_STEPS = { 0.6 }
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill", "sh__set_overkill", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.4
  self.damage.REVIVE_HEALTH_STEPS = { 0.5 }
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_145", "sh__set_overkill_145", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.35
  self.damage.REVIVE_HEALTH_STEPS = { 0.4 }
end)

Hooks:PostHook(PlayerTweakData, "_set_easy_wish", "sh__set_easy_wish", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.3
  self.damage.REVIVE_HEALTH_STEPS = { 0.3 }
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_290", "sh__set_overkill_290", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.25
  self.damage.REVIVE_HEALTH_STEPS = { 0.2 }
end)

Hooks:PostHook(PlayerTweakData, "_set_sm_wish", "sh__set_sm_wish", function (self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.2
  self.damage.REVIVE_HEALTH_STEPS = { 0.1 }
end)
