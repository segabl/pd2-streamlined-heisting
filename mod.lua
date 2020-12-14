if not StreamHeist then

  _G.StreamHeist = {}
  StreamHeist.mod_path = ModPath
  StreamHeist.mod_instance = ModInstance
  StreamHeist.settings = {
    logs = false
  }
  StreamHeist.menu_builder = MenuBuilder:new("streamlined_heisting", StreamHeist.settings)

  function StreamHeist:log(...)
    if self.settings.logs then
      log("[StreamlinedHeisting] " .. table.concat({...}, " "))
    end
  end

  -- Add new enemies to the character map
  Hooks:Add("HopLibOnCharacterMapCreated", "HopLibOnCharacterMapCreatedStreamlinedHeisting", function (char_map)

    table.insert(char_map.basic.list, "ene_sniper_3")
    table.insert(char_map.gitgud.list, "ene_zeal_swat_2")
    table.insert(char_map.gitgud.list, "ene_zeal_swat_heavy_2")
    table.insert(char_map.gitgud.list, "ene_zeal_medic_m4")
    table.insert(char_map.gitgud.list, "ene_zeal_medic_r870")
    table.insert(char_map.gitgud.list, "ene_zeal_sniper")

  end)

  Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitStreamlinedHeisting", function (loc)

    HopLib:load_localization(StreamHeist.mod_path .. "loc/", loc)
    loc:add_localized_strings({
      ene_zeal_medic = loc:exists("ene_medic") and loc:text("ene_medic"),
      ene_zeal_sniper = loc:exists("ene_sniper") and loc:text("ene_sniper")
    })

  end)

  Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusStreamlinedHeisting", function(menu_manager, nodes)

    StreamHeist.menu_builder:create_menu(nodes)

  end)

end

if RequiredScript then

  local fname = StreamHeist.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end

end
