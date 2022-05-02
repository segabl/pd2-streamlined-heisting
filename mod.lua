if not StreamHeist then

	StreamHeist = {
		mod_path = ModPath,
		mod_instance = ModInstance,
		logging = io.file_is_readable("mods/developer.txt")
	}

	function StreamHeist:mission_script_patches()
		if self._mission_script_patches == nil then
			local level_id = Global.game_settings and Global.game_settings.level_id
			if not level_id then
				return
			end

			local path = self.mod_path .. "req/mission_script/" .. level_id:gsub("_night$", "") .. ".lua"
			self._mission_script_patches = io.file_is_readable(path) and blt.vm.dofile(path) or false
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
	end)

	-- Check for common mod conflicts
	Hooks:Add("MenuManagerOnOpenMenu", "MenuManagerOnOpenMenuStreamlinedHeisting", function()
		if Global.sh_mod_conflicts then
			return
		end

		local conflicting_mods = {
			["Assault Tweaks Standalone"] = true,
			["Assault Tweaks Standalone Lite"] = true,
			["Full Speed Swarm"] = true,
			["Ire and Fist"] = true,
			["LIES"] = true,
			["Mildly Alarming Enemy Spawngroups"] = true,
			["Snap's Spawngroups"] = true,
			["United Offensive"] = true
		}
		Global.sh_mod_conflicts = {}
		for _, mod in pairs(BLT.Mods:Mods()) do
			if mod:IsEnabled() and conflicting_mods[mod:GetName()] then
				table.insert(Global.sh_mod_conflicts, mod:GetName())
			end
		end

		if #Global.sh_mod_conflicts > 0 then
			local message = "The following mod(s) are likely to cause unintended behavior or crashes in combination with Streamlined Heisting:\n\n"
			local buttons = {
				{
					text = "Disable conflicting mods",
					callback = function ()
						for _, mod_name in pairs(Global.sh_mod_conflicts) do
							local mod = BLT.Mods:GetModByName(mod_name)
							if mod then
								mod:SetEnabled(false, true)
							end
						end
						BLT.Mods:Save()
					end
				},
				{
					text = "Keep enabled (not recommended)"
				},
			}
			QuickMenu:new("Warning", message .. table.concat(Global.sh_mod_conflicts, "\n"), buttons, true)
		end
	end)

	-- Notify about required game restart
	ModInstance.SetEnabled = function (self, enable, ...)
		BLTMod.SetEnabled(self, enable, ...)
		QuickMenu:new("Information", "A game restart is required to fully " .. (enable and "enable" or "disable") .. " all parts of Streamlined Heisting!", {}, true)
	end

end

local required = {}
if RequiredScript and not required[RequiredScript] then

	local fname = StreamHeist.mod_path .. RequiredScript:gsub(".+/(.+)", "lua/%1.lua")
	if io.file_is_readable(fname) then
		dofile(fname)
	end

	required[RequiredScript] = true

end
