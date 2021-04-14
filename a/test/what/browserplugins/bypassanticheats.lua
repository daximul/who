--[[

local meta = getrawmetatable(game) -- grab the table of "game" so that we can modify it 
local namecall = meta.__namecall -- grabbing the old function 
setreadonly(meta, false) -- metatables are locked by default, so we need to unlock it using this

-- newcclosure wraps it in a "C Closure" which makes it so you do not over-write the global function

meta.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod() -- an example of a "namecall" is like [game:GetService], namecalling is like example:namecallexample
    
    if method == 'Kick' then -- checking if the namecall was ":Kick"
        return wait(9e9) -- instead of executing the kick like normal, we make it wait for 9 billion seconds (practically infinite)
    end

    return namecall(self, ...) -- we didn't hit a flag, so we'll return the old function that we grabbed earlier with self,... (self is the object so like game.Players.LocalPlayer) and ... is the arguments so like :Kick("Fuck you stupid retard")
end)

setreadonly(meta, true) -- this isn't FULLY needed but it's good practice to re-lock our table after we are done with it so any other code doesn't realize it is modified

]]--
local OriginalSettings = {
	Player = {
		Ws = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed,
		Jp = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower,
	},
}
local Plugin = {
	["PluginName"] = "Bypass Anticheats",
	["PluginDescription"] = "",
	["Commands"] = {
		["bypasswalkspeed"] = {
			["ListName"] = "bypasswalkspeed / bws",
			["Description"] = "Bypass WalkSpeed on Most Games",
			["Aliases"] = {"bws"},
			["Function"] = function(args,speaker)
				local oldspeed = OriginalSettings.Player.Ws or 16
				local getrawmt = (debug and debug.getmetatable) or getrawmetatable
				local setReadOnly = setreadonly or (make_writeable and function(table, readonly) if readonly then make_readonly(table) else make_writeable(table) end end)
				local lp = game:GetService("Players").LocalPlayer
				local meta = getrawmt(game)
				local caller = checkcaller or is_protosmasher_caller
				local index = meta.__index
				local newindex = meta.__newindex
				local namecall = meta.__namecall
				setReadOnly(meta, false)
				meta.__namecall = newcclosure(function(self, ...)
					local method = getnamecallmethod()
					local args = {...}
					if method == string.lower("fireserver") and args[1] == "WalkSpeed" then return oldspeed end
					return namecall(self, ...)
				end)
				setReadOnly(meta, true)
			end,
		},
		["bypassjumppower"] = {
			["ListName"] = "bypassjumppower / bjp",
			["Description"] = "Bypass JumpPower on Most Games",
			["Aliases"] = {"bjp"},
			["Function"] = function(args,speaker)
				local oldpower = OriginalSettings.Player.Js or 50
				local getrawmt = (debug and debug.getmetatable) or getrawmetatable
				local setReadOnly = setreadonly or (make_writeable and function(table, readonly) if readonly then make_readonly(table) else make_writeable(table) end end)
				local lp = game:GetService("Players").LocalPlayer
				local meta = getrawmt(game)
				local caller = checkcaller or is_protosmasher_caller
				local index = meta.__index
				local newindex = meta.__newindex
				local namecall = meta.__namecall
				setReadOnly(meta, false)
				meta.__namecall = newcclosure(function(self, ...)
					local method = getnamecallmethod()
					local args = {...}
					if method == string.lower("fireserver") and args[1] == "JumpPower" then return oldpower end
					return namecall(self, ...)
				end)
				setReadOnly(meta, true)
			end,
		},
		["bypassteleport"] = {
			["ListName"] = "bypassteleport / btp",
			["Description"] = "Bypass Teleportation on Most Games",
			["Aliases"] = {"btp"},
			["Function"] = function(args,speaker)
				local getrawmt = (debug and debug.getmetatable) or getrawmetatable
				local setReadOnly = setreadonly or (make_writeable and function(table, readonly) if readonly then make_readonly(table) else make_writeable(table) end end)
				local lp = game:GetService("Players").LocalPlayer
				local meta = getrawmt(game)
				local caller = checkcaller or is_protosmasher_caller
				local index = meta.__index
				local newindex = meta.__newindex
				local namecall = meta.__namecall
				setReadOnly(meta, false)
				meta.__newindex = newcclosure(function(self, meme, value)
					if caller() then return newindex(self, meme, value) end
					if tostring(self) == "HumanoidRootPart" or tostring(self) == "Torso" or tostring(self) == "UpperTorso" then
						if meme == "CFrame" or meme == "Position" then
							return true
						end
					end
					return newindex(self, meme, value)
				end)
				setReadOnly(meta, true)
			end,
		},
		["bypasskick"] = {
			["ListName"] = "bypasskick / bk",
			["Description"] = "Bypass Kick on Most Games",
			["Aliases"] = {"bk"},
			["Function"] = function(args,speaker)
				local getrawmt = (debug and debug.getmetatable) or getrawmetatable
				local setReadOnly = setreadonly or (make_writeable and function(table, readonly) if readonly then make_readonly(table) else make_writeable(table) end end)
				local meta = getrawmt(game)
				local namecall = meta.__namecall
				setReadOnly(meta, false)
				meta.__namecall = newcclosure(function(self, ...)
					local method = getnamecallmethod()
					if method == "Kick" then
						return wait(9e9)
					end
					return namecall(self, ...)
				end)
				setReadOnly(meta, true)
			end,
		},
	},
}
return Plugin
