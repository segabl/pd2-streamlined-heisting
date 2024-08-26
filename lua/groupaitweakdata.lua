-- Set up spawn group weights and assault phase settings
Hooks:PostHook(GroupAITweakData, "_init_task_data", "sh__init_task_data", function (self, difficulty_index)
	local f = math.max(0, difficulty_index - 2) / 6

	self.smoke_grenade_timeout = { 25, 35 }
	self.smoke_grenade_lifetime = math.lerp(9, 15, f)
	self.flash_grenade_timeout = { 15, 20 }
	self.flash_grenade.timer = math.lerp(2, 1, f)
	self.cs_grenade_timeout = { 60, 90 }
	self.cs_grenade_lifetime = math.lerp(20, 40, f)
	self.cs_grenade_chance_times = { 60, 240 }
	self.min_grenade_timeout = 15
	self.no_grenade_push_delay = 8

	self.spawn_cooldown_mul = math.lerp(2, 1, f)
	self.spawn_kill_cooldown = 10

	-- Spawn Groups
	local special_weight = math.lerp(3, 5, f)
	self.besiege.assault.groups = {
		tac_swat_shotgun_rush = { 1, 1.5, 2 },
		tac_swat_shotgun_rush_no_medic = { 1, 0.5, 0 },
		tac_swat_shotgun_flank = { 0.5, 0.75, 1 },
		tac_swat_shotgun_flank_no_medic = { 0.5, 0.25, 0 },
		tac_swat_rifle = { 8, 12, 16 },
		tac_swat_rifle_no_medic = { 8, 4, 0 },
		tac_swat_rifle_flank = { 4, 6, 8 },
		tac_swat_rifle_flank_no_medic = { 4, 2, 0 },
		tac_shield_wall_ranged = { 0, special_weight * 0.5, special_weight },
		tac_shield_wall_charge = { 0, special_weight * 0.5, special_weight },
		tac_tazer_flanking = { 0, special_weight * 0.5, special_weight },
		tac_tazer_charge = { 0, special_weight * 0.5, special_weight },
		tac_bull_rush = { 0, special_weight * 0.5, special_weight },
		FBI_spoocs = { 0, special_weight * 0.5, special_weight },
		single_spooc = { 0, 0, 0 },
		Phalanx = { 0, 0, 0 },
		marshal_squad = { 0, 0, 0 },
		snowman_boss = { 0, 0, 0 },
		piggydozer = { 0, 0, 0 },
		custom_assault = { 0, 0, 0 } -- Catches all scripted spawns during assault participating to group ai
	}

	-- Winters damage reduction settings
	self.phalanx.vip.damage_reduction.start = 0.05
	self.phalanx.vip.damage_reduction.increase = 0.05
	self.phalanx.vip.damage_reduction.increase_intervall = 10

	-- Assault phases settings
	self.besiege.assault.delay = { math.lerp(50, 25, f), math.lerp(40, 20, f), math.lerp(30, 15, f) }
	self.besiege.assault.hostage_hesitation_delay = { 10, 7.5, 5 }
	self.besiege.assault.force = { 8, 11, 14 }
	self.besiege.assault.force_pool = { 60, 70, 80 }
	self.besiege.assault.force_balance_mul = { 1, 1.5, 2, 2.5 }
	self.besiege.assault.force_pool_balance_mul = { 1, 1.5, 2, 2.5 }
	self.besiege.assault.sustain_duration_min = { math.lerp(60, 120, f), math.lerp(120, 180, f), math.lerp(180, 240, f) }
	self.besiege.assault.sustain_duration_max = self.besiege.assault.sustain_duration_min
	self.besiege.assault.sustain_duration_balance_mul = { 1, 1, 1, 1 }
	self.besiege.assault.fade = {
		enemies_defeated_percentage = 0.5,
		enemies_defeated_time = 30,
		engagement_percentage = 0.25,
		engagement_time = 20,
		drama_time = 10
	}

	self.besiege.reenforce.groups = {
		reenforce_init = { 1, 0, 0 },
		reenforce_light = { 0, 1, 0 },
		reenforce_heavy = { 0, 0, 1 }
	}

	self.besiege.reenforce.interval = { 60, 45, 30 }

	self.besiege.recon.groups = {
		hostage_rescue = { 1, 1, 1 },
		single_spooc = { 0, 0, 0 },
		Phalanx = { 0, 0, 0 },
		marshal_squad = { 0, 0, 0 },
		snowman_boss = { 0, 0, 0 },
		piggydozer = { 0, 0, 0 },
		custom_recon = { 0, 0, 0 } -- Catches all scripted spawns during recon participating to group ai
	}

	self.besiege.recon.force = { 2, 4, 6 }
	self.besiege.recon.interval_variation = 30

	self.besiege.regroup.duration = { 30, 25, 20 }

	self.besiege.recurring_group_SO.recurring_cloaker_spawn.interval = { math.lerp(120, 15, f), math.lerp(240, 30, f) }

	self.street = deep_clone(self.besiege)
	self.safehouse = deep_clone(self.besiege)
end)


