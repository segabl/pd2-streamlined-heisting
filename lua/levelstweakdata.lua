-- Enable flashlight state on some night time levels
-- Add level specific unit overrides
Hooks:PostHook(LevelsTweakData, "init", "sh_init", function(self)
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

	self.chas.ai_unit_group_overrides = {
		CS_cop_C45_R870 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_02/ene_male_chas_police_02")
			}
		},
		CS_cop_stealth_MP5 = {
			america = {
				Idstring("units/pd2_dlc_chas/characters/ene_male_chas_police_01/ene_male_chas_police_01")
			}
		}
	}
	self.sand.ai_unit_group_overrides = self.chas.ai_unit_group_overrides

	self.rvd1.ai_unit_group_overrides = {
		CS_cop_C45_R870 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"),
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4")
			}
		},
		CS_cop_stealth_MP5 = {
			america = {
				Idstring("units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2")
			}
		}
	}
	self.rvd2.ai_unit_group_overrides = self.rvd1.ai_unit_group_overrides
end)
