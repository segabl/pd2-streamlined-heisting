local interval_medium = {
	values = {
		interval = 30
	}
}
local interval_long = {
	values = {
		interval = 60
	}
}
return {
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 38, 39 },
			{ 52, 90 },
			{ 53, 54 },
			{ 60, 61 },
			{ 64, 65 },
			{ 120, 121 },
			{ 123, 124 },
			{ 125, 128, 138 },
			{ 126, 127, 137 },
			{ 129, 136 },
			{ 130, 135 },
			{ 131, 132 },
			{ 133, 134 },
			{ 139, 153 }
		}
	},
	-- Delay SWAT response
	[100116] = {
		on_executed = {
			{ id = 100122, delay = 60 }
		}
	},
	-- Slow down skylight spawns
	[100019] = interval_long,
	[100021] = interval_long,
	[100809] = interval_long,
	[100810] = interval_long,
	-- Shorten side window interval
	[102399] = interval_medium,
	[102400] = interval_medium
}