return {
	-- Enter main hall
	[103594] = {
		difficulty = 0.1
	},
	-- Boss dead, safe objective
	[101169] = {
		difficulty = 1
	},
	-- Disable Sosa retreat on low health during boss fight
	[101596] = {
		values = {
			enabled = false
		}
	},
	-- Fallback to make Sosa retreat when house is accessible
	[102653] = {
		on_executed = {
			{ id = 102692, delay = 0 }
		}
	},
	-- Disable bad navlink
	[101057] = {
		values = {
			enabled = false
		}
	},
	-- Combine some navigation areas
	[141003] = {
		ai_area = {
			{ 2, 66 },
			{ 16, 72 },
			{ 29, 88 },
			{ 31, 95, 96 },
			{ 34, 81 },
			{ 36, 47, 179 },
			{ 38, 89 },
			{ 39, 86 },
			{ 53, 80 },
			{ 55, 105 },
			{ 71, 78 },
			{ 79, 82 },
			{ 87, 90, 91, 92, 93, 94 }
		}
	}
}