--!strict
-- Finds the flattest dry spot near the map centre and puts a SpawnLocation there.

local Heightmap = require(script.Parent:WaitForChild("Heightmap"))

local SpawnPlacer = {}

function SpawnPlacer.place(spec: any, heights: any, container: Instance)
	local cells = heights.Cells
	local v = heights.Values
	local mid = math.floor(cells / 2)
	local best, bestScore = nil :: Vector3?, math.huge

	-- Search outward from the centre, preferring flat ground above water.
	for x = 2, cells - 1 do
		for z = 2, cells - 1 do
			local h = v[x][z]
			if h > spec.WaterLevel + 0.03 and h < 0.6 then
				local slope = math.abs(v[x + 1][z] - v[x - 1][z]) + math.abs(v[x][z + 1] - v[x][z - 1])
				local dist = ((x - mid) ^ 2 + (z - mid) ^ 2) ^ 0.5 / cells
				local score = slope * 10 + dist
				if score < bestScore then
					bestScore = score
					best = Heightmap.toWorld(spec, heights, x, z)
				end
			end
		end
	end

	-- Fallback: hover above the centre if the map is mostly water.
	local position = best or Vector3.new(0, spec.BaseHeight + spec.MaxHeight + 10, 0)

	for _, s in workspace:GetDescendants() do
		if s:IsA("SpawnLocation") and not s:IsDescendantOf(container) then
			s.Enabled = false
		end
	end

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "MapSpawn"
	spawn.Anchored = true
	spawn.Size = Vector3.new(12, 1, 12)
	spawn.Position = position + Vector3.new(0, 1, 0)
	spawn.Transparency = 0.6
	spawn.CanCollide = true
	spawn.Duration = 0
	spawn.Parent = container
end

return SpawnPlacer
