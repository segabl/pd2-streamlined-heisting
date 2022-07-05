-- Make Holdout maps load Zeal package
Hooks:PostHook(LevelsTweakData, "init", "sh_init", function (self)
	for _, v in pairs(self) do
		if type(v) == "table" and v.group_ai_state == "skirmish" then
			if type(v.package) == "table" then
				table.insert(v.package, "packages/sm_wish")
			else
				v.package = {
					v.package,
					"packages/sm_wish"
				}
			end
		end
	end
end)
