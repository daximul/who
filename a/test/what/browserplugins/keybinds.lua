--// daximul
--// 5/12/2021

local Binds = {}

local LocalMouse = game:GetService("Players").LocalPlayer:GetMouse()

local Notif = {
	Title = "~ Keybinds ~",
	LongKey = "Key cannot be longer than 2 characters.",
	AddedBind = "Successfully Added Keybind",
	RemovedBind = "Removed Keybind",
	RemovedAll = "Removed all Keybinds",
	MissingArg = "Missing Argument",
	CmdNotFound = "Command Not Found",
}

local InTable = function(tbl, val)
	if tbl == nil then return false end
	for _,v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end

local ClearTable = function(tbl)
	for key in pairs(tbl) do
		tbl[key] = nil
	end
end

LocalMouse.KeyDown:Connect(function(Input)
	local Key = string.lower(Input)
	for i = 1, #Binds do
		if Binds[i].KEY == Key then
			local command = string.lower(Binds[i].CMD)
			execCmd(tostring(command))
		end
	end
end)

local Plugin = {
	["PluginName"] = "~ Keybinds ~",
	["PluginDescription"] = "",
	["Commands"] = {
		["bind"] = {
			["ListName"] = "bind [cmd] [key]",
			["Description"] = "Bind a Command to a Key",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
				if #args < 2 then return notify(Notif.Title, Notif.MissingArg) end
				local command = string.lower(tostring(args[1]))
				local key = string.lower(tostring(args[2]))
				if #key < 2 then
					local id = #Binds + 1
					Binds[id] = {
						CMD = command,
						KEY = key,
					}
					notify(Notif.Title, Notif.AddedBind)
				elseif #key > 2 then return notify(Notif.Title, Notif.LongKey) end
			end,
		},
		["unbind"] = {
			["ListName"] = "unbind [cmd]",
			["Description"] = "Remove a Bind for a Command",
			["Aliases"] = {},
			["Function"] = function(args, speaker)
				if #args < 1 then return notify(Notif.Title, Notif.MissingArg) end
				local command = string.lower(tostring(args[1]))
				for i = 1, #Binds do
					if Binds[i].CMD == command then
						table.remove(Binds, i)
						notify(Notif.Title, Notif.RemovedBind)
					else
						notify(Notif.Title, Notif.CmdNotFound)
						break
					end
				end
			end,
		},
		["clearbinds"] = {
			["ListName"] = "clearbinds / cbinds",
			["Description"] = "Remove all Current Binds",
			["Aliases"] = {"cbinds"},
			["Function"] = function(args, speaker)
				ClearTable(Binds)
				notify(Notif.Title, Notif.RemovedAll)
			end,
		},
	},
}

return Plugin
