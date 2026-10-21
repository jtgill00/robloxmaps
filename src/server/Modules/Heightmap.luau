--!strict
-- Builds a 2D grid of heights (0..1) from layered Perlin noise.
-- Same spec + same seed = same grid, every time.

local GRID = 8 -- studs per cell (matches design/tokens.json scale.gridUnit)

export type Heights = {
	Cells: number,             -- cells along one side
	Grid: number,              -- studs per cell
	Values: { { number } },    -- Values[x][z] in 0..1
}

local Heightmap = {}
Heightmap.GRID = GRID

function Heightmap.generate(spec: any, seed: number): Heights
	local n = spec.Noise
	local cells = math.floor(spec.Size / GRID)

	-- Offset the noise field by the seed so different seeds give different maps.
	local rng = Random.new(seed)
	local ox, oz = rng:NextNumber(-10000, 10000), rng:NextNumber(-10000, 10000)

	local values: { { number } } = table.create(cells)
	local minV, maxV = math.huge, -math.huge

	for x = 1, cells do
		local column = table.create(cells)
		for z = 1, cells do
			local amp, freq, total, norm = 1, 1, 0, 0
			for _ = 1, n.Octaves do
				local sx = (x * GRID / n.Scale) * freq + ox
				local sz = (z * GRID / n.Scale) * freq + oz
				total += math.noise(sx, sz, seed % 1000 + 0.5) * amp
				norm += amp
				amp *= n.Persistence
				freq *= n.Lacunarity
			end
			local v = total / norm
			column[z] = v
			minV = math.min(minV, v)
			maxV = math.max(maxV, v)
		end
		values[x] = column
	end

	-- Normalise to 0..1, then shape with the exponent.
	local range = math.max(maxV - minV, 1e-6)
	for x = 1, cells do
		local column = values[x]
		for z = 1, cells do
			column[z] = ((column[z] - minV) / range) ^ n.Exponent
		end
	end

	return { Cells = cells, Grid = GRID, Values = values }
end

-- World position of a cell centre, with the map centred on the origin.
function Heightmap.toWorld(spec: any, heights: Heights, x: number, z: number): Vector3
	local half = spec.Size / 2
	local y = spec.BaseHeight + heights.Values[x][z] * spec.MaxHeight
	return Vector3.new((x - 0.5) * heights.Grid - half, y, (z - 0.5) * heights.Grid - half)
end

return Heightmap
