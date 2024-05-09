local no_spawn_instigator_ids = {
	values = {
		spawn_instigator_ids = false
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
	[101562] = no_spawn_instigator_ids
}