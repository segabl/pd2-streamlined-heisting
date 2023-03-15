-- Properly sync reload
function UnitNetworkHandler:reload_weapon_cop(cop, sender)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) or not self._verify_character_and_sender(cop, sender) then
		return
	end

	if not alive(cop) then
		return
	end

	local current_action = cop:movement():get_action(3)
	if current_action and current_action:type() == "shoot" then
		-- If we are currently in shoot action, set the mag to empty
		cop:inventory():equipped_unit():base():ammo_base():set_ammo_remaining_in_clip(0)
	else
		-- Otherwise request an actual reload action
		cop:movement():action_request({
			body_part = 3,
			type = "reload"
		})
	end
end


-- Ignore duplicate grenade sync
function UnitNetworkHandler:sync_smoke_grenade(detonate_pos, shooter_pos, duration, flashbang)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end

	local t = TimerManager:game():time()
	local last_t = self._last_grenade_t
	self._last_grenade_t = t

	if last_t and last_t + 4 > t and mvector3.equal(self._last_grenade_pos, detonate_pos) then
		StreamHeist:log("Ignoring duplicate grenade sync")
		return
	end

	self._last_grenade_pos = mvector3.copy(detonate_pos)

	managers.groupai:state():sync_smoke_grenade(detonate_pos, shooter_pos, duration, flashbang)
end

function UnitNetworkHandler:sync_cs_grenade(detonate_pos, shooter_pos, duration)
	if not self._verify_gamestate(self._gamestate_filter.any_ingame) then
		return
	end

	local t = TimerManager:game():time()
	local last_t = self._last_grenade_t
	self._last_grenade_t = t

	if last_t and last_t + 4 > t and mvector3.equal(self._last_grenade_pos, detonate_pos) then
		StreamHeist:log("Ignoring duplicate grenade sync")
		return
	end

	self._last_grenade_pos = mvector3.copy(detonate_pos)

	managers.groupai:state():sync_cs_grenade(detonate_pos, shooter_pos, duration)
end
