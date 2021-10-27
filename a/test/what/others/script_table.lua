local ScriptsHolder = {}

local AddScript = function(scriptname, devs, gameid, scrfunction)
  ScriptsHolder[#ScriptsHolder + 1] = {
    ["Name"] = tostring(scriptname),
		["Dev"] = tostring(devs),
		["ID"] = tostring(gameid),
		["Func"] = scrfunction
	}
end

AddScript("bruh", "your mom", "Universal", function()
  print("sussy baka mf")
end)

AddScript("Custom Reset", "Atp Zombie", "17838693", function()
	Players.LocalPlayer.Character:BreakJoints()
end)

return ScriptsHolder
