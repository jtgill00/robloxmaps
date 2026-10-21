--!strict
-- Picks which map spec to build when the server starts.
-- Set ActiveMap to the name of any file in Shared/Maps.

local MapConfig = {
	ActiveMap = "ForestValley",

	-- Set to a number to override the map's own seed (handy for testing).
	-- Leave as nil to use the seed in the map file.
	SeedOverride = nil :: number?,

	-- Clears the previous generated map before building a new one.
	ClearExisting = true,
}

return MapConfig
