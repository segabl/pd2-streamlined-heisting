-- Give each difficulty a unique grace period time, revive health and suspicion multipliers
Hooks:PostHook(PlayerTweakData, "_set_normal", "sh__set_normal", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.25
	self.damage.REVIVE_HEALTH_STEPS = { 0.65 }

	self.suspicion.max_value = 6
	self.suspicion.range_mul = 0.8
	self.suspicion.buildup_mul = 0.8
end)

Hooks:PostHook(PlayerTweakData, "_set_hard", "sh__set_hard", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.25
	self.damage.REVIVE_HEALTH_STEPS = { 0.55 }

	self.suspicion.max_value = 7
	self.suspicion.range_mul = 0.9
	self.suspicion.buildup_mul = 0.9
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill", "sh__set_overkill", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.25
	self.damage.REVIVE_HEALTH_STEPS = { 0.45 }

	self.suspicion.max_value = 8
	self.suspicion.range_mul = 1
	self.suspicion.buildup_mul = 1
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_145", "sh__set_overkill_145", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.25
	self.damage.REVIVE_HEALTH_STEPS = { 0.35 }

	self.suspicion.max_value = 9
	self.suspicion.range_mul = 1.1
	self.suspicion.buildup_mul = 1.1
end)

Hooks:PostHook(PlayerTweakData, "_set_easy_wish", "sh__set_easy_wish", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.25
	self.damage.REVIVE_HEALTH_STEPS = { 0.25 }

	self.suspicion.max_value = 10
	self.suspicion.range_mul = 1.2
	self.suspicion.buildup_mul = 1.2
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_290", "sh__set_overkill_290", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.25
	self.damage.REVIVE_HEALTH_STEPS = { 0.15 }

	self.suspicion.max_value = 11
	self.suspicion.range_mul = 1.3
	self.suspicion.buildup_mul = 1.3
end)

Hooks:PostHook(PlayerTweakData, "_set_sm_wish", "sh__set_sm_wish", function (self)
	self.damage.MIN_DAMAGE_INTERVAL = 0.25
	self.damage.REVIVE_HEALTH_STEPS = { 0.05 }

	self.suspicion.max_value = 12
	self.suspicion.range_mul = 1.4
	self.suspicion.buildup_mul = 1.4
end)


-- Slightly increase bleed out health and increase suppression decay speed
Hooks:PostHook(PlayerTweakData, "init", "sh_init", function (self)
	self.damage.BLEED_OUT_HEALTH_INIT = 20
	self.damage.MIN_DAMAGE_INTERVAL = 0.25
	self.damage.respawn_time_penalty = 20
	self.suppression.max_value = 5
	self.suppression.receive_mul = 1
	self.suppression.tolerance = 0
end)


-- No faster armor recovery in SP
function PlayerTweakData:_set_singleplayer() end