-- Improve enemy chatter, make proper use of chatter settings like duration and radius
Hooks:PostHook(GroupAITweakData, "_init_chatter_data", "sh__init_chatter_data", function (self)
	local interval = { 1, 2 }
	local duration_short = { 5, 10 }
	local duration_medium = { 10, 20 }
	local duration_long = { 20, 40 }
	local radius_small = 1000
	local radius_medium = 1500
	local radius_large = 2000

	for _, chatter in pairs(self.enemy_chatter) do
		chatter.interval = interval
		chatter.duration = duration_short
		chatter.radius = radius_small
		chatter.max_nr = 1
	end

	-- Loud chatter
	self.enemy_chatter.aggressive.duration = duration_medium
	self.enemy_chatter.contact.duration = duration_medium
	self.enemy_chatter.retreat.queue = "m01"
	self.enemy_chatter.push = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.push.queue = "pus"
	self.enemy_chatter.flank = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.flank.queue = "t01"
	self.enemy_chatter.open_fire = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.open_fire.queue = "att"
	self.enemy_chatter.suppress = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.suppress.queue = "hlp"
	self.enemy_chatter.get_hostages = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.get_hostages.queue = "civ"
	self.enemy_chatter.get_loot = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.get_loot.queue = "l01"
	self.enemy_chatter.watch_background = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.watch_background.queue = "bak"
	self.enemy_chatter.watch_background.duration = duration_medium
	self.enemy_chatter.hostage_delay = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.hostage_delay.queue = "p02"
	self.enemy_chatter.hostage_delay.duration = duration_long
	self.enemy_chatter.hostage_delay.radius = radius_medium
	self.enemy_chatter.group_death = clone(self.enemy_chatter.watch_background)
	self.enemy_chatter.group_death.queue = "lk3a"
	self.enemy_chatter.sentry_gun = clone(self.enemy_chatter.contact)
	self.enemy_chatter.sentry_gun.queue = "ch2"
	self.enemy_chatter.sentry_gun.duration = duration_long
	self.enemy_chatter.sentry_gun.radius = radius_large
	self.enemy_chatter.jammer = clone(self.enemy_chatter.aggressive)
	self.enemy_chatter.jammer.queue = "ch3"
	self.enemy_chatter.jammer.radius = radius_medium

	-- Stealth chatter
	self.enemy_chatter.idle = clone(self.enemy_chatter.go_go)
	self.enemy_chatter.idle.queue = "a06"
	self.enemy_chatter.idle.duration = duration_long
	self.enemy_chatter.idle.radius = radius_large
	self.enemy_chatter.report = clone(self.enemy_chatter.idle)
	self.enemy_chatter.report.queue = "a05"
end)


