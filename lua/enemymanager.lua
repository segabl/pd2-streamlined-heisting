-- Make medics require line of sight to heal
function EnemyManager:get_nearby_medic(unit)
	if self:is_civilian(unit) then
		return
	end

	local unit_pos = unit:movement():m_head_pos()
	local enemies = World:find_units_quick(unit, "sphere", unit_pos, tweak_data.medic.radius, managers.slot:get_mask("enemies"))
	for _, enemy in pairs(enemies) do
		if enemy:base():has_tag("medic") and not World:raycast("ray", unit_pos, enemy:movement():m_head_pos(), "slot_mask", managers.slot:get_mask("AI_visibility")) then
			return enemy
		end
	end
end
