-- Add random pitch when tased (Tasers are now evil!)
local _check_action_shock_original = PlayerTased._check_action_shock
function PlayerTased:_check_action_shock(t, input, ...)
	local do_shock = self._next_shock and self._next_shock < t

	_check_action_shock_original(self, t, input, ...)

	if do_shock then
		local cam_base = self._unit:camera():camera_unit():base()
		cam_base:animate_pitch(t, nil, cam_base._camera_properties.pitch + math.random(-5, 5), 0.25)
	end
end
