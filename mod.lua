if not CASS then

  _G.CASS = {}
  CASS.mod_path = ModPath

  function CASS:log(...)
    local params = {...}
    local str = ""
    for _, v in pairs(params) do
      str = str .. tostring(v) .. " "
    end
    log("[CASS] " .. str)
  end

end

if RequiredScript then

  local fname = CASS.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
  if io.file_is_readable(fname) then
    dofile(fname)
  end

end
