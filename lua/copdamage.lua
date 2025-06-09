-- Health granularity prevents linear damage interpolation of AI against other AI from working
-- correctly and notably rounds up damage against enemies with a high HP pool even for player weapons.
-- Increasing the health granularity makes damage dealt more accurate to the actual weapon damage stats
CopDamage._HEALTH_GRANULARITY = 8192

function CopDamage:_send_melee_attack_result(attack_data, damage_percent, damage_effect_percent, hit_offset_height, variant, body_index)
	body_index = math.clamp(body_index, 0, 128)
	damage_percent = math.clamp(damage_percent, 0, self._HEALTH_GRANULARITY)
	damage_effect_percent = math.clamp(damage_effect_percent, 0, self._HEALTH_GRANULARITY)

	self._unit:network():send("damage_melee", attack_data.attacker_unit, damage_percent, damage_effect_percent, body_index, hit_offset_height, variant, self._dead and true or false)
end


-- Make head hitbox size consistent across enemies
Hooks:PostHook(CopDamage, "init", "sh_init", function (self)
	local head_body = self._unit:body(self._head_body_name or "head")
	if head_body then
		head_body:set_sphere_radius(18)
	end
end)


-- Make these functions check that the attacker unit is a player (to make sure NPC vs NPC melee doesn't crash)
local _dismember_condition_original = CopDamage._dismember_condition
function CopDamage:_dismember_condition(attack_data, ...)
	if alive(attack_data.attacker_unit) and attack_data.attacker_unit:base().is_local_player then
		return _dismember_condition_original(self, attack_data, ...)
	end
end

local _sync_dismember_original = CopDamage._sync_dismember
function CopDamage:_sync_dismember(attacker_unit, ...)
	if alive(attacker_unit) and attacker_unit:base().is_husk_player then
		return _sync_dismember_original(self, attacker_unit, ...)
	end
end


-- Additional suppression on hit
Hooks:PreHook(CopDamage, "_on_damage_received", "sh__on_damage_received", function (self, damage_info)
	self:build_suppression(4 * damage_info.damage / self._HEALTH_INIT, nil)
end)


-- Fixed critical hit multiplier
function CopDamage:roll_critical_hit(attack_data)
	if self:can_be_critical(attack_data) and math.random() < managers.player:critical_hit_chance() then
		return true, attack_data.damage * 3
	end

	return false, attack_data.damage
end


-- Make hurt type more dynamic by interpolating between hurt severity entries
Hooks:OverrideFunction(CopDamage, "get_damage_type", function (self, damage_percent, category)
	local hurt_table = self._char_tweak.damage.hurt_severity[category or "bullet"]
	local dmg = damage_percent / self._HEALTH_GRANULARITY

	if hurt_table.health_reference == "current" then
		dmg = math.min(1, self._HEALTH_INIT * dmg / self._health)
	elseif hurt_table.health_reference ~= "full" then
		dmg = math.min(1, self._HEALTH_INIT * dmg / hurt_table.health_reference)
	end

	local prev_zone, zone
	for i, test_zone in ipairs(hurt_table.zones) do
		if i == #hurt_table.zones or dmg < test_zone.health_limit then
			zone = test_zone
			break
		end
		prev_zone = test_zone
	end

	local rand = math.random()
	local total_chance = 0
	local t = prev_zone and math.map_range_clamped(dmg, prev_zone.health_limit or 0, zone.health_limit or 1, 0, 1)
	for sev_name, hurt_type in pairs(self._hurt_severities) do
		local chance = prev_zone and math.lerp(prev_zone[sev_name] or 0, zone[sev_name] or 0, t) or zone[sev_name] or 0
		total_chance = total_chance + chance
		if rand < total_chance then
			return hurt_type or "dmg_rcv"
		end
	end

	return "dmg_rcv"
end)


-- Disable impact sounds and blood effects for stuns
local damage_explosion = CopDamage.damage_explosion
function CopDamage:damage_explosion(attack_data, ...)
	local no_blood = self._no_blood
	self._no_blood = attack_data.variant == "stun"

	local result = damage_explosion(self, attack_data, ...)

	self._no_blood = no_blood

	return result
end

local sync_damage_explosion = CopDamage.sync_damage_explosion
function CopDamage:sync_damage_explosion(attacker_unit, damage_percent, i_attack_variant, ...)
	local no_blood = self._no_blood
	self._no_blood = CopDamage._ATTACK_VARIANTS[i_attack_variant] == "stun"

	local result = sync_damage_explosion(self, attacker_unit, damage_percent, i_attack_variant, ...)

	self._no_blood = no_blood

	return result
end


-- Fix synced melee damage ignoring medic heal
local sync_damage_melee_original = CopDamage.sync_damage_melee
function CopDamage:sync_damage_melee(attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, variant, death, ...)
	if death or variant ~= 7 then
		return sync_damage_melee_original(self, attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, variant, death, ...)
	end

	local attack_data = {
		variant = "healed",
		attacker_unit = attacker_unit,
		damage = damage_percent * self._HEALTH_INIT_PRECENT,
		is_synced = true,
		pos = self._unit:position(),
		result = {
			variant = "melee",
			type = "healed"
		}
	}

	self:do_medic_heal()

	if attacker_unit then
		attack_data.attack_dir = self._unit:position() - attacker_unit:position()
		mvector3.normalize(attack_data.attack_dir)
		attack_data.name_id = attacker_unit:inventory() and attacker_unit:inventory():get_melee_weapon_id()
	else
		attack_data.attack_dir = -self._unit:rotation():y()
	end

	mvector3.set_z(attack_data.pos, attack_data.pos.z + math.random() * 180)

	if not self._no_blood then
		local from = Vector3(0, 0, hit_offset_height)
		mvector3.add(from, self._unit:movement():m_pos())
		managers.game_play_central:sync_play_impact_flesh(from, attack_data.attack_dir)
	end

	self:_send_sync_melee_attack_result(attack_data, hit_offset_height)
	self:_on_damage_received(attack_data)
end


-- Revert headshot multipliers for fire damage
local damage_fire_original = CopDamage.damage_fire
function CopDamage:damage_fire(attack_data, ...)
	local head_body_name = self._head_body_name
	self._head_body_name = nil
	local result = damage_fire_original(self, attack_data, ...)
	self._head_body_name = head_body_name
	return result
end
