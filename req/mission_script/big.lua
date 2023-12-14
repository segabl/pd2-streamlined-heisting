return {
	[105844] = {
		reinforce = {
			{
				name = "meetingroom",
				force = 2,
				position = Vector3(-3400, 1000, -600)
			},
			{
				name = "outside_vault",
				force = 2,
				position = Vector3(-3000, 500, -1000)
			}
		}
	},
	-- Elevator intervals
	[105434] = {
		values = {
			interval = 20
		}
	},
	[105450] = {
		values = {
			interval = 20
		}
	},
	[105500] = {
		values = {
			interval = 20
		}
	},
	-- Enable roof spawns
	[100006] = {
		values = {
			spawn_groups = { 100019, 100007, 100692 }
		}
	},
	-- Roof spawn intervals
	[100007] = {
		values = {
			interval = 20
		}
	},
	[100692] = {
		values = {
			interval = 20
		}
	},
	-- Make server hack guranteed when solo
	[104494] = {
		pre_func = function (self)
			if table.size(managers.network:session():peers()) == 0 then
				self._chance = 100
			end
		end
	}
}