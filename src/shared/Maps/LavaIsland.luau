--!strict
-- A dark volcanic island. The low ground is cracked lava.

return {
	Name = "LavaIsland",
	Theme = "Volcanic",
	Seed = 666,

	Size = 512,
	BaseHeight = 0,
	MaxHeight = 160,
	WaterLevel = 0.18,

	Noise = {
		Scale = 160,
		Octaves = 4,
		Persistence = 0.5,
		Lacunarity = 2.1,
		Exponent = 2.0,
	},

	PropDensity = 0.002,
}
