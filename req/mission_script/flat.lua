return {
	-- Disable roof/stairs reinforcement
	[102501] = {
		values = {
			enabled = false
		}
	},
	[103181] = {
		values = {
			enabled = false
		}
	},
	-- Disable scripted spawn spam
	[101745] = {
		values = {
			enabled = false
		}
	},
	-- Disable roof visblockers to slow down roof swarming
	[102263] = {
		func = function ()
			for _, id in pairs({ 100612, 100613, 100642, 100651, 100768, 100769, 100772 }) do
				local unit = managers.worlddefinition:get_unit(id)
				if alive(unit) then
					managers.game_play_central:mission_disable_unit(unit)
				end
			end
		end
	}
}