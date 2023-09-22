return {
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
	}
}
