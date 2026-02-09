local interval = {
	values = {
		interval = 20
	}
}
return {
	-- Combine some navigation areas
	[101786] = {
		ai_area = {
			{ 125, 139, 140 },
			{ 75, 188, 199, 200, 213, 224 },
			{ 73, 74, 205 },
			{ 225, 226 },
			{ 178, 180 },
			{ 181, 219 },
			{ 76, 187, 227, 228, 230 },
			{ 78, 184 },
			{ 77, 185 },
			{ 79, 80, 183 },
			{ 186, 206 },
			{ 203, 211 },
			{ 190, 191, 192, 193, 194, 195, 196, 197, 214, 215, 216, 217, 218 },
			{ 120, 122 },
			{ 143, 144 },
			{ 145, 146 },
			{ 202, 223 }
		}
	},
	-- Slow down roof spawns
	[104110] = interval,
	[104111] = interval,
	[104321] = interval,
	[104324] = interval,
	[104330] = interval,
	[104410] = interval,
	-- Adjust difficulty scaling
	[100156] = {
		values = {
			difficulty = 0.5
		}
	},
	[104076] = {
		values = {
			difficulty = 0.75
		}
	}
}