-- Add random pitch when tased (Tasers are now evil!)
local _check_action_shock_original = PlayerTased._check_action_shock
function PlayerTased:_check_action_shock(t, input, ...)
	local do_shock = self._next_shock and self._next_shock < t

	_check_action_shock_original(self, t, input, ...)

	if do_shock then
		self._cam_start_pitch = self._unit:camera():camera_unit():base()._camera_properties.pitch
		self._cam_target_pitch = math.clamp(self._cam_start_pitch + math.rand(-5, 5), -90, 90)
		self._cam_start_pitch_t = t
		self._cam_target_pitch_t = t + 0.2
	end

	if self._cam_start_pitch then
		if t > self._cam_target_pitch_t then
			self._cam_start_pitch = nil
		else
			local pitch = math.map_range(t, self._cam_start_pitch_t, self._cam_target_pitch_t, self._cam_start_pitch, self._cam_target_pitch)
			self._unit:camera():camera_unit():base():set_pitch(pitch)
		end
	end
end
