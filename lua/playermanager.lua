-- Reduce damage taken while inside of vehicles
local damage_reduction_skill_multiplier_original = PlayerManager.damage_reduction_skill_multiplier
function PlayerManager:damage_reduction_skill_multiplier(...)
	local dmg_reduction = damage_reduction_skill_multiplier_original(self, ...)

	local player = self:player_unit()
	if player and player:movement()._current_state_name == "driving" then
		dmg_reduction = dmg_reduction * 0.5
	end

	return dmg_reduction
end


-- Make cooldown for picking up bags consistent instead of random
local drop_carry_original = PlayerManager.drop_carry
function PlayerManager:drop_carry(...)
	local carry_data = self:get_my_carry_data()

	drop_carry_original(self, ...)

	if carry_data then
		self._carry_blocked_cooldown_t = Application:time() + 0.5
	end
end
