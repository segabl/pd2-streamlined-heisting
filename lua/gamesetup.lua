
Hooks:PostHook(GameSetup, "init_finalize", "cass_init_finalize", function (self)

  local unit_ids = Idstring("unit")
  local dres = managers and managers.dyn_resource

  local ai_group_type = tweak_data.levels:get_ai_group_type()
  if ai_group_type == "murkywater" then

  elseif ai_group_type == "russian" then

  end
  --[[
  if PackageManager:loaded("packages/sm_wish") then
    CASS:log("Loading new Zeal units...")
    dres:load(unit_ids, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2"), "packages/sm_wish")
    dres:load(unit_ids, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2_husk"), "packages/sm_wish")
    dres:load(unit_ids, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_3/ene_zeal_swat_3"), "packages/sm_wish")
    dres:load(unit_ids, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_3/ene_zeal_swat_3_husk"), "packages/sm_wish")
    dres:load(unit_ids, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870/ene_zeal_swat_heavy_r870"), "packages/sm_wish")
    dres:load(unit_ids, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870/ene_zeal_swat_heavy_r870_husk"), "packages/sm_wish")
  end
  ]]

end)