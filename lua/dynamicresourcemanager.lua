-- Load custom units when they are needed
local ids_unit = Idstring("unit")
Hooks:PostHook(DynamicResourceManager, "preload_units", "sh_preload_units", function (self)
	local function load_unload_unit(path, load)
		local has = self:has_resource(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
		if load and not has then
			self:load(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
			self:load(ids_unit, Idstring(path .. "_husk"), self.DYN_RESOURCES_PACKAGE)
		elseif not load and has then
			self:unload(ids_unit, Idstring(path), self.DYN_RESOURCES_PACKAGE)
			self:unload(ids_unit, Idstring(path .. "_husk"), self.DYN_RESOURCES_PACKAGE)
		end
	end

	local base_needed = PackageManager:has(ids_unit, Idstring("units/payday2/characters/ene_sniper_1/ene_sniper_1"))
	load_unload_unit("units/payday2/characters/ene_sniper_3/ene_sniper_3", base_needed)

	local zeals_needed = PackageManager:has(ids_unit, Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"))
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2", zeals_needed)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2", zeals_needed)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4", zeals_needed)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870", zeals_needed)
	load_unload_unit("units/pd2_dlc_gitgud/characters/ene_zeal_sniper/ene_zeal_sniper", zeals_needed)
end)
