-- Make bulldozer armor scale with difficulty
Hooks:PostHook(CoreBodyDamage, "init", "sh_init", function (self)
	local unit_type = self._body_element and self._unit:base() and self._unit:base()._tweak_table
	if unit_type and unit_type:match("^tank") then
		if not CoreBodyDamage._tank_armor_multiplier then
			local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
			local diff_i_norm = (diff_i - 2) / (#tweak_data.difficulties - 2)
			CoreBodyDamage._tank_armor_multiplier = math.lerp(1, 0.25, diff_i_norm)
		end
		self._body_element._damage_multiplier = CoreBodyDamage._tank_armor_multiplier
	end
end)
