-- Fix rare crash with anticipation voice
local check_anticipation_voice_original = HUDManager.check_anticipation_voice
function HUDManager:check_anticipation_voice(...)
	return self._anticipation_dialogs and check_anticipation_voice_original(self, ...)
end


-- Check for cloaker spawn noise setting
local post_event_original = HUDManager.post_event
function HUDManager:post_event(event, ...)
	if event ~= "cloaker_spawn" or StreamHeist.settings.restore_cloaker_spawn_noise then
		return post_event_original(self, event, ...)
	end
end
