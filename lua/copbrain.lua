-- Fix spamming of grenades by units that dodge with grenades (Cloaker)
Hooks:PostHook(CopBrain, "init", "sh_init", function (self)
	self._flashbang_cover_expire_t = 0
	self._next_cover_grenade_chk_t = 0
end)


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


-- If Iter is installed and streamlined path option is used, don't make any further changes
if Iter and Iter.settings and Iter.settings.streamline_path then
	return
end


-- Call pathing results callback in logic if it exists
Hooks:PostHook(CopBrain, "clbk_pathing_results", "sh_clbk_pathing_results", function (self)
	local current_logic = self._current_logic
	if current_logic.on_pathing_results then
		current_logic.on_pathing_results(self._logic_data)
	end
end)
