-- Instant detection outside of stealth
local _create_detected_attention_object_data_original = CopLogicBase._create_detected_attention_object_data
function CopLogicBase._create_detected_attention_object_data(...)
	local data = _create_detected_attention_object_data_original(...)
	if managers.groupai:state():enemy_weapons_hot() then
		data.notice_progress = 1
	end
	return data
end


-- Make important enemies more reactive
local queue_task_original = CopLogicBase.queue_task
function CopLogicBase.queue_task(internal_data, id, func, data, exec_t, asap, ...)
	if asap and exec_t then
		exec_t = math.min(exec_t, data.t + (data.important and 0.1 or 1))
	end
	return queue_task_original(internal_data, id, func, data, exec_t, asap, ...)
end


-- Make shield_cover tactics stick closer to their shield tactics providers
Hooks:PreHook(CopLogicBase, "on_new_objective", "sh_on_new_objective", function (data, old_objective)
	if not data.objective or data.objective.type ~= "defend_area" or not data.group or not data.tactics or not data.tactics.shield_cover then
		return
	end

	local logic_data
	local shielding_units = {}
	for _, u_data in pairs(data.group.units) do
		logic_data = u_data.unit:brain()._logic_data
		if logic_data and logic_data.tactics and logic_data.tactics.shield then
			table.insert(shielding_units, u_data.unit)
		end
	end
	if #shielding_units > 0 then
		data.objective.type = "follow"
		data.objective.follow_unit = table.random(shielding_units)
		data.objective.distance = 400
	end
end)
