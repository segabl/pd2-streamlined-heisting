-- Fix retreat chatter using the wrong voiceline and make voiclines used for pushing unique
Hooks:PostHook(GroupAITweakData, "_init_chatter_data", "sh__init_chatter_data", function (self)
	self.enemy_chatter.retreat.queue = "m01"
	self.enemy_chatter.push = {
		radius = 1000,
		max_nr = 0,
		queue = "pus",
		group_min = 0,
		duration = { 10, 10 },
		interval = { 0.75, 1.2 }
	}
end)


-- We're using the same unit categories for all difficulties for the sake of making the code more readable and not having
-- to do all that if-else crap that Overkill originally did. While unit categories are the same, the units they contain still
-- depend on the difficulty, for instance FBI_heavy_G36 will spawn normal M4 heavies on overkill despite the unit category name
Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "sh__init_unit_categories", function (self, difficulty_index)
	if difficulty_index == 8 then
		self.unit_categories.FBI_swat_M4 = self.unit_categories.CS_swat_MP5
		self.unit_categories.FBI_swat_R870 = self.unit_categories.CS_swat_R870
		self.unit_categories.FBI_swat_R870.unit_types.america = {
			Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_2/ene_zeal_swat_2")
		}
		self.unit_categories.FBI_heavy_G36 = self.unit_categories.CS_heavy_M4
		self.unit_categories.FBI_heavy_R870 = self.unit_categories.CS_heavy_R870
		self.unit_categories.FBI_heavy_R870.unit_types.america = {
			Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_2/ene_zeal_swat_heavy_2")
		}
		self.unit_categories.FBI_shield = self.unit_categories.CS_shield
		self.unit_categories.medic_M4.unit_types.america = {
			Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_m4/ene_zeal_medic_m4")
		}
		self.unit_categories.medic_R870.unit_types.america = {
			Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic_r870/ene_zeal_medic_r870")
		}
	elseif difficulty_index > 5 then
		self.unit_categories.FBI_swat_R870.unit_types.america = {
			Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
		}
	elseif difficulty_index <= 3 then
		self.unit_categories.FBI_swat_M4 = self.unit_categories.CS_swat_MP5
		self.unit_categories.FBI_swat_R870 = self.unit_categories.CS_swat_R870
		self.unit_categories.FBI_heavy_G36 = self.unit_categories.CS_heavy_M4
		self.unit_categories.FBI_heavy_R870 = self.unit_categories.CS_heavy_R870
		self.unit_categories.FBI_shield = self.unit_categories.CS_shield
		self.unit_categories.FBI_suit_C45_M4.unit_types.america = {
			Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
			Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
		}
		self.unit_categories.FBI_suit_M4_MP5.unit_types.america = {
			Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
			Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
		}
		self.unit_categories.FBI_suit_C45_M4.unit_types.zombie = {
			Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"),
			Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4")
		}
		self.unit_categories.FBI_suit_M4_MP5.unit_types.zombie = {
			Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"),
			Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4")
		}
	end

	-- Use the same russian units on all difficulties since factions are incomplete
	self.unit_categories.FBI_swat_R870.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870")
	}
	self.unit_categories.FBI_swat_M4.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass")
	}
	self.unit_categories.FBI_heavy_G36.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36")
	}
	self.unit_categories.FBI_heavy_R870.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870")
	}
	self.unit_categories.FBI_suit_C45_M4.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870")
	}
	self.unit_categories.FBI_suit_M4_MP5.unit_types.russia = {
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg/ene_akan_cs_cop_akmsu_smg"),
		Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870")
	}
	if difficulty_index > 3 then
		self.unit_categories.FBI_shield.unit_types.russia = {
			Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg")
		}
	end

	-- Use the same murky units on all difficulties since their models don't differ
	self.unit_categories.FBI_swat_R870.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi_r870/ene_murkywater_light_fbi_r870")
	}
	self.unit_categories.FBI_swat_M4.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi")
	}
	self.unit_categories.FBI_heavy_G36.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy/ene_murkywater_heavy")
	}
	self.unit_categories.FBI_heavy_R870.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_heavy_shotgun/ene_murkywater_heavy_shotgun")
	}
	-- temp fix till I have proper murky HRT
	self.unit_categories.FBI_suit_C45_M4.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870")
	}
	self.unit_categories.FBI_suit_M4_MP5.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_r870/ene_murkywater_light_r870")
	}

	-- Use the same federal police units on all difficulties since their models don't differ
	self.unit_categories.FBI_swat_R870.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870")
	}
	self.unit_categories.FBI_swat_M4.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi")
	}
	self.unit_categories.FBI_heavy_G36.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi/ene_swat_heavy_policia_federale_fbi")
	}
	self.unit_categories.FBI_heavy_R870.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870")
	}
	-- temp fix till I have proper federal police HRT
	self.unit_categories.FBI_suit_C45_M4.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
		Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02")
	}
	self.unit_categories.FBI_suit_M4_MP5.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
		Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02")
	}

	-- Skulldozers on Mayhem
	if difficulty_index == 6 then
		table.insert(self.unit_categories.FBI_tank.unit_types.america, Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"))
		table.insert(self.unit_categories.FBI_tank.unit_types.russia, Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"))
		table.insert(self.unit_categories.FBI_tank.unit_types.zombie, Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3"))
		table.insert(self.unit_categories.FBI_tank.unit_types.murkywater, Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4"))
		table.insert(self.unit_categories.FBI_tank.unit_types.federales, Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249"))
	end

	local limits_shield = { 0, 2, 2, 3, 3, 4, 4, 5 }
	local limits_medic = { 0, 0, 0, 0, 1, 2, 3, 4 }
	local limits_taser = { 0, 0, 1, 1, 2, 2, 3, 3 }
	local limits_tank = { 0, 0, 0, 1, 1, 2, 2, 3 }
	local limits_spooc = { 0, 0, 0, 1, 1, 2, 2, 3 }
	self.special_unit_spawn_limits = {
		shield = limits_shield[difficulty_index],
		medic = limits_medic[difficulty_index],
		taser = limits_taser[difficulty_index],
		tank = limits_tank[difficulty_index],
		spooc = limits_spooc[difficulty_index]
	}
end)


Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "sh__init_enemy_spawn_groups", function (self, difficulty_index)
	-- Improve and fix incorrect tactics
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
		"flash_grenade",
		"rescue_hostages"
	}
	self._tactics.swat_rifle = {
		"ranged_fire",
		"smoke_grenade",
		"flash_grenade"
	}
	self._tactics.swat_rifle_flank = {
		"flank",
		"flash_grenade",
		"rescue_hostages"
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

	-- Setup/Fix spawngroups
	self.enemy_spawn_groups.tac_swat_shotgun_rush = {
		amount = { 2, 3 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 2,
				rank = 2,
				unit = "FBI_swat_R870",
				tactics = self._tactics.swat_shotgun_rush
			},
			{
				amount_min = 1,
				freq = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_heavy_R870",
				tactics = self._tactics.swat_shotgun_rush
			},
			{
				freq = difficulty_index / 16,
				amount_max = 1,
				rank = 2,
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
				amount_min = 1,
				freq = 1,
				amount_max = 2,
				rank = 2,
				unit = "FBI_swat_R870",
				tactics = self._tactics.swat_shotgun_flank
			},
			{
				amount_min = 1,
				freq = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_heavy_R870",
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
				amount_min = 1,
				freq = 1,
				amount_max = 2,
				rank = 2,
				unit = "FBI_swat_M4",
				tactics = self._tactics.swat_rifle
			},
			{
				amount_min = 1,
				freq = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_heavy_G36",
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
				amount_min = 1,
				freq = 1,
				amount_max = 2,
				rank = 2,
				unit = "FBI_swat_M4",
				tactics = self._tactics.swat_rifle_flank
			},
			{
				amount_min = 1,
				freq = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_heavy_G36",
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
		amount = { 4, 5 },
		spawn = {
			{
				amount_min = 2,
				freq = 1,
				amount_max = 4,
				rank = 2,
				unit = "FBI_heavy_G36",
				tactics = self._tactics.shield_support_ranged
			},
			{
				amount_min = 1,
				freq = 0.75,
				amount_max = 2,
				rank = 3,
				unit = "FBI_shield",
				tactics = self._tactics.shield_wall_ranged
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
		amount = { 4, 5 },
		spawn = {
			{
				amount_min = 2,
				freq = 1,
				amount_max = 4,
				rank = 2,
				unit = "FBI_heavy_R870",
				tactics = self._tactics.shield_support_charge
			},
			{
				amount_min = 1,
				freq = 0.75,
				amount_max = 2,
				rank = 3,
				unit = "FBI_shield",
				tactics = self._tactics.shield_wall_charge
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
				amount_min = 1,
				freq = 1,
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
			}
		}
	}

	self.enemy_spawn_groups.tac_tazer_flanking = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "CS_tazer",
				tactics = self._tactics.tazer_flanking
			},
			{
				freq = 1,
				amount_max = 3,
				rank = 2,
				unit = "FBI_swat_M4",
				tactics = self._tactics.tazer_flanking
			}
		}
	}

	self.enemy_spawn_groups.tac_tazer_charge = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 1,
				freq = 1,
				amount_max = 1,
				rank = 3,
				unit = "CS_tazer",
				tactics = self._tactics.tazer_charge
			},
			{
				freq = 1,
				amount_max = 3,
				rank = 2,
				unit = "FBI_swat_R870",
				tactics = self._tactics.tazer_charge
			}
		}
	}

	self.enemy_spawn_groups.hostage_rescue = {
		amount = { 2, 3 },
		spawn = {
			{
				freq = 1,
				rank = 1,
				unit = "FBI_suit_M4_MP5",
				tactics = self._tactics.swat_rifle_flank
			},
			{
				freq = 0.35,
				amount_max = 1,
				rank = 2,
				unit = "FBI_suit_C45_M4",
				tactics = self._tactics.swat_rifle_flank
			}
		}
	}

	local is_ranc = Global.game_settings and Global.game_settings.level_id == "ranc"
	self.enemy_spawn_groups.marshal_squad = {
		spawn_cooldown = is_ranc and 60 or 120,
		max_nr_simultaneous_groups = 2,
		initial_spawn_delay = is_ranc and 120 or 600,
		amount = { 1, 1 },
		spawn = {
			{
				rank = 1,
				freq = 1,
				unit = "marshal_marksman",
				tactics = self._tactics.marshal_marksman
			}
		},
		spawn_point_chk_ref = {
			tac_swat_rifle_flank = true
		}
	}
end)


