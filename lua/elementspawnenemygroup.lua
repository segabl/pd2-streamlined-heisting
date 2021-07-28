-- Update preferred spawn groups to contain all available groups
local forbidden_groups = {
	single_spooc = true,
	Phalanx = true
}
local all_groups = {}
for name, _ in pairs(tweak_data.group_ai.enemy_spawn_groups) do
	if not forbidden_groups[name] then
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