-- We're using the same unit categories for all difficulties for the sake of making the code more readable and not having
-- to do all that if-else crap that Overkill originally did. While unit categories are the same, the units they contain still
-- depend on the difficulty, for instance FBI_heavy_G36 will spawn normal M4 heavies on overkill despite the unit category name
function GroupAITweakData:_init_unit_categories_normal()
	local FBI_swat_M4 = self.unit_categories.FBI_swat_M4.unit_types
	FBI_swat_M4.america = {Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")}
	FBI_swat_M4.russia = {Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass")}
	FBI_swat_M4.zombie = {Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1")}
	FBI_swat_M4.murkywater = {Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light")}
	FBI_swat_M4.federales = {Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale")}

	local FBI_swat_R870 = self.unit_categories.FBI_swat_R870.unit_types
	FBI_swat_R870.america = { Idstring("units/payday2/characters/ene_swat_2/ene_swat_2") }
	FBI_swat_R870.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870") }
	FBI_swat_R870.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2") }
	FBI_swat_R870.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870") }
	FBI_swat_R870.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870") }

	local FBI_heavy_G36 = self.unit_categories.FBI_heavy_G36.unit_types
	FBI_heavy_G36.america = { Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1") }
	FBI_heavy_G36.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass") }
	FBI_heavy_G36.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1") }
	FBI_heavy_G36.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy") }
	FBI_heavy_G36.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale") }

	local FBI_heavy_R870 = self.unit_categories.FBI_heavy_R870.unit_types
	FBI_heavy_R870.america = { Idstring("units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870") }
	FBI_heavy_R870.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870") }
	FBI_heavy_R870.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870") }
	FBI_heavy_R870.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun") }
	FBI_heavy_R870.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870") }

	local FBI_shield = self.unit_categories.FBI_shield.unit_types
	FBI_shield.america = { Idstring("units/payday2/characters/ene_shield_2/ene_shield_2") }
	FBI_shield.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45") }
	FBI_shield.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2") }
	FBI_shield.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield") }
	FBI_shield.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45") }

	local FBI_tank = self.unit_categories.FBI_tank.unit_types
	FBI_tank.america = { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") }
	FBI_tank.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870") }
	FBI_tank.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1") }
	FBI_tank.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2") }
	FBI_tank.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870") }
end

function GroupAITweakData:_init_unit_categories_hard()
	self:_init_unit_categories_normal()
end

function GroupAITweakData:_init_unit_categories_overkill()
	local FBI_swat_M4 = self.unit_categories.FBI_swat_M4.unit_types
	FBI_swat_M4.america = { Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1") }
	FBI_swat_M4.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass") }
	FBI_swat_M4.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1") }
	FBI_swat_M4.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi") }
	FBI_swat_M4.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi") }

	local FBI_swat_R870 = self.unit_categories.FBI_swat_R870.unit_types
	FBI_swat_R870.america = { Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2") }
	FBI_swat_R870.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870") }
	FBI_swat_R870.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2") }
	FBI_swat_R870.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870") }
	FBI_swat_R870.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870") }

	local FBI_heavy_G36 = self.unit_categories.FBI_heavy_G36.unit_types
	FBI_heavy_G36.america = { Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1") }
	FBI_heavy_G36.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36") }
	FBI_heavy_G36.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1") }
	FBI_heavy_G36.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36") }
	FBI_heavy_G36.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36") }

	local FBI_heavy_R870 = self.unit_categories.FBI_heavy_R870.unit_types
	FBI_heavy_R870.america = { Idstring("units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870") }
	FBI_heavy_R870.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870") }
	FBI_heavy_R870.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870") }
	FBI_heavy_R870.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun") }
	FBI_heavy_R870.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870") }

	local FBI_shield = self.unit_categories.FBI_shield.unit_types
	FBI_shield.america = { Idstring("units/payday2/characters/ene_shield_1/ene_shield_1") }
	FBI_shield.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg") }
	FBI_shield.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1") }
	FBI_shield.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield") }
	FBI_shield.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9") }

	local FBI_tank = self.unit_categories.FBI_tank.unit_types
	FBI_tank.america = { Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1") }
	FBI_tank.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870") }
	FBI_tank.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1") }
	FBI_tank.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2") }
	FBI_tank.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870") }
end

function GroupAITweakData:_init_unit_categories_overkill_145()
	self:_init_unit_categories_overkill()

	self.unit_categories.FBI_tank.unit_types.america = {
		Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
		Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
	}
	self.unit_categories.FBI_tank.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga")
	}
	self.unit_categories.FBI_tank.unit_types.zombie = {
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"),
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2")
	}
	self.unit_categories.FBI_tank.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3")
	}
	self.unit_categories.FBI_tank.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga")
	}
end

function GroupAITweakData:_init_unit_categories_easy_wish()
	local FBI_swat_M4 = self.unit_categories.FBI_swat_M4.unit_types
	FBI_swat_M4.america = { Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1") }
	FBI_swat_M4.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass/ene_akan_fbi_swat_dw_ak47_ass") }
	FBI_swat_M4.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1") }
	FBI_swat_M4.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city/ene_murkywater_light_city") }
	FBI_swat_M4.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city") }

	local FBI_swat_R870 = self.unit_categories.FBI_swat_R870.unit_types
	FBI_swat_R870.america = { Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2") }
	FBI_swat_R870.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870/ene_akan_fbi_swat_dw_r870") }
	FBI_swat_R870.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2") }
	FBI_swat_R870.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_city_r870/ene_murkywater_light_city_r870") }
	FBI_swat_R870.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870") }

	local FBI_heavy_G36 = self.unit_categories.FBI_heavy_G36.unit_types
	FBI_heavy_G36.america = { Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36") }
	FBI_heavy_G36.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36") }
	FBI_heavy_G36.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1") }
	FBI_heavy_G36.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_g36/ene_murkywater_heavy_g36") }
	FBI_heavy_G36.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36") }

	local FBI_heavy_R870 = self.unit_categories.FBI_heavy_R870.unit_types
	FBI_heavy_R870.america = { Idstring("units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870") }
	FBI_heavy_R870.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870") }
	FBI_heavy_R870.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870") }
	FBI_heavy_R870.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun") }
	FBI_heavy_R870.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870") }

	local FBI_shield = self.unit_categories.FBI_shield.unit_types
	FBI_shield.america = { Idstring("units/payday2/characters/ene_city_shield/ene_city_shield") }
	FBI_shield.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg") }
	FBI_shield.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1") }
	FBI_shield.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield") }
	FBI_shield.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9") }

	self.unit_categories.FBI_tank.unit_types.america = {
		Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
		Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
		Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
	}
	self.unit_categories.FBI_tank.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg")
	}
	self.unit_categories.FBI_tank.unit_types.zombie = {
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"),
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2"),
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3")
	}
	self.unit_categories.FBI_tank.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4")
	}
	self.unit_categories.FBI_tank.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249")
	}
end

function GroupAITweakData:_init_unit_categories_overkill_290()
	self:_init_unit_categories_easy_wish()

	self.unit_categories.FBI_tank.unit_types.america = {
		Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
		Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
		Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"),
		Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
	}
	self.unit_categories.FBI_tank.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"),
		Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
	}
	self.unit_categories.FBI_tank.unit_types.zombie = {
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"),
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2"),
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3"),
		Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic")
	}
	self.unit_categories.FBI_tank.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_1/ene_murkywater_bulldozer_1")
	}
	self.unit_categories.FBI_tank.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun")
	}
end

function GroupAITweakData:_init_unit_categories_sm_wish()
	local FBI_swat_M4 = self.unit_categories.FBI_swat_M4.unit_types
	FBI_swat_M4.america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat") }
	FBI_swat_M4.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_ak47_ass/ene_akan_cs_swat_ak47_ass") }
	FBI_swat_M4.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1") }
	FBI_swat_M4.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light") }
	FBI_swat_M4.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale") }

	local FBI_swat_R870 = self.unit_categories.FBI_swat_R870.unit_types
	FBI_swat_R870.america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2") }
	FBI_swat_R870.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870") }
	FBI_swat_R870.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2") }
	FBI_swat_R870.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870") }
	FBI_swat_R870.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870") }

	local FBI_heavy_G36 = self.unit_categories.FBI_heavy_G36.unit_types
	FBI_heavy_G36.america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy") }
	FBI_heavy_G36.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass") }
	FBI_heavy_G36.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1") }
	FBI_heavy_G36.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy") }
	FBI_heavy_G36.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale") }

	local FBI_heavy_R870 = self.unit_categories.FBI_heavy_R870.unit_types
	FBI_heavy_R870.america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2") }
	FBI_heavy_R870.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870") }
	FBI_heavy_R870.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870") }
	FBI_heavy_R870.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun") }
	FBI_heavy_R870.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870") }

	local FBI_shield = self.unit_categories.FBI_shield.unit_types
	FBI_shield.america = { Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield") }
	FBI_shield.russia = { Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg") }
	FBI_shield.zombie = { Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1") }
	FBI_shield.murkywater = { Idstring("units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield") }
	FBI_shield.federales = { Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9") }

	self.unit_categories.FBI_tank.unit_types.america = {
		Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"),
		Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"),
		Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"),
		Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
		Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic")
	}
	self.unit_categories.FBI_tank.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"),
		Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
		Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic")
	}
	self.unit_categories.FBI_tank.unit_types.zombie = {
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"),
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2"),
		Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3"),
		Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"),
		Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic")
	}
	self.unit_categories.FBI_tank.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_1/ene_murkywater_bulldozer_1"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_medic/ene_murkywater_bulldozer_medic")
	}
	self.unit_categories.FBI_tank.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_medic_policia_federale/ene_swat_dozer_medic_policia_federale")
	}

	self.unit_categories.medic_M4.unit_types.america = {
		Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4")
	}
	self.unit_categories.medic_R870.unit_types.america = {
		Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870")
	}
end

Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "sh__init_unit_categories", function (self, difficulty_index)
	local difficulty_func = "_init_unit_categories_" .. (Global.game_settings and Global.game_settings.difficulty or "normal")
	if self[difficulty_func] then
		self[difficulty_func](self)
	else
		StreamHeist:warn("GroupAITweakData.%s does not exist", difficulty_func)
	end

	-- Russian Cops/HRT
	self.unit_categories.CS_cop_C45_R870.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_ak47_ass/ene_akan_cs_cop_ak47_ass"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870")
	}
	self.unit_categories.FBI_suit_C45_M4.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_ak47_ass/ene_akan_cs_cop_ak47_ass"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg")
	}
	self.unit_categories.FBI_suit_M4_MP5.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870")
	}

	-- Murkywater Cops/HRT
	self.unit_categories.CS_cop_C45_R870.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870")
	}
	self.unit_categories.FBI_suit_C45_M4.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870")
	}
	self.unit_categories.FBI_suit_M4_MP5.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870")
	}

	-- Federales Cops/HRT
	self.unit_categories.CS_cop_C45_R870.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
		Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02")
	}
	self.unit_categories.FBI_suit_C45_M4.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
		Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02")
	}
	self.unit_categories.FBI_suit_M4_MP5.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
		Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02")
	}

	local limits_shield = { 0, 2, 2, 3, 3, 4, 4, 5 }
	local limits_medic = { 0, 0, 0, 0, 1, 2, 3, 4 }
	local limits_taser = { 0, 0, 1, 1, 2, 2, 3, 3 }
	local limits_tank = { 0, 0, 0, 1, 1, 2, 2, 3 }
	local limits_spooc = { 0, 0, 0, 1, 1, 2, 2, 3 }
	self.special_unit_spawn_limits.shield = limits_shield[difficulty_index]
	self.special_unit_spawn_limits.medic = limits_medic[difficulty_index]
	self.special_unit_spawn_limits.taser = limits_taser[difficulty_index]
	self.special_unit_spawn_limits.tank = limits_tank[difficulty_index]
	self.special_unit_spawn_limits.spooc = limits_spooc[difficulty_index]
