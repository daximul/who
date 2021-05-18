local _Welcome = {}

local _Kohls = function()
	if workspace:FindFirstChild("Kohl's Admin Infinite") then
		return true
	else
		return false
	end
end

local _HD = function()
	local _LocalPlayer = game:GetService("Players")
	_LocalPlayer:WaitForChild("PlayerGui")
	if _LocalPlayer["PlayerGui"]:FindFirstChild("HDAdminGUIs") then
		return true
	else
		return false
	end
end

_Welcome.Load = function(tbl)
	local Notification = ""
	if (_Kohls()) and (_HD()) and (tbl["Prefix"] ~= ";") then
		tbl["Prefix"] = ";"
		Notification = "Kohls Admin & HD Admin Detected, Prefix Set to ;"
	end
	if (_Kohls()) and (not _HD()) and (tbl["Prefix"] ~= ";") then
		tbl["Prefix"] = ";"
		Notification = "Kohls Admin Detected, Prefix Set to ;"
	end
	if (not _Kohls) and (_HD()) and (tbl["Prefix"] ~= ";") then
		tbl["Prefix"] = ";"
		Notification = "HD Admin Detected, Prefix Set to ;"
	end
	if (not _Kohls()) and (not _HD()) then
		Notification = "Prefix is " .. tbl["Prefix"]
	end
	notify("Dark Admin", Notification)
end

return _Welcome
