# Map Design System

These are the visual rules every generated map follows. Treat this file as the source of truth when you design new themes, UI, or map previews.

## 1. Scale (studs)

| Thing | Size |
|---|---|
| Player height | ~5 studs |
| Terrain cell (grid unit) | 8 studs |
| Small map | 512 × 512 |
| Standard map | 1024 × 1024 |
| Large map | 2048 × 2048 |
| Tree | 14–28 tall |
| Rock | 4–14 wide |
| Edge buffer (no props) | 16 studs from map edge |

## 2. Height zones

Terrain height is normalised from 0 to 1. Each theme assigns a material to each zone:

| Zone | Range | Purpose |
|---|---|---|
| Low | below water level + 0.05 | Shorelines, beaches, lava edges |
| Mid | up to 0.60 | Main playable ground, where most props go |
| High | 0.60–0.80 | Hills and cliffs |
| Peak | above 0.80 | Landmarks and summits |

Props only spawn on slopes flatter than about 35° (surface normal Y > 0.8), and never on water.

## 3. Themes

| Theme | Mood | Low | Mid | High | Peak | Props |
|---|---|---|---|---|---|---|
| Forest | Calm, green | Sand | Grass | Rock | Snow | Trees 75%, rocks 25% |
| Desert | Hot, open | Sand | Sandstone | Rock | Limestone | Cacti 60%, rocks 40% |
| Tundra | Cold, quiet | Ice | Snow | Glacier | Snow | Pines 50%, rocks 50% |
| Volcanic | Dangerous | Cracked lava | Basalt | Slate | Basalt | Rocks 100% |

Exact colours are in `tokens.json`.

## 4. Lighting

| Theme | Clock time | Fog end | Feel |
|---|---|---|---|
| Forest | 14:00 | 1200 | Soft daylight |
| Desert | 12:30 | 1600 | Bright, bleached |
| Tundra | 9:30 | 700 | Pale, hazy |
| Volcanic | 19:00 | 600 | Dark red glow |

## 5. Rules

- Every map must have a reachable spawn on land.
- The same seed must produce the same map.
- Keep props simple (basic parts) so maps stay light on lower-end devices.
- Each new theme needs a Low, Mid, High, and Peak material, a prop mix, and a lighting preset.
