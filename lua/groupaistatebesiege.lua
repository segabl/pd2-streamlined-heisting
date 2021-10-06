local math_abs = math.abs
local math_min = math.min
local math_lerp = math.lerp
local math_random = math.random
local table_insert = table.insert
local table_remove = table.remove
local mvec_dis = mvector3.distance
local mvec_dis_sq = mvector3.distance_sq


-- Make hostage count affect hesitation delay
local _begin_assault_task_original = GroupAIStateBesiege._begin_assault_task
function GroupAIStateBesiege:_begin_assault_task(...)
	self._task_data.assault.was_first = self._task_data.assault.is_first

	_begin_assault_task_original(self, ...)

	if self._hostage_headcount > 0 then
		local assault_task = self._task_data.assault
		local anticipation_duration = self:_get_anticipation_duration(self._tweak_data.assault.anticipation_duration, assault_task.was_first)
		local hesitation_delay = self:_get_difficulty_dependent_value(self._tweak_data.assault.hostage_hesitation_delay)
		local hostage_multiplier = math.clamp(self._hostage_headcount, 1, 4)
		assault_task.phase_end_t = self._t + anticipation_duration + hesitation_delay * hostage_multiplier
		assault_task.is_hesitating = true
		assault_task.voice_delay = self._t + (assault_task.phase_end_t - self._t) / 2
	end
end


-- Make medic and minigun dozer count as dozers
local _get_special_unit_type_count_original = GroupAIStateBesiege._get_special_unit_type_count
function GroupAIStateBesiege:_get_special_unit_type_count(special_type, ...)
	if special_type ~= "tank" then
		return _get_special_unit_type_count_original(self, special_type, ...)
	end
	return _get_special_unit_type_count_original(self, "tank_medic", ...) + _get_special_unit_type_count_original(self, "tank_mini", ...) + _get_special_unit_type_count_original(self, "tank", ...)
end


