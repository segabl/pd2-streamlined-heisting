-- Force Cloakers to stand up before starting an attack on clients
Hooks:PreHook(UnitNetworkHandler, "action_spooc_start", "sh_action_spooc_start", function (self, unit)
	if not self._verify_character(unit) or not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end

	unit:movement():action_request({
		body_part = 4,
		type = "stand"
	})

	unit:movement():action_request({
		body_part = 3,
		type = "idle"
	})
end)


-- Fix function ignoring the actual aim state parameter and always starting a shoot action (thanks to RedFlame)
function UnitNetworkHandler:action_aim_state(cop, start)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character(cop) then
		return
	end

	if start then
		cop:movement():action_request({
			block_type = "action",
			body_part = 3,
			type = "shoot"
		})
	else
		cop:movement():sync_action_aim_end()
	end
end
