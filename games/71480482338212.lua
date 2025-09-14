
--[[

    pineapple 🍍
    by @stav, @sus, @GamingChairV4, @DaiPlayz, @cqrzy, @star

    game: Bedwarz 3
	game link: https://www.roblox.com/games/71480482338212/BedwarZ#!/about
	status: 🟢
]]

local Pineapple = loadstring(readfile('pineapple/gui/pineapple.lua'))()

local MainUI = Library:CreateMain({
	TextCharacters = 10,
	Toggle = "RightShift",
	
})

local Combat = MainUI:CreateTab({
	Text = "Combat",
	Image = "rbxassetid://0",
	ImageColor = Color3.fromRGB(0,0,0)
})

local Blatant = MainUI:CreateTab({
	Text = "Blatant",
	Image = "rbxassetid://0",
	ImageColor = Color3.fromRGB(0,0,0)
})

local Uninject = Blatant:CreateToggle({
	Name = "Uninject",
	ToolTipText = "Removes pineapple from the client.",
	Keybind = "None",
	Enabled = true,
	AutoDisable = false,
	AutoEnable = false,
	Hide = false,
	Callback = function(callback)
	-- callback is a bool if the toggle is toggled true / false ---
	if callback then
	print("Active")
	else
	print("Not active")
		end
	end,
})
