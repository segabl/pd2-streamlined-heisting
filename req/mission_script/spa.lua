local interval = {
	values = {
		interval = 20
	}
}
return {
	-- Slow down window spawns
	[100750] = interval,
	[101012] = interval,
	[102138] = interval,
	[104338] = interval
}