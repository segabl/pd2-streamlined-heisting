-- Always make enemies with special attack logics important
Hooks:PostHook(CopBrain, "post_init", "sh_post_init", function (self)
	if self._logics.attack ~= CopLogicAttack then
		self._forced_important = true
		self:set_important(true)
	end
end)

-- Update immediately once we have our pathing results instead of waiting for the next update
Hooks:PostHook(CopBrain, "clbk_pathing_results", "sh_clbk_pathing_results", function (self)
	local current_logic = self._current_logic
	if current_logic.clbk_pathing_results then
		current_logic.clbk_pathing_results(self._logic_data)
	end
end)

local set_important_original = CopBrain.set_important
function CopBrain:set_important(state, ...)
	return set_important_original(self, self._forced_important and true or state, ...)
end
