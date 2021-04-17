local Plugin = {
	["PluginName"] = "Universal Bhop",
	["PluginDescription"] = "",
	["Commands"] = {
		["bhop"] = {
			["ListName"] = "bhop",
			["Description"] = "Start Up the Bhop Mechanic",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
				 loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/daximul/who/main/a/test/what/others/hop_scr.lua"))();
			end,
		},
	},
}
return Plugin
