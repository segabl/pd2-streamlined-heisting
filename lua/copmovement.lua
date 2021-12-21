-- Fix enemies playing the suppressed stand-to-crouch animation when shot even if they are already crouching
local action_request_original = CopMovement.action_request
function CopMovement:action_request(action_desc, ...)
	if action_desc.variant == "suppressed_reaction" and self._ext_anim.crouch then
		return
	end
	return action_request_original(self, action_desc, ...)
end


-- Fix attention synch not providing the old attention
function CopMovement:synch_attention(attention)
	if attention and self._unit:character_damage():dead() then
		StreamHeist:log("[Warning] Attention synch to dead unit")
	end

	self:_remove_attention_destroy_listener(self._attention)
	self:_add_attention_destroy_listener(attention)

	if attention and attention.unit and not attention.destroy_listener_key then
		StreamHeist:log("[Warning] Attention synch with invalid data")
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
