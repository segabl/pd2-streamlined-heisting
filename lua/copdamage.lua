-- Health granularity prevents linear damage interpolation of AI against other AI from working
-- correctly and notably rounds up damage against enemies with a high HP pool even for player weapons.
-- Increasing the health granularity makes damage dealt more accurate to the actual weapon damage stats
CopDamage._HEALTH_GRANULARITY = 8192


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
