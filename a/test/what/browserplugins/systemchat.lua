local Plugin = {
    ["PluginName"] = "System Chat",
    ["PluginDescription"] = "",
    ["Commands"] = {
        ["systemchat"] = {
            ["ListName"] = "systemchat / schat [msg]",
            ["Description"] = "Chat as a System",
            ["Aliases"] = {'schat'},
            ["Function"] = function(args, speaker)
                local msg = "                                                                                                                   {System} " .. getstring(1)
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
            end
        }
    }
}
return Plugin
