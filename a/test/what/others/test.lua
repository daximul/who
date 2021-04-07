local anti = getfenv()
local function ParentGui(Gui)
	local HttpService = game:GetService("HttpService")
	local CoreGui = game:GetService("CoreGui")
	Gui.Name = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, math.random(25, 30))
	if (not is_sirhurt_closure) and (syn and syn.protect_gui) then
		syn.protect_gui(Gui)
		Gui.Parent = CoreGui
	elseif get_hidden_gui or gethui then
		local HiddenUI = get_hidden_gui or gethui
		Gui.Parent = HiddenUI()
	elseif CoreGui:FindFirstChild("RobloxGui") then
		Gui.Parent = CoreGui["RobloxGui"]
	else
		Gui.Parent = CoreGui
	end
end
local function Load()
	loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua")))();
	print("poggers!")
end
local moment = {"!2352532", "8wfe9htfreyhgd", "348feio", "esoidufhiough"}
local colors = {
	["Default"] = Color3.fromRGB(163, 153, 152),
	["Green"] = Color3.fromRGB(44, 101, 29),
	["Red"] = Color3.fromRGB(109, 0, 0),
}
local Interface = game:GetObjects("rbxassetid://6648713996")[1]
Interface.Main.Box.Text = "Key"
ParentGui(Interface)
Interface.Main.Box.FocusLost:Connect(function(EnterPressed)
	if EnterPressed then
		if table.find(moment, Interface.Main.Box.Text) then
			Interface.Main.Box.TextColor3 = colors["Green"]
			wait(1.9)
			Interface.Main.Visible = false
			wait(0.01)
			Interface:remove()
			Load()
		else
			Interface.Main.Box.TextColor3 = colors["Red"]
			wait(1.9)
			Interface.Main.Box.TextColor3 = colors["Default"]
		end
	end
end)
Interface.Close.MouseButton1Down:Connect(function()
	Interface.Main.Visible = false
	wait(0.01)
	Interface:remove()
end)
