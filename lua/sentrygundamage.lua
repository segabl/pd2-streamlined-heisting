-- Add a small delay before SWAT turrets retract for repair when their shield breaks
Hooks:PostHook(SentryGunDamage, "_apply_damage", "sh__apply_damage", function (self, damage, dmg_shield)
	if dmg_shield and self._shield_health <= 0 and not self._shield_repair_t then
		self._shield_repair_t = TimerManager:game():time() + 1
	end
end)

Hooks:PostHook(SentryGunDamage, "repair_shield", "sh_repair_shield", function (self)
	self._shield_repair_t = nil
end)

function SentryGunDamage:needs_repair()
	return self._shield_health <= 0 and self._shield_repair_t and TimerManager:game():time() > self._shield_repair_t
end
