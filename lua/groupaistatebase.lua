-- Make medic and minigun dozer register as specials
local function register_special_types(gstate)
	gstate._special_unit_types.tank_medic = true
	gstate._special_unit_types.tank_mini = true
end

Hooks:PostHook(GroupAIStateBase, "_init_misc_data", "sh__init_misc_data", register_special_types)
Hooks:PostHook(GroupAIStateBase, "on_simulation_started", "sh_on_simulation_started", register_special_types)


-- Fix cloaker spawn noise for host
local _process_recurring_grp_SO_original = GroupAIStateBase._process_recurring_grp_SO
function GroupAIStateBase:_process_recurring_grp_SO(...)
	if _process_recurring_grp_SO_original(self, ...) then
		managers.hud:post_event("cloaker_spawn")
		return true
	end
end


-- Make difficulty progress smoother
local set_difficulty_original = GroupAIStateBase.set_difficulty
function GroupAIStateBase:set_difficulty(value, ...)
	if not managers.game_play_central or managers.game_play_central:get_heist_timer() < 1 then
		return set_difficulty_original(self, value, ...)
	end

	self._difficulty_step = 0.05 * math.sign(value - self._difficulty_value)
	self._target_difficulty = value
	self._next_difficulty_step_t = self._next_difficulty_step_t or 0
end

Hooks:PostHook(GroupAIStateBase, "update", "sh_update", function (self, t)
	if self._target_difficulty and t >= self._next_difficulty_step_t then
		self._difficulty_value = self._difficulty_value + self._difficulty_step
		if self._difficulty_step > 0 and self._difficulty_value >= self._target_difficulty or self._difficulty_step < 0 and self._difficulty_value <= self._target_difficulty then
			self._difficulty_value = self._target_difficulty
			self._target_difficulty = nil
		else
			self._next_difficulty_step_t = t + 15
		end
		self:_calculate_difficulty_ratio()
	end
end)


-- Log time when criminals enter an area to use for the teargas check
Hooks:PreHook(GroupAIStateBase, "on_criminal_nav_seg_change", "sh_on_criminal_nav_seg_change", function (self, unit, nav_seg_id)
	local u_sighting = self._criminals[unit:key()]
	if not u_sighting then
		return
	end

	local prev_area = u_sighting.area
	local area = prev_area and prev_area.nav_segs[nav_seg_id] and prev_area or self:get_area_from_nav_seg_id(nav_seg_id)
	if prev_area and prev_area ~= area then
		if table.size(prev_area.criminal.units) <= 1 then
			prev_area.criminal_left_t = self._t
			prev_area.old_criminal_entered_t = prev_area.criminal_entered_t
			prev_area.criminal_entered_t = nil
		end
		if not area.criminal_entered_t then
			area.criminal_entered_t = area.criminal_left_t and area.criminal_left_t + 10 > self._t and area.old_criminal_entered_t or self._t
		end
	end
end)


-- Fix enemies aiming at their target's feet if they don't have direct LoS
local function fix_position(gstate, unit)
	local u_sighting = gstate._criminals[unit:key()]
	if u_sighting then
		mvector3.set_z(u_sighting.pos, u_sighting.pos.z + 140)
	end
end

Hooks:PostHook(GroupAIStateBase, "criminal_spotted", "sh_criminal_spotted", fix_position)
Hooks:PostHook(GroupAIStateBase, "on_criminal_nav_seg_change", "sh_on_criminal_nav_seg_change", fix_position)


-- Make flank pathing more dynamic by marking areas in which enemies die unsafe and delay spawn points when enemies die close to them
Hooks:PostHook(GroupAIStateBase, "on_enemy_unregistered", "sh_on_enemy_unregistered", function (self, unit)
	if not Network:is_server() or not unit:character_damage():dead() then
		return
	end

	local fs_settings = FullSpeedSwarm and FullSpeedSwarm.final_settings or {}

	if not fs_settings.improved_tactics then
		local nav_seg = unit:movement():nav_tracker():nav_segment()
		local area = self:get_area_from_nav_seg_id(nav_seg)
		area.unsafe_t = self._t + (area.unsafe_t and area.unsafe_t > self._t and math.min((area.unsafe_t - self._t) + 5, 60) or 5)
	end

	if fs_settings.spawn_delay then
		return
	end

	local e_data = self._police[unit:key()]
	if not e_data.group or not e_data.group.has_spawned then
		return
	end

	local spawn_point = unit:unit_data().mission_element
	if not spawn_point then
		return
	end

	local u_pos = e_data.m_pos
	local spawn_pos = spawn_point:value("position")
	local dist_sq = mvector3.distance_sq(spawn_pos, u_pos)
	local max_dist_sq = 1000000
	if dist_sq > max_dist_sq then
		return
	end

	for _, area in pairs(self._area_data) do
		if area.spawn_groups then
			for _, group in pairs(area.spawn_groups) do
				if group.spawn_pts then
					for _, point in pairs(group.spawn_pts) do
						if point.mission_element == spawn_point then
							local delay_t = self._t + math.lerp(8, 0, dist_sq / max_dist_sq)
							group.delay_t = math.max(group.delay_t, delay_t)
							return
						end
					end
				end
			end
		end
	end
end)

Hooks:PostHook(GroupAIStateBase, "is_area_safe", "sh_is_area_safe", function (self, area)
	if area.unsafe_t and area.unsafe_t > self._t then
		return false
	end
end)


-- Fix this function doing nothing
function GroupAIStateBase:_merge_coarse_path_by_area(coarse_path)
	local i_nav_seg = #coarse_path
	local area, last_area
	while i_nav_seg > 0 and #coarse_path > 2 do
		area = self:get_area_from_nav_seg_id(coarse_path[i_nav_seg][1])
		if last_area and last_area == area then
			table.remove(coarse_path, i_nav_seg)
		else
			last_area = area
		end
		i_nav_seg = i_nav_seg - 1
	end
end


-- Make specials not take up importance slots (they're already always counted as important)
local set_importance_weight_original = GroupAIStateBase.set_importance_weight
function GroupAIStateBase:set_importance_weight(u_key, ...)
	if self._police[u_key] and self._police[u_key].unit:brain()._forced_important then
		return
	end
	return set_importance_weight_original(self, u_key, ...)
end
