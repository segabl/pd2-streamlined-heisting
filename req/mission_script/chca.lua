local los_blockers = {}
local los_blocker_ids = Idstring("units/payday2/architecture/mkp/mkp_int_floor_4x4m_a")
local los_blocker_rot = Rotation(0, -90, 0)
for i = 0, 3 do
	table.insert(los_blockers, {
		name = los_blocker_ids,
		pos = Vector3(-10100 + (i * 400), 4300, 1250),
		rot = los_blocker_rot
	})
end
return {
	[101469] = {
		groups = {
			tac_shield_wall = false,
			tac_shield_wall_ranged = false,
			tac_shield_wall_charge = false
		}
	},
	[101470] = {
		groups = {
			tac_shield_wall = false,
			tac_shield_wall_ranged = false,
			tac_shield_wall_charge = false
		}
	},
	-- Add LoS blockers
	[143003] = {
		spawn = los_blockers
	}
}