
Hooks:PostHook(GameSetup, "load_packages", "cass_load_packages", function (self)

  local ai_group_type = tweak_data.levels:get_ai_group_type()
  if ai_group_type == "murkywater" then
    -- figure out how to make this work
    --CASS:load_asset_group("murky")
  elseif ai_group_type == "russian" then
    -- todo CASS:load_asset_group("russian")
  elseif PackageManager:loaded("packages/sm_wish") then
    --CASS:load_asset_group("zeal")
  else
    CASS:log("No special faction packages are loaded")
  end

end)