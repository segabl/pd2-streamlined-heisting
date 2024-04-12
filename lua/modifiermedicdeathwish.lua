-- Fix Medic heal on death effect stacking with amount of players
if Network:is_client() then
	ModifierMedicDeathwish.OnEnemyDied = nil
end
