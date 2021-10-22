local Lighting = game:GetService("Lighting")
local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
local gethidden = gethiddenproperty or get_hidden_property or get_hidden_prop
local PreviousTechnology = gethidden(Lighting, "Technology")
local Plugin = {
	["PluginName"] = "Future Lighting",
	["PluginDescription"] = "Lets you enable Future Lighting in any game",
	["Commands"] = {
		["futurelighting"] = {
			["ListName"] = "futurelighting / fl",
			["Description"] = "Enables Future Lighting",
			["Aliases"] = {"fl"},
			["Function"] = function(args, speaker)
				sethidden(Lighting, "Technology", Enum.Technology.Future)
			end
		},
		["unfuturelighting"] = {
			["ListName"] = "unfuturelighting / unfl",
			["Description"] = "Disables Future Lighting",
			["Aliases"] = {"unfl"},
			["Function"] = function(args, speaker)
				sethidden(Lighting, "Technology", PreviousTechnology)
			end
		},
	}
}
return Plugin
