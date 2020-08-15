local ids_unit = Idstring("unit")
Hooks:PostHook(DynamicResourceManager, "preload_units", "sh_preload_units", function (self)

  local function load_unit(path)
    self:load(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
    self:load(ids_unit, Idstring(path .. "_husk"), self.DYN_RESOURCES_PACKAGE)
  end

  StreamHeist:log("Loading custom units...")

  load_unit("units/payday2/characters/ene_swat_3/ene_swat_3")
  load_unit("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3")

  if PackageManager:loaded("packages/sm_wish") then
    StreamHeist:log("Zeal package loaded, loading custom Zeal units...")

    -- for some fucking reason these crash the game
    --load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2")
    --load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_3/ene_zeal_swat_3")
    load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870/ene_zeal_swat_heavy_r870")
  end

end)