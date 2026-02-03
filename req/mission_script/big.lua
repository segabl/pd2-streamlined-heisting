local interval = {
	values = {
		interval = 20
	}
}
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
	[105434] = interval,
	[105450] = interval,
	[105500] = interval,
	-- Enable roof spawns
	[100006] = {
		values = {
			spawn_groups = { 100019, 100007, 100692 }
		}
	},
	-- Roof spawn intervals
	[100007] = interval,
	[100692] = interval,
	-- Make server hack a higher chance when solo
	[104494] = {
		pre_func = function(self)
			if table.size(managers.network:session():peers()) == 0 then
				self._chance = 90
			end
		end
	},
	[100017] = {
		-- Combine some navigation areas
		ai_area = {
			{ 25, 26, 119 },
			{ 27, 120, 121 },
			{ 28, 118 },
			{ 38, 133 },
			{ 41, 42, 50, 66 },
			{ 43, 44, 51 }
		},
		-- Additional flee points
		flee_point = {
			{ name = "right_side", position = Vector3(3500, 2500, -1200) },
			{ name = "left_side", position = Vector3(3800, -4450, -1050) }
		}
	}
}