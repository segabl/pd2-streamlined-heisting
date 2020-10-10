if not StreamHeist then

  _G.StreamHeist = {}
  StreamHeist.mod_path = ModPath
  StreamHeist.settings = {
    logs = true
  }

  function StreamHeist:log(...)
    if not self.settings.logs then
      return
    end
    local params = {...}
    local str = ""
    for _, v in pairs(params) do
      str = str .. tostring(v) .. " "
    end
    print("[StreamlinedHeisting] " .. str)
    log("[StreamlinedHeisting] " .. str)
  end

  Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitStreamlinedHeisting", function (loc)

    HopLib:load_localization(StreamHeist.mod_path .. "loc/", loc)

  end)

  -- Add new enemies to the character map
  Hooks:Add("HopLibOnCharacterMapCreated", "HopLibOnCharacterMapCreatedStreamlinedHeisting", function (char_map)

    table.insert(char_map.basic.list, "ene_swat_heavy_r870")
    table.insert(char_map.basic.list, "ene_fbi_heavy_r870")
    table.insert(char_map.gitgud.list, "ene_zeal_swat_2")
    table.insert(char_map.gitgud.list, "ene_zeal_swat_heavy_2")
    table.insert(char_map.gitgud.list, "ene_zeal_medic_m4")
    table.insert(char_map.gitgud.list, "ene_zeal_medic_r870")

  end)

end

if RequiredScript then

  local fname = StreamHeist.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end

end
