local disabled = {
	values = {
		enabled = false
	}
}
return {
	[103469] = {
		flashlight = true
	},
	[103470] = {
		flashlight = false
	},
	-- Alert all civs on mask up and delay panic button SO
	[102518] = {
		on_executed = {
			{ id = 102540, delay = 10 }
		},
		func = function()
			for _, u_data in pairs(managers.enemy:all_civilians()) do
				u_data.unit:movement():set_cool(false)
			end
		end
	},
	-- Delay SWAT response
	[102675] = {
		on_executed = {
			{ id = 103225, delay = 20 }
		}
	},
	-- Disable most reinforce points
	[103706] = disabled,
	[103707] = disabled,
	[103847] = disabled,
	-- Let cloaker interrupt sniper SO
	[104306] = {
		values = {
			interruptible = true,
			interrupt_dmg = 0.1,
			interrupt_dis = 3
		}
	},
	-- Fix dozer/shield elevator ambush
	[104114] = {
		pre_func = function()
			local ai_graph = managers.mission:get_element_by_id(104126)
			local unit_sequence = managers.mission:get_element_by_id(102876)
			if ai_graph and unit_sequence and alive(unit_sequence._unit) then
				ai_graph:on_executed()
				unit_sequence._unit:damage():run_sequence_simple("run_sequence")
			end
		end
	},
	[104116] = {
		on_executed = {
			{ id = 104112, delay = 0 }
		}
	}
}