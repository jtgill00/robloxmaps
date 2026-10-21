--!strict
-- Turns a heightmap into Roblox terrain, then floods low ground with water.

local Palette = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Palette"))

local TerrainBuilder = {}

local function materialFor(h: number, waterLevel: number, theme: Palette.Theme): Enum.Material
	local z = Palette.Zones
	if h < waterLevel + z.ShoreBand then
		return theme.Materials.Low
	elseif h < z.High then
		return theme.Materials.Mid
	elseif h < z.Peak then
		return theme.Materials.High
	end
	return theme.Materials.Peak
end

function TerrainBuilder.build(spec: any, theme: Palette.Theme, heights: any)
	local terrain = workspace.Terrain
	local grid = heights.Grid
	local half = spec.Size / 2
	local floor = spec.BaseHeight - 8

	-- Colour the terrain materials to match the theme.
	pcall(function()
		local c = theme.Colors
		if c.Grass then terrain:SetMaterialColor(Enum.Material.Grass, c.Grass) end
		if c.Sand then terrain:SetMaterialColor(Enum.Material.Sand, c.Sand) end
		if c.Snow then terrain:SetMaterialColor(Enum.Material.Snow, c.Snow) end
		if c.Basalt then terrain:SetMaterialColor(Enum.Material.Basalt, c.Basalt) end
		if c.Rock then terrain:SetMaterialColor(Enum.Material.Rock, c.Rock) end
		if c.Water then terrain.WaterColor = c.Water end
	end)

	-- Ground: one column per cell, from below the floor up to the surface.
	for x = 1, heights.Cells do
		for z = 1, heights.Cells do
			local h = heights.Values[x][z]
			local top = spec.BaseHeight + h * spec.MaxHeight
			local height = math.max(top - floor, 4)
			local cf = CFrame.new((x - 0.5) * grid - half, floor + height / 2, (z - 0.5) * grid - half)
			terrain:FillBlock(cf, Vector3.new(grid, height, grid), materialFor(h, spec.WaterLevel, theme))
		end
		if x % 16 == 0 then
			task.wait() -- keep Studio responsive on big maps
		end
	end

	-- Water: one slab up to the water line, only replacing air.
	local waterTop = spec.BaseHeight + spec.WaterLevel * spec.MaxHeight
	local waterHeight = waterTop - floor
	if waterHeight > 0 then
		local region = Region3.new(
			Vector3.new(-half, floor, -half),
			Vector3.new(half, waterTop, half)
		):ExpandToGrid(4)
		terrain:ReplaceMaterial(region, 4, Enum.Material.Air, Enum.Material.Water)
	end
end

return TerrainBuilder
