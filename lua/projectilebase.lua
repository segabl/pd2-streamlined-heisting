-- Load npc throwables dynamically
local unit_ids = Idstring("unit")
Hooks:PreHook(ProjectileBase, "throw_projectile_npc", "sh_throw_projectile_npc", function (projectile_type)
	local tweak_entry = tweak_data.blackmarket.projectiles[projectile_type]
	local unit_name = Idstring(not Network:is_server() and tweak_entry.local_unit or tweak_entry.unit)
	if not PackageManager:has(unit_ids, unit_name) then
		StreamHeist:log("Loading projectile unit", projectile_type)
		managers.dyn_resource:load(unit_ids, unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end
end)
