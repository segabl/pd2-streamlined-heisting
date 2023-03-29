-- Fix enemies playing the suppressed stand-to-crouch animation when shot even if they are already crouching
local play_redirect_original = CopMovement.play_redirect
function CopMovement:play_redirect(redirect_name, ...)
	local result = play_redirect_original(self, redirect_name, ...)
	if result and redirect_name == "suppressed_reaction" and self._ext_anim.crouch then
		self._machine:set_parameter(result, "from_stand", 0)
	end
	return result
end


-- Fix attention synch not providing the old attention
function CopMovement:synch_attention(attention)
	if attention and self._unit:character_damage():dead() then
		StreamHeist:warn("Attention synch to dead unit")
	end

	self:_remove_attention_destroy_listener(self._attention)
	self:_add_attention_destroy_listener(attention)

	if attention and attention.unit and not attention.destroy_listener_key then
		StreamHeist:warn("Attention synch with invalid data")
		return self:synch_attention(nil)
	end

	local old_attention = self._attention
	self._attention = attention
	self._action_common_data.attention = attention

	for _, action in ipairs(self._active_actions) do
		if action and action.on_attention then
			action:on_attention(attention, old_attention)
		end
	end
end


-- Fix head position update on suppression
Hooks:PreHook(CopMovement, "_upd_stance", "sh__upd_stance", function (self, t)
	if self._stance.transition and self._stance.transition.next_upd_t < t then
		self._force_head_upd = true
	elseif self._suppression.transition and self._suppression.transition.next_upd_t < t then
		self._force_head_upd = true
	end
end)

Hooks:PostHook(CopMovement, "_change_stance", "sh__change_stance", function (self)
	self._force_head_upd = true
end)

Hooks:PostHook(CopMovement, "on_suppressed", "sh_on_suppressed", function (self)
	self._force_head_upd = true
end)
