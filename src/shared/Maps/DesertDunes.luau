--!strict
-- Wide, low dunes with a small oasis.

return {
	Name = "DesertDunes",
	Theme = "Desert",
	Seed = 4242,

	Size = 1024,
	BaseHeight = 0,
	MaxHeight = 70,
	WaterLevel = 0.12,

	Noise = {
		Scale = 340,
		Octaves = 3,
		Persistence = 0.45,
		Lacunarity = 2,
		Exponent = 1.1,
	},

	PropDensity = 0.0015,
}
