-- Grace period protects no matter the new potential damage but is shorter in general
function PlayerDamage:_chk_dmg_too_soon()
	local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
	return managers.player:player_timer():time() < next_allowed_dmg_t
end


-- Add slightly longer grace period on dodge (repurposing Anarchist/Armorer damage timer)
Hooks:PostHook(PlayerDamage, "_send_damage_drama", "sh__send_damage_drama", function (self, attack_data, health_subtracted)
	if health_subtracted == 0 and self._can_take_dmg_timer and self._can_take_dmg_timer <= 0 then
		self._can_take_dmg_timer = self._dmg_interval + 0.15
	end
end)


-- Add slightly longer grace period on armor break (repurposing Anarchist/Armorer damage timer)
local _calc_armor_damage_original = PlayerDamage._calc_armor_damage
function PlayerDamage:_calc_armor_damage(...)
	local had_armor = self:get_real_armor() > 0

	local health_subtracted = _calc_armor_damage_original(self, ...)

	if health_subtracted > 0 and had_armor and self:get_real_armor() <= 0 and self._can_take_dmg_timer <= 0 then
		self._can_take_dmg_timer = self._dmg_interval + 0.15
	end

	return health_subtracted
end


-- Fix Anarchist regen not triggering HUD armor update for clients
Hooks:PostHook(PlayerDamage, "change_armor", "sh_change_armor", function (self, change)
	if change > 0 and self:armor_ratio() < 1 then
		self:_send_set_armor()
	end
end)
