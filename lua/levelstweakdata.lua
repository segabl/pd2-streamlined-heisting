-- Enable flashlight state on some night time levels
Hooks:PostHook(LevelsTweakData, "init", "sh_init", function (self)
	self.arm_fac.flashlights_on = true
	self.arm_und.flashlights_on = true
	self.dah.flashlights_on = true
	self.election_day_2.flashlights_on = true
	self.escape_overpass_night.flashlights_on = true
	self.escape_park.flashlights_on = true
	self.firestarter_1.flashlights_on = true
	self.firestarter_2.flashlights_on = true
	self.nightclub.flashlights_on = true
	self.watchdogs_1_night.flashlights_on = true
	self.watchdogs_2.flashlights_on = true
	self.welcome_to_the_jungle_1_night.flashlights_on = true
end)
