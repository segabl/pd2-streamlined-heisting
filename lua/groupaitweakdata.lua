
Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "cass__init_unit_categories", function (self, difficulty_index)

  if difficulty_index > 5 and difficulty_index < 8 then
    self.unit_categories.FBI_swat_R870.unit_types.america = {
      Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2")
    }
    self.unit_categories.CS_swat_MP5.unit_types.america = {
      Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
    }
  elseif difficulty_index > 3 then
    self.unit_categories.CS_swat_MP5.unit_types.america = {
      Idstring("units/payday2/characters/ene_fbi_swat_smg/ene_fbi_swat_smg")
    }
  else
    self.unit_categories.FBI_swat_R870 = self.unit_categories.CS_swat_R870
    self.unit_categories.FBI_swat_M4 = deep_clone(self.unit_categories.CS_swat_MP5)
    self.unit_categories.FBI_swat_M4.unit_types.america = {
      Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
    }
    self.unit_categories.CS_swat_MP5.unit_types.america = {
      Idstring("units/payday2/characters/ene_swat_smg/ene_swat_smg")
    }
    self.unit_categories.FBI_heavy_G36 = self.unit_categories.CS_heavy_M4
    self.unit_categories.FBI_heavy_R870 = self.unit_categories.CS_heavy_R870
    self.unit_categories.FBI_shield = self.unit_categories.CS_shield
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

