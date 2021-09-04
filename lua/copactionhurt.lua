-- Prevent Shield knockdown animations stacking, once one plays it needs to finish for another one to trigger
local chk_block_original = CopActionHurt.chk_block
function CopActionHurt:chk_block(action_type, ...)
	return action_type == "shield_knock" and self._hurt_type == action_type or chk_block_original(self, action_type, ...)
end
