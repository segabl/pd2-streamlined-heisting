-- Make bulldozer armor scale with difficulty
local hp_muls = { 1, 1, 1.5, 2, 3, 4, 6, 8 }
Hooks:PostHook(CoreBodyDamage, "init", "sh_init", function (self)
	local unit_type = self._body_element and self._unit:base() and self._unit:base()._tweak_table
	if unit_type and unit_type:find("^tank") then
		if not CoreBodyDamage._tank_armor_multiplier then
			local diff_i = tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
			CoreBodyDamage._tank_armor_multiplier = 1 / hp_muls[diff_i]
			CoreBodyDamage._tank_glass_multiplier = 1 / math.max(1, hp_muls[diff_i] * 0.75)
		end
		self._body_element._damage_multiplier = self._body_element._name:find("glass") and CoreBodyDamage._tank_glass_multiplier or CoreBodyDamage._tank_armor_multiplier
	end
end)
