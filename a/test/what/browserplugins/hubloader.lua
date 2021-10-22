local Hubs = {
	["Owl Hub Back"] = "https://raw.githubusercontent.com/ZinityDrops/OwlHubLink/master/OwlHubBack.lua";
	["Owl Hub Universal"] = "https://raw.githubusercontent.com/Patch-Shack/newLoad/master/owlhub.lua";
	["Dark Hub"] = "https://raw.githubusercontent.com/RandomAdamYT/DarkHub/master/Init";
	["Psy Hub"] = "https://pastebin.com/raw/yqTJ402H";
}

local function loadhub(i)
	loadstring(game:HttpGetAsync(tostring(Hubs[i])))();
end

local Plugin = {
	["PluginName"] = "Hub Loader",
	["PluginDescription"] = "Load Specific Hubs",
	["Commands"] = {
		["owlhub"] = {
			["ListName"] = "owlhub",
			["Description"] = "Execute Owl Hub",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
				if (not is_sirhurt_closure) and syn then
					loadhub("Owl Hub Back")
				else
					loadhub("Owl Hub Universal")
				end
			end,
		},
		["darkhub"] = {
			["ListName"] = "darkhub",
			["Description"] = "Execute Dark Hub",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
				loadhub("Dark Hub")
			end,
		},
		["psyhub"] = {
			["ListName"] = "psyhub",
			["Description"] = "Execute Psy Hub",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
				loadhub("Psy Hub")
			end,
		},
	},
}

return Plugin
