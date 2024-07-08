local interval = {
	values = {
		interval = 45
	}
}
return {
	-- Slow down inside spawns
	[100247] = interval,
	[100067] = interval,
	[100068] = interval
}