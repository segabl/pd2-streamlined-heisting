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

end

if RequiredScript then

  local fname = StreamHeist.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end

end
