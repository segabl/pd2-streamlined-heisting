return {
	-- Scale PonR with difficulty
	[101161] = {
		values = {
			time_normal = 420,
			time_hard = 405,
			time_overkill = 390,
			time_overkill_145 = 375,
			time_easy_wish = 360,
			time_overkill_290 = 345,
			time_sm_wish = 330
		}
	},
	-- Allow bot navigation earlier
	[102736] = {
		on_executed = {
			{ id = 103049, delay = 1 }
		}
	},
	-- Combine some navigation areas
	[133004] = {
		ai_area = {
			{ 2, 72 },
			{ 4, 80 },
			{ 6, 81 },
			{ 32, 82, 83 },
			{ 52, 91 },
			{ 56, 97, 125 },
			{ 57, 99 },
			{ 73, 74 },
			{ 84, 85 },
			{ 89, 90 },
			{ 92, 124 },
			{ 93, 94 }
		}
	}
}