--// daximul
--// 7/30/2021

local Binds = {}

local LocalMouse = game:GetService("Players").LocalPlayer:GetMouse()
local strl = string.lower

local ClearTable = function(tbl)
	for key in pairs(tbl) do
		tbl[key] = nil
	end
end

LocalMouse.KeyDown:Connect(function(Input)
	for i = 1, #Binds do
		if Binds[i].KEY == strl(tostring(Input)) then
			execCmd(Binds[i].CMD)
		end
	end
end)

local Plugin = {
	["PluginName"] = "~ Keybinds ~",
	["PluginDescription"] = "",
	["Commands"] = {
		["keybind"] = {
			["ListName"] = "keybind / bind [cmd] [key]",
			["Description"] = "Bind a Command to a Key",
			["Aliases"] = {"bind"},
			["Function"] = function(args, speaker)
				if #args < 2 then return notify("~ Keybinds ~", "Missing Argument") end
				local command = strl(tostring(args[1]))
				local key = strl(tostring(args[2]))
				if #key < 2 then
					local id = #Binds + 1
					Binds[id] = {
						CMD = command,
						KEY = key,
					}
					notify("~ Keybinds ~", "Successfully Added Keybind")
				elseif #key > 2 then return notify("~ Keybinds ~", "Key cannot be longer than 2 characters.") end
			end,
		},
		["unkeybind"] = {
			["ListName"] = "unkeybind / unbind [key]",
			["Description"] = "Remove a Bind for a Command",
			["Aliases"] = {"unbind"},
			["Function"] = function(args, speaker)
				if #args < 1 then return notify("~ Keybinds ~", "Missing Argument") end
				local key = strl(tostring(args[1]))
				for i = 1, #Binds do
					if Binds[i].KEY == key then
						table.remove(Binds, i)
						notify("~ Keybinds ~", "Removed Keybind")
					end
				end
			end,
		},
		["clearkeybinds"] = {
			["ListName"] = "clearkeybinds / clearbinds / ckeybinds / cbinds",
			["Description"] = "Remove all Current Binds",
			["Aliases"] = {"clearbinds", "ckeybinds", "cbinds"},
			["Function"] = function(args, speaker)
				ClearTable(Binds)
				notify("~ Keybinds ~", "Removed all Keybinds")
			end,
		},
	},
}

return Plugin
