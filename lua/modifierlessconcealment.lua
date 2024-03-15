-- Fix crash when opening inventory in Crime Spree lobby
local modify_value_original = ModifierLessConcealment.modify_value
function ModifierLessConcealment:modify_value(id, value, ...)
	if managers.groupai then
		return modify_value_original(self, id, value, ...)
	end

	return value
end
