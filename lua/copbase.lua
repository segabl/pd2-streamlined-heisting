-- Set up material switching for zombie faction
local zombie_materials = tweak_data.levels:get_ai_group_type() == "zombie" and StreamHeist:require("zombie_materials")
local zombie_materials_applied = {}

function CopBase:_chk_apply_zombie_material(force)
	if not zombie_materials then
		return
	end

	local mat_config_key = self._unit:material_config():key()
	local materials = zombie_materials[mat_config_key] or force and zombie_materials_applied[mat_config_key]
	if not materials then
		return
	end

	for m_name, m_data in pairs(materials) do
		local material = self._unit:material(Idstring(m_name))
		if material then
			for texture_type, texture in pairs(m_data) do
				Application:set_material_texture(material, Idstring(texture_type), texture)
			end
		end
	end

	-- Base material only needs to be set once since it is shared
	zombie_materials[mat_config_key] = nil
	zombie_materials_applied[mat_config_key] = materials
end

Hooks:PostHook(CopBase, "on_material_applied", "sh_on_material_applied", function (self)
	self:_chk_apply_zombie_material(true)
end)


-- Check zombie material switch and dynamically load throwable if we have one
local unit_ids = Idstring("unit")
Hooks:PostHook(CopBase, "init", "sh_init", function (self)
	self:_chk_apply_zombie_material(false)

	local throwable = self._char_tweak.throwable
	if not throwable then
		return
	end

	local tweak_entry = tweak_data.blackmarket.projectiles[throwable]
	local unit_name = Idstring(not Network:is_server() and tweak_entry.local_unit or tweak_entry.unit)
	local sprint_unit_name = tweak_entry.sprint_unit and Idstring(tweak_entry.sprint_unit)

	if not PackageManager:has(unit_ids, unit_name) then
		StreamHeist:log("Loading projectile unit", throwable)
		managers.dyn_resource:load(unit_ids, unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end

	if sprint_unit_name and not PackageManager:has(unit_ids, sprint_unit_name) then
		StreamHeist:log("Loading projectile sprint unit", throwable)
		managers.dyn_resource:load(unit_ids, sprint_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE)
	end
end)


-- Check for weapon changes
if Network:is_client() then
	return
end

local weapon_mapping = StreamHeist:require("unit_weapons")
Hooks:PreHook(CopBase, "post_init", "sh_post_init", function (self)
	self._default_weapon_id = weapon_mapping[self._unit:name():key()] or self._default_weapon_id
	if type(self._default_weapon_id) == "table" then
		self._default_weapon_id = table.random(self._default_weapon_id)
	end
end)
