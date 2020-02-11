function PlayerDamage:_chk_dmg_too_soon(damage)
  local t = managers.player:player_timer():time()
  local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
  -- I-frames protect no matter the new potential damage but the remaining i-frame time
  -- will be reduced based on the new to previous damage ratio if the new damage is higher
  if t < next_allowed_dmg_t then
    if damage > self._last_received_dmg + 0.1 then
      self._next_allowed_dmg_t = Application:digest_value(t + (next_allowed_dmg_t - t) * (self._last_received_dmg / (damage - 0.1)), true)
      self._last_received_dmg = damage
    end
    return true
  end
end