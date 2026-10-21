--!strict
-- Theme definitions. Mirrors design/tokens.json — keep both in sync.

export type Theme = {
	Materials: { Low: Enum.Material, Mid: Enum.Material, High: Enum.Material, Peak: Enum.Material },
	Colors: { [string]: Color3 },
	Props: { [string]: number }, -- prop name -> weight (should add up to 1)
	Lighting: { ClockTime: number, FogEnd: number, Brightness: number },
}

local hex = Color3.fromHex

local Palette = {}

Palette.Themes = {
	Forest = {
		Materials = { Low = Enum.Material.Sand, Mid = Enum.Material.Grass, High = Enum.Material.Rock, Peak = Enum.Material.Snow },
		Colors = {
			Grass = hex("#4F7F3A"), Foliage = hex("#3E6B2F"), Trunk = hex("#6B4A2E"),
			Rock = hex("#7A7A72"), Water = hex("#3C7FA6"), Fog = hex("#C9D8D2"),
		},
		Props = { Tree = 0.75, Rock = 0.25 },
		Lighting = { ClockTime = 14, FogEnd = 1200, Brightness = 2 },
	},
	Desert = {
		Materials = { Low = Enum.Material.Sand, Mid = Enum.Material.Sandstone, High = Enum.Material.Rock, Peak = Enum.Material.Limestone },
		Colors = {
			Sand = hex("#D9B77E"), Cactus = hex("#5E8C4A"), Rock = hex("#A0826D"),
			Water = hex("#4A9BB5"), Fog = hex("#EAD9B8"),
		},
		Props = { Cactus = 0.6, Rock = 0.4 },
		Lighting = { ClockTime = 12.5, FogEnd = 1600, Brightness = 3 },
	},
	Tundra = {
		Materials = { Low = Enum.Material.Ice, Mid = Enum.Material.Snow, High = Enum.Material.Glacier, Peak = Enum.Material.Snow },
		Colors = {
			Snow = hex("#EEF3F6"), Pine = hex("#2F4F3E"), Trunk = hex("#4E3B2A"),
			Rock = hex("#8A9299"), Water = hex("#5D8FA8"), Fog = hex("#DCE6EC"),
		},
		Props = { Pine = 0.5, Rock = 0.5 },
		Lighting = { ClockTime = 9.5, FogEnd = 700, Brightness = 1.5 },
	},
	Volcanic = {
		Materials = { Low = Enum.Material.CrackedLava, Mid = Enum.Material.Basalt, High = Enum.Material.Slate, Peak = Enum.Material.Basalt },
		Colors = {
			Basalt = hex("#2B2B2E"), Lava = hex("#E2541F"), Rock = hex("#3D3A3A"),
			Water = hex("#5A2A1E"), Fog = hex("#4A2A22"),
		},
		Props = { Rock = 1.0 },
		Lighting = { ClockTime = 19, FogEnd = 600, Brightness = 1 },
	},
} :: { [string]: Theme }

Palette.Zones = { High = 0.6, Peak = 0.8, ShoreBand = 0.05 }

function Palette.get(name: string): Theme
	local theme = Palette.Themes[name]
	assert(theme, `Unknown theme "{name}". Add it to Palette.Themes.`)
	return theme
end

return Palette
