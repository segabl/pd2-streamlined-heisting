-- Limit logic updates, there's no need to update it every frame
local update_original = CivilianBrain.update
function CivilianBrain:update(unit, t, ...)
	if self._next_logic_upd_t <= t then
		self._next_logic_upd_t = t + self._logic_upd_interval
		return update_original(self, unit, t, ...)
	end
end
