local Plugin = {
	["PluginName"] = "Owl Hub",
	["PluginDescription"] = "",
	["Commands"] = {
		["owlhub"] = {
			["ListName"] = "owlhub",
			["Description"] = "Load Owl Hub",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				if (not is_sirhurt_closure) and syn then
					loadstring(game:HttpGet("https://raw.githubusercontent.com/ZinityDrops/OwlHubLink/master/OwlHubBack.lua"))();
				else
					loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Patch-Shack/newLoad/master/owlhub.lua"))();
				end
			end,
		},
	},
}
return Plugin
