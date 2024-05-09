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