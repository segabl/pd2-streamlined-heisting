local ids_unit = Idstring("unit")

local function load_unit(path)
  local dres = managers.dyn_resource
  dres:load(ids_unit, Idstring(path), dres.DYN_RESOURCES_PACKAGE)
  dres:load(ids_unit, Idstring(path .. "_husk"), dres.DYN_RESOURCES_PACKAGE)
end

Hooks:PostHook(GameSetup, "init_finalize", "sh_init_finalize", function ()

  StreamHeist:log("Loading custom units...")

  load_unit("units/payday2/characters/ene_swat_3/ene_swat_3")
  load_unit("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3")

  if PackageManager:loaded("packages/sm_wish") then
    --StreamHeist:log("Zeal package loaded, loading custom Zeal units...")

    --load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2")
    --load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_3/ene_zeal_swat_3")
    --load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870/ene_zeal_swat_heavy_r870")
  end

end)