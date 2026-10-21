--!strict
-- Tall icy mountains with frozen lakes between them.

return {
	Name = "FrozenPeaks",
	Theme = "Tundra",
	Seed = 9001,

	Size = 1024,
	BaseHeight = 0,
	MaxHeight = 220,
	WaterLevel = 0.22,

	Noise = {
		Scale = 200,
		Octaves = 5,
		Persistence = 0.55,
		Lacunarity = 2,
		Exponent = 1.8,
	},

	PropDensity = 0.003,
}
