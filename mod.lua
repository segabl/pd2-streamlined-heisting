if not StreamHeist then

	StreamHeist = {
		mod_path = ModPath,
		mod_instance = ModInstance,
		logging = io.file_is_readable("mods/developer.txt")
	}

	function StreamHeist:log(...)
		if self.logging then
			log("[StreamlinedHeisting] " .. table.concat({...}, " "))
		end
	end

	-- Redirect unit localization for units that can't be auto-detected
	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitStreamlinedHeisting", function (loc)
		loc:add_localized_strings({
			ene_zeal_medic = loc:exists("ene_medic") and loc:text("ene_medic"),
			ene_zeal_sniper = loc:exists("ene_sniper") and loc:text("ene_sniper")
		})
	end)

end

local required = {}
if RequiredScript and not required[RequiredScript] then

	local fname = StreamHeist.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
	if io.file_is_readable(fname) then
		dofile(fname)
	end

	required[RequiredScript] = true

end
