-- Example of what you should do
loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua")))();

while (not getgenv()["da_env"]) and (not getgenv()["da_env"]["loaded"]) do wait() end

local Build = getgenv()["da_env"]

local function Themeify(bgc3, bc3)
	for i,v in pairs(Build.Interface:GetDescendants()) do
		if v:IsA("TextButton") or v:IsA("Frame") or (v.Name == "Box" and v.Parent.Name == "CmdSearch") or (v.Name == "Box" and v.Parent.Name == "PrefixBox") then
			v.BackgroundColor3 = Color3.fromRGB(bgc3[1], bgc3[2], bgc3[3])
			v.BorderColor3 = Color3.fromRGB(bc3[1], bc3[2], bc3[3])
		end
	end
end

Themeify({30, 30, 30}, {40, 40, 40})
-- Themeify(rgb background color, rgb border color)

Build.newCmd("publicbuild", {}, "publicbuild", "Dark Admin Public User Build Theme Test", function(args, speaker)
	print(Build.build_key)
end)






--[[
Documentation


- Loaded, Key, Commands, and Interface -

Build.loaded                if the build has loaded

Build.Interface             get the gui of DA

Build.build_key             honestly just a randomly generated string thats it

Bui.notify                  legit just notify
     Build.notify("title", "hi")
     Build.notify("", "default stuff idk")

Build.newCmd                make a new command
     Build.newCmd("command name", {"alias1", "alias2", "leave blank for no alias like {}"}, "the name you see in the command lists", "command description", function(args, speaker)

Example:
Build.newCmd("publicbuild", {}, "publicbuild", "Dark Admin Public User Build Theme Test", function(args, speaker)
	print(Build.build_key)
end)




- Plugin Browser -


Build.BrowserBtn            make a new plugin browser plugin
     BrowserBtn("name in the list, I recommend 0 symbols or special characters", "plugin name, first restriction does NOT apply", "plugin description", "return loadstring(game:HttpGet('keep this return loadstring crap and replace the link with your own link to your crap'))();")

the return loadstring for the Browser has to get the same code you do for a regular plugin

Example:
BrowserBtn("Owl Hub", "Owl Hub", "Load Owl Hub", "return loadstring(game:HttpGet('https://raw.githubusercontent.com/daximul/who/main/a/test/what/browserplugins/owlhub.lua'))();")

What the String Returns:
local Plugin = {
	["PluginName"] = "Owl Hub",
	["PluginDescription"] = "",
	["Commands"] = {
		["owlhub"] = {
			["ListName"] = "owlhub",
			["Description"] = "Load Owl Hub",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				 loadstring(game:HttpGet("https://raw.githubusercontent.com/ZinityDrops/OwlHubLink/master/OwlHubBack.lua"))();
			end,
		},
	},
}
return Plugin

]]--
