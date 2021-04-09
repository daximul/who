local function ClearLighting()
	local Li = game:GetService("Lighting")
	for i, v in pairs(Li:GetChildren()) do
		v:Destroy()
	end
end
local Plugin = {
	["PluginName"] = "RTX",
	["PluginDescription"] = "Graphics Enhancer",
	["Commands"] = {
		["rtx"] = {
			["ListName"] = "rtx",
			["Description"] = "RTX Autumn Edition",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				ClearLighting()
				local Mode = "Autumn"
				workspace.Terrain.Decoration = true
				local a = game:GetService("Lighting")
				a.Ambient = Color3.fromRGB(33, 33, 33)
				a.Brightness = 6.67
				a.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
				a.ColorShift_Top = Color3.fromRGB(255, 247, 237)
				a.EnvironmentDiffuseScale = 0.105
				a.EnvironmentSpecularScale = 0.522
				a.GlobalShadows = true
				a.OutdoorAmbient = Color3.fromRGB(51, 54, 67)
				a.ShadowSoftness = 0.04
				a.GeographicLatitude = -15.525
				a.ExposureCompensation = 0.75
				local b = Instance.new("BloomEffect", a)
				b.Enabled = true
				b.Intensity = 0.04
				b.Size = 1900
				b.Threshold = 0.915
				local c = Instance.new("ColorCorrectionEffect", a)
				c.Brightness = 0.176
				c.Contrast = 0.39
				c.Enabled = true
				c.Saturation = 0.2
				c.TintColor = Color3.fromRGB(217, 145, 57)
				if Mode == "Summer" then
					c.TintColor = Color3.fromRGB(255, 220, 148)
				elseif Mode == "Autumn" then
					c.TintColor = Color3.fromRGB(217, 145, 57)
				else
					warn("No mode selected!")
					print("Please select a mode")
					b:Destroy()
					c:Destroy()
				end
				local d = Instance.new("DepthOfFieldEffect", a)
				d.Enabled = true
				d.FarIntensity = 0.077
				d.FocusDistance = 21.54
				d.InFocusRadius = 20.77
				d.NearIntensity = 0.277
				local e = Instance.new("ColorCorrectionEffect", a)
				e.Brightness = 0
				e.Contrast = -0.07
				e.Saturation = 0
				e.Enabled = true
				e.TintColor = Color3.fromRGB(255, 247, 239)
				local e2 = Instance.new("ColorCorrectionEffect", a)
				e2.Brightness = 0.2
				e2.Contrast = 0.45
				e2.Saturation = -0.1
				e2.Enabled = true
				e2.TintColor = Color3.fromRGB(255, 255, 255)
				local s = Instance.new("SunRaysEffect", a)
				s.Enabled = true
				s.Intensity = 0.01
				s.Spread = 0.146
			end,
		},
		["rge"] = {
			["ListName"] = "rge",
			["Description"] = "Roblox Graphics Enhancer",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				ClearLighting()
				local light = game:GetService("Lighting")
				local ter = workspace.Terrain
				local color = Instance.new("ColorCorrectionEffect")
				local bloom = Instance.new("BloomEffect")
				local sun = Instance.new("SunRaysEffect")
				local blur = Instance.new("BlurEffect")
				color.Parent = light
				bloom.Parent = light
				sun.Parent = light
				blur.Parent = light
				local config = {
					Terrain = true;
					ColorCorrection = true;
					Sun = true;
					Lighting = true;
					BloomEffect = true;
	
				}
				color.Enabled = false
				color.Contrast = 0.15
				color.Brightness = 0.1
				color.Saturation = 0.25
				color.TintColor = Color3.fromRGB(255, 222, 211)
				bloom.Enabled = false
				bloom.Intensity = 0.1
				sun.Enabled = false
				sun.Intensity = 0.2
				sun.Spread = 1
				bloom.Enabled = false
				bloom.Intensity = 0.05
				bloom.Size = 32
				bloom.Threshold = 1
				blur.Enabled = false
				blur.Size = 6
				if config.ColorCorrection then
					color.Enabled = true
				end
				if config.Sun then
					sun.Enabled = true
				end
				if config.Terrain then
					ter.Decoration = true
					ter.WaterColor = Color3.fromRGB(10, 10, 24)
					ter.WaterWaveSize = 0.1
					ter.WaterWaveSpeed = 22
					ter.WaterTransparency = 0.9
					ter.WaterReflectance = 0.05
				end
				if config.Lighting then
					light.Ambient = Color3.fromRGB(0, 0, 0)
					light.Brightness = 4
					light.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
					light.ColorShift_Top = Color3.fromRGB(0, 0, 0)
					light.ExposureCompensation = 0
					light.FogColor = Color3.fromRGB(132, 132, 132)
					light.GlobalShadows = true
					light.OutdoorAmbient = Color3.fromRGB(112, 117, 128)
					light.Outlines = false
				end
			end,
		},
	},
}
return Plugin
