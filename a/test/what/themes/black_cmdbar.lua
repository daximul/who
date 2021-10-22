--// Black Command Bar
--// Transparency is 0.7
loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua")))();
while (not getgenv()["da_env"]) and (not getgenv()["da_env"]["loaded"]) do wait() end
local Build = getgenv()["da_env"]
Build.Interface.Main.BackgroundTransparency = 0.7
Build.Interface.Main.BackgroundColor3 = Color3.fromRGB(24, 21, 19)
Build.Interface.Main.Box.BackgroundColor3 = Color3.fromRGB(29, 25, 23)