-- Improve ending condition for assault fade
-- The hardcoded amount of minimum enemies left was way too high and would lead to fade being instantly over after its minimum duration
local _upd_assault_task_original = GroupAIStateBesiege._upd_assault_task
function GroupAIStateBesiege:_upd_assault_task(...)
	local task_data = self._task_data.assault

	if not task_data.active then
		return
	end

	if task_data.phase ~= "fade" then
		return _upd_assault_task_original(self, ...)
	end

	self:_assign_recon_groups_to_retire()

	if not self._hunt_mode then
		local end_assault
		local is_skirmish = managers.skirmish:is_skirmish()
		local enemies_defeated_time_limit = is_skirmish and 0 or self._tweak_data.assault.fade_settings.enemies_defeated_time_limit or 30
		local drama_engagement_time_limit = is_skirmish and 0 or self._tweak_data.assault.fade_settings.drama_engagement_time_limit or 30
		local enemies_left = self:_count_police_force("assault")
		local min_enemies_left = task_data.force * (self._tweak_data.assault.fade_settings.enemies_defeated_percentage or 0.5)
		local enemies_defeated = enemies_left < min_enemies_left or self._t > task_data.phase_end_t + enemies_defeated_time_limit
		if enemies_defeated then
			if not task_data.said_retreat then
				task_data.said_retreat = true
				self:_police_announce_retreat()
			elseif task_data.phase_end_t < self._t then
				local drama_pass = self._drama_data.amount < tweak_data.drama.assault_fade_end
				local engagement_pass = self:_count_criminals_engaged_force(11) <= 10
				local taking_too_long = self._t > task_data.phase_end_t + drama_engagement_time_limit
				end_assault = drama_pass and engagement_pass or taking_too_long
			end
		end

		if task_data.force_end or end_assault then
			task_data.active = nil
			task_data.phase = nil
			task_data.said_retreat = nil
			task_data.force_end = nil
			local force_regroup = task_data.force_regroup
			task_data.force_regroup = nil

			if self._draw_drama then
				self._draw_drama.assault_hist[#self._draw_drama.assault_hist][2] = self._t
			end

			managers.mission:call_global_event("end_assault")
			self:_begin_regroup_task(force_regroup)
			return
		end
	end

	if self._drama_data.amount <= tweak_data.drama.low then
		for criminal_key, criminal_data in pairs(self._player_criminals) do
			self:criminal_spotted(criminal_data.unit)

			for _, group in pairs(self._groups) do
				if group.objective.charge then
					for _, u_data in pairs(group.units) do
						u_data.unit:brain():clbk_group_member_attention_identified(nil, criminal_key)
					end
				end
			end
		end
	end

	local primary_target_area = task_data.target_areas[1]
	if self:is_area_safe_assault(primary_target_area) then
		local target_pos = primary_target_area.pos
		local nearest_area, nearest_dis

		for _, criminal_data in pairs(self._player_criminals) do
			if not criminal_data.status then
				local dis = mvec_dis_sq(target_pos, criminal_data.m_pos)

				if not nearest_dis or dis < nearest_dis then
					nearest_dis = dis
					nearest_area = self:get_area_from_nav_seg_id(criminal_data.tracker:nav_segment())
				end
			end
		end

		if nearest_area then
			primary_target_area = nearest_area
			task_data.target_areas[1] = nearest_area
		end
	end

	if task_data.use_smoke_timer < self._t then
		task_data.use_smoke = true
	end

	self:detonate_queued_smoke_grenades()

	self:_assign_enemy_groups_to_assault(task_data.phase)
end


-- Add an alternate in_place check to prevent enemy groups from getting stuck
function GroupAIStateBesiege:_assign_enemy_groups_to_assault(phase)
	for _, group in pairs(self._groups) do
		if group.has_spawned and group.objective.type == "assault_area" then
			if group.objective.moving_out then
				local done_moving

				for _, u_data in pairs(group.units) do
					local objective = u_data.unit:brain():objective()
					if objective and objective.grp_objective == group.objective then
						if objective.in_place or objective.area and objective.area.nav_segs[u_data.unit:movement():nav_tracker():nav_segment()] then
							done_moving = true
						else
							done_moving = false
							break
						end
					end
				end

				if done_moving then
					group.objective.moving_out = nil
					group.in_place_t = self._t
					group.objective.moving_in = nil
					self:_voice_move_complete(group)
				end
			end

			if not group.objective.moving_in then
				self:_set_assault_objective_to_group(group, phase)
			end
		end
	end
end


-- Fix more cases of stuck enemies
function GroupAIStateBesiege:_set_assault_objective_to_group(group, phase)
	local phase_is_anticipation = phase == "anticipation"
	local current_objective = group.objective
	local approach, open_fire, push, pull_back, charge
	local obstructed_area = self:_chk_group_areas_tresspassed(group)
	local group_leader_u_key, group_leader_u_data = self._determine_group_leader(group.units)
	local in_place_duration = group.in_place_t and self._t - group.in_place_t or 0
	local tactics_map = {}

	if group_leader_u_data and group_leader_u_data.tactics then
		for _, tactic_name in ipairs(group_leader_u_data.tactics) do
			tactics_map[tactic_name] = true
		end

		if current_objective.tactic and not tactics_map[current_objective.tactic] then
			current_objective.tactic = nil
		end

		for i_tactic, tactic_name in ipairs(group_leader_u_data.tactics) do
			if tactic_name == "deathguard" and not phase_is_anticipation then
				if current_objective.tactic == tactic_name then
					for u_key, u_data in pairs(self._char_criminals) do
						if u_data.status and current_objective.follow_unit == u_data.unit then
							if current_objective.area.nav_segs[u_data.tracker:nav_segment()] then
								return
							end
						end
					end
				end

				local closest_crim_u_data, closest_crim_dis_sq
				for u_key, u_data in pairs(self._char_criminals) do
					if u_data.status then
						local closest_u_id, closest_u_data, closest_u_dis_sq = self._get_closest_group_unit_to_pos(u_data.m_pos, group.units)
						if closest_u_dis_sq and (not closest_crim_dis_sq or closest_u_dis_sq < closest_crim_dis_sq) then
							closest_crim_u_data = u_data
							closest_crim_dis_sq = closest_u_dis_sq
						end
					end
				end

				if closest_crim_u_data then
					local search_params = {
						id = "GroupAI_deathguard",
						from_tracker = group_leader_u_data.unit:movement():nav_tracker(),
						to_tracker = closest_crim_u_data.tracker,
						access_pos = self._get_group_acces_mask(group)
					}
					local coarse_path = managers.navigation:search_coarse(search_params)

					if coarse_path then
						local grp_objective = {
							distance = 800,
							type = "assault_area",
							attitude = "engage",
							tactic = "deathguard",
							moving_in = true,
							follow_unit = closest_crim_u_data.unit,
							area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
							coarse_path = coarse_path
						}
						group.is_chasing = true

						self:_set_objective_to_enemy_group(group, grp_objective)
						self:_voice_deathguard_start(group)
						return
					end
				end
			elseif tactic_name == "charge" and not current_objective.moving_out then
				charge = true
			end
		end
	end

	local objective_area = current_objective.area
	if obstructed_area then
		if phase_is_anticipation then
			-- If we run into enemies during anticipation, pull back
			pull_back = true
		elseif current_objective.moving_out and tactics_map.ranged_fire then
			-- If we run into enemies while moving out, open fire (if we aren't already doing that)
			open_fire = not current_objective.open_fire
		elseif not current_objective.pushed or charge and not current_objective.charge then
			-- If we run into enemies and haven't pushed yet, push
			push = true
		end
	elseif not current_objective.moving_out then
		-- Check if there are any criminals close to our objective area
		local has_criminals_close = next(objective_area.criminal.units) and true
		if not has_criminals_close then
			local objective_pos = objective_area.pos
			local max_dis_sq = charge and 1000000 or 4000000
			for _, u_data in pairs(self:all_criminals()) do
				if math_abs(u_data.m_pos.z - objective_pos.z) < 300 and mvec_dis_sq(u_data.m_pos, objective_pos) < max_dis_sq then
					has_criminals_close = true
					break
				end
			end
		end

		-- Check if any of our group members can see an enemy
		local has_visible_target, logic_data, focus_enemy
		for _, u_data in pairs(group.units) do
			logic_data = u_data.unit:brain()._logic_data
			focus_enemy = logic_data and logic_data.attention_obj
			if focus_enemy and focus_enemy.reaction >= AIAttentionObject.REACT_AIM and focus_enemy.verified then
				has_visible_target = true
				break
			end
		end

		if charge then
			-- When we are charging, always move closer, push if enemies are already close
			approach = not has_criminals_close
			push = not approach
		elseif not has_criminals_close or not group.in_place_t then
			-- If no criminals are close or if we just spawned, approach if we can't see any enemy, are not using ranged fire or have been in place for a while
			-- Open fire otherwise (if we aren't already doing that)
			approach = not has_visible_target or not tactics_map.ranged_fire or in_place_duration > 10
			open_fire = not approach and not current_objective.open_fire
		else
			-- If none of the above applies, push if we can't see any enemy or if we're chasing, open fire otherwise (if we aren't already doing that)
			push = not has_visible_target or group.is_chasing or not tactics_map.ranged_fire
			open_fire = not push and not current_objective.open_fire
		end
	end

	if open_fire then
		objective_area = obstructed_area or objective_area
		local grp_objective = {
			attitude = "engage",
			pose = "stand",
			type = "assault_area",
			stance = "hos",
			open_fire = true,
			tactic = current_objective.tactic,
			area = objective_area,
			coarse_path = {
				{
					objective_area.pos_nav_seg,
					mvector3.copy(objective_area.pos)
				}
			}
		}

		self:_set_objective_to_enemy_group(group, grp_objective)
		self:_voice_open_fire_start(group)
	elseif approach or push then
		local assault_area, alternate_assault_area, alternate_assault_area_from, assault_path, alternate_assault_path
		local to_search_areas = {
			objective_area
		}
		local found_areas = {
			[objective_area] = "init"
		}

		repeat
			local search_area = table_remove(to_search_areas)

			if next(search_area.criminal.units) then
				local assault_from_here = true

				if not push and tactics_map.flank then
					local assault_from_area = found_areas[search_area]

					if assault_from_area ~= "init" then
						assault_from_here = false

						if not alternate_assault_area or math_random() < 0.5 then
							local search_params = {
								id = "GroupAI_assault",
								from_seg = current_objective.area.pos_nav_seg,
								to_seg = search_area.pos_nav_seg,
								access_pos = self._get_group_acces_mask(group),
								verify_clbk = callback(self, self, "is_nav_seg_safe")
							}
							alternate_assault_path = managers.navigation:search_coarse(search_params)

							if alternate_assault_path then
								self:_merge_coarse_path_by_area(alternate_assault_path)
								alternate_assault_area = search_area
								alternate_assault_area_from = assault_from_area
							end
						end

						found_areas[search_area] = nil
					end
				end

				if assault_from_here then
					local search_params = {
						id = "GroupAI_assault",
						from_seg = current_objective.area.pos_nav_seg,
						to_seg = search_area.pos_nav_seg,
						access_pos = self._get_group_acces_mask(group),
						verify_clbk = callback(self, self, "is_nav_seg_safe")
					}
					assault_path = managers.navigation:search_coarse(search_params)

					if assault_path then
						self:_merge_coarse_path_by_area(assault_path)
						assault_area = search_area
						break
					end
				end
			else
				for _, other_area in pairs(search_area.neighbours) do
					if not found_areas[other_area] then
						table_insert(to_search_areas, other_area)
						found_areas[other_area] = search_area
					end
				end
			end
		until #to_search_areas == 0

		if not assault_area and alternate_assault_area then
			assault_area = alternate_assault_area
			found_areas[assault_area] = alternate_assault_area_from
			assault_path = alternate_assault_path
		end

		if assault_area and assault_path then
			assault_area = push and assault_area or found_areas[assault_area] == "init" and objective_area or found_areas[assault_area]

			if #assault_path > 2 and assault_area.nav_segs[assault_path[#assault_path - 1][1]] then
				table_remove(assault_path)
			end

			local used_grenade
			if push then
				local detonate_pos
				if charge then
					for _, c_data in pairs(assault_area.criminal.units) do
						detonate_pos = c_data.unit:movement():m_pos()
						break
					end
				end

				-- Check which grenade to use to push, grenade use is required for the push to be initiated
				-- If grenade isn't available, push regardless anyway after a short delay
				used_grenade = self:_chk_group_use_grenade(group, detonate_pos) or group.ignore_grenade_check_t and group.ignore_grenade_check_t <= self._t

				if used_grenade then
					self:_voice_move_in_start(group)
				elseif not group.ignore_grenade_check_t then
					group.ignore_grenade_check_t = self._t + 2
				end
			end

			if not push or used_grenade then
				local grp_objective = {
					type = "assault_area",
					stance = "hos",
					area = assault_area,
					coarse_path = assault_path,
					pose = push and "crouch" or "stand",
					attitude = push and "engage" or "avoid",
					moving_in = push and true or nil,
					open_fire = push or nil,
					pushed = push or nil,
					charge = charge,
					interrupt_dis = charge and 0 or nil
				}
				group.is_chasing = group.is_chasing or push

				self:_set_objective_to_enemy_group(group, grp_objective)
			end
		end
	elseif pull_back then
		local retreat_area

		for _, u_data in pairs(group.units) do
			local nav_seg_id = u_data.tracker:nav_segment()

			if current_objective.area.nav_segs[nav_seg_id] then
				retreat_area = current_objective.area
				break
			end

			if self:is_nav_seg_safe(nav_seg_id) then
				retreat_area = self:get_area_from_nav_seg_id(nav_seg_id)
				break
			end
		end

		if not retreat_area and current_objective.coarse_path then
			local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)
			if forwardmost_i_nav_point then
				retreat_area = self:get_area_from_nav_seg_id(current_objective.coarse_path[forwardmost_i_nav_point][1])
			end
		end

		if retreat_area then
			local new_grp_objective = {
				attitude = "avoid",
				stance = "hos",
				pose = "crouch",
				type = "assault_area",
				area = retreat_area,
				coarse_path = {
					{
						retreat_area.pos_nav_seg,
						mvector3.copy(retreat_area.pos)
					}
				}
			}
			group.is_chasing = nil

			self:_set_objective_to_enemy_group(group, new_grp_objective)
			return
		end
	end
end


-- Optimize this function to use existing area lookups instead of nested loops
function GroupAIStateBesiege:_chk_group_areas_tresspassed(group)
	for _, u_data in pairs(group.units) do
		local area = self:get_area_from_nav_seg_id(u_data.tracker:nav_segment())
		if not self:is_area_safe(area) then
			return area
		end
	end
end


-- Add custom grenade usage function
function GroupAIStateBesiege:_chk_group_use_grenade(group, detonate_pos)
	local task_data = self._task_data.assault
	if not task_data.use_smoke then
		-- If a grenade was previously used within a certain timeframe, count that as a successful current use
		return task_data.use_smoke_push_t and task_data.use_smoke_push_t <= self._t
	end

	local grenade_types = {
		smoke_grenade = true,
		flash_grenade = true
	}
	local grenade_candidates = {}
	for _, u_data in pairs(group.units) do
		if u_data.tactics_map then
			for grenade_type, _ in pairs(grenade_types) do
				if u_data.tactics_map[grenade_type] then
					table.insert(grenade_candidates, { grenade_type, u_data })
				end
			end
		end
	end

	if #grenade_candidates == 0 then
		return
	end

	local candidate = table.random(grenade_candidates)
	local grenade_type = candidate[1]
	local grenade_user = candidate[2]

	local area
	if detonate_pos then
		area = self:get_area_from_nav_seg_id(managers.navigation:get_nav_seg_from_pos(detonate_pos, true))
	else
		local nav_seg = managers.navigation._nav_segments[grenade_user.tracker:nav_segment()]
		for neighbour_nav_seg_id, door_list in pairs(nav_seg.neighbours) do
			area = self:get_area_from_nav_seg_id(neighbour_nav_seg_id)
			if task_data.target_areas[1].nav_segs[neighbour_nav_seg_id] or next(area.criminal.units) then
				local random_door_id = door_list[math_random(#door_list)]
				if type(random_door_id) == "number" then
					detonate_pos = managers.navigation._room_doors[random_door_id].center
				else
					detonate_pos = random_door_id:script_data().element:nav_link_end_pos()
				end
				break
			end
		end
	end

	if not detonate_pos then
		return
	end

	if area and area.criminal_entered_t and table.size(area.neighbours) <= 2 and math_random() < (self._t - area.criminal_entered_t - 60) / 240 then
		-- If players camp a specific area for too long, turn the originally chosen grenade into a teargas grenade instead
		area.criminal_entered_t = nil
		grenade_type = "cs_grenade"

		detonate_pos = mvector3.copy(area.pos)
		for _, v in pairs(area.criminal.units) do
			mvector3.add(detonate_pos, v.unit:movement():m_pos())
		end
		mvector3.divide(detonate_pos, table.size(area.criminal.units) + 1)
		mvector3.set_z(detonate_pos, area.pos.z)

		self:detonate_cs_grenade(detonate_pos, mvector3.copy(grenade_user.m_pos), tweak_data.group_ai.cs_grenade_lifetime or 10)
	else
		if grenade_type == "flash_grenade" and grenade_user.char_tweak.chatter.flash_grenade then
			self:chk_say_enemy_chatter(grenade_user.unit, grenade_user.m_pos, "flash_grenade")
		elseif grenade_type == "smoke_grenade" and grenade_user.char_tweak.chatter.smoke then
			self:chk_say_enemy_chatter(grenade_user.unit, grenade_user.m_pos, "smoke")
		end

		self:detonate_smoke_grenade(detonate_pos, mvector3.copy(grenade_user.m_pos), tweak_data.group_ai[grenade_type .. "_lifetime"] or 10, grenade_type == "flash_grenade")
	end

	local timeout = tweak_data.group_ai[grenade_type .. "_timeout"] or tweak_data.group_ai.smoke_and_flash_grenade_timeout
	task_data.use_smoke_push_t = self._t + timeout[1] * 0.15
	task_data.use_smoke_timer = self._t + math_lerp(timeout[1], timeout[2], math_random())
	task_data.use_smoke = false

	return true
end


-- Keep recon groups around during anticipation
-- Making them retreat only afterwards gives them more time to complete their objectives
local _assign_recon_groups_to_retire_original = GroupAIStateBesiege._assign_recon_groups_to_retire
function GroupAIStateBesiege:_assign_recon_groups_to_retire(...)
	if self._task_data.assault.phase == "anticipation" then
		return
	end
	return _assign_recon_groups_to_retire_original(self, ...)
end


-- Reduce the importance of spawn group distance in spawn group weight to encourage enemies spawning from more directions
-- Also slightly optimized this function to properly check all areas
function GroupAIStateBesiege:_find_spawn_group_near_area(target_area, allowed_groups, target_pos, max_dis, verify_clbk)
	target_pos = target_pos or target_area.pos
	max_dis = max_dis and max_dis * max_dis

	local t = self._t
	local valid_spawn_groups = {}
	local valid_spawn_group_distances = {}

	for _, area in pairs(self._area_data) do
		local spawn_groups = area.spawn_groups
		if spawn_groups then
			for _, spawn_group in ipairs(spawn_groups) do
				if spawn_group.delay_t <= t and (not verify_clbk or verify_clbk(spawn_group)) then
					local dis_id = tostring(spawn_group.nav_seg) .. "-" .. tostring(target_area.pos_nav_seg)

					if not self._graph_distance_cache[dis_id] then
						local path = managers.navigation:search_coarse({
							access_pos = "swat",
							from_seg = spawn_group.nav_seg,
							to_seg = target_area.pos_nav_seg,
							id = dis_id
						})

						if path and #path >= 2 then
							local dis = 0
							local current = spawn_group.pos
							for i = 2, #path do
								local nxt = path[i][2]
								if current and nxt then
									dis = dis + mvec_dis(current, nxt)
								end
								current = nxt
							end
							self._graph_distance_cache[dis_id] = dis
						end
					end

					if self._graph_distance_cache[dis_id] then
						local my_dis = self._graph_distance_cache[dis_id]
						if not max_dis or my_dis < max_dis then
							local spawn_group_id = spawn_group.mission_element:id()
							valid_spawn_groups[spawn_group_id] = spawn_group
							valid_spawn_group_distances[spawn_group_id] = my_dis
						end
					end
				end
			end
		end
	end

	if not next(valid_spawn_group_distances) then
		return
	end

	local total_weight = 0
	local candidate_groups = {}
	for i, dis in pairs(valid_spawn_group_distances) do
		local my_wgt = math_lerp(1, 0.75, math_min(1, dis / 5000))
		local my_spawn_group = valid_spawn_groups[i]
		local my_group_types = my_spawn_group.mission_element:spawn_groups()
		my_spawn_group.distance = dis
		total_weight = total_weight + self:_choose_best_groups(candidate_groups, my_spawn_group, my_group_types, allowed_groups, my_wgt)
	end

	if total_weight == 0 then
		return
	end

	return self:_choose_best_group(candidate_groups, total_weight)
end


-- Reorder task updates so groups that have finished spawning immediately get their objectives instead of waiting for the next update
function GroupAIStateBesiege:_upd_police_activity()
	self._police_upd_task_queued = false

	if self._police_activity_blocked then
		return
	end

	if self._ai_enabled then
		self:_upd_SO()
		self:_upd_grp_SO()
		self:_check_spawn_phalanx()
		self:_check_phalanx_group_has_spawned()
		self:_check_phalanx_damage_reduction_increase()

		-- Do _upd_group_spawning and _upd_groups before the various task updates
		if self._enemy_weapons_hot then
			self:_claculate_drama_value()
			self:_upd_group_spawning()
			self:_upd_groups()
			self:_begin_new_tasks()
			self:_upd_regroup_task()
			self:_upd_reenforce_tasks()
			self:_upd_recon_tasks()
			self:_upd_assault_task()
		end
	end

	self:_queue_police_upd_task()
end


-- Update police activity in consistent intervals
function GroupAIStateBesiege:_queue_police_upd_task()
	if not self._police_upd_task_queued then
		self._police_upd_task_queued = true
		managers.enemy:queue_task("GroupAIStateBesiege._upd_police_activity", self._upd_police_activity, self, self._t + 0.5)
	end
end
