--[[

    pineapple 🍍
    by @stav, @sus, @GamingChairV4, @DaiPlayz, @cqrzy, @star

    game: Bedwars 
	game link: https://www.roblox.com/games/6872265039/BedWars-ALL-KITS-FREE
	status: 🟢
]]

local cloneref = cloneref or function(obj)
    return obj
end
local playersService = cloneref(game:GetService('Players'))
local userInputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local lplr = playersService.LocalPlayer

local entitylib = loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/libraries/entity.lua'))()
local pineapple, bedwars, weaponmeta = loadfile('pineapple/gui/pineapple.lua')(), {}, {}

local inv = workspace[lplr.Name].InventoryFolder.Value

local function hasItem(item: string): string?
    if inv:FindFirstChild(item) then
        return true, 1
    end
    
    return false
end

do
    weaponmeta = {
        {'rageblade', 100},
        {'emerald_sword', 99},
        {'deathbloom', 99},
        {'glitch_void_sword', 98},
        {'sky_scythe', 98},
        {'diamond_sword', 97}, 
        {'iron_sword', 96},
        {'stone_sword', 95},
        {'wood_sword', 94},
        {'emerald_dao', 93},
        {'diamond_dao', 99},
        {'diamond_dagger', 99},
        {'diamond_great_hammer', 99},
        {'diamond_scythe', 99},
        {'iron_dao', 97},
        {'iron_scythe', 97},
        {'iron_dagger', 97},
        {'iron_great_hammer', 97},
        {'stone_dao', 96},
        {'stone_dagger', 96},
        {'stone_great_hammer', 96},
        {'stone_scythe', 96},
        {'wood_dao', 95},
        {'wood_scythe', 95},
        {'wood_great_hammer', 95},
        {'wood_dagger', 95},
        {'frosty_hammer', 1},
    }
end

do
    bedwars = setmetatable({
        Knit = require(replicatedStorage.rbxts_include.node_modules['@easy-games'].knit.src.Knit.KnitClient),
        GetController = function(controller: string): string?
            if bedwars.Knit.Controllers[controller] then
                return bedwars.Knit.Controllers[controller]
            end

            return pineapple:notif('Pineapple', 'Failed to get controller: '..controller, math.random(6, 7), 'warning')
        end,
        GetBestWeapon = function(): any?
            local bestWeaponMeta, bestSword = 0, nil

            for _, v in ipairs(weaponmeta) do
                local name, meta = v[1], v[2]

                if meta > bestWeaponMeta then
                    bestWeaponMeta = meta
                    bestSword = name
                end
            end

            return inv:FindFirstChild(bestSword)
        end,
        FOVController = bedwars.GetController('FOVController'),
        SwordController = bedwars.GetController('SwordController'),
        SprintController = bedwars.GetController('SprintController')
    }, nil)
end

pineapple:CreateMain({
    textCharacters = 10,
    Toggle = "RightShift",
    MainTextColor = Color3.fromRGB(255, 255, 10)
})

local tabs = {
    Combat = pineapple:CreateTab({
        Name = 'Combat',
        Icon = 'rbxassetid://138185990548352',
        ImageColor = Color3.fromRGB(255, 255, 255)
    }),
    Exploit = pineapple:CreateTab({
        Name = 'Exploit',
        Icon = 'rbxassetid://71954798465945',
        ImageColor = Color3.fromRGB(255, 255, 255)
    }),
    Move = pineapple:CreateTab({
        Name = 'Move',
        Icon = 'rbxassetid://91366694317593',
        ImageColor = Color3.fromRGB(255, 255, 255)
    }),
    Player = pineapple:CreateTab({
        Name = 'Player',
        Icon = 'rbxassetid://103157697311305',
        ImageColor = Color3.fromRGB(255, 255, 255)
    }),
    Visual = pineapple:CreateTab({
        Name = 'Visual',
        Icon = 'rbxassetid://118420030502964',
        ImageColor = Color3.fromRGB(255, 255, 255)
    }),
    World = pineapple:CreateTab({
        Name = 'World',
        Icon = 'rbxassetid://76313147188124',
        ImageColor = Color3.fromRGB(255, 255, 255)
    })
}

do
    local Speed
    Speed = tabs.Move:CreateToggle({
        Name = 'Speed',
        Function = function(callback)
            if callback then
                repeat
                    lplr.Character.Humanoid.WalkSpeed = 23
                    task.wait()
                until not callback
            else
                lplr.Character.Humanoid.WalkSpeed = 16
            end
        end,
        ToolTipText = 'Increases your speed'
    })
end

--[[do
    local Killaura
    Killaura = pineapple:CreateToggle({
        Name = 'Killaura',
        Function = function(callback)
            if callback then
                repeat
                    task.wait()
                until not callback
            end
        end,
        ToolTipText = 'Attacks enemies around you'
    })
end]]

--[[do
    local Killaura
    Killaura = Pineapple:CreateToggle({

    })
end]]
