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
    local str = "[StreamlinedHeisting] " .. table.concat({...}, " ")
    print(str)
    log(str)
  end

  Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitStreamlinedHeisting", function (loc)

    loc:add_localized_strings({
      ene_zeal_medic = loc:text("ene_medic")
    })

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
