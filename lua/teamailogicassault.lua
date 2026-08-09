-- Prevent changing back to hostile stance if bot entered with combat stance
local enter_original = TeamAILogicAssault.enter
function TeamAILogicAssault.enter(data, ...)
	local movement = data.unit:movement()
	local set_stance = rawget(movement, "set_stance")

	if movement:stance_code() ~= 1 then
		movement.set_stance = function() end
	end

	enter_original(data, ...)

	movement.set_stance = set_stance
end
