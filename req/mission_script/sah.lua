local disabled = {
	values = {
		enabled = false
	}
}
local interval_short = {
	values = {
		interval = 20
	}
}
local interval_medium = {
	values = {
		interval = 30
	}
}
local interval_long = {
	values = {
		interval = 40
	}
}
return {
	-- Disable instant difficulty increase
	[100122] = disabled,
	-- Loud, slightly delay police response
	[100109] = {
		values = {
			base_delay = 30
		}
	},
	[100129] = {
		difficulty = 0.4,
		reinforce = {
			{
				name = "auction_room",
				force = 2,
				position = Vector3(0, 2000, -100)
			},
			{
				name = "outside",
				force = 2,
				position = Vector3(0, -3300, -50)
			}
		},
		on_executed = {
			{ id = 100127, delay = 0 },
			{ id = 103905, delay = 0 },
			{ id = 103910, delay = 0 },
			{ id = 103912, delay = 0 },
			{ id = 103913, delay = 0 }
		}
	},
	-- Disable area report triggers
	[100140] = disabled,
	[106783] = disabled,
	[103926] = disabled,
	[106784] = disabled,
	-- Slow down roof spawns
	[102667] = interval_short,
	[106776] = interval_short,
	[106767] = interval_short,
	[106764] = interval_short,
	[100694] = interval_medium,
	[100154] = interval_medium,
	-- Slow down storage spawns
	[102303] = interval_long,
	[103662] = interval_short,
	[104089] = interval_long,
	-- Slow down and adjust storage window spawns
	[103522] = {
		values = {
			interval = 60
		},
		groups = {
			tac_bull_rush = false,
			tac_shield_wall = false,
			tac_shield_wall_ranged = false,
			tac_shield_wall_charge = false
		}
	}
}