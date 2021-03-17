-- Fix enemies playing the suppressed stand-to-crouch animation when shot even if they are already crouching
local action_request_original = CopMovement.action_request
function CopMovement:action_request(action_desc, ...)
	if action_desc.variant == "suppressed_reaction" and self._ext_anim.crouch then
		return
	end
	return action_request_original(self, action_desc, ...)
end
