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

	-- Fix some weapon data
	self.asval_smg_npc.sounds.prefix = self.asval_crew.sounds.prefix
	self.dmr_npc.trail = "effects/particles/weapons/sniper_trail"
	self.m249_npc.usage = "is_lmg"
	self.mac11_npc.sounds.prefix = self.mac10_crew.sounds.prefix
	self.mossberg_npc.anim_usage = "is_shotgun_pump"
	self.mossberg_npc.CLIP_AMMO_MAX = 2
	self.mossberg_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
	self.mossberg_npc.sounds.prefix = self.huntsman_crew.sounds.prefix
	self.mossberg_npc.usage = "is_double_barrel"
	self.rpk_lmg_npc.sounds.prefix = self.rpk_crew.sounds.prefix
	self.rpk_lmg_npc.usage = "is_lmg"
	self.saiga_npc.auto.fire_rate = 0.18
	self.saiga_npc.CLIP_AMMO_MAX = 20
	self.sko12_conc_npc.auto = { fire_rate = 0.22 }
	self.sko12_conc_npc.concussion_data.chance = 0.1
	self.sko12_conc_npc.FIRE_MODE = "auto"
	self.sr2_smg_npc.sounds.prefix = self.sr2_crew.sounds.prefix
	self.ump_npc.sounds.prefix = self.schakal_crew.sounds.prefix

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


-- Scale swat turret stats and standardize NPC weapon damage
local turret_damage_mul = {
	{ 0, 1 },
	{ 1500, 0.5 },
	{ 3000, 0.1 },
	{ 10000, 0 }
}
local function set_presets(weap_tweak_data)
	local diff_i = weap_tweak_data.tweak_data:difficulty_to_index(Global.game_settings and Global.game_settings.difficulty or "normal")
	for k, v in pairs(weap_tweak_data) do
		if k:match("_turret_module") then
			v.DAMAGE = diff_i
			v.DAMAGE_MUL_RANGE = turret_damage_mul
			v.HEALTH_INIT = (v.CAN_GO_IDLE and v.AUTO_REPAIR and 500 or 1000) * diff_i
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
