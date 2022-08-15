-- Make Holdout maps load Zeal package
Hooks:PostHook(GameSetup, "load_packages", "sh_load_packages", function (self)
	local lvl_tweak_data = Global.level_data and Global.level_data.level_id and tweak_data.levels[Global.level_data.level_id]
	if lvl_tweak_data and lvl_tweak_data.group_ai_state == "skirmish" and not PackageManager:loaded("packages/sm_wish") then
		StreamHeist:log("Loading ZEAL package for Holdout...")
		table.insert(self._loaded_diff_packages, "packages/sm_wish")
		PackageManager:load("packages/sm_wish")
	end
end)
