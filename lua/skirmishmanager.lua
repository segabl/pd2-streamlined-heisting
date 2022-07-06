-- Make enemy units switch difficulty factions over waves
local wave_unit_categories = {
	[2] = {
		FBI_swat_M4 = Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"),
		FBI_swat_R870 = Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"),
		FBI_heavy_G36 = Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"),
		FBI_heavy_R870 = Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"),
		FBI_shield = Idstring("units/payday2/characters/ene_shield_2/ene_shield_2"),
		medic_M4 = Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
		medic_R870 = Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
		CS_tazer = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
		spooc = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
	},
	[4] = {
		FBI_swat_M4 = Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
		FBI_swat_R870 = Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
		FBI_heavy_G36 = Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
		FBI_heavy_R870 = Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"),
		FBI_shield = Idstring("units/payday2/characters/ene_shield_1/ene_shield_1"),
		medic_M4 = Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
		medic_R870 = Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
		CS_tazer = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
		spooc = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
	},
	[6] = {
		FBI_swat_M4 = Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
		FBI_swat_R870 = Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
		FBI_heavy_G36 = Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"),
		FBI_heavy_R870 = Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"),
		FBI_shield = Idstring("units/payday2/characters/ene_city_shield/ene_city_shield"),
		medic_M4 = Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"),
		medic_R870 = Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"),
		CS_tazer = Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
		spooc = Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
	},
	[8] = {
		FBI_swat_M4 = Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"),
		FBI_swat_R870 = Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"),
		FBI_heavy_G36 = Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"),
		FBI_heavy_R870 = Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2"),
		FBI_shield = Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"),
		medic_M4 = Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4"),
		medic_R870 = Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870"),
		CS_tazer = Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
		spooc = Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker")
	}
}

Hooks:PostHook(SkirmishManager, "init_finalize", "sh_init_finalize", function (self)
	if not self:is_skirmish() then
		return
	end

	local unit_categories = tweak_data.group_ai.unit_categories
	local first = wave_unit_categories[2]
	for k, v in pairs(first) do
		unit_categories[k].unit_types.america = {
			v
		}
	end
end)

Hooks:PostHook(SkirmishManager, "_apply_modifiers_for_wave", "sh__apply_modifiers_for_wave", function (self, wave_number)
	self._unit_wave_index = wave_unit_categories[wave_number] and wave_number or self._unit_wave_index or 2
	local next_unit_wave_index = 8
	for i = wave_number + 1, next_unit_wave_index do
		if wave_unit_categories[i] then
			next_unit_wave_index = i
			break
		end
	end

	local amount, progress
	if next_unit_wave_index == self._unit_wave_index then
		amount = 1
		progress = 0
	else
		amount = next_unit_wave_index - self._unit_wave_index
		progress = wave_number - self._unit_wave_index
	end

	local unit_categories = tweak_data.group_ai.unit_categories
	for k, v in pairs(wave_unit_categories[self._unit_wave_index]) do
		unit_categories[k].unit_types.america = {}
		for _ = 1, amount - progress do
			table.insert(unit_categories[k].unit_types.america, v)
		end
	end

	for k, v in pairs(wave_unit_categories[next_unit_wave_index]) do
		for _ = 1, progress do
			table.insert(unit_categories[k].unit_types.america, v)
		end
	end
end)
