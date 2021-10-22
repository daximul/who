loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/daximul/who/main/a/test/what/script.lua")))();

while not getgenv().DA_PUBLIC_USER_BUILD.loaded do wait() end

local Build = DA_PUBLIC_USER_BUILD

local function Themeify(bgc3, bc3)
	for i,v in pairs(Build.Interface:GetDescendants()) do
		if v:IsA("TextButton") or v:IsA("Frame") or (v.Name == "Box" and v.Parent.Name == "CmdSearch") or (v.Name == "Box" and v.Parent.Name == "PrefixBox") then
			v.BackgroundColor3 = Color3.fromRGB(bgc3[1], bgc3[2], bgc3[3])
			v.BorderColor3 = Color3.fromRGB(bc3[1], bc3[2], bc3[3])
		end
	end
end

Themeify({32, 32, 32}, {64, 64, 64})

spawn(function()
	local PlusLabel = Instance.new("TextLabel")
	PlusLabel.Name = "PlusLabel"
	PlusLabel.Parent = game.StarterGui.theme.DaUi
	PlusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PlusLabel.BackgroundTransparency = 1.000
	PlusLabel.BorderSizePixel = 0
	PlusLabel.Position = UDim2.new(0.226256981, 0, 0, 0)
	PlusLabel.Size = UDim2.new(0, 36, 0, 24)
	PlusLabel.Font = Enum.Font.Gotham
	PlusLabel.Text = "Plus"
	PlusLabel.TextColor3 = Color3.fromRGB(47, 143, 70)
	PlusLabel.TextSize = 12.000
	PlusLabel.TextXAlignment = Enum.TextXAlignment.Left
end)

newCmd("emote", {}, "emote [name]", "Play a R15 Emote", function(args, speaker)
	if r15(Players.LocalPlayer) then
		if args[1] then
			local Player_Animations = {
				["Drum Master - Royal Blood"] = 6531483720;
				["Rock Star - Royal Blood"] = 6533093212;
				["Rock Guitar - Royal Blood"] = 6532134724;
				["Drum Solo - Royal Blood"] = 6532839007;
				["Around Town"] = 3303391864;
				["Top Rock"] = 3361276673;
				Fashionable = 3333331310;
				Robot = 3338025566;
				Twirl = 3334968680;
				Jacks = 3338066331;
				T = 3338010159;
				Shy = 3337978742;
				Monkey = 3333499508;
				["Borock's Rage"] = 3236842542;
				["Ud'zal's Summoning"] = 3303161675;
				["Hype Dance"] = 3695333486;
				Godlike = 3337994105;
				Swoosh = 3361481910;
				Sneaky = 3334424322;
				["Side to Side"] = 3333136415;
				Greatest = 3338042785;
				Louder = 3338083565;
				Beckon = 5230598276;
				Bored = 5230599789;
				Cower = 4940563117;
				Tantrum = 5104341999;
				["Hero Landing"] = 5104344710;
				Confused = 4940561610;
				["Jumping Wave"] = 4940564896;
				["Keeping Time"] = 4555808220;
				Agree = 4841397952;
				["Power Blast"] = 4841403964;
				Disagree = 4841401869;
				Sleep = 4686925579;
				Sad = 4841407203;
				Happy = 4841405708;
				["Chicken Dance"] = 4841399916;
				["Bunny Hop"] = 4641985101;
				["Air Dance"] = 4555782893;
				Curtsy = 4555816777;
				Zombie = 4210116953;
				["Fast Hands"] = 4265701731;
				["Baby Dance"] = 4265725525;
				Celebrate = 3338097973;
				["Fancy Feet"] = 3333432454;
				Y = 4349285876;
				Shuffle = 4349242221;
				Bodybuilder = 3333387824;
				["Sandwich Dance"] = 4406555273;
				["Dorky Dance"] = 4212455378;
				["Heisman Pose"] = 3695263073;
				["Superhero Reveal"] = 3695373233;
				Dizzy = 3361426436;
				["Get Out"] = 3333272779;
				Fishing = 3334832150;
				Tree = 4049551434;
				["Line Dance"] = 4049037604;
				Idol = 4101966434;
				Haha = 3337966527;
				Salute = 3333474484;
				Hello = 3344650532;
				["Air Guitar"] = 3695300085;
				["Cha Cha"] = 3695322025;
				Shrug = 3334392772;
				Point2 = 3344585679;
				Tilt = 3334538554;
				Stadium = 3338055167;
				["High Wave"] = 5915690960;
				Applaud = 5915693819;
				["Break Dance"] = 5915648917;
				["Rock On"] = 5915714366;
				["Dolphin Dance"] = 5918726674;
				["Jumping Cheer"] = 5895324424;
				["Floss Dance"] = 5917459365;
				["Country Line Dance"] = 5915712534;
				["Panini Dance"] = 5915713518;
				["Holiday Dance"] = 5937558680;
				["Rodeo Dance"] = 5918728267;
				["Old Town Road Dance"] = 5937560570;
			}
			local function PlayAnim(id)
				local Anim = Instance.new("Animation")
				Anim.AnimationId = ("rbxassetid://" .. id)
				local Emote = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(Anim)
				Emote.Name = "Emote"
				Emote:Play(0)
				Emote:AdjustSpeed(1)
			end
			local AnimName = string.lower(getstring(1))
			for i,v in pairs(Player_Animations) do
				if AnimName == string.sub(string.lower(tostring(i)), 1, #AnimName) then
					PlayAnim(v)
				end
			end
		else
			notify("", "Argument Missing")
		end
	else
		notify("", "R15 Required")
	end
end)

newCmd("emoteid", {}, "emoteid [id]", "Play a R15 Emote Using It's ID", function(args, speaker)
	if r15(Players.LocalPlayer) then
		if args[1] then
			local function PlayAnim(id)
				local Anim = Instance.new("Animation")
				Anim.AnimationId = ("rbxassetid://" .. id)
				local Emote = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(Anim)
				Emote.Name = "Emote"
				Emote:Play(0)
				Emote:AdjustSpeed(1)
			end
			local CheckIfWorks = pcall(function()
				PlayAnim(args[1])
			end)
			if CheckIfWorks then
				PlayAnim(args[1])
			else
				notify("Emote", "Error Running " .. args[1])
			end
		else
			notify("", "Argument Missing")
		end
	else
		notify("", "R15 Required")
	end
end)
