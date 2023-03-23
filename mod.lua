if not StreamHeist then

	StreamHeist = {
		mod_path = ModPath,
		save_path = SavePath .. "streamlined_heisting.json",
		mod_instance = ModInstance,
		logging = io.file_is_readable("mods/developer.txt"),
		required = {},
		settings = {
			auto_faction_tweaks = true,
			faction_tweaks = {
				swat = true,
				fbi = true,
				gensec = true,
				zeal = true,
				murkywater = true,
				federales = true,
				russia = true
			}
		}
	}

	function StreamHeist:require(file)
		local path = self.mod_path .. "req/" .. file .. ".lua"
		return io.file_is_readable(path) and blt.vm.dofile(path)
	end

	function StreamHeist:mission_script_patches()
		if self._mission_script_patches == nil then
			local level_id = Global.game_settings and Global.game_settings.level_id
			if level_id then
				self._mission_script_patches = self:require("mission_script/" .. level_id:gsub("_night$", ""):gsub("_day$", "")) or false
			end
		end
		return self._mission_script_patches
	end

	function StreamHeist:log(...)
		if self.logging then
			log("[StreamlinedHeisting] " .. table.concat({...}, " "))
		end
	end

	function StreamHeist:warn(...)
		log("[StreamlinedHeisting][Warning] " .. table.concat({...}, " "))
	end

	function StreamHeist:error(...)
		log("[StreamlinedHeisting][Error] " .. table.concat({...}, " "))
	end

	-- Redirect unit localization for units that can't be auto-detected
	Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInitStreamlinedHeisting", function (loc)
		loc:add_localized_strings({
			ene_zeal_medic = loc:exists("ene_medic") and loc:text("ene_medic"),
			ene_zeal_sniper = loc:exists("ene_sniper") and loc:text("ene_sniper")
		})

		if HopLib then
			HopLib:load_localization(StreamHeist.mod_path .. "loc/", loc)
		else
			loc:load_localization_file(StreamHeist.mod_path .. "loc/english.txt")
		end
	end)

	-- Check for common mod conflicts
	Hooks:Add("MenuManagerOnOpenMenu", "MenuManagerOnOpenMenuStreamlinedHeisting", function()
		if Global.sh_mod_conflicts then
			return
		end

		Global.sh_mod_conflicts = {}
		local conflicting_mods = StreamHeist:require("mod_conflicts") or {}
		for _, mod in pairs(BLT.Mods:Mods()) do
			if mod:IsEnabled() and conflicting_mods[mod:GetName()] then
				table.insert(Global.sh_mod_conflicts, mod:GetName())
			end
		end

		if #Global.sh_mod_conflicts > 0 then
			local message = managers.localization:text("sh_menu_conflicts") .. "\n\n" .. table.concat(Global.sh_mod_conflicts, "\n")
			local buttons = {
				{
					text = managers.localization:text("sh_menu_conflicts_disable"),
					callback = function ()
						for _, mod_name in pairs(Global.sh_mod_conflicts) do
							local mod = BLT.Mods:GetModByName(mod_name)
							if mod then
								mod:SetEnabled(false, true)
							end
						end
						MenuCallbackHandler:perform_blt_save()
					end
				},
				{
					text = managers.localization:text("sh_menu_conflicts_ignore")
				},
			}
			QuickMenu:new(managers.localization:text("sh_menu_warning"), message, buttons, true)
		end
	end)

	-- Create settings menu
	Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenusStreamlinedHeisting", function(_, nodes)

		local menu_id = "sh_menu"
		MenuHelper:NewMenu(menu_id)

		local faction_menu_elements = {}
		MenuCallbackHandler.sh_auto_faction_tweaks_toggle = function(self, item)
			local enabled = (item:value() == "on")
			StreamHeist.settings.auto_faction_tweaks = enabled
			for _, element in pairs(faction_menu_elements) do
				element:set_enabled(not enabled)
			end
		end

		MenuCallbackHandler.sh_faction_toggle = function(self, item)
			StreamHeist.settings.faction_tweaks[item:name()] = (item:value() == "on")
		end

		MenuCallbackHandler.sh_save = function()
			io.save_as_json(StreamHeist.settings, StreamHeist.save_path)
		end

		MenuHelper:AddToggle({
			id = "auto_faction_tweaks",
			title = "sh_menu_auto_faction_tweaks",
			desc = "sh_menu_auto_faction_tweaks_desc",
			callback = "sh_auto_faction_tweaks_toggle",
			value = StreamHeist.settings.auto_faction_tweaks,
			menu_id = menu_id,
			priority = 100
		})

		for i, faction in ipairs({ "swat", "fbi", "gensec", "zeal", "russia", "federales", "murkywater" }) do
			local menu_element = MenuHelper:AddToggle({
				id = faction,
				title = "sh_menu_" .. faction,
				desc = "sh_menu_faction_tweak_desc",
				callback = "sh_faction_toggle",
				value = StreamHeist.settings.faction_tweaks[faction],
				disabled = StreamHeist.settings.auto_faction_tweaks,
				menu_id = menu_id,
				priority = 10 - i
			})

			table.insert(faction_menu_elements, menu_element)
		end

		nodes[menu_id] = MenuHelper:BuildMenu(menu_id, { back_callback = "sh_save" })
		MenuHelper:AddMenuItem(nodes["blt_options"], menu_id, "sh_menu_main")
	end)

	-- Load settings
	if io.file_is_readable(StreamHeist.save_path) then
		local data = io.load_as_json(StreamHeist.save_path)
		if data then
			local function merge(tbl1, tbl2)
				for k, v in pairs(tbl2) do
					if type(tbl1[k]) == type(v) then
						if type(v) == "table" then
							merge(tbl1[k], v)
						else
							tbl1[k] = v
						end
					end
				end
			end
			merge(StreamHeist.settings, data)
		end
	end

	-- Disable some of "The Fixes"
	TheFixesPreventer = TheFixesPreventer or {}
	TheFixesPreventer.crash_upd_aim_coplogicattack = true
	TheFixesPreventer.fix_copmovement_aim_state_discarded = true
	TheFixesPreventer.tank_remove_recoil_anim = true
	TheFixesPreventer.tank_walk_near_players  = true

	-- Check faction tweaks
	if not Global.sh_faction_tweaks_check then
		Global.sh_faction_tweaks_check = true

		local auto_detect = StreamHeist.settings.auto_faction_tweaks
		local asset_loader = StreamHeist.mod_instance.supermod:GetAssetLoader()
		local mod_overrides = {}
		if auto_detect then
			for modname, data in pairs(DB:mods()) do
				for _, file in pairs(data.files) do
					local name, ext = file:match("^(.-)%.(.-)$")
					if ext == "model" then
						mod_overrides[name] = modname
					end
				end
			end
		end

		for faction, enabled in pairs(StreamHeist.settings.faction_tweaks) do
			if auto_detect then
				enabled = true
				local assets = asset_loader.script_loadable_packages[faction].assets
				for _, spec in pairs(assets) do
					if mod_overrides[spec.dbpath] then
						StreamHeist:log("Disabling faction tweak for faction", faction, "due to mod_override", mod_overrides[spec.dbpath])
						enabled = false
						break
					end
				end
				StreamHeist.settings.faction_tweaks[faction] = enabled
			end

			if enabled then
				asset_loader:LoadAssetGroup(faction)
			end
		end

		if auto_detect then
			io.save_as_json(StreamHeist.settings, StreamHeist.save_path)
		end
	end
end

if RequiredScript and not StreamHeist.required[RequiredScript] then

	local fname = StreamHeist.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
	if io.file_is_readable(fname) then
		dofile(fname)
	end

	StreamHeist.required[RequiredScript] = true

end
