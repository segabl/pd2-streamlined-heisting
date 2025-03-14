local interval = {
	values = {
		interval = 20
	}
}
return {
	-- Combine some navigation areas
	[100303] = {
		ai_area = {
			{ 13, 58, 105 },
			{ 36, 35, 103, 32, 108, 33, 34 },
			{ 49, 170 },
			{ 121, 165 },
			{ 167, 61, 166, 60 },
			{ 62, 169 },
			{ 59, 168 },
			{ 110, 64, 111 },
			{ 63, 162 }
		}
	},
	-- Slow down window spawns
	[100750] = interval,
	[101012] = interval,
	[102138] = interval,
	[104338] = interval
}