local interval = {
	values = {
		interval = 30
	}
}
return {
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 44, 84, 85 },
			{ 103, 104, 105, 106 },
			{ 97, 99 },
			{ 52, 86 }
		}
	},
	-- Increase delay on side door spawns
	[103347] = interval,
	[103348] = interval
}