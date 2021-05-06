-- Slightly increase tickrate (from 60 tasks/s to 80 tasks/s) to allow higher task throughput
-- Having more available tasks per second than the max amount of enemies should stop any task slowdown
Hooks:PostHook(GroupAITweakData, "init", "sh_init", function (self)
	self.ai_tick_rate = 0.0125
end)

-- We're using the same unit categories for all difficulties for the sake of making the code more readable and not having
-- to do all that if-else crap that Overkill originally did. While unit categories are the same, the units they contain still
-- depend on the difficulty, for instance FBI_heavy_G36 will spawn normal M4 heavies on overkill despite the unit category name
Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "sh__init_unit_categories", function (self, difficulty_index)
	if difficulty_index == 8 then
		self.unit_categories.FBI_swat_M4 = deep_clone(self.unit_categories.CS_swat_MP5)
		self.unit_categories.FBI_swat_M4.unit_types.america = {
			Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat")
		}
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
		self.unit_categories.FBI_swat_R870 = self.unit_categories.CS_swat_R870
		self.unit_categories.FBI_swat_M4 = deep_clone(self.unit_categories.CS_swat_MP5)
		self.unit_categories.FBI_swat_M4.unit_types.america = {
			Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
		}
		self.unit_categories.FBI_heavy_G36 = self.unit_categories.CS_heavy_M4
		self.unit_categories.FBI_heavy_R870 = self.unit_categories.CS_heavy_R870
		self.unit_categories.FBI_shield = self.unit_categories.CS_shield
		self.unit_categories.FBI_suit_M4_MP5.unit_types.america = {
			Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
			Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
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
	self.unit_categories.FBI_suit_M4_MP5.unit_types.murkywater = {
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light_fbi/ene_murkywater_light_fbi"),
		Idstring("units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light")
	}

	-- Use the same federal police units on all difficulties since their models don't differ
	self.unit_categories.FBI_swat_R870.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870")
	}
	self.unit_categories.FBI_swat_M4.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi")
	}
	self.unit_categories.FBI_heavy_G36.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale")
	}
	self.unit_categories.FBI_heavy_R870.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870")
	}
	-- temp fix till I have proper federal police HRT
	self.unit_categories.FBI_suit_M4_MP5.unit_types.federales = {
		Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale/ene_swat_policia_federale"),
		Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870")
	}

	-- Skulldozers on Mayhem
	if difficulty_index == 6 then
		table.insert(self.unit_categories.FBI_tank.unit_types.america, Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"))
		table.insert(self.unit_categories.FBI_tank.unit_types.russia, Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"))
		table.insert(self.unit_categories.FBI_tank.unit_types.zombie, Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3"))
		table.insert(self.unit_categories.FBI_tank.unit_types.murkywater, Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3"))
		table.insert(self.unit_categories.FBI_tank.unit_types.federales, Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249"))
	end

	self.special_unit_spawn_limits = {
		shield = math.max(2, math.ceil(difficulty_index * 0.75)),
		medic = math.max(0, difficulty_index - 4),
		taser = math.max(0, math.ceil((difficulty_index - 2) * 0.5)),
		tank = math.max(0, math.ceil((difficulty_index - 3) * 0.75)),
		spooc = math.max(0, math.min(difficulty_index - 3, 2))
	}
end)


Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "sh__init_enemy_spawn_groups", function (self, difficulty_index)
	-- fix incorrect flank tactic name
	self._tactics.tazer_flanking = {
		"flank",
		"charge",
		"provide_coverfire",
		"smoke_grenade",
		"murder"
	}
	table.insert(self._tactics.swat_rifle, "shield_cover")
	table.insert(self._tactics.swat_rifle_flank, "shield_cover")
	table.insert(self._tactics.swat_shotgun_rush, "shield_cover")
	table.insert(self._tactics.swat_shotgun_flank, "shield_cover")

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
				amount_min = 0,
				freq = difficulty_index / 12,
				amount_max = 1,
				rank = 2,
				unit = "medic_R870",
				tactics = self._tactics.swat_shotgun_rush
			}
		}
	}

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
				amount_min = 0,
				freq = difficulty_index / 12,
				amount_max = 1,
				rank = 1,
				unit = "medic_R870",
				tactics = self._tactics.swat_shotgun_flank
			}
		}
	}

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
				amount_min = 0,
				freq = difficulty_index / 12,
				amount_max = 1,
				rank = 1,
				unit = "medic_M4",
				tactics = self._tactics.swat_rifle
			}
		}
	}

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
				amount_min = 0,
				freq = difficulty_index / 12,
				amount_max = 1,
				rank = 1,
				unit = "medic_M4",
				tactics = self._tactics.swat_rifle_flank
			}
		}
	}

	self.enemy_spawn_groups.tac_shield_wall_ranged = {
		amount = { 5, 6 },
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
				amount_min = 2,
				freq = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_shield",
				tactics = self._tactics.shield_wall_ranged
			},
			{
				amount_min = 0,
				freq = difficulty_index / 12,
				amount_max = 1,
				rank = 1,
				unit = "medic_M4",
				tactics = self._tactics.shield_support_ranged
			}
		}
	}

	self.enemy_spawn_groups.tac_shield_wall_charge = {
		amount = { 5, 6 },
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
				amount_min = 2,
				freq = 1,
				amount_max = 2,
				rank = 3,
				unit = "FBI_shield",
				tactics = self._tactics.shield_wall_charge
			},
			{
				amount_min = 0,
				freq = difficulty_index / 12,
				amount_max = 1,
				rank = 1,
				unit = "medic_R870",
				tactics = self._tactics.shield_support_charge
			}
		}
	}

	self.enemy_spawn_groups.tac_shield_wall = {
		amount = { 3, 4 },
		spawn = {
			{
				amount_min = 3,
				freq = 1,
				amount_max = 4,
				rank = 3,
				unit = "FBI_shield",
				tactics = self._tactics.shield_wall
			},
			{
				amount_min = 0,
				freq = difficulty_index / 12,
				amount_max = 1,
				rank = 2,
				unit = "medic_M4",
				tactics = self._tactics.shield_support_ranged
			}
		}
	}

	self.enemy_spawn_groups.tac_bull_rush = {
		amount = { 1, 1 },
		spawn = {
			{
				freq = 1,
				rank = 3,
				unit = "FBI_tank",
				tactics = self._tactics.tank_rush
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
				amount_min = 0,
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
				amount_min = 0,
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
				amount_min = 2,
				freq = 1,
				amount_max = 3,
				rank = 1,
				unit = "FBI_suit_M4_MP5",
				tactics = self._tactics.swat_rifle_flank
			}
		}
	}
