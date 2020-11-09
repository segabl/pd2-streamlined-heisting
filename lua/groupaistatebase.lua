-- Fix cloaker spawn noise for host
local _process_recurring_grp_SO_original = GroupAIStateBase._process_recurring_grp_SO
function GroupAIStateBase:_process_recurring_grp_SO(...)
  if _process_recurring_grp_SO_original(self, ...) then
    managers.hud:post_event("cloaker_spawn")
    return true
  end
end
