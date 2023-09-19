-- Make concussion update function use hurt update (to update position and play the full animation)
-- Fix Shields not using their own concussion stun animations
-- Remove position reservations on death
Hooks:PostHook(CopActionHurt, "init", "sh_init", function (self)
	if self._hurt_type == "concussion" then
		if self._unit:base()._tweak_table == "shield" then
			local redir_res = self._ext_movement:play_redirect("concussion_stun")
			self._machine:set_parameter(redir_res, "shield_var" .. self:_pseudorandom(4), 1)
		end
		self.update = self._upd_hurt
	elseif self._hurt_type == "death" and Network:is_server() then
		self._unit:brain():rem_all_pos_rsrv()
	end
end)


-- Make sick update finish their hurt exit anims before expiring
Hooks:OverrideFunction(CopActionHurt, "_upd_sick", function (self, t)
	if self._sick_time then
		if t > self._sick_time then
			self._ext_movement:play_redirect("idle")
			self._sick_time = nil
		end
	elseif not self._ext_anim.hurt then
		self._expired = true
	end
end)


-- Prevent hurt and knockdown animations stacking, once one plays it needs to finish for another one to trigger
local hurt_blocks = {
	heavy_hurt = true,
	hurt = true,
	hurt_sick = true,
	knock_down = true,
	poison_hurt = true,
	shield_knock = true,
	stagger = true
}
Hooks:OverrideFunction(CopActionHurt, "chk_block", function (self, action_type, t)
	if self._hurt_type == "death" then
		return true
	elseif hurt_blocks[action_type] and not self._ext_anim.hurt_exit then
		return true
	elseif action_type == "turn" then
		return true
	elseif action_type == "death" then
		return false
	end

	return CopActionAct.chk_block(self, action_type, t)
end)
