local interval = {
	values = {
		interval = 20
	}
}
return {
	-- Combine some navigation areas
	[300000] = {
		ai_area = {
			{ 1, 2, 5 },
			{ 47, 54, 67, 68, 70, 112 },
			{ 49, 61, 73 },
			{ 41, 52 },
			{ 29, 33, 42, 44 },
			{ 3, 4 },
			{ 45, 57, 60, 69 },
			{ 58, 65 },
			{ 76, 84 },
			{ 81, 72, 62 },
			{ 55, 111 },
			{ 86, 101, 104, 106, 108, 109 },
			{ 24, 39 },
			{ 90, 93, 94, 96 }
		}
	},
	-- Delay SWAT response
	[300203] = {
		on_executed = {
			{ id = 300164, delay = 45 }
		}
	},
	-- Enable unused spawngroup
	[300164] = {
		values = {
			spawn_groups = { 300313, 300314, 300281 }
		}
	},
	-- Add intervals to rappel spawns
	[301847] = interval,
	[301852] = interval,
	[302083] = interval,
	[302084] = interval
}