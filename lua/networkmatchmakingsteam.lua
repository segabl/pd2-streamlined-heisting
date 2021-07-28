-- Set matchmaking key by appending mod info (appending will keep vanilla versioning intact)
NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY = NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY .. "_sh_v" .. StreamHeist.mod_instance:GetVersion()
StreamHeist:log("Matchmaking key set to", NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY)
