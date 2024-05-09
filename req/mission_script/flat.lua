local disabled = {
	values = {
		enabled = false
	}
}
local enabled = {
	values = {
		enabled = true
	}
}
return {
	-- Disable roof/stairs reinforcement
	[102501] = disabled,
	[103181] = disabled,
	-- Disable scripted spawn spam
	[101745] = disabled,
	-- Enable alley C4
	[102261] = {
		pre_func = function (self)
			for _, v in pairs(self._original_on_executed) do
				if v.id == 100350 then
					return
				end
			end
			table.insert(self._original_on_executed, { id = 100350, delay = 0 })
		end
	},
	[100789] = {
		func = function ()
			managers.dialog:queue_dialog("Play_pln_flt_25", {
				delay = 3
			})
		end
	},
	-- Enable additional sniper spots
	[101599] = enabled,
	[101521] = enabled
}