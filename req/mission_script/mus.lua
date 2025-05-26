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
			{ 4, 52 },
			{ 136, 129 },
			{ 153, 139 },
			{ 140, 154 }
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