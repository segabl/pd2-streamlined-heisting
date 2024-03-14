-- Make medics require line of sight to heal
local verify_heal_requesting_unit_original = MedicDamage.verify_heal_requesting_unit
function MedicDamage:verify_heal_requesting_unit(requesting_unit, ...)
	if not verify_heal_requesting_unit_original(self, requesting_unit, ...) then
		return false
	end

	local unit_pos = requesting_unit:movement():m_head_pos()
	local medic_pos = self._unit:movement():m_head_pos()
	return not World:raycast("ray", unit_pos, medic_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "report")
end


-- Fix medics healing during full body actions
local is_available_for_healing_original = MedicDamage.is_available_for_healing
function MedicDamage:is_available_for_healing(requesting_unit, ...)
	if self._unit:movement():chk_action_forbidden("act") then
		return false
	end
	return is_available_for_healing_original(self, requesting_unit, ...)
end
