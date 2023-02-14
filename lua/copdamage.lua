-- Health granularity prevents linear damage interpolation of AI against other AI from working
-- correctly and notably rounds up damage against enemies with a high HP pool even for player weapons.
-- Increasing the health granularity makes damage dealt more accurate to the actual weapon damage stats
CopDamage._HEALTH_GRANULARITY = 8192


-- Make head hitbox size consistent across enemies
Hooks:PostHook(CopDamage, "init", "sh_init", function (self)
	local head_body = self._unit:body(self._head_body_name or "head")
	if head_body then
		head_body:set_sphere_radius(18)
	end
end)


-- Make these functions check that the attacker unit is a player (to make sure NPC vs NPC melee doesn't crash)
local _dismember_condition_original = CopDamage._dismember_condition
function CopDamage:_dismember_condition(attack_data, ...)
	if alive(attack_data.attacker_unit) and attack_data.attacker_unit:base().is_local_player then
		return _dismember_condition_original(self, attack_data, ...)
	end
end

local _sync_dismember_original = CopDamage._sync_dismember
function CopDamage:_sync_dismember(attacker_unit, ...)
	if alive(attacker_unit) and attacker_unit:base().is_husk_player then
		return _sync_dismember_original(self, attacker_unit, ...)
	end
end


-- Don't set suppression to maximum on hit, increase by a static value instead
local build_suppression_original = CopDamage.build_suppression
function CopDamage:build_suppression(amount, ...)
	return build_suppression_original(self, amount == "max" and 2 or amount, ...)
end


-- Fixed critical hit multiplier
function CopDamage:roll_critical_hit(attack_data)
	if self:can_be_critical(attack_data) and math.random() < managers.player:critical_hit_chance() then
		return true, attack_data.damage * 3
	end

	return false, attack_data.damage
end
