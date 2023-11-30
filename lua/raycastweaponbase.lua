-- Add chance to concussion effect to make it less obnoxious
local give_impact_damage_original = ConcussiveInstantBulletBase.give_impact_damage
function ConcussiveInstantBulletBase:give_impact_damage(col_ray, weapon_unit, ...)
	local conc_tweak = alive(weapon_unit) and weapon_unit:base().concussion_tweak and weapon_unit:base():concussion_tweak()
	if math.random() < (conc_tweak and conc_tweak.chance or 1) then
		return give_impact_damage_original(self, col_ray, weapon_unit, ...)
	else
		return self.super.give_impact_damage(self, col_ray, weapon_unit, ...)
	end
end
