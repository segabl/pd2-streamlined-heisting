-- Make hostage count affect hesitation delay
local _begin_assault_task_original = GroupAIStateBesiege._begin_assault_task
function GroupAIStateBesiege:_begin_assault_task(...)
	self._task_data.assault.was_first = self._task_data.assault.is_first

	_begin_assault_task_original(self, ...)

	if self._hostage_headcount > 0 then
		local assault_task = self._task_data.assault
		local anticipation_duration = self:_get_anticipation_duration(self._tweak_data.assault.anticipation_duration, assault_task.was_first)
		local hesitation_delay = self:_get_difficulty_dependent_value(self._tweak_data.assault.hostage_hesitation_delay)
		local hostage_multiplier = math.clamp(self._hostage_headcount / 2, 1, 4)
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


-- Add delay to spawn points that are being kill farmed (based on TdlQ's code in FSS)
function GroupAIStateBesiege:_get_spawn_group_data(spawn_point_id)
	self._spawn_point_data_mapping = self._spawn_point_data_mapping or {}
	if self._spawn_point_data_mapping[spawn_point_id] == nil then
		self._spawn_point_data_mapping[spawn_point_id] = false
		for area_id, area in pairs(self._area_data) do
			for _, spawn_group_data in pairs(area.spawn_groups or {}) do
				for _, sp_data in pairs(spawn_group_data.spawn_pts or {}) do
					if sp_data.mission_element._id == spawn_point_id then
						self._spawn_point_data_mapping[spawn_point_id] = spawn_group_data
						return spawn_group_data
					end
				end
			end
		end
	end
	return self._spawn_point_data_mapping[spawn_point_id]
end

Hooks:PostHook(GroupAIStateBesiege, "on_enemy_unregistered", "sh_on_enemy_unregistered", function (self, unit)
	local e_data = self._police[unit:key()]
	if e_data.assigned_area and unit:character_damage():dead() then
		local spawn_point = unit:unit_data().mission_element
		local spawn_pos = spawn_point and spawn_point:value("position")
		if spawn_pos and mvector3.distance_sq(spawn_pos, e_data.m_pos) < 640000 then
			local spawn_group_data = self:_get_spawn_group_data(spawn_point._id)
			if spawn_group_data and (not spawn_group_data.delay_t or spawn_group_data.delay_t < self._t) then
				local delay = 3 + math.random()
				if spawn_group_data.delay_extend_t and spawn_group_data.delay_extend_t > self._t then
					spawn_group_data.sh_delay_mul = (spawn_group_data.sh_delay_mul or 1) + 0.25
					delay = delay * spawn_group_data.sh_delay_mul
				else
					spawn_group_data.sh_delay_mul = 1
				end
				spawn_group_data.delay_t = self._t + delay
				spawn_group_data.delay_extend_t = spawn_group_data.delay_t + 3
			end
		end
	end
end)
