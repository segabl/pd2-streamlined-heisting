local no_chance_increase = {
	on_executed = {
		{ id = 102887, remove = true }
	}
}
local chance_increase = {
	on_executed = {
		{ id = 102887, delay = 0 }
	}
}
return {
	-- Combine some navigation areas
	[100053] = {
		ai_area = {
			{ 38, 39, 40 },
			{ 50, 51, 52 },
			{ 55, 78 },
			{ 61, 165 }
		}
	},
	-- Give saw to all players
	[101865] = {
		func = function(self)
			managers.network:session():send_to_peers_synched("give_equipment", self._values.equipment, self._values.amount)
		end
	},
	-- No code chance increase on fail or knockout
	[102865] = no_chance_increase,
	[102872] = no_chance_increase,
	-- Code chance increase each time taxman is hit
	[102006] = chance_increase,
	[102868] = chance_increase,
	-- Code chance increase amount
	[102887] = {
		values = {
			chance = 10
		}
	},
	-- Faint duration increase
	[102860] = {
		values = {
			action_duration_min = 60,
			action_duration_max = 90
		}
	}
}