-- Don't replace spawns in editor mode
if Global.editor_mode then
	StreamHeist:log("Editor mode is active, spawn group changes disabled")
	return
end

-- Update preferred spawn groups to contain new groups and add intervals to groups with special spawn actions
local group_mapping = {
	tac_swat_rifle = {
		"tac_swat_rifle",
		"tac_swat_rifle_no_medic",
		"tac_swat_rifle_flank",
		"tac_swat_rifle_flank_no_medic",
		"tac_swat_shotgun_rush",
		"tac_swat_shotgun_rush_no_medic",
		"tac_swat_shotgun_flank",
		"tac_swat_shotgun_flank_no_medic",
		"hostage_rescue"
	},
	tac_shield_wall = {
		"tac_shield_wall_ranged",
		"tac_shield_wall_charge"
	},
	tac_tazer_flanking = {
		"tac_tazer_flanking",
		"tac_tazer_charge"
	}
}
group_mapping.tac_swat_rifle_flank = group_mapping.tac_swat_rifle
group_mapping.tac_shield_wall_ranged = group_mapping.tac_shield_wall
group_mapping.tac_shield_wall_charge = group_mapping.tac_shield_wall
group_mapping.tac_tazer_charge = group_mapping.tac_tazer_flanking

Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "sh__finalize_values", function (self)
	if not self._values.preferred_spawn_groups then
		return
	end

	if self._values.interval == 0 then
		for _, id in pairs(self._values.elements) do
			local spawn_point = self:get_mission_element(id)
			if spawn_point and spawn_point._values.spawn_action then
				self._values.interval = 5
				StreamHeist:log(self:editor_name(), "0s -> 5s interval, spawn action", tostring(CopActionAct._act_redirects.enemy_spawn[spawn_point._values.spawn_action]))
				break
			end
		end
	end

	local new_groups = {}
	for _, initial_group in pairs(self._values.preferred_spawn_groups) do
		local mapping = group_mapping[initial_group]
		if mapping then
			for _, added_group in pairs(mapping) do
				new_groups[added_group] = true
			end
		else
			new_groups[initial_group] = true
		end
	end
	new_groups = table.map_keys(new_groups)

	if #self._values.preferred_spawn_groups ~= #new_groups then
		StreamHeist:log(self:editor_name(), "preferred_spawn_groups", #self._values.preferred_spawn_groups, "->", #new_groups, "entries")
		self._values.preferred_spawn_groups = new_groups
	end
end)
