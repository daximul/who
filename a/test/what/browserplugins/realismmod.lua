local Lighting = game:GetService("Lighting")
local Blur = Instance.new("BlurEffect")
Blur.Name = "Blur"
Blur.Enabled = false
Blur.Size = 1.2
local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Brightness = 0.05
ColorCorrection.Contrast = 0.1
ColorCorrection.Enabled = false
ColorCorrection.Saturation = 0.1
ColorCorrection.TintColor = Color3.fromRGB(230, 230, 230)
local DepthOfField = Instance.new("DepthOfFieldEffect")
DepthOfField.Enabled = false
DepthOfField.FarIntensity = 0.15
DepthOfField.FocusDistance = 15
DepthOfField.InFocusRadius = 50
DepthOfField.NearIntensity = 0.75
local SunRays = Instance.new("SunRaysEffect")
SunRays.Enabled = false
SunRays.Intensity = 0.05
SunRays.Spread = 0.7
local OldChildren = {}
for i,v in pairs(Lighting:GetChildren()) do
	table.insert(OldChildren, v)
end
Blur.Parent = Lighting
ColorCorrection.Parent = Lighting
DepthOfField.Parent = Lighting
SunRays.Parent = Lighting
local Plugin = {
	["PluginName"] = "Realism Mod",
	["PluginDescription"] = "Graphics Enhancer",
	["Commands"] = {
		["realism"] = {
			["ListName"] = "realism",
			["Description"] = "Enable Realism Mod",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				Lighting.FogEnd = 4500
				Lighting.OutdoorAmbient = Color3.fromRGB(140, 140, 140)
				Lighting.GlobalShadows = true
				Lighting.Brightness = 1.5
				Lighting.Ambient = Color3.fromRGB(0, 0, 0)
				Lighting.ShadowColor = Color3.fromRGB(61, 61, 61)
				Blur.Enabled = true
				ColorCorrection.Enabled = true
				DepthOfField.Enabled = true
				SunRays.Enabled = true
				for i,v in pairs(OldChildren) do
					v.Enabled = false
				end
			end,
		},
		["unrealism"] = {
			["ListName"] = "unrealism",
			["Description"] = "Disable Realism Mod",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				Blur.Enabled = false
				ColorCorrection.Enabled = false
				DepthOfField.Enabled = false
				SunRays.Enabled = false
				for i,v in pairs(OldChildren) do
					v.Enabled = true
				end
				execCmd("restorelighting")
			end,
		},
	},
}
return Plugin
