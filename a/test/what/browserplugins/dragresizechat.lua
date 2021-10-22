local Plugin = {
	["PluginName"] = "Draggable Chat",
	["PluginDescription"] = "Poptart#4811, Orion#4085",
	["Commands"] = {
		["dragchat"] = {
			["ListName"] = "dragchat / dragc",
			["Description"] = "Drag roblox chat anywhere hold left click",
			["Aliases"] = {"dragc"},
			["Function"] = function(args,speaker)
				repeat wait() until game:IsLoaded()
				local ChatSettings = require(game:GetService("Chat").ClientChatModules.ChatSettings)
				local ChatFrame = game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame
				ChatSettings.WindowResizable = true
				ChatSettings.WindowDraggable = true
				ChatFrame.ChatChannelParentFrame.Visible = true
				ChatFrame.ChatBarParentFrame.Position = ChatFrame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(), chatFrame.ChatChannelParentFrame.Size.Y)
			end
		}
	}
}
return Plugin
