-- Grace period protects no matter the new potential damage but is shorter in general
-- If the previous shot was dodged, extend the grace period to reduce negative impact of lower grace period on dodge builds
function PlayerDamage:_chk_dmg_too_soon()
  local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
  if self._last_dodged then
    next_allowed_dmg_t = next_allowed_dmg_t + 0.2
  end
  return managers.player:player_timer():time() < next_allowed_dmg_t
end


-- If this function is called with a value of 0 for health_subtracted it means the player dodged a shot
Hooks:PostHook(PlayerDamage, "_send_damage_drama", "sh__send_damage_drama", function (self, attack_data, health_subtracted)

  self._last_dodged = health_subtracted == 0

end)
