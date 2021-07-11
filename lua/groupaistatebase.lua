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


-- Fix enemies aiming at their target's feet if they don't have direct LoS
local function fix_position(gstate, unit)
	local u_sighting = gstate._criminals[unit:key()]
	if u_sighting then
		mvector3.set_z(u_sighting.pos, u_sighting.pos.z + 140)
	end
end

Hooks:PostHook(GroupAIStateBase, "criminal_spotted", "sh_criminal_spotted", fix_position)
Hooks:PostHook(GroupAIStateBase, "on_criminal_nav_seg_change", "sh_on_criminal_nav_seg_change", fix_position)


-- Make flank pathing more dynamic by marking areas in which enemies die unsafe
Hooks:PostHook(GroupAIStateBase, "on_enemy_unregistered", "sh_on_enemy_unregistered", function (self, unit)
	if not Network:is_server() or not unit:character_damage():dead() then
		return
	end

	local nav_seg = unit:movement():nav_tracker():nav_segment()
	local area = self:get_area_from_nav_seg_id(nav_seg)

	area.unsafe_t = self._t + (area.unsafe_t and area.unsafe_t > self._t and math.min((area.unsafe_t - self._t) + 10, 60) or 10)
end)

local function check_area_safety(gstate, area)
	if area.unsafe_t and area.unsafe_t > gstate._t then
		return false
	end
end

Hooks:PostHook(GroupAIStateBase, "is_area_safe", "sh_is_area_safe", check_area_safety)
Hooks:PostHook(GroupAIStateBase, "is_area_safe_assault", "sh_is_area_safe_assault", check_area_safety)
