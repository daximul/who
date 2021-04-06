local Plugin = {
	["PluginName"] = "Wall Run",
	["PluginDescription"] = "",
	["Commands"] = {
		["wallrun"] = {
			["Description"] = "Allows you to run on walls! Press N to Toggle",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				 loadstring(game:HttpGetAsync(("https://pastebin.com/raw/pC7rFinA")))();
			end,
		},
	},
}
return Plugin
