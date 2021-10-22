local Plugin = {
	["PluginName"] = "Empty Server Finder",
	["PluginDescription"] = "Find an Empty Server",
	["Commands"] = {
		["emptyserver"] = {
			["ListName"] = "emptyserver",
			["Description"] = "Find the Emptiest Server",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				local Outcome = loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/who/main/a/test/what/others/emptyservfinder.lua")))();
				if (type(Outcome) == "string") then
					notify("Empty Server", Outcome);
				elseif (Outcome == nil) then
					notify("Empty Server", "Error");
				else
					game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Outcome);
				end
			end,
		},
	},
}
return Plugin
