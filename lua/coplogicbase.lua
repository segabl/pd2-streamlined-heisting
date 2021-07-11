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
