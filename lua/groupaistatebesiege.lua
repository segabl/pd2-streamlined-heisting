Hooks:PreHook(GroupAIStateBesiege, "_begin_assault_task", "sh___begin_assault_task", function (self)
  self._task_data.assault.was_first = self._task_data.assault.is_first
end)

Hooks:PostHook(GroupAIStateBesiege, "_begin_assault_task", "sh___begin_assault_task", function (self)
  if self._hostage_headcount > 0 then
    local assault_task = self._task_data.assault
    local anticipation_duration = self:_get_anticipation_duration(self._tweak_data.assault.anticipation_duration, assault_task.was_first)
    local hesitation_delay = self:_get_difficulty_dependent_value(self._tweak_data.assault.hostage_hesitation_delay)
    local hostage_multiplier = math.clamp(self._hostage_headcount / 2, 1, 4)
    assault_task.phase_end_t = self._t + anticipation_duration + hesitation_delay * hostage_multiplier
    assault_task.is_hesitating = true
    assault_task.voice_delay = self._t + (assault_task.phase_end_t - self._t) / 2
  end
end)
