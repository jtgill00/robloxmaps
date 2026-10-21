--!strict
-- A rolling green valley with a lake. Copy this file to make a new map.

return {
	Name = "ForestValley",
	Theme = "Forest",
	Seed = 1337,

	Size = 1024,        -- width and depth in studs (512, 1024 or 2048)
	BaseHeight = 0,     -- lowest point of the terrain (Y)
	MaxHeight = 120,    -- tallest possible point above BaseHeight
	WaterLevel = 0.28,  -- 0..1, anything below this fills with water

	Noise = {
		Scale = 260,      -- bigger = wider, gentler hills
		Octaves = 4,      -- more = more detail
		Persistence = 0.5,
		Lacunarity = 2,
		Exponent = 1.4,   -- above 1 flattens valleys and sharpens peaks
	},

	PropDensity = 0.004, -- props per square stud of usable land
}
