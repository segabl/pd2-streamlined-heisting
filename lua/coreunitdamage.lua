-- Make bulldozer armor scale with difficulty
local hp_muls = { 1, 1, 1.5, 2, 3, 4, 6, 8 }
Hooks:PostHook(CoreBodyDamage, "init", "sh_init", function (self)
	local unit_type = self._body_element and self._unit:base() and self._unit:base()._tweak_table
	if unit_type and unit_type:match("^tank") then
		if not CoreBodyDamage._tank_armor_multiplier then
			local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
			CoreBodyDamage._tank_armor_multiplier = 1 / hp_muls[diff_i]
		end
		self._body_element._damage_multiplier = CoreBodyDamage._tank_armor_multiplier
	end
end)
