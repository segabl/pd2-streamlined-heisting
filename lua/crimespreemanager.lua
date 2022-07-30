-- Reset secured bags on mission start (vanilla doesn't clear this so it displays wrong in the HUD)
Hooks:PreHook(CrimeSpreeManager, "on_mission_started", "sh_on_mission_started", function (self)
	if self:is_active() then
		managers.loot:reset()
	end
end)


-- Make secured bonus bags add crime spree levels
-- Unfortunately a function override is pretty much the only thing we can do here
Hooks:OverrideFunction(CrimeSpreeManager, "on_mission_completed", function (self, mission_id)
	if not self:is_active() then
		return
	end

	managers.mission:clear_job_values()

	if not self:has_failed() then
		local mission_data = self:get_mission(mission_id)
		local spree_add = mission_data.add
		self._mission_completion_gain = mission_data.add

		if not self:_is_host() and self._global.start_data and self._global.start_data.server_spree_level then
			local server_level = self._global.start_data and self._global.start_data.server_spree_level or -1
			if server_level < 0 then
				server_level = self:server_spree_level()
			end
			self:set_peer_spree_level(1, server_level + spree_add)
		end

		if not self:_is_host() and self:spree_level() < self:server_spree_level() and tweak_data.crime_spree.catchup_min_level <= managers.experience:current_level() then
			local diff = self:server_spree_level() - self:spree_level()
			self._catchup_bonus = math.min(tweak_data.crime_spree.catchup_limit, math.floor(diff * tweak_data.crime_spree.catchup_bonus))
			spree_add = spree_add + self._catchup_bonus
		end

		if not self:_is_host() and self:server_spree_level() < self:spree_level() then
			local diff = self:spree_level() - self:server_spree_level()
			spree_add = spree_add - diff
		end

		local bonus_bags = math.min(managers.loot:get_secured_bonus_bags_amount(), 10)
		if bonus_bags > 0 then
			spree_add = spree_add + bonus_bags
		end

		spree_add = math.max(math.floor(spree_add), 0)
		self._spree_add = spree_add
		local reward_add = spree_add

		if self:spree_level() <= self:server_spree_level() then
			self._global.winning_streak = (self._global.winning_streak or 1) + spree_add * tweak_data.crime_spree.winning_streak

			if self._global.winning_streak < 1 then
				self._global.winning_streak = self._global.winning_streak + 1
			end

			local pre_winning = reward_add
			reward_add = reward_add * self._global.winning_streak
			self._winning_streak = reward_add - pre_winning
		end

		reward_add = math.max(math.floor(reward_add), 0)

		if self:in_progress() then
			self._global.spree_level = self._global.spree_level + spree_add
			self:_check_highest_level(self._global.spree_level or 0)
		end

		self._global.reward_level = self._global.reward_level + reward_add
		self._global.unshown_rewards = self._global.unshown_rewards or {}

		for _, reward in ipairs(tweak_data.crime_spree.rewards) do
			self._global.unshown_rewards[reward.id] = (self._global.unshown_rewards[reward.id] or 0) + reward_add * reward.amount
		end
	end

	self._global.current_mission = nil
	self._global._start_data = self._global.start_data
	self._global.start_data = nil
	self._global.randomization_cost = false

	self:generate_new_mission_set()
	self:check_achievements()
	MenuCallbackHandler:save_progress()

	if Network:is_server() then
		MenuCallbackHandler:update_matchmake_attributes()
	end
end)
