

--[[

    pineapple 🍍
    by @stav, @sus, @vxrm, @DaiPlayz, @cqrzy, @star

    game: Bedwarz 3
	game link: https://www.roblox.com/games/71480482338212/BedwarZ#!/about
	status: 🟢
]]

local Pineapple = loadstring(readfile('pineapple/gui/pineapple.lua'))()

local MainUI = Pineapple:CreateMain({
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

Pineapple:notif("Pineapple","Executed properly!", 3, "info")
Pineapple:notif("Pineapple","This script is in BETA & some functions are broken.", 15, "info")

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
        Pineapple:notif("Pineapple","Processing your  uninject...", 3, "warning")
        task.wait(1.5)
        Pineapple:notif("Pineapple","Saving all your data", 1, "info")
        task.wait(4)
        Pineapple:Uninject()
    else
        Pineapple:notif("Pineapple","Removed pineapple from the client.", 3, "info")
        end
    end,
})

--// BedWars 3 Killaura (Toggle, Ignores Teammates, No Face Target)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ItemsRemotes")
local SwordHit = Remotes:WaitForChild("SwordHit")

local validSwords = {"Wooden Sword", "Stone Sword", "Iron Sword", "Diamond Sword", "Emerald Sword"}

-- Finds sword in inventory
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

-- Control flag
local KillauraEnabled = false

-- Toggle
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
            Pineapple:notif("Pineapple", "Killaura activated.", 3, "info")
        else
            Pineapple:notif("Pineapple", "Killaura deactivated.", 3, "info")
        end
    end,
})

-- Spam loop
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


--// BedWars 3 Scaffold (Toggle, Grid Snapped, Team Wool)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlaceRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ItemsRemotes"):WaitForChild("PlaceBlock")

local LocalPlayer = Players.LocalPlayer
local ScaffoldEnabled = false

-- detect wool type from team
local function getWoolType()
    if LocalPlayer.Team then
        return LocalPlayer.Team.Name .. " Wool"
    end
    return "Wool"
end

-- toggle UI
local ScaffoldToggle = Utility:CreateToggle({
    Name = "Scaffold",
    ToolTipText = "by @vxrm",
    Keybind = "None",
    Enabled = false,
    Callback = function(callback)
        ScaffoldEnabled = callback
        if ScaffoldEnabled then
            Pineapple:notif("Pineapple","Scaffold activated.",3,"info")
        else
            Pineapple:notif("Pineapple","Scaffold deactivated.",3,"info")
        end
    end,
})

-- placement loop
task.spawn(function()
    while task.wait(0.05) do
        if ScaffoldEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local forward = hrp.CFrame.LookVector

            -- place block slightly in front & below
            local blockPos = (hrp.Position + forward * 2) - Vector3.new(0, 3, 0)

            -- snap to Roblox block grid
            blockPos = Vector3.new(
                math.floor(blockPos.X + 0.5),
                math.floor(blockPos.Y + 0.5),
                math.floor(blockPos.Z + 0.5)
            )

            local args = {
                getWoolType(),
                73, -- block ID
                blockPos
            }
            PlaceRemote:FireServer(unpack(args))
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



