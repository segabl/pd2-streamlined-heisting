
Hooks:PostHook(GameSetup, "load_packages", "cass_load_packages", function (self)

  local ai_group_type = tweak_data.levels:get_ai_group_type()
  if ai_group_type == "murkywater" then
    CASS:log("Murkywater faction package is loaded, loading custom Murky units...")
    -- todo
  elseif ai_group_type == "russian" then
    CASS:log("Russian faction package is loaded, loading custom Russian units...")
    -- todo
  elseif PackageManager:loaded("packages/sm_wish") then
    CASS:log("Death Sentence package is loaded, loading custom Zeal units...")
    --CASS:load_asset_group("zeals")
  else
    CASS:log("No special faction packages are loaded")
  end

end)