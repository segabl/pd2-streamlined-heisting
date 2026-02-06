return {
	-- Combine some navigation areas
	[100442] = {
		ai_area = {
			{ 13, 100 },
			{ 53, 56, 57, 58 }
		}
	},
	-- Disable Winters
	[104262] = {
		values = {
			enabled = false
		}
	},
	-- Set difficulty
	[100648] = {
		difficulty = 0.5
	},
	[101961] = {
		values = {
			difficulty = 0.5
		}
	},
	[100812] = {
		values = {
			difficulty = 0.5
		},
		on_executed = {
			{ id = 101495, delay = 0 }
		}
	}
}