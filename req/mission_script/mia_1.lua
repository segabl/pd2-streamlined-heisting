local disabled = {
	values = {
		enabled = false
	}
}
return {
	-- Improve reinforce spots
	[100022] = {
		reinforce = {
			{
				name = "touch_grass",
				force = 3,
				position = Vector3(2000, -900, 30)
			}
		}
	},
	[100589] = disabled,
	[100590] = disabled
}