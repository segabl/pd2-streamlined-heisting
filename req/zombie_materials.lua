local head = {
	diffuse_texture = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/heads_atlas_hvh_df"),
	bump_normal_texture = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/heads_atlas_hvh_nm")
}
local light_helmet = {
	diffuse_texture = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/helmets_atlas_hvh_df"),
	bump_normal_texture = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/helmets_atlas_hvh_nm")
}
local heavy_helmet = {
	diffuse_texture = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/helmets_heavy_taser_atlas_hvh_df"),
	bump_normal_texture = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/helmets_heavy_taser_atlas_hvh_nm")
}
local swat_body = {
	diffuse_texture = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/swat_body_hvh_df"),
	bump_normal_texture = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/swat_body_hvh_nm")
}
local fbi_swat_body = {
	diffuse_texture = Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/swat_fbi_body_hvh_df"),
	bump_normal_texture = Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/swat_fbi_body_hvh_nm")
}
local fbi_heavy_body = {
	diffuse_texture = Idstring("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/spook_hvh_df"),
	bump_normal_texture = Idstring("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/spook_hvh_nm")
}
local city_swat_body = {
	diffuse_texture = Idstring("units/pd2_dlc_hvh/characters/shared_textures/swat_city_df"),
	bump_normal_texture = Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/swat_body_hvh_nm")
}
local city_heavy_body = {
	diffuse_texture = Idstring("units/pd2_dlc_hvh/characters/shared_textures/swat_city_heavy_df"),
	bump_normal_texture = Idstring("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/spook_hvh_nm")
}

local swat_materials = {
	mtr_head = head,
	mtr_swat = swat_body,
	mtr_ene_acc_swat_helmet = light_helmet
}
local fbi_swat_materials = {
	mtr_head = head,
	mtr_swat = fbi_swat_body,
	mtr_swat_fbi = fbi_swat_body,
	mtr_helmet = light_helmet
}
local fbi_heavy_materials = {
	mtr_head = head,
	mtr_body = fbi_heavy_body,
	mtr_light_body = fbi_swat_body,
	mtr_heavy_helmet = heavy_helmet,
	mtr_gadgets = light_helmet
}
local city_swat_materials = {
	mtr_head = head,
	mtr_swat = city_swat_body,
	mtr_city_swat = city_swat_body,
	mtr_helmet = light_helmet
}
local city_heavy_materials = {
	mtr_head = head,
	mtr_body = city_heavy_body,
	mtr_light_body = city_swat_body,
	mtr_heavy_helmet = heavy_helmet,
	mtr_gadgets = light_helmet
}

local unit_data = {
	["units/payday2/characters/ene_swat_1/ene_swat_1"] = swat_materials,
	["units/payday2/characters/ene_swat_2/ene_swat_2"] = swat_materials,
	["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = swat_materials,
	["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = swat_materials,
	["units/payday2/characters/ene_shield_2/ene_shield_2"] = swat_materials,
	["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = swat_materials,
	["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = fbi_swat_materials,
	["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = fbi_swat_materials,
	["units/payday2/characters/ene_shield_1/ene_shield_1"] = fbi_swat_materials,
	["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = fbi_swat_materials,
	["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = fbi_heavy_materials,
	["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = fbi_heavy_materials,
	["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = city_swat_materials,
	["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = city_swat_materials,
	["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = city_swat_materials,
	["units/payday2/characters/ene_city_shield/ene_city_shield"] = city_swat_materials,
	["units/payday2/characters/ene_sniper_3/ene_sniper_3"] = city_swat_materials,
	["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = city_heavy_materials,
	["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = city_heavy_materials
}

local final = {}
for u_name, u_materials in pairs(unit_data) do
	local materials = {}
	for m_name, m_data in pairs(u_materials) do
		materials[m_name] = m_data
		materials[m_name .. "_lod1"] = m_data
		materials[m_name .. "_lod2"] = m_data
		materials[m_name .. "_lod_1"] = m_data
		materials[m_name .. "_lod_2"] = m_data
	end

	final[u_name:key()] = materials
	final[(u_name .. "_contour"):key()] = materials
end

return final