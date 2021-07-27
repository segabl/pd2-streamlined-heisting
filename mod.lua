if not HopLib then
	Hooks:PostHook(MenuMainState, "at_enter", "sh_at_enter", function ()
		local title = "HopLib not found!"
		local text = "Streamlined Heisting needs HopLib to work properly!\n\nPlease check the required dependencies!"
		QuickMenu:new(title, text, {}, true)
	end)
end

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

	-- Add new enemies to the character map
	Hooks:Add("HopLibOnCharacterMapCreated", "HopLibOnCharacterMapCreatedStreamlinedHeisting", function (char_map)
		table.insert(char_map.basic.list, "ene_sniper_3")
		table.insert(char_map.bph.list, "ene_murkywater_shield_c45")
		table.insert(char_map.gitgud.list, "ene_zeal_swat_2")
		table.insert(char_map.gitgud.list, "ene_zeal_swat_heavy_2")
		table.insert(char_map.gitgud.list, "ene_zeal_medic_m4")
		table.insert(char_map.gitgud.list, "ene_zeal_medic_r870")
		table.insert(char_map.gitgud.list, "ene_zeal_sniper")
	end)

	-- Redirect unit localization for units that can't be auto-detected
	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitStreamlinedHeisting", function (loc)
		loc:add_localized_strings({
			ene_zeal_medic = loc:exists("ene_medic") and loc:text("ene_medic"),
			ene_zeal_sniper = loc:exists("ene_sniper") and loc:text("ene_sniper")
		})
	end)

end

if RequiredScript then

	local fname = StreamHeist.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
	if io.file_is_readable(fname) then
		dofile(fname)
	end

end
