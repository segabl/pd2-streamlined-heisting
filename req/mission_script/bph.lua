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
	}
}