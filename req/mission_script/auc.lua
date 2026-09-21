return {
	-- Combine some navigation areas
	[101204] = {
		ai_area = {
			{ 94, 134, 135 },
			{ 97, 129, 130, 131, 132, 133 }
		}
	},
	-- Reinforce fountain
	[103141] = {
		reinforce = {
			{
				name = "fountain",
				force = 3,
				position = Vector3(2600, 2850, -80)
			}
		}
	},
	[103330] = {
		reinforce = {
			{
				name = "fountain"
			}
		}
	},
	-- Disable auctioneer sniper objective on damage
	[105761] = {
		values = {
			interruptible = true,
			interrupt_dmg = 0.1,
			interrupt_dis = 3
		}
	}
}