function GroupAITweakData:_init_enemy_spawn_groups(difficulty_index)
  self._tactics = {
    Phalanx_minion = {
      "smoke_grenade",
      "charge",
      "provide_coverfire",
      "provide_support",
      "shield",
      "deathguard"
    },
    Phalanx_vip = {
      "smoke_grenade",
      "charge",
      "provide_coverfire",
      "provide_support",
      "shield",
      "deathguard"
    },
    swat_shotgun_rush = {
      "charge",
      "provide_coverfire",
      "provide_support",
      "deathguard",
      "flash_grenade"
    },
    swat_shotgun_flank = {
      "charge",
      "provide_coverfire",
      "provide_support",
      "flank",
      "deathguard",
      "flash_grenade"
    },
    swat_rifle = {
      "ranged_fire",
      "provide_coverfire",
      "provide_support"
    },
    swat_rifle_flank = {
      "ranged_fire",
      "provide_coverfire",
      "provide_support",
      "flank",
      "flash_grenade"
    },
    shield_wall_ranged = {
      "shield",
      "ranged_fire",
      "provide_support "
    },
    shield_support_ranged = {
      "shield_cover",
      "ranged_fire",
      "provide_coverfire"
    },
    shield_wall_charge = {
      "shield",
      "charge",
      "provide_support "
    },
    shield_support_charge = {
      "shield_cover",
      "charge",
      "provide_coverfire",
      "flash_grenade"
    },
    shield_wall = {
      "shield",
      "ranged_fire",
      "provide_support",
      "murder",
      "deathguard"
    },
    shield_flank = {
      "shield",
      "ranged_fire",
      "provide_coverfire",
      "provide_support",
      "flank"
    },
    shield_support_flank = {
      "shield_cover",
      "ranged_fire",
      "provide_coverfire",
      "provide_support",
      "flank"
    },
    tazer_flanking = {
      "flank",
      "charge",
      "provide_coverfire",
      "smoke_grenade",
      "murder"
    },
    tazer_charge = {
      "charge",
      "provide_coverfire",
      "murder"
    },
    tank_rush = {
      "charge",
      "provide_coverfire",
      "murder"
    },
    spooc = {
      "charge",
      "shield_cover",
      "smoke_grenade"
    }
  }
  self.enemy_spawn_groups = {}

  -- tac_swat_shotgun_rush
  self.enemy_spawn_groups.tac_swat_shotgun_rush = {
    amount = { 3, 4 },
    spawn = {
      {
        amount_min = 2,
        freq = 1,
        amount_max = 2,
        rank = 2,
        unit = "FBI_swat_R870",
        tactics = self._tactics.swat_shotgun_rush
      },
      {
        amount_min = 1,
        freq = 3,
        amount_max = 1,
        rank = 3,
        unit = "FBI_heavy_R870",
        tactics = self._tactics.swat_shotgun_rush
      },
      {
        amount_min = 0,
        freq = difficulty_index / 16,
        amount_max = 1,
        rank = 2,
        unit = "medic_R870",
        tactics = self._tactics.swat_shotgun_rush
      }
    }
  }

  -- tac_swat_shotgun_flank
  self.enemy_spawn_groups.tac_swat_shotgun_flank = {
    amount = { 3, 4 },
    spawn = {
      {
        amount_min = 2,
        freq = 1,
        amount_max = 2,
        rank = 2,
        unit = "FBI_swat_R870",
        tactics = self._tactics.swat_shotgun_flank
      },
      {
        amount_min = 1,
        freq = 3,
        amount_max = 1,
        rank = 3,
        unit = "FBI_heavy_R870",
        tactics = self._tactics.swat_shotgun_flank
      },
      {
        amount_min = 0,
        freq = difficulty_index / 16,
        amount_max = 1,
        rank = 1,
        unit = "medic_R870",
        tactics = self._tactics.swat_shotgun_flank
      }
    }
  }

  -- tac_swat_rifle
  self.enemy_spawn_groups.tac_swat_rifle = {
    amount = { 4, 5 },
    spawn = {
      {
        amount_min = 2,
        freq = 1,
        amount_max = 2,
        rank = 2,
        unit = "FBI_swat_M4",
        tactics = self._tactics.swat_rifle
      },
      {
        amount_min = 2,
        freq = 1,
        amount_max = 2,
        rank = 3,
        unit = "FBI_heavy_G36",
        tactics = self._tactics.swat_rifle
      },
      {
        amount_min = 0,
        freq = difficulty_index / 16,
        amount_max = 1,
        rank = 1,
        unit = "medic_M4",
        tactics = self._tactics.swat_rifle
      }
    }
  }

  -- tac_swat_rifle_flank
  self.enemy_spawn_groups.tac_swat_rifle_flank = {
    amount = { 4, 5 },
    spawn = {
      {
        amount_min = 0,
        freq = 1,
        amount_max = 2,
        rank = 2,
        unit = "FBI_swat_M4",
        tactics = self._tactics.swat_rifle_flank
      },
      {
        amount_min = 0,
        freq = 0.5,
        amount_max = 2,
        rank = 2,
        unit = "CS_swat_MP5",
        tactics = self._tactics.swat_rifle_flank
      },
      {
        amount_min = 2,
        freq = 1,
        amount_max = 2,
        rank = 3,
        unit = "FBI_heavy_G36",
        tactics = self._tactics.swat_rifle_flank
      },
      {
        amount_min = 0,
        freq = difficulty_index / 16,
        amount_max = 1,
        rank = 1,
        unit = "medic_M4",
        tactics = self._tactics.swat_rifle_flank
      }
    }
  }

  -- tac_shield_wall_ranged
  self.enemy_spawn_groups.tac_shield_wall_ranged = {
    amount = { 4, 5 },
    spawn = {
      {
        amount_min = 2,
        freq = 2,
        amount_max = 2,
        rank = 2,
        unit = "FBI_heavy_G36",
        tactics = self._tactics.shield_support_ranged
      },
      {
        amount_min = 2,
        freq = 2,
        amount_max = 2,
        rank = 3,
        unit = "FBI_shield",
        tactics = self._tactics.shield_wall_ranged
      },
      {
        amount_min = 0,
        freq = difficulty_index / 16,
        amount_max = 1,
        rank = 1,
        unit = "medic_M4",
        tactics = self._tactics.shield_support_charge
      }
    }
  }

  -- tac_shield_wall_charge
  self.enemy_spawn_groups.tac_shield_wall_charge = {
    amount = { 4, 5 },
    spawn = {
      {
        amount_min = 2,
        freq = 2,
        amount_max = 2,
        rank = 2,
        unit = "FBI_heavy_R870",
        tactics = self._tactics.shield_support_charge
      },
      {
        amount_min = 2,
        freq = 2,
        amount_max = 2,
        rank = 3,
        unit = "FBI_shield",
        tactics = self._tactics.shield_wall_charge
      },
      {
        amount_min = 0,
        freq = difficulty_index / 16,
        amount_max = 1,
        rank = 1,
        unit = "medic_R870",
        tactics = self._tactics.shield_support_charge
      }
    }
  }

  -- tac_shield_wall
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
        freq = difficulty_index / 16,
        amount_max = 1,
        rank = 2,
        unit = "medic_M4",
        tactics = self._tactics.shield_support_ranged
      }
    }
  }

  -- tac_bull_rush
  self.enemy_spawn_groups.tac_bull_rush = {
    amount = { 1, 1 + math.round(difficulty_index / 3) },
    spawn = {
      {
        amount_min = 1,
        freq = 1,
        amount_max = 3,
        rank = 3,
        unit = "FBI_tank",
        tactics = self._tactics.tank_rush
      },
      {
        amount_min = 0,
        freq = difficulty_index / 16,
        amount_max = 1,
        rank = 1,
        unit = "medic_M4",
        tactics = self._tactics.tank_rush
      }
    }
  }

  self.enemy_spawn_groups.tac_tazer_flanking = {
    amount = { 3, 3 },
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
        amount_min = 2,
        freq = 1,
        amount_max = 2,
        rank = 2,
        unit = "CS_swat_MP5",
        tactics = self._tactics.tazer_flanking
      }
    }
  }
  self.enemy_spawn_groups.tac_tazer_charge = {
    amount = { 3, 3 },
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
        amount_min = 2,
        freq = 1,
        amount_max = 2,
        rank = 2,
        unit = "FBI_swat_R870",
        tactics = self._tactics.tazer_charge
      }
    }
  }

  self.enemy_spawn_groups.Phalanx = {
    amount = {
      self.phalanx.minions.amount + 1,
      self.phalanx.minions.amount + 1
    },
    spawn = {
      {
        amount_min = 1,
        freq = 1,
        amount_max = 1,
        rank = 2,
        unit = "Phalanx_vip",
        tactics = self._tactics.Phalanx_vip
      },
      {
        freq = 1,
        amount_min = 1,
        rank = 1,
        unit = "Phalanx_minion",
        tactics = self._tactics.Phalanx_minion
      }
    }
  }
  
  self.enemy_spawn_groups.FBI_spoocs = {
    amount = { 1, 1 + math.round(difficulty_index / 4) },
    spawn = {
      {
        freq = 1,
        amount_min = 1,
        rank = 1,
        unit = "spooc",
        tactics = self._tactics.spooc
      }
    }
  }
  self.enemy_spawn_groups.single_spooc = self.enemy_spawn_groups.FBI_spoocs

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
  self.enemy_spawn_groups.hostage_rescue_shield = {
    amount = { 2, 3 },
    spawn = {
      {
        amount_min = 2,
        freq = 1,
        rank = 1,
        unit = "FBI_suit_M4_MP5",
        tactics = self._tactics.shield_flank_support
      },
      {
        amount_min = 0,
        freq = difficulty_index / 32,
        amount_max = 1,
        rank = 3,
        unit = "FBI_shield",
        tactics = self._tactics.shield_flank
      }
    }
  }
  self.enemy_spawn_groups.hostage_rescue_medic = {
    amount = { 2, 3 },
    spawn = {
      {
        amount_min = 2,
        freq = 1,
        rank = 1,
        unit = "FBI_suit_M4_MP5",
        tactics = self._tactics.swat_rifle_flank
      },
      {
        amount_min = 0,
        freq = difficulty_index / 32,
        amount_max = 1,
        rank = 3,
        unit = "medic_M4",
        tactics = self._tactics.swat_rifle_flank
      },
    }
  }
