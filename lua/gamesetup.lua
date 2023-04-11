-- Make Holdout maps load Zeal package and maps with zombie faction load zombie package
Hooks:PostHook(GameSetup, "load_packages", "sh_load_packages", function (self)
	local lvl_tweak_data = Global.level_data and Global.level_data.level_id and tweak_data.levels[Global.level_data.level_id]
	if lvl_tweak_data and lvl_tweak_data.group_ai_state == "skirmish" and not PackageManager:loaded("packages/sm_wish") then
		StreamHeist:log("Loading ZEAL package for Holdout...")
		table.insert(self._loaded_diff_packages, "packages/sm_wish")
		PackageManager:load("packages/sm_wish")
	end

	if tweak_data.levels:get_ai_group_type() == "zombie" and not PackageManager:loaded("packages/narr_hvh") then
		StreamHeist:log("Loading zombies package...")
		table.insert(self._loaded_event_packages, "packages/narr_hvh")
		PackageManager:load("packages/narr_hvh")
	end
end)
