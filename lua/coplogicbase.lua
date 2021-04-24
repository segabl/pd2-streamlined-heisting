-- Improve reaction times of important/special enemies
local queue_task_original = CopLogicBase.queue_task
function CopLogicBase.queue_task(internal_data, id, func, data, exec_t, ...)
	if exec_t and func == data.logic.queued_update then
		exec_t = math.min(exec_t, data.t + (data.important and 0.2 or 1.5))
	end
	return queue_task_original(internal_data, id, func, data, exec_t, ...)
end


-- Instant detection outside of stealth
local _create_detected_attention_object_data_original = CopLogicBase._create_detected_attention_object_data
function CopLogicBase._create_detected_attention_object_data(...)
	local data = _create_detected_attention_object_data_original(...)
	if managers.groupai:state():enemy_weapons_hot() then
		data.notice_progress = 1
	end
	return data
end
