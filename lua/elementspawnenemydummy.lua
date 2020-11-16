-- Map to correct incorrect faction spawns
local enemy_replacements = {
  normal = {
    swat_1 = "units/payday2/characters/ene_swat_1/ene_swat_1",
    swat_2 = "units/payday2/characters/ene_swat_2/ene_swat_2",
    heavy_1 = "units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1",
    heavy_2 = "units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",
    shield = "units/payday2/characters/ene_shield_2/ene_shield_2"
  },
  overkill = {
    swat_1 = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
    swat_2 = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
    heavy_1 = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",
    heavy_2 = "units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
    shield = "units/payday2/characters/ene_shield_1/ene_shield_1"
  },
  easy_wish = {
    swat_1 = "units/payday2/characters/ene_city_swat_1/ene_city_swat_1",
    swat_2 = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
    heavy_1 = "units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36",
    heavy_2 = "units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870",
    shield = "units/payday2/characters/ene_city_shield/ene_city_shield"
  },
  sm_wish = {
    swat_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat",
    swat_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2",
    heavy_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy",
    heavy_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2",
    shield = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield",
    dozer_1 = "units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2",
    dozer_2 = "units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3",
    dozer_3 = "units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"
  }
}
enemy_replacements.hard = enemy_replacements.normal
enemy_replacements.overkill_145 = enemy_replacements.overkill
enemy_replacements.overkill_290 = enemy_replacements.easy_wish
local enemy_mapping = {
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
  [Idstring("units/payday2/characters/ene_swat_1/ene_swat_1"):key()] = "swat_1",
  [Idstring("units/payday2/characters/ene_swat_2/ene_swat_2"):key()] = "swat_2",
  [Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"):key()] = "heavy_1",
  [Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"):key()] = "heavy_2",
  [Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"):key()] = "heavy_1",
  [Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"):key()] = "shield",
  [Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"):key()] = "swat_1"
}

Hooks:PostHook(ElementSpawnEnemyDummy, "init", "sh_init", function(self)
  local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
  local mapped_name = enemy_mapping[self._enemy_name:key()]
  local mapped_unit = enemy_replacements[difficulty] and enemy_replacements[difficulty][mapped_name]
  if mapped_unit then
    StreamHeist:log(self:editor_name(), mapped_name, "->", mapped_unit)
    self._enemy_name = Idstring(mapped_unit)
  end
end)
