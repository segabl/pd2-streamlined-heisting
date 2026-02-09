local short_interval = {
	values = {
		interval = 5
	}
}
local long_interval = {
	values = {
		interval = 15
	}
}
return {
	-- Combine some navigation areas
	[101157] = {
		ai_area = {
			{ 1, 2 },
			{ 18, 116 },
			{ 17, 25 },
			{ 19, 52 },
			{ 92, 97 },
			{ 9, 90 },
			{ 24, 91, 109 },
			{ 23, 27, 108 },
			{ 93, 106 },
			{ 21, 26, 75 },
			{ 56, 115 },
			{ 59, 107 },
			{ 83, 114 },
			{ 70, 71 },
			{ 81, 88 },
			{ 47, 50 },
			{ 48, 49, 68 },
			{ 36, 104 },
			{ 35, 103 },
			{ 34, 102 },
			{ 33, 101 }
		}
	},
	-- Fix harasser respawn delay
	[102807] = {
		on_executed = {
			{ id = 102804, delay = 30 }
		}
	},
	-- Rappel group delays
	[100024] = short_interval,
	[100131] = long_interval,
	[100132] = short_interval,
	[100145] = short_interval,
	[100146] = long_interval,
	[100147] = short_interval,
	[100148] = long_interval,
	[100149] = short_interval,
}