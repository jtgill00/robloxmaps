--!strict
-- Applies the theme's time of day, fog, and atmosphere.

local Lighting = game:GetService("Lighting")

local LightingSetup = {}

function LightingSetup.apply(theme: any)
	local l = theme.Lighting
	Lighting.ClockTime = l.ClockTime
	Lighting.Brightness = l.Brightness
	Lighting.FogEnd = l.FogEnd
	Lighting.FogStart = l.FogEnd * 0.3
	if theme.Colors.Fog then
		Lighting.FogColor = theme.Colors.Fog
	end

	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
	atmosphere.Density = math.clamp(400 / l.FogEnd, 0.2, 0.6)
	atmosphere.Haze = 1
	if theme.Colors.Fog then
		atmosphere.Color = theme.Colors.Fog
		atmosphere.Decay = theme.Colors.Fog:Lerp(Color3.new(0, 0, 0), 0.3)
	end
	atmosphere.Parent = Lighting
end

return LightingSetup
