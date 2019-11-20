if not CASS then

  _G.CASS = {}
  CASS.mod_path = ModPath
  CASS.logs = true

  function CASS:log(...)
    if not self.logs then
      return
    end
    local params = {...}
    local str = ""
    for _, v in pairs(params) do
      str = str .. tostring(v) .. " "
    end
    log("[CASS] " .. str)
  end

  function CASS:load_asset_group(name)
    if not self.asset_loader then
      local mod = BLT.Mods:GetModOwnerOfFile(CASS.mod_path)
      self.asset_loader = mod and mod.supermod and mod.supermod:GetAssetLoader()
      if not self.asset_loader then
        self:log("ERROR: Couldn't retrieve the mod's asset loader!")
        return
      end
    end
    self.asset_loader:LoadAssetGroup(name)
  end

end

if RequiredScript then

  local fname = CASS.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end

end
