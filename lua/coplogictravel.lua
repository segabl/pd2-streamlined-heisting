-- Fix need for another queued task to update pathing or leaving cover on expired cover time
-- Basicall just does the needed checks before calling the original function to save on a queued update
Hooks:PreHook(CopLogicTravel, "upd_advance", "sh_upd_advance", function (data)
	local unit = data.unit
	local my_data = data.internal_data
	local t = TimerManager:game():time()
	if my_data.processing_advance_path or my_data.processing_coarse_path then
		CopLogicTravel._upd_pathing(data, my_data)
	elseif my_data.cover_leave_t and my_data.cover_leave_t < t then
		if not unit:movement():chk_action_forbidden("walk") and not data.unit:anim_data().reload then
			my_data.cover_leave_t = nil
		end
	end
end)


-- Sanity check for rare follow_unit crash
Hooks:PreHook(CopLogicTravel, "_begin_coarse_pathing", "sh__begin_coarse_pathing", function (data)
	if data.objective.follow_unit and not alive(data.objective.follow_unit) then
		data.objective.follow_unit = nil
	end
end)
