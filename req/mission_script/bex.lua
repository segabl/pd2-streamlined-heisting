local disabled = {
	values = {
		enabled = false
	}
}
return {
	-- Disable server room reinforce
	[101835] = {
		values = {
			enabled = false
		}
	},
	-- Reinforce second floor above tellers
	[100027] = {
		reinforce = {
			{
				name = "teller_balcony1",
				force = 2,
				position = Vector3(1200, -2200, 400)
			},
			{
				name = "teller_balcony2",
				force = 2,
				position = Vector3(-1200, -2200, 400)
			}
		}
	},
	-- Reinforce drill parts car on first break
	[103346] = {
		reinforce = {
			{
				name = "parts_car",
				force = 2,
				position = Vector3(3100, -1400, 0)
			}
		}
	},
	[103347] = {
		reinforce = {
			{
				name = "parts_car",
				force = 2,
				position = Vector3(1600, 2100, 0)
			}
		}
	},
	[103352] = {
		reinforce = {
			{
				name = "parts_car",
				force = 2,
				position = Vector3(1800, -2000, 0)
			}
		}
	},
	[103354] = {
		reinforce = {
			{
				name = "parts_car",
				force = 2,
				position = Vector3(-1700, 3300, 0)
			}
		}
	},
	-- Disable parts reinforce when drill is done
	[101829] = {
		reinforce = {
			{
				name = "parts_car"
			}
		}
	},
	-- Disable broken navlinks
	[102541] = {
		on_executed = {
			{ id = 102544, remove = true }
		}
	},
	[104726] = {
		on_executed = {
			{ id = 101490, remove = true }
		}
	},
	-- Disable cheat spawns
	[100741] = disabled,
	[102369] = disabled,
	[102382] = disabled,
	[102781] = disabled,
	-- Combine some navigation areas
	[100017] = {
		ai_area = {
			{ 57, 59 },
			{ 68, 77 }
		}
	}
}