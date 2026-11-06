local interval = {
		values = {
			interval = 30
		}
	}
return {
	-- Slow down pyro booth and skylight spawns
	[100805] = interval,
	[101555] = interval,
	[104406] = interval
}