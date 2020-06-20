local forbidden_groups = {
  single_spooc = true,
  FBI_spooks = true,
  Phalanx = true
}
Hooks:PostHook(ElementSpawnEnemyGroup, "_finalize_values", "sh__finalize_values", function(self)
  if not self._group_data.spawn_type == "random" then
    return
  end
  local groups = {}
  for name, _ in pairs(tweak_data.group_ai.enemy_spawn_groups) do
    if not forbidden_groups[name] then
      table.insert(groups, name)
    end
  end
  self._values.preferred_spawn_groups = groups
end)
