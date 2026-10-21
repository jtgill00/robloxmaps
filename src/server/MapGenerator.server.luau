--!strict
-- Entry point. Reads MapConfig, loads the active map spec, and builds it.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local MapConfig = require(Shared:WaitForChild("MapConfig"))
local Palette = require(Shared:WaitForChild("Palette"))

local Modules = script.Parent:WaitForChild("Modules")
local Heightmap = require(Modules:WaitForChild("Heightmap"))
local TerrainBuilder = require(Modules:WaitForChild("TerrainBuilder"))
local PropPlacer = require(Modules:WaitForChild("PropPlacer"))
local SpawnPlacer = require(Modules:WaitForChild("SpawnPlacer"))
local LightingSetup = require(Modules:WaitForChild("LightingSetup"))

local function loadSpec(name: string)
	local module = Shared:WaitForChild("Maps"):FindFirstChild(name)
	assert(module and module:IsA("ModuleScript"), `No map called "{name}" in Shared/Maps`)
	return require(module) :: any
end

local function build()
	local spec = loadSpec(MapConfig.ActiveMap)
	local seed = MapConfig.SeedOverride or spec.Seed
	local theme = Palette.get(spec.Theme)

	print(`[MapSystem] Building "{spec.Name}" ({spec.Theme}) with seed {seed}`)
	local started = os.clock()

	if MapConfig.ClearExisting then
		workspace.Terrain:Clear()
		local old = workspace:FindFirstChild("GeneratedMap")
		if old then
			old:Destroy()
		end
	end

	local container = Instance.new("Folder")
	container.Name = "GeneratedMap"
	container.Parent = workspace

	local heights = Heightmap.generate(spec, seed)
	TerrainBuilder.build(spec, theme, heights)
	PropPlacer.place(spec, theme, heights, seed, container)
	SpawnPlacer.place(spec, heights, container)
	LightingSetup.apply(theme)

	print(`[MapSystem] Done in {string.format("%.2f", os.clock() - started)}s`)
end

build()
