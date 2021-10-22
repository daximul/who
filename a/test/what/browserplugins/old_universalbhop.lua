local BunnyHop = "Waiting"
local Plugin = {
	["PluginName"] = "Universal Bhop",
	["PluginDescription"] = "",
	["Commands"] = {
		["bhop"] = {
			["ListName"] = "bhop",
			["Description"] = "Start the Bhop Mechanic",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
				if BunnyHop == "Waiting" then
					BunnyHop = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/daximul/who/main/a/test/what/others/hop_scr.lua"))();
					BunnyHop:Start()
				else
					BunnyHop:Start()
				end
			end,
		},
		["unbhop"] = {
			["ListName"] = "unbhop",
			["Description"] = "Stop the Bhop Mechanic",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
				if BunnyHop == "Waiting" then return end
				BunnyHop:Stop()
			end,
		},
	},
}
return Plugin
