Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "sh__init_unit_categories", function (self, difficulty_index)

  -- We're using the same unit categories for all difficulties for the sake of making the code more readable and not having
  -- to do all that if-else crap that Overkill originally did. While unit categories are the same, the units they contain still
  -- depend on the difficulty, for instance FBI_heavy_G36 will spawn normal M4 heavies on overkill despite the unit category name

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

  if difficulty_index <= 2 then
    self.special_unit_spawn_limits = {
      shield = 2,
      medic = 0,
      taser = 0,
      tank = 0,
      spooc = 0
    }
  elseif difficulty_index == 3 then
    self.special_unit_spawn_limits = {
      shield = 3,
      medic = 0,
      taser = 1,
      tank = 0,
      spooc = 0
    }
  elseif difficulty_index == 4 then
    self.special_unit_spawn_limits = {
      shield = 4,
      medic = 1,
      taser = 2,
      tank = 1,
      spooc = 1
    }
  elseif difficulty_index == 5 then
    self.special_unit_spawn_limits = {
      shield = 4,
      medic = 2,
      taser = 2,
      tank = 2,
      spooc = 2
    }
  elseif difficulty_index == 6 then
    self.special_unit_spawn_limits = {
      shield = 5,
      medic = 3,
      taser = 3,
      tank = 2,
      spooc = 2
    }
  elseif difficulty_index == 7 then
    self.special_unit_spawn_limits = {
      shield = 5,
      medic = 3,
      taser = 3,
      tank = 3,
      spooc = 3
    }
  else
    self.special_unit_spawn_limits = {
      shield = 6,
      medic = 5,
      taser = 4,
      tank = 4,
      spooc = 3
    }
  end

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
        freq = difficulty_index / 32,
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
        freq = difficulty_index / 32,
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
        freq = difficulty_index / 32,
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
        freq = difficulty_index / 32,
        amount_max = 1,
        rank = 1,
        unit = "medic_M4",
        tactics = self._tactics.swat_rifle_flank
      }
    }
  }

  self.enemy_spawn_groups.tac_shield_wall_ranged = {
    amount = { 4, 5 },
    spawn = {
      {
        amount_min = 2,
        freq = 1,
        amount_max = 2,
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
        freq = difficulty_index / 32,
        amount_max = 1,
        rank = 1,
        unit = "medic_M4",
        tactics = self._tactics.shield_support_charge
      }
    }
  }

  self.enemy_spawn_groups.tac_shield_wall_charge = {
    amount = { 4, 5 },
    spawn = {
      {
        amount_min = 2,
        freq = 1,
        amount_max = 2,
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
        freq = difficulty_index / 32,
        amount_max = 1,
        rank = 1,
        unit = "medic_R870",
        tactics = self._tactics.shield_support_charge
      }
    }
  }

  self.enemy_spawn_groups.tac_shield_wall = {
    amount = { 4, 5 },
    spawn = {
      {
        amount_min = 4,
        freq = 4,
        amount_max = 4,
        rank = 3,
        unit = "FBI_shield",
        tactics = self._tactics.shield_wall
      },
      {
        amount_min = 0,
        freq = difficulty_index / 32,
        amount_max = 1,
        rank = 2,
        unit = "medic_M4",
        tactics = self._tactics.shield_support_ranged
      }
    }
  }

  self.enemy_spawn_groups.tac_bull_rush = {
    amount = { 1, 1 + math.ceil(math.max(0, difficulty_index - 5) / 2) },
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
    amount = { 1, 3 },
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
    amount = { 1, 3 },
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
        amount_max = 2,
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

  if difficulty_index <= 2 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 1, 1, 1 },
      tac_swat_shotgun_flank = { 0.5, 0.5, 0.5 },
      tac_swat_rifle = { 8, 8, 8 },
      tac_swat_rifle_flank = { 2, 2, 2 },
      tac_shield_wall_ranged = { 0, 1, 2 },
      tac_shield_wall_charge = { 0, 0.5, 1 },
      tac_shield_wall = { 0, 0.5, 1 },
      tac_tazer_flanking = { 0, 0, 0 },
      tac_tazer_charge = { 0, 0, 0 },
      FBI_spoocs = { 0, 0, 0 },
      tac_bull_rush = { 0, 0, 0 }
    }
  elseif difficulty_index == 3 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 1, 1, 1 },
      tac_swat_shotgun_flank = { 0.5, 0.5, 0.5 },
      tac_swat_rifle = { 8, 8, 8 },
      tac_swat_rifle_flank = { 2, 2, 2 },
      tac_shield_wall_ranged = { 0, 2, 4 },
      tac_shield_wall_charge = { 0, 1, 2 },
      tac_shield_wall = { 0, 1, 2 },
      tac_tazer_flanking = { 0, 1, 2 },
      tac_tazer_charge = { 0, 1, 2 },
      FBI_spoocs = { 0, 0, 0 },
      tac_bull_rush = { 0, 0, 0 }
    }
  elseif difficulty_index == 4 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 2, 2, 2 },
      tac_swat_shotgun_flank = { 1, 1, 1 },
      tac_swat_rifle = { 16, 16, 16 },
      tac_swat_rifle_flank = { 4, 4, 4 },
      tac_shield_wall_ranged = { 0, 4, 8 },
      tac_shield_wall_charge = { 0, 2, 4 },
      tac_shield_wall = { 0, 2, 4 },
      tac_tazer_flanking = { 0, 2, 4 },
      tac_tazer_charge = { 0, 2, 4 },
      FBI_spoocs = { 0, 1, 2 },
      tac_bull_rush = { 0, 1, 2 }
    }
  elseif difficulty_index == 5 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 2, 2, 2 },
      tac_swat_shotgun_flank = { 1, 1, 1 },
      tac_swat_rifle = { 16, 16, 16 },
      tac_swat_rifle_flank = { 4, 4, 4 },
      tac_shield_wall_ranged = { 0, 4, 8 },
      tac_shield_wall_charge = { 0, 2, 4 },
      tac_shield_wall = { 0, 2, 4 },
      tac_tazer_flanking = { 0, 2, 4 },
      tac_tazer_charge = { 0, 2, 4 },
      FBI_spoocs = { 0, 2, 4 },
      tac_bull_rush = { 0, 2, 4 }
    }
  elseif difficulty_index == 6 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 2, 2, 2 },
      tac_swat_shotgun_flank = { 1, 1, 1 },
      tac_swat_rifle = { 16, 16, 16 },
      tac_swat_rifle_flank = { 4, 4, 4 },
      tac_shield_wall_ranged = { 0, 4, 8 },
      tac_shield_wall_charge = { 0, 3, 6 },
      tac_shield_wall = { 0, 3, 6 },
      tac_tazer_flanking = { 0, 3, 6 },
      tac_tazer_charge = { 0, 3, 6 },
      FBI_spoocs = { 0, 3, 6 },
      tac_bull_rush = { 0, 3, 6 }
    }
  elseif difficulty_index >= 7 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 2, 2, 2 },
      tac_swat_shotgun_flank = { 1, 1, 1 },
      tac_swat_rifle = { 16, 16, 16 },
      tac_swat_rifle_flank = { 4, 4, 4 },
      tac_shield_wall_ranged = { 0, 4, 8 },
      tac_shield_wall_charge = { 0, 4, 8 },
      tac_shield_wall = { 0, 4, 8 },
      tac_tazer_flanking = { 0, 4, 8 },
      tac_tazer_charge = { 0, 4, 8 },
      FBI_spoocs = { 0, 4, 8 },
      tac_bull_rush = { 0, 4, 8 }
    }
  end
  self.besiege.assault.groups.single_spooc = { 0, 0, 0 }
  self.besiege.assault.groups.Phalanx = { 0, 0, 0 }

  local f = 2 - (difficulty_index - 1) / 7
  self.besiege.assault.hostage_hesitation_delay = { 20 * f, 15 * f, 10 * f }
  self.besiege.assault.force = { 6, 12, 18 }
  self.besiege.assault.force_pool = { 75, 100, 150 }
  self.besiege.assault.force_balance_mul = { 1, 2, 3, 4 }
  self.besiege.assault.force_pool_balance_mul = { 1, 2, 3, 4 }

  self.besiege.recon.groups = {
    tac_swat_shotgun_flank = { 1, 1, 1 },
    tac_swat_rifle_flank = { 2, 2, 2 },
    hostage_rescue = { 8, 8, 8 }
  }
  self.besiege.recon.groups.single_spooc = { 0, 0, 0 }
  self.besiege.recon.groups.Phalanx = { 0, 0, 0 }

  self.besiege.reenforce.groups = {
    tac_swat_shotgun_flank = { 1, 1, 1 },
    tac_swat_rifle_flank = { 2, 2, 2 },
    FBI_spoocs = { 0, 0.5, 1 }
  }
  self.besiege.reenforce.groups.single_spooc = { 0, 0, 0 }
  self.besiege.reenforce.groups.Phalanx = { 0, 0, 0 }

  self.street = deep_clone(self.besiege)
  self.safehouse = deep_clone(self.besiege)

end)
