local interval_long = {
	values = {
		interval = 60
	}
}
local interval_medium = {
	values = {
		interval = 45
	}
}
local interval_short = {
	values = {
		interval = 30
	}
}
return {
	-- Make cloaker spawn participate to group AI
	[101320] = {
		values = {
			participate_to_group_ai = true
		}
	},
	-- Remove spawn groups closest to broken bridge part
	[101176] = {
		values = {
			spawn_groups = { 100867, 101153, 101157, 101154, 101160, 101156, 101159 }
		}
	},
	-- Increase spawn group intervals next to prison vans, closest to furthest
	[100867] = interval_long,
	[101153] = interval_long,
	[101157] = interval_long,
	[101154] = interval_medium,
	[101160] = interval_medium,
	[101156] = interval_short,
	[101159] = interval_short
}