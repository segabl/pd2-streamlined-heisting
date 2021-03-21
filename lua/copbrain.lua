-- Always make enemies with special attack logics important
Hooks:PostHook(CopBrain, "post_init", "sh_post_init", function (self)
	if self._logics.attack ~= CopLogicAttack then
		self:set_important(true)
		self._forced_important = true
	end
end)

local set_important_original = CopBrain.set_important
function CopBrain:set_important(state, ...)
	if self._forced_important then
		return
	end
	return set_important_original(self, state, ...)
end
