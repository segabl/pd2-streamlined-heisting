-- Reuse function of idle logic to make enemies in an area aware of a player entering the area
CopLogicTravel.on_area_safety = CopLogicIdle.on_area_safety


-- Update pathing immediately when receiving travel logic or pathing results
Hooks:PostHook(CopLogicTravel, "enter", "sh_enter", CopLogicTravel.upd_advance)

function CopLogicTravel.on_pathing_results(data)
	CopLogicTravel.upd_advance(data)
end


-- Sanity check for rare follow_unit crash
Hooks:PreHook(CopLogicTravel, "_begin_coarse_pathing", "sh__begin_coarse_pathing", function (data)
	if data.objective.follow_unit and not alive(data.objective.follow_unit) then
		data.objective.follow_unit = nil
	end
end)


-- Fix need for another queued task to update pathing or leaving cover on expired cover time
-- Basically just does the needed checks before calling the original function to save on a queued update
Hooks:PreHook(CopLogicTravel, "upd_advance", "sh_upd_advance", function (data)
	local unit = data.unit
	local my_data = data.internal_data
	local t = TimerManager:game():time()
	if my_data.processing_advance_path or my_data.processing_coarse_path then
		CopLogicTravel._upd_pathing(data, my_data)
	elseif my_data.cover_leave_t then
		if my_data.coarse_path and my_data.coarse_path_index == #my_data.coarse_path or my_data.cover_leave_t < t and not unit:movement():chk_action_forbidden("walk") and not data.unit:anim_data().reload then
			my_data.cover_leave_t = nil
		end
	end
end)


-- Make groups move together (remove close to criminal check to avoid splitting groups)
function CopLogicTravel.chk_group_ready_to_move(data, my_data)
	local my_objective = data.objective
	if not my_objective.grp_objective or my_objective.type == "follow" then
		return true
	end

	local my_dis = mvector3.distance_sq(my_objective.area.pos, data.m_pos)
	if my_dis > 4000000 then
		return true
	end

	my_dis = my_dis * (1.15 ^ 2)
	for u_key, u_data in pairs(data.group.units) do
		if u_key ~= data.key then
			local his_objective = u_data.unit:brain():objective()
			if his_objective and his_objective.grp_objective == my_objective.grp_objective and not his_objective.in_place then
				if my_dis < mvector3.distance_sq(his_objective.area.pos, u_data.m_pos) then
					return false
				end
			end
		end
	end

	return true
end


-- If Iter is installed and streamlined path option is used, don't make any further changes
if Iter and Iter.settings and Iter.settings.streamline_path then
	return
end


-- Take the direct path if possible and immediately start pathing instead of waiting for the next update (thanks to RedFlame)
function CopLogicTravel._check_start_path_ahead(data)
	local my_data = data.internal_data

	if my_data.processing_advance_path then
		return
	end

	local coarse_path = my_data.coarse_path
	local next_index = my_data.coarse_path_index + 2
	local total_nav_points = #coarse_path

	if next_index > total_nav_points then
		return
	end

	local to_pos = data.logic._get_exact_move_pos(data, next_index)
	local from_pos = data.pos_rsrv.move_dest.position

	if math.abs(from_pos.z - to_pos.z) < 100 and not managers.navigation:raycast({allow_entry = false, pos_from = from_pos, pos_to = to_pos}) then
		my_data.advance_path = {
			mvector3.copy(from_pos),
			to_pos
		}

		return
	end

	my_data.processing_advance_path = true
	local prio = data.logic.get_pathing_prio(data)
	local nav_segs = CopLogicTravel._get_allowed_travel_nav_segs(data, my_data, to_pos)

	data.unit:brain():search_for_path_from_pos(my_data.advance_path_search_id, from_pos, to_pos, prio, nil, nav_segs)
end

function CopLogicTravel._chk_start_pathing_to_next_nav_point(data, my_data)
	if not CopLogicTravel.chk_group_ready_to_move(data, my_data) then
		return
	end

	local from_pos = data.unit:movement():nav_tracker():field_position()
	local to_pos = CopLogicTravel._get_exact_move_pos(data, my_data.coarse_path_index + 1)

	if math.abs(from_pos.z - to_pos.z) < 100 and not managers.navigation:raycast({allow_entry = false, pos_from = from_pos, pos_to = to_pos}) then
		my_data.advance_path = {
			mvector3.copy(from_pos),
			to_pos
		}

		-- If we don't have to wait for the pathing results, immediately start advancing
		CopLogicTravel._chk_begin_advance(data, my_data)
		if my_data.advancing and my_data.path_ahead then
			CopLogicTravel._check_start_path_ahead(data)
		end

		return
	end

	my_data.processing_advance_path = true
	local prio = data.logic.get_pathing_prio(data)
	local nav_segs = CopLogicTravel._get_allowed_travel_nav_segs(data, my_data, to_pos)

	data.unit:brain():search_for_path(my_data.advance_path_search_id, to_pos, prio, nil, nav_segs)
end
