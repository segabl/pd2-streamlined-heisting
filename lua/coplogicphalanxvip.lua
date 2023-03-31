-- Retry retreat if the initial retreat objective failed for whatever reason
function CopLogicPhalanxVip._clbk_breakup_fail(data)
	if not data.internal_data or not alive(data.unit) or data.unit:character_damage():dead() then
		return
	end

	CopLogicBase.add_delayed_clbk(data.internal_data, "phalanx_vip_retreat", callback(CopLogicPhalanxVip, CopLogicPhalanxVip, "_assign_retreat_objective", data), 2)
end

function CopLogicPhalanxVip._assign_retreat_objective(data)
	local nav_seg = data.unit:movement():nav_tracker():nav_segment()
	local flee_pos = managers.groupai:state():flee_point(nav_seg)

	if flee_pos then
		data.brain:set_objective({
			forced = true,
			attitude = "avoid",
			type = "flee",
			pos = flee_pos,
			nav_seg = managers.navigation:get_nav_seg_from_pos(flee_pos),
			fail_clbk = callback(CopLogicPhalanxVip, CopLogicPhalanxVip, "_clbk_breakup_fail", data)
		})
	else
		CopLogicPhalanxVip._clbk_breakup_fail(data)
	end
end

function CopLogicPhalanxVip.breakup(remote_call)
	local groupai = managers.groupai:state()
	local phalanx_vip = groupai:phalanx_vip()

	if alive(phalanx_vip) then
		groupai:unit_leave_group(phalanx_vip, false)
		managers.groupai:state():unregister_phalanx_vip()

		CopLogicPhalanxVip._assign_retreat_objective(phalanx_vip:brain()._logic_data)
		phalanx_vip:sound():say("cpw_a04", true, true)
	end

	if not remote_call then
		CopLogicPhalanxMinion.breakup(true)
	end
end
