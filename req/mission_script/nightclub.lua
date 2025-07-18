local interval = {
	values = {
		interval = 20
	}
}
return {
	-- Combine some navigation areas
	[100087] = {
		ai_area = {
			{ 6, 7 },
			{ 8, 10 },
			{ 15, 16 },
			{ 17, 18 },
			{ 19, 20 },
			{ 21, 22 },
			{ 23, 24 },
			{ 38, 39 },
			{ 54, 59 },
			{ 69, 70 },
			{ 13, 68 },
			{ 36, 95 },
			{ 91, 92 },
			{ 32, 33, 34 },
			{ 83, 85, 90 }
		}
	},
	-- Add intervals to rappel spawns
	[103174] = interval,
	[104731] = interval
}