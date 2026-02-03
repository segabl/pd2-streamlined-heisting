local player_1 = {
	values = {
		player_1 = true
	}
}
local reinforce = {
	on_executed = {
		{ id = 100364, delay = 0 }
	}
}
return {
	-- Special ambush chance increase
	[103072] = {
		values = {
			chance = 75
		}
	},
	[105563] = player_1,
	[105574] = player_1,
	-- Enable spawns sooner
	[103882] = {
		on_executed = {
			{ id = 100251, delay = 30 },
			{ id = 105774, delay = 20 }
		}
	},
	-- Enable max diff after 2 instead of 3 assault waves
	[101307] = {
		values = {
			amount = 2
		}
	},
	-- Enable all street reinforce spots when first responders arrive
	[104727] = reinforce,
	[104728] = reinforce,
	[104729] = reinforce,
	[104730] = reinforce,
	-- Additional flee points
	[105722] = {
		flee_point = {
			{ name = "back_spawns", position = Vector3(1950, 6350, 1) }
		}
	}
}