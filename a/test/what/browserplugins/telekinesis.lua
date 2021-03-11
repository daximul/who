local Plugin = {
	["PluginName"] = "Telekinesis",
	["PluginDescription"] = "Control Unanchored Parts",
	["Commands"] = {
		["telekinesis"] = {
			["ListName"] = "telekinesis / tel",
			["Description"] = "Jedi with Unanchored Parts",
			["Aliases"] = {"tel"},
			["Function"] = function(args,speaker)
				 loadstring(game:HttpGet("https://pastebin.com/raw/CJ4K4rRw"))();
			end,
		},
	},
}
return Plugin
