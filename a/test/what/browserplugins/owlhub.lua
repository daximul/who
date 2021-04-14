local Plugin = {
	["PluginName"] = "Owl Hub",
	["PluginDescription"] = "",
	["Commands"] = {
		["owlhub"] = {
			["ListName"] = "owlhub",
			["Description"] = "Load Owl Hub",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				 -- loadstring(game:HttpGet("https://raw.githubusercontent.com/ZinityDrops/OwlHubLink/master/OwlHubBack.lua"))();
				loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Patch-Shack/newLoad/master/owlhub.lua"))();
			end,
		},
	},
}
return Plugin
