function ParentGui(Gui)
	Gui.Name = game:GetService("HttpService"):GenerateGUID(false):gsub('-', ''):sub(1, math.random(25, 30))
	if CoreGui:FindFirstChild("RobloxGui") then
		Gui.Parent = CoreGui["RobloxGui"]
	else
		Gui.Parent = CoreGui
	end
end
local Dex = game:GetObjects("rbxassetid://3567096419")[1]
ParentGui(Dex)
	local function Load(Obj, Url)
		local function GiveOwnGlobals(Func, Script)
			local Fenv = {}
			local RealFenv = {script = Script}
			local FenvMt = {}
			FenvMt.__index = function(a,b)
				if RealFenv[b] == nil then
					return getfenv()[b]
				else
					return RealFenv[b]
				end
			end
			FenvMt.__newindex = function(a, b, c)
				if RealFenv[b] == nil then
					getfenv()[b] = c
				else
					RealFenv[b] = c
				end
			end
			setmetatable(Fenv, FenvMt)
			setfenv(Func, Fenv)
			return Func
		end
		local function LoadScripts(Script)
			if Script.ClassName == "Script" or Script.ClassName == "LocalScript" then
				spawn(function()
					GiveOwnGlobals(loadstring(Script.Source, "=" .. Script:GetFullName()), Script)()
				end)
			end
			for i,v in pairs(Script:GetChildren()) do
				LoadScripts(v)
			end
		end
		LoadScripts(Obj)
	end

	Load(Dex)
