local elements = {
	des = {
		[100304] = {
			reinforce = {
				{ name = "main_hall", force = 9, position = Vector3(-120, -2400, 100) }
			}
		},
		[100286] = {
			reinforce = {
				{ name = "main_hall" }
			}
		}
	},
	sah = {
		[101400] = {
			reinforce = {
				{ name = "auction_room", force = 5, position = Vector3(0, 2000, -100) }
			}
		}
	},
	chas = {
		[101190] = {
			reinforce = {
				{ name = "store_front1", force = 3, position = Vector3(-2000, 300, -10) },
				{ name = "store_front2", force = 3, position = Vector3(-1000, 300, -10) }
			}
		},
		[101647] = {
			reinforce = {
				{ name = "store_front2" },
				{ name = "back_alley", force = 3, position = Vector3(-1400, 4900, 540) }
			}
		}
	},
	pent = {
		[103595] = {
			reinforce = {
				{ name = "main_room", force = 3, position = Vector3(300, -1600, 12100) }
			}
		},
		[103831] = {
			reinforce = {
				{ name = "main_room" },
				{ name = "helipad", force = 3, position = Vector3(1600, -1600, 13100) }
			}
		}
	},
	friend = {
		[101612] = {
			enabled = false -- Sosa retreat spot SO selection
		}
	},
	nmh = { -- Disable most reinforce points on No Mercy
		[103706] = {
			enabled = false
		},
		[103707] = {
			enabled = false
		},
		[103847] = {
			enabled = false
		}
	},
	chca = {
		[101469] = {
			groups = {
				tac_shield_wall = false,
				tac_shield_wall_ranged = false,
				tac_shield_wall_charge = false
			}
		},
		[101470] = {
			groups = {
				tac_shield_wall = false,
				tac_shield_wall_ranged = false,
				tac_shield_wall_charge = false
			}
		}
	},
	watchdogs_1 = {
		[101687] = {
			groups = {
				tac_bull_rush = false,
				tac_shield_wall = false,
				tac_shield_wall_ranged = false,
				tac_shield_wall_charge = false
			}
		},
		[102827] = {
			groups = {
				tac_bull_rush = false
			}
		}
	}
}
elements.watchdogs_1_night = elements.watchdogs_1

return elements