Hooks:PostHook(GroupAITweakData, "_init_task_data", "sh__init_task_data", function (self, difficulty_index)
	local f = math.max(0, difficulty_index - 2) / 6

	self.smoke_grenade_timeout = { 25, 35 }
	self.smoke_grenade_lifetime = math.lerp(9, 15, f)
	self.flash_grenade_timeout = { 10, 15 }
	self.flash_grenade.timer = math.lerp(2, 1, f)
	self.cs_grenade_timeout = { 60, 90 }
	self.cs_grenade_lifetime = math.lerp(20, 40, f)

	self.spawn_cooldown_mul = math.lerp(2.5, 1, f)

	-- Spawn Groups
	local special_weight = math.lerp(3, 5, f)
	self.besiege.assault.groups = {
		tac_swat_shotgun_rush = { 1, 1.5, 2 },
		tac_swat_shotgun_rush_no_medic = { 1, 0.5, 0 },
		tac_swat_shotgun_flank = { 0.5, 0.75, 1 },
		tac_swat_shotgun_flank_no_medic = { 0.5, 0.25, 0 },
		tac_swat_rifle = { 7, 10.5, 14 },
		tac_swat_rifle_no_medic = { 7, 3.5, 0 },
		tac_swat_rifle_flank = { 5, 7.5, 10 },
		tac_swat_rifle_flank_no_medic = { 5, 2.5, 0 },
		tac_shield_wall_ranged = { 0, special_weight * 0.5, special_weight },
		tac_shield_wall_charge = { 0, special_weight * 0.5, special_weight },
		tac_tazer_flanking = { 0, special_weight * 0.5, special_weight },
		tac_tazer_charge = { 0, special_weight * 0.5, special_weight },
		tac_bull_rush = { 0, special_weight * 0.5, special_weight },
		FBI_spoocs = { 0, special_weight * 0.5, special_weight },
		single_spooc = { 0, 0, 0 },
		Phalanx = { 0, 0, 0 },
		marshal_squad = { 0, 0, 0 },
		custom_assault = { 0, 0, 0 } -- Catches all scripted spawns during assault participating to group ai
	}

	-- Winters damage reduction settings
	self.phalanx.vip.damage_reduction.start = 0.05
	self.phalanx.vip.damage_reduction.increase = 0.05
	self.phalanx.vip.damage_reduction.increase_intervall = 10

	-- Assault phases settings
	self.besiege.assault.delay = { math.lerp(50, 25, f), math.lerp(40, 20, f), math.lerp(30, 15, f) }
	self.besiege.assault.hostage_hesitation_delay = { 10, 7.5, 5 }
	self.besiege.assault.force = { difficulty_index * 0.5 + 4, difficulty_index * 0.5 + 6, difficulty_index * 0.5 + 8 }
	self.besiege.assault.force_pool = table.collect(self.besiege.assault.force, function (val) return val * 7 end)
	self.besiege.assault.force_balance_mul = { 1, 1.75, 2.5, 3.25 }
	self.besiege.assault.force_pool_balance_mul = { 1, 1.75, 2.5, 3.25 }
	self.besiege.assault.sustain_duration_min = { math.lerp(60, 120, f), math.lerp(120, 180, f), math.lerp(180, 240, f) }
	self.besiege.assault.sustain_duration_max = self.besiege.assault.sustain_duration_min
	self.besiege.assault.sustain_duration_balance_mul = { 1, 1, 1, 1 }

	self.besiege.reenforce.groups = {
		tac_swat_shotgun_rush_no_medic = { 1, 1, 1 },
		tac_swat_rifle_no_medic = { 4, 4, 4 }
	}

	self.besiege.reenforce.interval = { 60, 45, 30 }

	self.besiege.recon.groups = {
		hostage_rescue = { 1, 1, 1 },
		single_spooc = { 0, 0, 0 },
		Phalanx = { 0, 0, 0 },
		marshal_squad = { 0, 0, 0 },
		custom_recon = { 0, 0, 0 } -- Catches all scripted spawns during recon participating to group ai
	}

	self.besiege.recon.force = { 2, 4, 6 }
	self.besiege.recon.interval_variation = 30

	self.besiege.regroup.duration = { 30, 25, 20 }

	self.besiege.recurring_group_SO.recurring_cloaker_spawn.interval = { math.lerp(120, 15, f), math.lerp(240, 30, f) }

	self.street = deep_clone(self.besiege)
	self.safehouse = deep_clone(self.besiege)
end)
