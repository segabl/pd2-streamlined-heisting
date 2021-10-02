-- Update preferred spawn groups to contain all used groups and add intervals to groups with special spawn actions
local all_groups = {}
local group_ai_tweak = tweak_data.group_ai
for name, _ in pairs(group_ai_tweak.enemy_spawn_groups) do
	local entry = group_ai_tweak.besiege.assault.groups[name] or group_ai_tweak.besiege.recon.groups[name] or group_ai_tweak.besiege.reenforce.groups[name]
	if entry and table.count(entry, function (weight) return weight ~= 0 end) > 0 then
		table.insert(all_groups, name)
	end
end

Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "sh__finalize_values", function (self)
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
	if self._values.preferred_spawn_groups and #self._values.preferred_spawn_groups > 1 then
		StreamHeist:log(self:editor_name(), "preferred_spawn_groups", #self._values.preferred_spawn_groups, "->", #all_groups, "entries")
		self._values.preferred_spawn_groups = all_groups
	end
end)
