-- Dynamically load throwable if we have one
local unit_ids = Idstring("unit")
Hooks:PostHook(CopBase, "init", "sh_init", function(self)
	local throwable = self._char_tweak.throwable
	if not throwable then
		return
	end

	local tweak_entry = tweak_data.blackmarket.projectiles[throwable]
	local unit_name = Idstring(Network:is_client() and tweak_entry.local_unit or tweak_entry.unit)
	local sprint_unit_name = tweak_entry.sprint_unit and Idstring(tweak_entry.sprint_unit)

	if not PackageManager:has(unit_ids, unit_name) then
		StreamHeist:log("Loading projectile unit %s", throwable)
		managers.dyn_resource:load(unit_ids, unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end

	if sprint_unit_name and not PackageManager:has(unit_ids, sprint_unit_name) then
		StreamHeist:log("Loading projectile sprint unit %s", throwable)
		managers.dyn_resource:load(unit_ids, sprint_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end
end)


-- Check for weapon changes
CopBase.unit_weapon_mapping = StreamHeist:require("unit_weapons")
if Network:is_client() then
	return
end

Hooks:PreHook(CopBase, "post_init", "sh_post_init", function(self)
	local mapping = self.unit_weapon_mapping[self._unit:name():key()]
	local mapping_type = type(mapping)
	if mapping_type == "table" then
		local selector = WeightedSelector:new()
		for k, v in pairs(mapping) do
			if type(k) == "number" then
				selector:add(v, 1)
			else
				selector:add(k, v)
			end
		end
		self._default_weapon_id = selector:select() or self._default_weapon_id
	elseif mapping_type == "string" then
		self._default_weapon_id = mapping
	end
end)
