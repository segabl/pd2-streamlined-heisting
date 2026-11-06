return {
	-- Combine some navigation areas
	[100667] = {
		ai_area = {
			{ 2, 3 },
			{ 11, 24, 25 },
			{ 15, 22, 49 },
			{ 18, 19 },
			{ 26, 27 }
		}
	},
	-- Randomize planks amount
	[100822] = {
		values = {
			amount = 2,
			amount_random = 2
		}
	},
	-- Cook chance evaluation and increment
	[100724] = {
		on_executed = {
			{ id = 100494, delay = 15, delay_rand = 10 }
		}
	},
	[100723] = {
		values = {
			chance = 15
		}
	},
	-- Reinforce next to cars
	[100941] = {
		reinforce = {
			{
				name = "such_a_nice_car",
				force = 2,
				position = Vector3(675, -1200, 875)
			}
		}
	},
	-- Disable visible flee point
	[100458] = {
		values = {
			enabled = false
		}
	}
}
