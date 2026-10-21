--!strict
-- Scatters simple props (trees, pines, cacti, rocks) on flat, dry land.

local Heightmap = require(script.Parent:WaitForChild("Heightmap"))

local PropPlacer = {}

local EDGE_BUFFER = 16
local MIN_NORMAL_Y = 0.8 -- about 35 degrees

local function part(props: { [string]: any }, parent: Instance): Part
	local p = Instance.new("Part")
	p.Anchored = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	for k, v in props do
		(p :: any)[k] = v
	end
	p.Parent = parent
	return p
end

local builders: { [string]: (Vector3, Random, any, Instance) -> () } = {}

builders.Tree = function(pos, rng, colors, parent)
	local model = Instance.new("Model")
	model.Name = "Tree"
	local h = rng:NextNumber(14, 28)
	part({ Name = "Trunk", Size = Vector3.new(1.6, h * 0.5, 1.6), Position = pos + Vector3.new(0, h * 0.25, 0),
		Color = colors.Trunk, Material = Enum.Material.Wood, Shape = Enum.PartType.Cylinder,
		Orientation = Vector3.new(0, 0, 90) }, model)
	part({ Name = "Leaves", Size = Vector3.one * (h * 0.55), Position = pos + Vector3.new(0, h * 0.7, 0),
		Color = colors.Foliage, Material = Enum.Material.Grass, Shape = Enum.PartType.Ball }, model)
	model.Parent = parent
end

builders.Pine = function(pos, rng, colors, parent)
	local model = Instance.new("Model")
	model.Name = "Pine"
	local h = rng:NextNumber(16, 26)
	part({ Name = "Trunk", Size = Vector3.new(1.4, h * 0.4, 1.4), Position = pos + Vector3.new(0, h * 0.2, 0),
		Color = colors.Trunk, Material = Enum.Material.Wood }, model)
	for i = 0, 2 do
		local w = h * (0.45 - i * 0.12)
		part({ Name = "Tier" .. i, Size = Vector3.new(w, h * 0.22, w),
			Position = pos + Vector3.new(0, h * (0.45 + i * 0.18), 0),
			Color = colors.Pine, Material = Enum.Material.Grass }, model)
	end
	model.Parent = parent
end

builders.Cactus = function(pos, rng, colors, parent)
	local model = Instance.new("Model")
	model.Name = "Cactus"
	local h = rng:NextNumber(6, 12)
	part({ Name = "Body", Size = Vector3.new(1.8, h, 1.8), Position = pos + Vector3.new(0, h / 2, 0),
		Color = colors.Cactus, Material = Enum.Material.Grass }, model)
	if rng:NextNumber() > 0.4 then
		part({ Name = "Arm", Size = Vector3.new(1.2, h * 0.4, 1.2), Position = pos + Vector3.new(1.5, h * 0.6, 0),
			Color = colors.Cactus, Material = Enum.Material.Grass }, model)
	end
	model.Parent = parent
end

builders.Rock = function(pos, rng, colors, parent)
	local s = rng:NextNumber(4, 14)
	local rock = part({ Name = "Rock", Size = Vector3.new(s, s * rng:NextNumber(0.5, 0.9), s * rng:NextNumber(0.7, 1.2)),
		Color = colors.Rock, Material = Enum.Material.Slate }, parent)
	rock.CFrame = CFrame.new(pos + Vector3.new(0, rock.Size.Y * 0.3, 0))
		* CFrame.Angles(rng:NextNumber(-0.3, 0.3), rng:NextNumber(0, math.pi * 2), rng:NextNumber(-0.3, 0.3))
end

local function pickWeighted(weights: { [string]: number }, rng: Random): string
	-- Sort keys so the pick is deterministic for a given seed.
	local keys = {}
	for k in weights do table.insert(keys, k) end
	table.sort(keys)
	local roll, acc = rng:NextNumber(), 0
	for _, k in keys do
		acc += weights[k]
		if roll <= acc then return k end
	end
	return keys[#keys]
end

function PropPlacer.place(spec: any, theme: any, heights: any, seed: number, container: Instance)
	local folder = Instance.new("Folder")
	folder.Name = "Props"
	folder.Parent = container

	local rng = Random.new(seed + 1)
	local area = spec.Size * spec.Size
	local attempts = math.floor(area * spec.PropDensity)
	local half = spec.Size / 2
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { workspace.Terrain }

	local placed = 0
	for i = 1, attempts do
		local x = rng:NextNumber(-half + EDGE_BUFFER, half - EDGE_BUFFER)
		local z = rng:NextNumber(-half + EDGE_BUFFER, half - EDGE_BUFFER)
		local top = spec.BaseHeight + spec.MaxHeight + 50
		local hit = workspace:Raycast(Vector3.new(x, top, z), Vector3.new(0, -(spec.MaxHeight + 200), 0), params)

		if hit and hit.Material ~= Enum.Material.Water and hit.Normal.Y >= MIN_NORMAL_Y then
			local kind = pickWeighted(theme.Props, rng)
			local build = builders[kind]
			if build then
				build(hit.Position, rng, theme.Colors, folder)
				placed += 1
			end
		end

		if i % 200 == 0 then task.wait() end
	end

	print(`[MapSystem] Placed {placed} props`)
end

return PropPlacer
