-- Unregister sentry guns to prevent enemies from getting stuck
Hooks:PostHook(SentryGunBase, "setup", "sh_setup", function (self)
	self:unregister()
end)
