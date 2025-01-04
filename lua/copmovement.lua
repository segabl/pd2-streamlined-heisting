-- Fix enemies playing the suppressed stand-to-crouch animation when shot even if they are already crouching
local play_redirect_original = CopMovement.play_redirect
function CopMovement:play_redirect(redirect_name, ...)
	local result = play_redirect_original(self, redirect_name, ...)
	if result and redirect_name == "suppressed_reaction" and self._ext_anim.crouch then
		self._machine:set_parameter(result, "from_stand", 0)
	end
	return result
end


-- Fix head position update on suppression
Hooks:PreHook(CopMovement, "_upd_stance", "sh__upd_stance", function(self, t)
	if self._stance.transition and self._stance.transition.next_upd_t < t then
		self._force_head_upd = true
	elseif self._suppression.transition and self._suppression.transition.next_upd_t < t then
		self._force_head_upd = true
	end
end)

Hooks:PostHook(CopMovement, "_change_stance", "sh__change_stance", function(self)
	self._force_head_upd = true
end)

Hooks:PostHook(CopMovement, "on_suppressed", "sh_on_suppressed", function(self)
	self._force_head_upd = true
end)


-- Skip damage actions on units that are already in a death action
-- Redirect stun animations for Bulldozers and Shields
local damage_clbk_original = CopMovement.damage_clbk
function CopMovement:damage_clbk(my_unit, damage_info)
	if self._active_actions[1] and self._active_actions[1]._hurt_type == "death" then
		return
	end

	if damage_info.variant == "stun" then
		if self._unit:base():has_tag("tank") then
			damage_info.variant = "hurt"
			damage_info.result = {
				variant = "hurt",
				type = "expl_hurt"
			}
		elseif self._unit:base():has_tag("shield") then
			damage_info.variant = "hurt"
			damage_info.result = {
				variant = "hurt",
				type = "concussion"
			}
		end
	end

	return damage_clbk_original(self, my_unit, damage_info)
end


-- Toggle flashlights when set to cool or uncool
Hooks:PreHook(CopMovement, "_post_init", "sh__post_init", function(self)
	local equipped_weapon = self._ext_inventory:equipped_unit()
	if alive(equipped_weapon) then
		equipped_weapon:base():set_flashlight_enabled(false)
	end
end)

function CopMovement:_chk_flashlight_state()
	local equipped_weapon = self._ext_inventory:equipped_unit()
	if not alive(equipped_weapon) then
		return
	end

	local flashlight_on = not self:cool() and not self._ext_inventory:shield_unit() and managers.game_play_central:flashlights_on()
	if flashlight_on then
		local lights = self._unit:get_objects_by_type(Idstring("light"))
		if #lights > 0 and lights[1]:enable() then
			flashlight_on = false
		end
	end

	equipped_weapon:base():set_flashlight_enabled(flashlight_on)
end

Hooks:PostHook(CopMovement, "set_cool", "sh_set_cool", CopMovement._chk_flashlight_state)

function CopMovement:sync_equip_weapon()
	self:_chk_flashlight_state()
end
