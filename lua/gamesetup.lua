
Hooks:PostHook(GameSetup, "load_packages", "cass_load_packages", function (self)

  if (PackageManager:loaded("packages/sm_wish")) then
    CASS:log("Death sentence package is loaded")
  else
    CASS:log("Death sentence package is not loaded")
  end

  if tweak_data.levels:get_ai_group_type() == "murkywater" then
    CASS:log("Murkywater faction package is loaded")
  else
    CASS:log("Murkywater faction package is not loaded")
  end

end)