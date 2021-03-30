local Plugin = {
	["PluginName"] = "Swear by ASTP",
	["PluginDescription"] = "",
	["Commands"] = {
		["swear"] = {
			["ListName"] = "swear [string]",
			["Description"] = "Chat the message with the bypass symbol",
			["Aliases"] = {},
			["Function"] = function(args,speaker)
				local RS = game:GetService("ReplicatedStorage")
				local DCSCE = RS:FindFirstChild("DefaultChatSystemChatEvents")
				if DCSCE then
					local SMR = RS.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
					if SMR then
						local Symbol = "￿"
						local SayMessageRequest = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
						SayMessageRequest:FireServer(Symbol .. " " .. getstring(1))
					end
				end
			end,
		},
	},
}
return Plugin
