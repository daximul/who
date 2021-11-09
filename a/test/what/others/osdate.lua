local CurrentDate = os.date("*t")
local Month = CurrentDate["month"]

local Months = {
	["January"] = 1,
	["February"] = 2,
	["March"] = 3,
	["April"] = 4,
	["May"] = 5,
	["June"] = 6,
	["July"] = 7,
	["August"] = 8,
	["September"] = 9,
	["October"] = 10,
	["November"] = 11,
	["December"] = 12
}

-- if Month == Months["January"] then return "🎉 Dark Admin 🎉" end
-- if Month == Months["February"] then return "❤️ Dark Admin ❤️" end
-- if Month == Months["March"] then return "🍀 Dark Admin 🍀" end
if Month == Months["April"] then return "🥚 Dark Admin 🥚" end
if Month == Months["October"] then return "🎃 Dark Admin 🎃" end
-- if Month == Months["November"] then return "🦃 Dark Admin 🦃" end
if Month == Months["December"] then return "🎄 Dark Admin 🎄" end

return "Dark Admin"