end

Hooks:PostHook(GroupAITweakData, "_init_task_data", "cass__init_task_data", function (self, difficulty_index)

  if difficulty_index <= 2 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 2, 2, 2 },
      tac_swat_shotgun_flank = { 1, 1, 1 },
      tac_swat_rifle = { 4, 4, 4 },
      tac_swat_rifle_flank = { 2, 2, 2 },
      tac_shield_wall_ranged = { 2, 2, 2 },
      tac_shield_wall_charge = { 1, 1, 1 },
      tac_shield_wall = { 1, 1, 1 },
      tac_tazer_flanking = { 1, 1, 1 },
      tac_tazer_charge = { 1, 1, 1 },
      FBI_spoocs = { 0, 0, 0 },
      tac_bull_rush = { 0, 0, 0 }
    }
  elseif difficulty_index == 3 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 4, 4, 4 },
      tac_swat_shotgun_flank = { 2, 2, 2 },
      tac_swat_rifle = { 8, 8, 8 },
      tac_swat_rifle_flank = { 4, 4, 4 },
      tac_shield_wall_ranged = { 4, 4, 4 },
      tac_shield_wall_charge = { 2, 2, 2 },
      tac_shield_wall = { 2, 2, 2 },
      tac_tazer_flanking = { 2, 2, 2 },
      tac_tazer_charge = { 2, 2, 2 },
      FBI_spoocs = { 1, 1, 1 },
      tac_bull_rush = { 1, 1, 1 }
    }
  elseif difficulty_index == 4 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 4, 4, 4 },
      tac_swat_shotgun_flank = { 2, 2, 2 },
      tac_swat_rifle = { 8, 8, 8 },
      tac_swat_rifle_flank = { 4, 4, 4 },
      tac_shield_wall_ranged = { 4, 4, 4 },
      tac_shield_wall_charge = { 2, 2, 2 },
      tac_shield_wall = { 2, 2, 2 },
      tac_tazer_flanking = { 2, 2, 2 },
      tac_tazer_charge = { 2, 2, 2 },
      FBI_spoocs = { 2, 2, 2 },
      tac_bull_rush = { 2, 2, 2 }
    }
  elseif difficulty_index == 5 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 4, 4, 4 },
      tac_swat_shotgun_flank = { 2, 2, 2 },
      tac_swat_rifle = { 8, 8, 8 },
      tac_swat_rifle_flank = { 4, 4, 4 },
      tac_shield_wall_ranged = { 4, 4, 4 },
      tac_shield_wall_charge = { 3, 3, 3 },
      tac_shield_wall = { 3, 3, 3 },
      tac_tazer_flanking = { 3, 3, 3 },
      tac_tazer_charge = { 3, 3, 3 },
      FBI_spoocs = { 3, 3, 3 },
      tac_bull_rush = { 3, 3, 3 }
    }
  elseif difficulty_index == 6 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 4, 4, 4 },
      tac_swat_shotgun_flank = { 2, 2, 2 },
      tac_swat_rifle = { 8, 8, 8 },
      tac_swat_rifle_flank = { 4, 4, 4 },
      tac_shield_wall_ranged = { 4, 4, 4 },
      tac_shield_wall_charge = { 4, 4, 4 },
      tac_shield_wall = { 4, 4, 4 },
      tac_tazer_flanking = { 4, 4, 4 },
      tac_tazer_charge = { 4, 4, 4 },
      FBI_spoocs = { 4, 4, 4 },
      tac_bull_rush = { 4, 4, 4 }
    }
  elseif difficulty_index == 7 then
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 4, 4, 4 },
      tac_swat_shotgun_flank = { 2, 2, 2 },
      tac_swat_rifle = { 6, 6, 6 },
      tac_swat_rifle_flank = { 3, 3, 3 },
      tac_shield_wall_ranged = { 4, 4, 4 },
      tac_shield_wall_charge = { 4, 4, 4 },
      tac_shield_wall = { 4, 4, 4 },
      tac_tazer_flanking = { 4, 4, 4 },
      tac_tazer_charge = { 4, 4, 4 },
      FBI_spoocs = { 4, 4, 4 },
      tac_bull_rush = { 4, 4, 4 }
    }
  else
    self.besiege.assault.groups = {
      tac_swat_shotgun_rush = { 4, 4, 4 },
      tac_swat_shotgun_flank = { 2, 2, 2 },
      tac_swat_rifle = { 4, 4, 4 },
      tac_swat_rifle_flank = { 2, 2, 2 },
      tac_shield_wall_ranged = { 4, 4, 4 },
      tac_shield_wall_charge = { 4, 4, 4 },
      tac_shield_wall = { 4, 4, 4 },
      tac_tazer_flanking = { 4, 4, 4 },
      tac_tazer_charge = { 4, 4, 4 },
      FBI_spoocs = { 4, 4, 4 },
      tac_bull_rush = { 4, 4, 4 }
    }
  end

  self.besiege.recon.groups = {
    hostage_rescue = { 10, 10, 10 },
    hostage_rescue_medic = { 1, 1, 1 },
    hostage_rescue_shield = { 1, 1, 1 }
  }

  self.street = deep_clone(self.besiege)
  self.safehouse = deep_clone(self.besiege)

end)