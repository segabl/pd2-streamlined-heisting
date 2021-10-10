-- Fix fire damage update resetting DoT grace and not triggering DoT damage until no more fire DoT is added
-- Instead of updating the damage received time, update the DoT duration with the difference between new and old received time
local _add_doted_enemy_original = FireManager._add_doted_enemy
function FireManager:_add_doted_enemy(enemy_unit, fire_damage_received_time, ...)
	if self._doted_enemies then
		for _, dot_info in ipairs(self._doted_enemies) do
			if dot_info.enemy_unit == enemy_unit then
				dot_info.dot_length = dot_info.dot_length + fire_damage_received_time - dot_info.fire_damage_received_time
				return
			end
		end
	end

	return _add_doted_enemy_original(self, enemy_unit, fire_damage_received_time, ...)
end
