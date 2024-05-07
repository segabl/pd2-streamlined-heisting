NPCRaycastWeaponBase.flashlight_blacklist = {
	[Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_c45/wpn_npc_c45"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_sawnoff_shotgun/wpn_npc_sawnoff_shotgun"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_smg_mp9/wpn_npc_smg_mp9"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_mac11/wpn_npc_mac11"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_sniper/wpn_npc_sniper"):key()] = true,
	[Idstring("units/payday2/weapons/wpn_npc_c45/wpn_npc_x_c45"):key()] = true,
	[Idstring("units/pd2_dlc_mad/weapons/wpn_npc_svd/wpn_npc_svd"):key()] = true,
	[Idstring("units/pd2_dlc_mad/weapons/wpn_npc_asval/wpn_npc_asval"):key()] = true,
	[Idstring("units/pd2_dlc_mad/weapons/wpn_npc_sr2/wpn_npc_sr2"):key()] = true,
	[Idstring("units/pd2_dlc_spa/weapons/wpn_npc_svd_silenced/wpn_npc_svd_silenced"):key()] = true,
	[Idstring("units/pd2_dlc_drm/weapons/wpn_npc_heavy_zeal_sniper/wpn_npc_heavy_zeal_sniper"):key()] = true,
	[Idstring("units/pd2_dlc_uno/weapons/wpn_npc_smoke/wpn_npc_smoke"):key()] = true,
	[Idstring("units/pd2_dlc_usm1/weapons/wpn_npc_dmr/wpn_npc_dmr"):key()] = true,
	[Idstring("units/pd2_dlc_usm2/weapons/wpn_npc_deagle/wpn_npc_deagle"):key()] = true
}

Hooks:PostHook(NPCRaycastWeaponBase, "init", "sh_init", function (self)
	if not StreamHeist.settings.allow_flashlights or self.flashlight_blacklist[self._unit:name():key()] then
		if self._flashlight_data and alive(self._flashlight_data.light) then
			World:delete_light(self._flashlight_data.light)
		end
		self._flashlight_data = nil
		return
	end

	if self._flashlight_data then
		return
	end

	local light_object = self._unit:get_object(Idstring("a_effect_flashlight"))
	if not light_object then
		return
	end

	local effect = self._unit:effect_spawner(Idstring("flashlight"))
	if not effect then
		return
	end

	local light = World:create_light("spot|specular")

	self._flashlight_data = {
		light = light,
		effect = effect
	}

	light:link(light_object)
	light:set_far_range(400)
	light:set_spot_angle_end(25)
	light:set_multiplier(2)

	local obj_rot = light_object:rotation()
	light:set_rotation(Rotation(obj_rot:z(), -obj_rot:x(), -obj_rot:y()))
	light:set_enable(false)

	self._unit:set_moving()
end)
