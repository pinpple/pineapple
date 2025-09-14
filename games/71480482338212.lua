
--[[

    pineapple 🍍
    by @stav, @sus, @GamingChairV4, @DaiPlayz, @cqrzy, @star

    game: Bedwarz 3
	game link: https://www.roblox.com/games/71480482338212/BedwarZ#!/about
	status: 🟢
]]

local Pineapple = loadstring(readfile('pineapple/gui/pineapple.lua'))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GamingChairV4/pineapple/refs/heads/main/gui/pineapple.lua"))()

local MainUI = Library:CreateMain({
    TextCharacters = 67,
    Toggle = "RightShift",

})

local Utility = MainUI:CreateTab({
    Text = "Utility",
    Image = "rbxassetid://138185990548352",
    ImageColor = Color3.fromRGB(0,0,0)
})

local Combat = MainUI:CreateTab({
    Text = "Combat",
    Image = "rbxassetid://138185990548352", -- change to whatever image you want
    ImageColor = Color3.fromRGB(255,0,0),
    Position = UDim2.new(0, 10, 0, 60) -- offset by 50 pixels on Y axis
})

Library:notif("Pineapple","Executed properly!", 3, "info")
Library:notif("Pineapple","This script is in BETA & some functions are broken.", 15, "info")

local Uninject = Utility:CreateToggle({
    Name = "Uninject",
    ToolTipText = "Uninject pineapple from your client.",
    Keybind = "None",
    Enabled = false,
    AutoDisable = false,
    AutoEnable = false,
    Hide = false,
    Callback = function(callback)
    if callback then
    print("Active")
        Library:notif("Pineapple","Processing your  uninject...", 3, "warning")
        task.wait(1.5)
        Library:notif("Pineapple","Saving all your data", 1, "info")
        task.wait(4)
        Library:Uninject()
    else
        Library:notif("Pineapple","Removed pineapple from the client.", 3, "info")
        end
    end,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ItemsRemotes")
local SwordHit = Remotes:WaitForChild("SwordHit")

local validSwords = {"Wooden Sword", "Stone Sword", "Iron Sword", "Diamond Sword", "Emerald Sword"}

local function getSword()
    local inv = LocalPlayer:FindFirstChild("Inventory")
    if inv then
        for _, item in ipairs(inv:GetChildren()) do
            if table.find(validSwords, item.Name) then
                return item.Name
            end
        end
    end
    return nil
end

local KillauraEnabled = false

local KillauraToggle = Utility:CreateToggle({
    Name = "Killaura",
    ToolTipText = "Automatically attack players within 18 studs (360°)",
    Keybind = "None",
    Enabled = false,
    AutoDisable = false,
    AutoEnable = false,
    Hide = false,
    Callback = function(callback)
        KillauraEnabled = callback
        if KillauraEnabled then
            Library:notif("Pineapple", "Killaura activated.", 3, "info")
        else
            Library:notif("Pineapple", "Killaura deactivated.", 3, "info")
        end
    end,
})

task.spawn(function()
    while task.wait(0.1) do
        if KillauraEnabled then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local sword = getSword()
                if sword then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                            if dist <= 18 then
                                SwordHit:FireServer(sword, plr.Character)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local ScaffoldEnabled = false

local ScaffoldToggle = Utility:CreateToggle({
    Name = "Scaffold",
    ToolTipText = "Automatically places blocks in front of you.",
    Keybind = "None",
    Enabled = false,
    AutoDisable = false,
    AutoEnable = false,
    Hide = false,
    Callback = function(callback)
        ScaffoldEnabled = callback
        if ScaffoldEnabled then
            Library:notif("Pineapple", "Scaffold activated.", 3, "info")
        else
            Library:notif("Pineapple", "Scaffold deactivated.", 3, "info")
        end
    end,
})

-- Scaffold loop
task.spawn(function()
    while task.wait(0.001) do
        if ScaffoldEnabled then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local teamColor = LocalPlayer.Team and LocalPlayer.Team.Name or "Blue"
                local woolType = teamColor .. " Wool" 

                local forward = hrp.CFrame.LookVector
                local placePos = hrp.Position + forward * 3 

                local args = {woolType, 73, Vector3.new(placePos.X, placePos.Y - 1, placePos.Z)}
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ItemsRemotes"):WaitForChild("PlaceBlock"):FireServer(unpack(args))
            end
        end
    end
end)


--[[

    specific credits @ 🍍
    
    killaura: @stingray, @spring67
    scaffold: @stingray
    gui: @star
    updates & maintenance: @everyone
    testing: @cqrzy, @stingray, @sus, @stav
    contributors: @spring67 (some of killaura)
    pineapple logo: (Idk)
    pineapple name: @stingray
    pineapple idea: @everyone
    pineapple overall: @stav, @sus, @GamingChairV4, @DaiPlayz, @cqrzy

]]
