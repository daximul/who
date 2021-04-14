local Plugin = {
	["PluginName"] = "More Dex",
	["PluginDescription"] = "Adds More Explorers",
	["Commands"] = {
		["sentineldex"] = {
			["ListName"] = "sentineldex / sendex",
			["Description"] = "Loads Sentinel Dex",
			["Aliases"] = {"sendex"},
			["Function"] = function(args, speaker)
					loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Patch-Shack/newLoad/master/sentinel_dex.lua"))();
				end
			end
		}
		["dexv2"] = {
			["ListName"] = "dexv2",
			["Description"] = "Loads Dex v2",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
					loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Patch-Shack/newLoad/master/dexv2.lua"))();
				end
			end
		}
	}
}
return Plugin
