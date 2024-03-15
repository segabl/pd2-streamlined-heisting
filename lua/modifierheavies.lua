-- Make modifier simply swap unit categories to not rely on Light to Heavy mappings
Hooks:OverrideFunction(ModifierHeavies, "init", function (self, data)
	ModifierHeavies.super.init(self, data)

	local unit_categories = tweak_data.group_ai.unit_categories
	unit_categories.CS_swat_MP5.unit_types = deep_clone(unit_categories.CS_heavy_M4.unit_types)
	unit_categories.CS_swat_R870.unit_types = deep_clone(unit_categories.CS_heavy_R870.unit_types)
	unit_categories.FBI_swat_M4.unit_types = deep_clone(unit_categories.FBI_heavy_G36.unit_types)
	unit_categories.FBI_swat_R870.unit_types = deep_clone(unit_categories.FBI_heavy_R870.unit_types)
end)