end)


Hooks:PostHook(GroupAITweakData, "_init_task_data", "sh__init_task_data", function (self, difficulty_index)
	local special_weight = difficulty_index * 0.75
	local shield_weight = difficulty_index * 0.625 + 1
	self.besiege.assault.groups = {
		tac_swat_shotgun_rush = { 2, 2, 2 },
		tac_swat_shotgun_flank = { 1, 1, 1 },
		tac_swat_rifle = { 16, 16, 16 },
		tac_swat_rifle_flank = { 4, 4, 4 },
		tac_shield_wall_ranged = { 0, shield_weight * 0.5, shield_weight },
		tac_shield_wall_charge = { 0, shield_weight * 0.5, shield_weight },
		tac_shield_wall = { 0, shield_weight * 0.5, shield_weight },
		tac_tazer_flanking = { 0, special_weight * 0.5, special_weight },
		tac_tazer_charge = { 0, special_weight * 0.5, special_weight },
		FBI_spoocs = { 0, special_weight * 0.5, special_weight },
		tac_bull_rush = { 0, special_weight * 0.5, special_weight },
		single_spooc = { 0, 0, 0 },
		Phalanx = { 0, 0, 0 }
	}

	local f = (difficulty_index - 1) / 7
	self.besiege.assault.hostage_hesitation_delay = { math.lerp(20, 10, f), math.lerp(15, 7.5, f), math.lerp(10, 5, f) }
	self.besiege.assault.force = { 8, 12, 16 }
	self.besiege.assault.force_pool = { 50 + f * 50, 100 + f * 50, 150 + f * 50 }
	self.besiege.assault.force_balance_mul = { 1, 2, 3, 4 }
	self.besiege.assault.force_pool_balance_mul = { 1, 2, 3, 4 }

	self.besiege.recon.groups = {
		hostage_rescue = { 1, 1, 1 },
		single_spooc = { 0, 0, 0 },
		Phalanx = { 0, 0, 0 }
	}

	self.street = deep_clone(self.besiege)
	self.safehouse = deep_clone(self.besiege)
end)
