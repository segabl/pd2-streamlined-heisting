local no_spawn_instigator_ids = {
	values = {
		spawn_instigator_ids = false
	}
}
local interval = {
	values = {
		enabled = true,
		interval = 4
	}
}
return {
	-- Boss spawn
	[100154] = {
		difficulty = 0.1
	},
	-- Boss dead
	[100153] = {
		difficulty = 1
	},
	-- Fix nav links
	[101433] = no_spawn_instigator_ids,
	[101434] = no_spawn_instigator_ids,
	[101435] = no_spawn_instigator_ids,
	[101562] = no_spawn_instigator_ids,
	-- Reduce skylight navlink cooldowns and enable disabled ones
	[101055] = interval,
	[101086] = interval,
	[101087] = interval,
	[101089] = interval,
	[101090] = interval,
	[101091] = interval,
	[101092] = interval
}