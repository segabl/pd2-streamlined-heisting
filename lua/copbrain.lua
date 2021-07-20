-- Always make enemies with special attack logics important
Hooks:PostHook(CopBrain, "post_init", "sh_post_init", function (self)
	if self._logics.attack ~= CopLogicAttack then
		self._forced_important = true
		self:set_important(true)
	end
end)

local set_important_original = CopBrain.set_important
function CopBrain:set_important(state, ...)
	return set_important_original(self, self._forced_important and true or state, ...)
end
