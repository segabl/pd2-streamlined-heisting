-- Load custom units when they are needed
local ids_unit = Idstring("unit")
Hooks:PostHook(DynamicResourceManager, "preload_units", "sh_preload_units", function (self)
	local function load_unit(path)
		if not self:has_resource(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE) then
			self:load(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
			self:load(ids_unit, Idstring(path .. "_husk"), self.DYN_RESOURCES_PACKAGE)
		end
	end

	if PackageManager:has(ids_unit, Idstring("units/payday2/characters/ene_sniper_1/ene_sniper_1")) then
		StreamHeist:log("Loading custom SWAT units...")
		load_unit("units/payday2/characters/ene_sniper_3/ene_sniper_3")
	end

	if PackageManager:has(ids_unit, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat")) then
		StreamHeist:log("Loading custom Zeal units...")
		load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2")
		load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2")
		load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4")
		load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870")
		load_unit("units/pd2_dlc_gitgud/characters/ene_zeal_sniper/ene_zeal_sniper")
	end
end)
