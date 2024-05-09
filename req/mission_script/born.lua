local interval = {
	values = {
		interval = 15
	}
}
return {
	-- Slow down roof and garage spawns
	[100007] = interval,
	[100128] = interval
}