local disabled = {
	values = {
		enabled = false
	}
}
local interval = {
	values = {
		interval = 20
	}
}
return {
	-- Don't kill off enemies in courtyard/patio
	[102903] = disabled,
	[102904] = disabled,
	-- Increase window spawngroup intervals
	[100132] = interval,
	[100133] = interval,
	[103491] = interval,
	-- Combine some navigation areas
	[101230] = {
		ai_area = {
			{ 9, 208, 209 },
			{ 25, 26 },
			{ 28, 310 },
			{ 44, 311 },
			{ 53, 54, 55 },
			{ 72, 73 }
		}
	}
}