end)


-- Set up tactics and spawngroups
Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "sh__init_enemy_spawn_groups", function (self, difficulty_index)
	self._tactics.swat_shotgun_rush = {
		"charge",
		"deathguard",
		"smoke_grenade",
		"flash_grenade"
	}
	self._tactics.swat_shotgun_flank = {
		"charge",
		"flank",
		"deathguard",
		"flash_grenade"
	}
	self._tactics.swat_rifle = {
		"ranged_fire",
		"smoke_grenade",
		"flash_grenade"
	}
	self._tactics.swat_rifle_flank = {
		"flank",
		"deathguard",
		"flash_grenade"
	}
	self._tactics.shield_wall_ranged = {
		"shield",
		"ranged_fire"
	}
	self._tactics.shield_wall_charge = {
		"shield",
		"charge"
	}
	self._tactics.tank_rush = {
		"shield",
		"charge",
		"smoke_grenade",
		"murder"
	}
	self._tactics.tazer_charge = {
		"charge",
		"smoke_grenade",
		"murder"
	}
	self._tactics.tazer_flanking = {
		"flank",
		"flash_grenade",
		"murder"
	}
	self._tactics.spooc = {
		"flank",
		"smoke_grenade"
	}
	self._tactics.marshal_marksman = {
		"ranged_fire",
		"no_push"
	}
	self._tactics.marshal_shield = {
		"charge"
	}

	self.enemy_spawn_groups.tac_swat_shotgun_rush = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_heavy_R870",
				tactics = self._tactics.swat_shotgun_rush
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "FBI_swat_R870",
				tactics = self._tactics.swat_shotgun_rush
			},
			{
				freq = difficulty_index / 16,
				amount_max = 1,
				rank = 1,
				unit = "medic_R870",
				tactics = self._tactics.swat_shotgun_rush
			}
		}
	}

	self.enemy_spawn_groups.tac_swat_shotgun_rush_no_medic = deep_clone(self.enemy_spawn_groups.tac_swat_shotgun_rush)
	table.remove(self.enemy_spawn_groups.tac_swat_shotgun_rush_no_medic.spawn)

	self.enemy_spawn_groups.tac_swat_shotgun_flank = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_heavy_R870",
				tactics = self._tactics.swat_shotgun_flank
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "FBI_swat_R870",
				tactics = self._tactics.swat_shotgun_flank
			},
			{
				freq = difficulty_index / 20,
				amount_max = 1,
				rank = 1,
				unit = "medic_R870",
				tactics = self._tactics.swat_shotgun_flank
			}
		}
	}

	self.enemy_spawn_groups.tac_swat_shotgun_flank_no_medic = deep_clone(self.enemy_spawn_groups.tac_swat_shotgun_flank)
	table.remove(self.enemy_spawn_groups.tac_swat_shotgun_flank_no_medic.spawn)

	self.enemy_spawn_groups.tac_swat_rifle = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_heavy_G36",
				tactics = self._tactics.swat_rifle
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "FBI_swat_M4",
				tactics = self._tactics.swat_rifle
			},
			{
				freq = difficulty_index / 16,
				amount_max = 1,
				rank = 1,
				unit = "medic_M4",
				tactics = self._tactics.swat_rifle
			}
		}
	}

	self.enemy_spawn_groups.tac_swat_rifle_no_medic = deep_clone(self.enemy_spawn_groups.tac_swat_rifle)
	table.remove(self.enemy_spawn_groups.tac_swat_rifle_no_medic.spawn)

	self.enemy_spawn_groups.tac_swat_rifle_flank = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_heavy_G36",
				tactics = self._tactics.swat_rifle_flank
			},
			{
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				rank = 2,
				unit = "FBI_swat_M4",
				tactics = self._tactics.swat_rifle_flank
			},
			{
				freq = difficulty_index / 20,
				amount_max = 1,
				rank = 1,
				unit = "medic_M4",
				tactics = self._tactics.swat_rifle_flank
			}
		}
	}

	self.enemy_spawn_groups.tac_swat_rifle_flank_no_medic = deep_clone(self.enemy_spawn_groups.tac_swat_rifle_flank)
	table.remove(self.enemy_spawn_groups.tac_swat_rifle_flank_no_medic.spawn)

	self.enemy_spawn_groups.tac_shield_wall_ranged = {
		amount = { 4, 4 },
		spawn = {
			{
				freq = difficulty_index / 16,
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_shield",
				tactics = self._tactics.shield_wall_ranged
			},
			{
				freq = 0.25,
				rank = 2,
				unit = "FBI_swat_M4",
				tactics = self._tactics.shield_support_ranged
			},
			{
				freq = 1,
				rank = 2,
				unit = "FBI_heavy_G36",
				tactics = self._tactics.shield_support_ranged
			},
			{
				freq = difficulty_index / 32,
				amount_max = 1,
				rank = 1,
				unit = "medic_M4",
				tactics = self._tactics.shield_support_ranged
			}
		}
	}
	self.enemy_spawn_groups.tac_shield_wall = self.enemy_spawn_groups.tac_shield_wall_ranged

	self.enemy_spawn_groups.tac_shield_wall_charge = {
		amount = { 4, 4 },
		spawn = {
			{
				freq = difficulty_index / 16,
				amount_min = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_shield",
				tactics = self._tactics.shield_wall_charge
			},
			{
				freq = 0.25,
				rank = 2,
				unit = "FBI_swat_R870",
				tactics = self._tactics.shield_support_charge
			},
			{
				freq = 1,
				rank = 2,
				unit = "FBI_heavy_R870",
				tactics = self._tactics.shield_support_charge
			},
			{
				freq = difficulty_index / 32,
				amount_max = 1,
				rank = 1,
				unit = "medic_R870",
				tactics = self._tactics.shield_support_charge
			}
		}
	}

	self.enemy_spawn_groups.tac_bull_rush = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 2,
				unit = "FBI_tank",
				tactics = self._tactics.tank_rush
			},
			{
				freq = 1,
				rank = 1,
				unit = "FBI_heavy_R870",
				tactics = self._tactics.shield_support_charge
			},
			{
				freq = 1,
				rank = 1,
				unit = "FBI_heavy_G36",
				tactics = self._tactics.shield_support_charge
			},
			{
				freq = difficulty_index / 64,
				amount_max = 1,
				rank = 1,
				unit = "medic_R870",
				tactics = self._tactics.shield_support_charge
			}
		}
	}

	self.enemy_spawn_groups.tac_tazer_flanking = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 2,
				unit = "CS_tazer",
				tactics = self._tactics.tazer_flanking
			},
			{
				freq = 1,
				rank = 1,
				unit = "FBI_swat_M4",
				tactics = self._tactics.tazer_flanking
			}
		}
	}

	self.enemy_spawn_groups.tac_tazer_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				rank = 2,
				unit = "CS_tazer",
				tactics = self._tactics.tazer_charge
			},
			{
				freq = 1,
				rank = 1,
				unit = "FBI_swat_R870",
				tactics = self._tactics.tazer_charge
			}
		}
	}

	self.enemy_spawn_groups.hostage_rescue = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.35,
				amount_max = 1,
				rank = 2,
				unit = "FBI_suit_C45_M4",
				tactics = self._tactics.swat_rifle_flank
			},
			{
				freq = 1,
				rank = 1,
				unit = "FBI_suit_M4_MP5",
				tactics = self._tactics.swat_rifle_flank
			}
		}
	}

	self.enemy_spawn_groups.reenforce_init = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "CS_cop_C45_R870",
				tactics = self._tactics.swat_rifle_flank
			}
		}
	}

	self.enemy_spawn_groups.reenforce_light = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 0.2,
				amount_max = 1,
				rank = 2,
				unit = "FBI_heavy_R870",
				tactics = self._tactics.swat_shotgun_rush
			},
			{
				freq = 0.4,
				amount_max = 1,
				rank = 2,
				unit = "FBI_heavy_G36",
				tactics = self._tactics.swat_rifle
			},
			{
				freq = 1,
				rank = 1,
				unit = "FBI_swat_R870",
				tactics = self._tactics.swat_shotgun_rush
			},
			{
				freq = 2,
				rank = 1,
				unit = "FBI_swat_M4",
				tactics = self._tactics.swat_rifle
			}
		}
	}

	self.enemy_spawn_groups.reenforce_heavy = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 2,
				unit = "FBI_heavy_R870",
				tactics = self._tactics.swat_shotgun_rush
			},
			{
				freq = 2,
				rank = 2,
				unit = "FBI_heavy_G36",
				tactics = self._tactics.swat_rifle
			},
			{
				freq = 0.2,
				amount_max = 1,
				rank = 1,
				unit = "FBI_swat_R870",
				tactics = self._tactics.swat_shotgun_rush
			},
			{
				freq = 0.4,
				amount_max = 1,
				rank = 1,
				unit = "FBI_swat_M4",
				tactics = self._tactics.swat_rifle
			}
		}
	}
end)


-- Handle level specific spawngroups
Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups_level", "sh__init_enemy_spawn_groups_level", function (self, tweak_data)
	local lvl_tweak_data = tweak_data.levels[Global.game_settings and Global.game_settings.level_id or Global.level_data and Global.level_data.level_id]
	if not lvl_tweak_data or lvl_tweak_data.ai_marshal_spawns_disabled then
		return
	end

	self.enemy_spawn_groups.marshal_squad = {
		spawn_cooldown = 60,
		max_nr_simultaneous_groups = 1,
		initial_spawn_delay = lvl_tweak_data.ai_marshal_spawns_fast and 90 or 480,
		amount = { 1, 1 },
		spawn = {
			{
				rank = 1,
				freq = 1,
				unit = "marshal_marksman",
				tactics = self._tactics.marshal_marksman
			},
			{
				rank = 1,
				freq = 1,
				unit = "marshal_shield",
				tactics = self._tactics.marshal_shield
			}
		}
	}
end)
