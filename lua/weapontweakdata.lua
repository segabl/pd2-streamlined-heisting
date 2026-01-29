-- Copies weapon data and sets some values from a crew weapon version
local function copy_data(weapon, stats, cosmetics)
	weapon = weapon or {}
	for k, v in pairs(stats) do
		weapon[k] = type(v) == "table" and deep_clone(v) or v
	end
	weapon.categories = clone(cosmetics.categories)
	weapon.sounds.prefix = cosmetics.sounds.prefix
	weapon.muzzleflash = cosmetics.muzzleflash
	weapon.muzzleflash_silenced = cosmetics.muzzleflash_silenced
	weapon.shell_ejection = cosmetics.shell_ejection
	weapon.hold = cosmetics.hold
	weapon.reload = cosmetics.reload
	weapon.anim_usage = cosmetics.anim_usage or cosmetics.usage
	return weapon
end


-- Setup/fix npc weapons
Hooks:PostHook(WeaponTweakData, "init", "sh_init", function(self, tweak_data)
	self.tweak_data = tweak_data

	-- Fix some weapon data
	self.asval_smg_npc.sounds.prefix = self.asval_crew.sounds.prefix
	self.deagle_npc.usage = "is_revolver"
	self.deagle_npc.anim_usage = "is_pistol"
	self.dmr_npc.trail = "effects/particles/weapons/sniper_trail"
	self.mac11_npc.sounds.prefix = self.mac10_crew.sounds.prefix
	self.mossberg_npc.usage = "is_double_barrel"
	self.mossberg_npc.reload = "looped"
	self.mossberg_npc.looped_reload_single = true
	self.saiga_npc.auto.fire_rate = 0.18
	self.saiga_npc.CLIP_AMMO_MAX = 20
	self.sko12_conc_npc.auto = { fire_rate = 0.22 }
	self.sko12_conc_npc.concussion_data.chance = 0.25
	self.sko12_conc_npc.concussion_data.distance_max = 2000
	self.sko12_conc_npc.FIRE_MODE = "auto"
	self.sr2_smg_npc.sounds.prefix = self.sr2_crew.sounds.prefix
	self.ump_npc.sounds.prefix = self.schakal_crew.sounds.prefix

	-- Make weapons of the same use type have the same stats (damage increase is handled by weapon presets)
	-- This ensures consistent damage scaling independent of the weapon use of different factions
	self.ak47_ass_npc = copy_data(self.ak47_ass_npc, self.m4_npc, self.ak47_crew)
	self.akmsu_smg_npc = copy_data(self.akmsu_smg_npc, self.m4_npc, self.akmsu_crew)
	self.g36_npc = copy_data(self.g36_npc, self.m4_npc, self.g36_crew)
	self.mp5_npc = copy_data(self.mp5_npc, self.m4_npc, self.mp5_crew)
	self.scar_npc = copy_data(self.scar_npc, self.m4_npc, self.scar_crew)
	self.shepheard_npc = copy_data(self.shepheard_npc, self.m4_npc, self.shepheard_crew)
	self.benelli_npc = copy_data(self.benelli_npc, self.r870_npc, self.ben_crew)
	self.ksg_npc = copy_data(self.ksg_npc, self.r870_npc, self.ksg_crew)
	self.spas12_npc = copy_data(self.spas12_npc, self.r870_npc, self.spas12_crew)
	self.rpk_lmg_npc = copy_data(self.rpk_lmg_npc, self.m249_npc, self.rpk_crew)
end)


-- Scale swat turret stats and standardize NPC weapon damage
-- Also assign proper damage values for team AI weapons
local turret_damage_mul = {
	{ 0, 1 },
	{ 1500, 0.5 },
	{ 3000, 0.1 },
	{ 10000, 0 }
}
local crew_weapon_mapping = {
	ak47 = "ak74",
	ak47_ass = "ak74",
	ben = "benelli",
	beretta92 = "b92fs",
	c45 = "glock_17",
	g17 = "glock_17",
	glock_18 = "glock_18c",
	m14 = "new_m14",
	m4 = "new_m4",
	mossberg = "huntsman",
	mp5 = "new_mp5",
	raging_bull = "new_raging_bull",
	x_c45 = "x_g17"
}
local alert_sizes = {
	is_sniper = 10000,
	is_smg = 3000,
	is_pistol = 2500
}
function WeaponTweakData:_set_presets()
	local diff_i = self.tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
	local crew_presets = self.tweak_data.character.presets.weapon.gang_member
	for k, v in pairs(self) do
		if k:match("_turret_module") then
			v.DAMAGE = diff_i
			v.DAMAGE_MUL_RANGE = turret_damage_mul
			v.HEALTH_INIT = 500 * diff_i
			v.SHIELD_HEALTH_INIT = 100 * diff_i
			v.CLIP_SIZE = 300 + 25 * diff_i
			v.BAG_DMG_MUL = 20
			v.SHIELD_DMG_MUL = 1
			v.FIRE_DMG_MUL = 1
			v.EXPLOSION_DMG_MUL = 5
			v.SHIELD_DAMAGE_CLAMP = nil
			v.BODY_DAMAGE_CLAMP = nil
		elseif k:match("_npc$") then
			v.DAMAGE = 1
			v.suppression = v.armor_piercing and 5 or v.is_shotgun and 3 or 1
			v.spread = v.rays and v.rays > 1 and 6 or 0
			if v.categories and v.categories[1] == "snp" and v.usage ~= "is_sniper" then
				v.anim_usage = v.anim_usage or v.usage
				v.usage = "is_sniper"
			end
			v.alert_size = (alert_sizes[v.usage] or 5000) * (v.has_suppressor and 0.2 or 1)
		elseif k:match("_crew$") then
			local player_id = k:gsub("_crew$", ""):gsub("_secondary$", ""):gsub("_primary$", "")
			local player_weapon = crew_weapon_mapping[player_id] and self[crew_weapon_mapping[player_id]] or self[player_id]
			if player_weapon then
				v.CLIP_AMMO_MAX = player_weapon.CLIP_AMMO_MAX
				v.alert_size = self.stats.alert_size[player_weapon.stats.alert_size] or v.alert_size
			end

			-- Check for BWE balance
			if not v.old_usage and crew_presets[v.usage] then
				local usage = crew_presets[v.usage]
				local is_automatic = v.auto and usage.autofire_rounds
				local mag = v.CLIP_AMMO_MAX
				local burst = is_automatic and math.min(usage.autofire_rounds[2], mag) or 1
				local rate = is_automatic and v.auto.fire_rate or 0
				local recoil = (usage.FALLOFF[1].recoil[1] + usage.FALLOFF[1].recoil[2]) * 0.5

				v.DAMAGE = ((mag / burst) * (burst - 1) * rate + (mag / burst - 1) * recoil + 2) / mag
				v.FIRE_MODE = is_automatic and "auto" or "single"
			end
		end
	end
end

WeaponTweakData._set_easy = WeaponTweakData._set_presets
WeaponTweakData._set_normal = WeaponTweakData._set_presets
WeaponTweakData._set_hard = WeaponTweakData._set_presets
WeaponTweakData._set_overkill = WeaponTweakData._set_presets
WeaponTweakData._set_overkill_145 = WeaponTweakData._set_presets
WeaponTweakData._set_easy_wish = WeaponTweakData._set_presets
WeaponTweakData._set_overkill_290 = WeaponTweakData._set_presets
WeaponTweakData._set_sm_wish = WeaponTweakData._set_presets
