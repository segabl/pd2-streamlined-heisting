if not StreamHeist then

  _G.StreamHeist = {}
  StreamHeist.mod_path = ModPath
  StreamHeist.menu_id = "StreamHeistMenu"
  StreamHeist.settings = {
    logs = false
  }

  function StreamHeist:log(...)
    if not self.settings.logs then
      return
    end
    local str = "[StreamlinedHeisting] " .. table.concat({...}, " ")
    print(str)
    log(str)
  end

  function StreamHeist:save()
    local file = io.open(SavePath .. "StreamHeist.txt", "w+")
    if file then
      file:write(json.encode(self.settings))
      file:close()
    end
  end

  function StreamHeist:load()
    local file = io.open(SavePath .. "StreamHeist.txt", "r")
    if not file then
      return
    end
    local data = json.decode(file:read("*all"))
    file:close()
    for k, v in pairs(data or {}) do
      self.settings[k] = v
    end
  end

  -- Add new enemies to the character map
  Hooks:Add("HopLibOnCharacterMapCreated", "HopLibOnCharacterMapCreatedStreamlinedHeisting", function (char_map)

    table.insert(char_map.basic.list, "ene_swat_heavy_r870")
    table.insert(char_map.basic.list, "ene_fbi_heavy_r870")
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
      ene_zeal_medic = loc:text("ene_medic"),
      ene_zeal_sniper = loc:text("ene_sniper")
    })

  end)

  Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenusStreamHeist", function(menu_manager, nodes)
    MenuHelper:NewMenu(StreamHeist.menu_id)
  end)

  Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenusStreamHeist", function(menu_manager, nodes)

    StreamHeist:load()

    MenuCallbackHandler.StreamHeist_toggle = function(self, item)
      StreamHeist.settings[item:name()] = (item:value() == "on")
    end

    MenuCallbackHandler.StreamHeist_save = function(self)
      StreamHeist:save()
    end

    MenuHelper:AddToggle({
      id = "logs",
      title = "StreamHeist_menu_logs",
      desc = "StreamHeist_menu_logs_desc",
      callback = "StreamHeist_toggle",
      value = StreamHeist.settings.logs,
      menu_id = StreamHeist.menu_id,
      priority = 90
    })

  end)

  Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusPlayerStreamHeist", function(menu_manager, nodes)
    nodes[StreamHeist.menu_id] = MenuHelper:BuildMenu(StreamHeist.menu_id, { back_callback = "StreamHeist_save" })
    MenuHelper:AddMenuItem(nodes["blt_options"], StreamHeist.menu_id, "StreamHeist_menu_main", "StreamHeist_menu_main_desc")
  end)

end

if RequiredScript then

  local fname = StreamHeist.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end

end
