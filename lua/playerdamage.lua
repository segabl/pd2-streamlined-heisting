-- I-frames protect no matter the new potential damage but they are shorter in general
function PlayerDamage:_chk_dmg_too_soon(damage)
  local next_allowed_dmg_t = type(self._next_allowed_dmg_t) == "number" and self._next_allowed_dmg_t or Application:digest_value(self._next_allowed_dmg_t, false)
  return managers.player:player_timer():time() < next_allowed_dmg_t
end