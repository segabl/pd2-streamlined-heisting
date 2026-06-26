Hooks:PostHook(_G, "pd2_version", "sh_pd2_version", function()
	return Hooks:GetReturn() .. "_sh_v" .. StreamHeist.mod_instance:GetVersion()
end)
