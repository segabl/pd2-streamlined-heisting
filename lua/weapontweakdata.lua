-- Copies weapon data and sets some values from a crew weapon version
local function based_on(weap, crew_weap)
	local w = deep_clone(weap)
	w.categories = clone(crew_weap.categories)
	w.sounds.prefix = crew_weap.sounds.prefix
	w.muzzleflash = crew_weap.muzzleflash
	w.shell_ejection = crew_weap.shell_ejection
	w.hold = crew_weap.hold
	w.reload = crew_weap.reload
	w.anim_usage = crew_weap.anim_usage or crew_weap.usage
	return w
end


-- Setup/fix npc weapons
Hooks:PostHook(WeaponTweakData, "init", "sh_init", function(self, tweak_data)
	self.tweak_data = tweak_data

	self.saiga_npc.CLIP_AMMO_MAX = 20
	self.saiga_npc.auto.fire_rate = 0.18

	-- Fix existing weapons sounds
	self.mac11_npc.sounds.prefix = self.mac10_crew.sounds.prefix
	self.asval_smg_npc.sounds.prefix = self.asval_crew.sounds.prefix
	self.sr2_smg_npc.sounds.prefix = self.sr2_crew.sounds.prefix
	self.rpk_lmg_npc.sounds.prefix = self.rpk_crew.sounds.prefix

	-- Make weapons of the same use type have the same stats (damage increase is handled by weapon presets)
	-- This ensures consistent damage scaling independent of the weapon use of different factions
	self.ak47_ass_npc = based_on(self.m4_npc, self.ak47_crew)
	self.akmsu_smg_npc = based_on(self.m4_npc, self.akmsu_crew)
	self.g36_npc = based_on(self.m4_npc, self.g36_crew)
	self.mp5_npc = based_on(self.m4_npc, self.mp5_crew)
	self.scar_npc = based_on(self.m4_npc, self.scar_crew)
	self.shepheard_npc = based_on(self.m4_npc, self.shepheard_crew)
	self.benelli_npc = based_on(self.r870_npc, self.ben_crew)
	self.ksg_npc = based_on(self.r870_npc, self.ksg_crew)
	self.spas12_npc = based_on(self.r870_npc, self.spas12_crew)
end)


-- Make npc melee weapon only a cosmetic choice (damage is multiplied in charactertweakdata)
Hooks:PostHook(WeaponTweakData, "_init_data_npc_melee", "sh__init_data_npc_melee", function (self)
	for _, data in pairs(self.npc_melee) do
		data.damage = 1
	end
end)


-- Scale swat turret stats and standardize NPC weapon damage
local turret_damage_mul = {
	{ 0, 2 },
	{ 1500, 1 },
	{ 3000, 0.1 }
}
local turret_hp_mul = {
	swat_van_turret_module = 2
}
local function set_presets(weap_tweak_data)
	local diff_i = weap_tweak_data.tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
	local diff_i_norm = math.max(0, diff_i - 2) / (#weap_tweak_data.tweak_data.difficulties - 2)

	for k, v in pairs(weap_tweak_data) do
		if k:match("_turret_module$") then
			v.DAMAGE = diff_i * 0.5
			v.DAMAGE_MUL_RANGE = turret_damage_mul
			v.HEALTH_INIT = math.ceil(math.lerp(1000, 20000, diff_i_norm)) * (turret_hp_mul[k] or 1)
			v.SHIELD_HEALTH_INIT = math.ceil(math.lerp(50, 400, diff_i_norm)) * (turret_hp_mul[k] or 1)
			v.CLIP_SIZE = math.ceil(math.lerp(400, 800, diff_i_norm))
		elseif k:match("_npc$") then
			v.DAMAGE = 1
		end
	end
end

WeaponTweakData._set_easy = set_presets
WeaponTweakData._set_normal = set_presets
WeaponTweakData._set_hard = set_presets
WeaponTweakData._set_overkill = set_presets
WeaponTweakData._set_overkill_145 = set_presets
WeaponTweakData._set_easy_wish = set_presets
WeaponTweakData._set_overkill_290 = set_presets
WeaponTweakData._set_sm_wish = set_presets
