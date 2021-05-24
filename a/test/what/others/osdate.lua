local Text = ""
local Date = os.date("*t")

local Months = {
	January = 1,
	February = 2,
	March = 3,
	April = 4,
	May = 5,
	June = 6,
	July = 7,
	August = 8,
	September = 9,
	October = 10,
	November = 11,
	December = 12
}

if Date["month"] == Months.April then
	Text = ("🥚 Dark Admin 🥚")
elseif Date["month"] == Months.October then
	Text = ("🎃 Dark Admin 🎃")
elseif Date["month"] == Months.December then
	Text = ("🎄 Dark Admin 🎄")
elseif Date["month"] == Months.November then
	Text = ("🦃 Dark Admin 🦃")
elseif Date["month"] == Months.March then
	Text = ("🍀 Dark Admin 🍀")
elseif Date["month"] == Months.February then
	Text = ("❤️ Dark Admin ❤️")
else
	Text = ("Dark Admin")
end

if Text == "" then Text = "Dark Admin" end

return Text
