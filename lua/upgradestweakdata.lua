Hooks:PostHook(UpgradesTweakData, "_init_pd2_values", "sh__init_pd2_values", function (self)

  -- Remove the hidden 0.45 damage reduction multiplier stacked on top of the skill bonuses
  -- of the partners in crime skill to balance out the increase in joker accuracy
  self.values.player.convert_enemies_health_multiplier = {
    1
  }

end)