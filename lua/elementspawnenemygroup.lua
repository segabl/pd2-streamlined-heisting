-- Update preferred spawn groups to contain all used groups
local all_groups = {}
local group_ai_tweak = tweak_data.group_ai
for name, _ in pairs(group_ai_tweak.enemy_spawn_groups) do
	local entry = group_ai_tweak.besiege.assault.groups[name] or group_ai_tweak.besiege.recon.groups[name] or group_ai_tweak.besiege.reenforce.groups[name]
	if entry and table.count(entry, function (weight) return weight ~= 0 end) > 0 then
		table.insert(all_groups, name)
	end
end

Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "sh__finalize_values", function(self)
	if not self._values.preferred_spawn_groups or #self._values.preferred_spawn_groups <= 1 then
		return
	end
	StreamHeist:log(self:editor_name(), "preferred_spawn_groups", #self._values.preferred_spawn_groups, "->", #all_groups, "entries")
	self._values.preferred_spawn_groups = all_groups
end)
