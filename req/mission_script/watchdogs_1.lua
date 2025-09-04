local shield_so = {
	pre_func = function(element)
		if Network:is_client() then
			return
		end
		element:add_event_callback("spawn", function(unit)
			local pos = unit:movement():m_pos()
			unit:brain():set_objective({
				type = "sniper",
				pos = pos,
				nav_seg = managers.navigation:get_nav_seg_from_pos(pos),
				no_retreat = true
			})
		end)
	end
}
return {
	-- Combine some navigation areas
	[100125] = {
		ai_area = {
			{ 42, 75 },
			{ 51, 76 },
			{ 52, 134 },
			{ 81, 166, 167 },
			{ 127, 129 }
		}
	},
	-- Fix group spawns
	[101687] = {
		groups = {
			tac_bull_rush = false,
			tac_shield_wall = false,
			tac_shield_wall_ranged = false,
			tac_shield_wall_charge = false
		}
	},
	[102827] = {
		groups = {
			tac_bull_rush = false
		}
	},
	-- Delay SWAT response
	[100327] = {
		on_executed = {
			{ id = 100768, delay = 30 }
		}
	},
	-- Set shields to stay in place
	[102848] = shield_so,
	[102849] = shield_so,
	[102850] = shield_so,
	[102851] = shield_so
}