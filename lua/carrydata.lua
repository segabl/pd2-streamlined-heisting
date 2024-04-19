-- Tweak bag stealing conditions
function CarryData:clbk_pickup_SO_verification(unit)
	if not self._steal_SO_data or not self._steal_SO_data.SO_id then
		return false
	end

	if unit:movement():cool() then
		return false
	end

	if not unit:base():char_tweak().steal_loot then
		return false
	end

	local objective = unit:brain():objective()
	if not objective or objective.type == "free" or not objective.area then
		return true
	end

	if objective.grp_objective and objective.grp_objective.type == "reenforce_area" then
		return false
	end

	local nav_seg = unit:movement():nav_tracker():nav_segment()
	if objective.area == self._steal_SO_data.pickup_area or self._steal_SO_data.pickup_area.nav_segs[nav_seg] then
		return objective.area.nav_segs[nav_seg] or managers.groupai:state()._rescue_allowed
	end
end


-- Make enemies run with stolen bags instead of crouchwalking
Hooks:PostHook(CarryData, "_chk_register_steal_SO", "sh__chk_register_steal_SO", function (self)
	if self._steal_SO_data and self._steal_SO_data.pickup_objective and self._steal_SO_data.pickup_objective.followup_objective then
		self._steal_SO_data.pickup_objective.followup_objective.pose = "stand"
	end
end)
