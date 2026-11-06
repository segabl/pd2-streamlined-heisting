return {
	-- Combine some navigation areas
	[101711] = {
		ai_area = {
			{ 109, 201 },
			{ 90, 200 }
		}
	},
	-- Disable turret
	[101035] = {
		values = {
			on_executed = {},
			unit_ids = {
				102775,
				102776
			}
		}
	},
	-- Re-enable door nav segs when they open again
	[100959] = {
		func = function()
			managers.navigation:perform_graph_operation(200, "allow_access")
		end
	},
	[100965] = {
		func = function()
			managers.navigation:perform_graph_operation(201, "allow_access")
		end
	}
}