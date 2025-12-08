-- Don't replace spawns on custom enemy spawner map
local level_id =  Global.game_settings and Global.game_settings.level_id
if Global.editor_mode or level_id == "modders_devmap" or level_id == "Enemy_Spawner" then
	StreamHeist:log("Editor/Spawner mode is active, spawn group fixes disabled")
	return
end

-- Map to correct incorrect faction spawns
ElementSpawnEnemyDummy.faction_mapping = {
	normal = {
		swat_1 = "units/payday2/characters/ene_swat_1/ene_swat_1",
		swat_2 = "units/payday2/characters/ene_swat_2/ene_swat_2",
		heavy_1 = "units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1",
		heavy_2 = "units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",
		shield = "units/payday2/characters/ene_shield_2/ene_shield_2",
		sniper = "units/payday2/characters/ene_sniper_1/ene_sniper_1"
	},
	overkill = {
		swat_1 = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		swat_2 = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		heavy_1 = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",
		heavy_2 = "units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
		shield = "units/payday2/characters/ene_shield_1/ene_shield_1",
		sniper = "units/payday2/characters/ene_sniper_2/ene_sniper_2"
	},
	easy_wish = {
		swat_1 = {
			"units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
			"units/payday2/characters/ene_city_swat_3/ene_city_swat_3"
		},
		swat_2 = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		heavy_1 = "units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36",
		heavy_2 = "units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870",
		shield = "units/payday2/characters/ene_city_shield/ene_city_shield",
		sniper = "units/payday2/characters/ene_sniper_3/ene_sniper_3"
	},
	sm_wish = {
		swat_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat",
		swat_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2",
		heavy_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy",
		heavy_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2",
		shield = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield",
		sniper = "units/pd2_dlc_gitgud/characters/ene_zeal_sniper/ene_zeal_sniper",
		dozer_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2",
		dozer_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3",
		dozer_3 = "units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer",
		medic_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4",
		medic_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870",
		taser = "units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer",
		cloaker = "units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"
	}
}
ElementSpawnEnemyDummy.faction_mapping.hard = ElementSpawnEnemyDummy.faction_mapping.normal
ElementSpawnEnemyDummy.faction_mapping.overkill_145 = ElementSpawnEnemyDummy.faction_mapping.overkill
ElementSpawnEnemyDummy.faction_mapping.overkill_290 = ElementSpawnEnemyDummy.faction_mapping.easy_wish

ElementSpawnEnemyDummy.enemy_mapping = {
	[Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"):key()] = "dozer_1",
	[Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"):key()] = "dozer_2",
	[Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"):key()] = "dozer_3",
	[Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"):key()] = "heavy_1",
	[Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"):key()] = "heavy_2",
	[Idstring("units/payday2/characters/ene_city_shield/ene_city_shield"):key()] = "shield",
	[Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"):key()] = "swat_1",
	[Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"):key()] = "swat_2",
	[Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3"):key()] = "swat_1",
	[Idstring("units/payday2/characters/ene_city_swat_r870/ene_city_swat_r870"):key()] = "swat_2",
	[Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"):key()] = "heavy_1",
	[Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"):key()] = "heavy_2",
	[Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"):key()] = "swat_1",
	[Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"):key()] = "swat_2",
	[Idstring("units/payday2/characters/ene_shield_1/ene_shield_1"):key()] = "shield",
	[Idstring("units/payday2/characters/ene_shield_2/ene_shield_2"):key()] = "shield",
	[Idstring("units/payday2/characters/ene_sniper_1/ene_sniper_1"):key()] = "sniper",
	[Idstring("units/payday2/characters/ene_sniper_2/ene_sniper_2"):key()] = "sniper",
	[Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"):key()] = "swat_1",
	[Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"):key()] = "swat_2",
	[Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"):key()] = "heavy_1",
	[Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"):key()] = "heavy_2",
	[Idstring("units/payday2/characters/ene_medic_m4/ene_medic_m4"):key()] = "medic_1",
	[Idstring("units/payday2/characters/ene_medic_r870/ene_medic_r870"):key()] = "medic_2",
	[Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1"):key()] = "taser",
	[Idstring("units/payday2/characters/ene_spook_1/ene_spook_1"):key()] = "cloaker",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"):key()] = "heavy_1",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"):key()] = "shield",
	[Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"):key()] = "swat_1"
}

local difficulty
if tweak_data.levels[level_id] and tweak_data.levels[level_id].group_ai_state == "skirmish" then
	difficulty = "normal"
else
	difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
end
Hooks:PostHook(ElementSpawnEnemyDummy, "init", "sh_init", function (self)
	local mapped_name = self.enemy_mapping[self._enemy_name:key()]
	local mapped_unit = self.faction_mapping[difficulty] and self.faction_mapping[difficulty][mapped_name]
	if type(mapped_unit) == "table" then
		self._enemy_table = mapped_unit
	elseif mapped_unit then
		self._enemy_name = Idstring(mapped_unit)
	end
end)

Hooks:PreHook(ElementSpawnEnemyDummy, "produce", "sh_produce", function (self, params)
	if not (params and params.name) and self._enemy_table then
		self._enemy_name = Idstring(table.random(self._enemy_table))
	end
end)
