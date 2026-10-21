# Roblox Map System

A seed-driven system for generating Roblox maps (terrain, water, props, spawn points, lighting) from simple map spec files. Each map is a small Luau table. Change the spec, press Play, and get a new map.

## How it works

```
Map spec (src/shared/Maps/*.luau)
        │
        ▼
MapGenerator.server.luau ──► TerrainBuilder  (heightmap terrain + water)
                         ──► PropPlacer      (trees, rocks, cacti)
                         ──► SpawnPlacer     (safe spawn on land)
                         ──► LightingSetup   (time of day, fog, atmosphere)
        ▲
Theme palette (src/shared/Palette.luau)
```

- **Map specs** set the size, seed, height and noise settings, and prop density.
- **Themes** (Forest, Desert, Tundra, Volcanic) set the materials, colours, props, and lighting.
- **The same seed always produces the same map**, so a map you like can be recreated exactly.

## Folder structure

```
roblox-map-system/
├── default.project.json      Rojo project (maps folders into Roblox services)
├── rokit.toml                Toolchain (Rojo version)
├── design/
│   ├── DESIGN_SYSTEM.md      Visual rules: palettes, scale, zones, lighting
│   └── tokens.json           Machine-readable colours and materials
└── src/
    ├── shared/               → ReplicatedStorage.Shared
    │   ├── MapConfig.luau    Picks which map to build
    │   ├── Palette.luau      Theme definitions
    │   └── Maps/             One file per map
    └── server/               → ServerScriptService.MapSystem
        ├── MapGenerator.server.luau
        └── Modules/
```

## Getting started

1. Install [Rokit](https://github.com/rojo-rbx/rokit), then run `rokit install` in this folder.
2. Install the Rojo plugin in Roblox Studio.
3. Run `rojo serve`, then click **Connect** in the Studio Rojo plugin.
4. Press **Play**. The active map in `src/shared/MapConfig.luau` generates.

## Making a new map

1. Copy `src/shared/Maps/ForestValley.luau` and rename it (for example `CanyonRun.luau`).
2. Change `Name`, `Theme`, `Seed`, and any size or noise values.
3. Set `ActiveMap = "CanyonRun"` in `MapConfig.luau`.
4. Press Play.

## Adding a theme

Add an entry to `Palette.Themes` in `src/shared/Palette.luau` and to `design/tokens.json`, then follow the rules in `design/DESIGN_SYSTEM.md`.
