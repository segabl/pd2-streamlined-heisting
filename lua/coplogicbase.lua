-- Improve reaction times of important/special enemies
local queue_task_original = CopLogicBase.queue_task
function CopLogicBase.queue_task(internal_data, id, func, data, exec_t, ...)
	if exec_t and func == data.logic.queued_update then
		exec_t = math.min(exec_t, data.t + (data.important and 0.2 or 1.5))
	end
	return queue_task_original(internal_data, id, func, data, exec_t, ...)
end
