local MaxPlayers = math.huge
local ServersMaxPlayer = nil
local GoodServer = nil
local Gamelink = ("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")

local function ServerSearch()
	for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(Gamelink)).data) do
		if type(v) == "table" and MaxPlayers > v.playing then
			ServersMaxPlayer = v.maxPlayers
			MaxPlayers = v.playing
			GoodServer = v.id
		end
	end
end

local function GetServers()
	ServerSearch()
	for i,v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(Gamelink))) do
		if i == "nextPageCursor" then
			if Gamelink:find("&cursor=") then
				local a = Gamelink:find("&cursor=")
				local b = Gamelink:sub(a)
				gamelink = Gamelink:gsub(b, "")
			end
			Gamelink = (Gamelink .. "&cursor=" .. v)
			GetServers()
		end
	end
end

GetServers()

if #game:GetService("Players"):GetPlayers() - 1 == MaxPlayers then
	GoodServer = "Same Number of Players"
elseif GoodServer == game.JobId then
	GoodServer = "Current Server is Emptiest"
end

while GoodServer == nil do wait() end

return GoodServer
