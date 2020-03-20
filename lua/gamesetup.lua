Hooks:PostHook(GameSetup, "init_finalize", "cass_init_finalize", function ()

  local ids_unit = Idstring("unit")
  local dres = managers.dyn_resource

  CASS:log("Loading custom units")

  dres:load(ids_unit, Idstring("units/payday2/characters/ene_swat_3/ene_swat_3"), dres.DYN_RESOURCES_PACKAGE)
  dres:load(ids_unit, Idstring("units/payday2/characters/ene_swat_3/ene_swat_3_husk"), dres.DYN_RESOURCES_PACKAGE)

  dres:load(ids_unit, Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"), dres.DYN_RESOURCES_PACKAGE)
  dres:load(ids_unit, Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3_husk"), dres.DYN_RESOURCES_PACKAGE)

end)