local cloneref = cloneref or function(obj: Instance): any?
    return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local lplr = playersService.LocalPlayer

local entitylib = loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/libraries/entity.lua'))()
local pineapple, items = loadstring(readfile('pineapple/gui/pineapple.lua'))(), {}

local MainUI = pineapple:CreateMain({
    TextCharacters = 67,
    Toggle = 'RightShift'
})

local Utility = MainUI:CreateTab({
    Text = 'Utility',
    Image = 'rbxassetid://138185990548352',
    ImageColor = Color3.fromRGB(0,0,0)
})

local Combat = MainUI:CreateTab({
    Text = 'Combat',
    Image = 'rbxassetid://138185990548352',
    ImageColor = Color3.fromRGB(255, 0, 0),
    Position = UDim2.new(0, 10, 0, 60)
})

do
    items = {
        Melee = {'Wooden Sword', 'Stone Sword', 'Iron Sword', 'Diamond Sword', 'Emerald Sword'},
        Pickaxes = {'Wooden Pickaxe', 'Stone Pickaxe', 'Iron Pickaxe', 'Diamond Pickaxe'}
    }
end

local function hasTool(v)
    return lplr.Backpack and lplr.Backpack:FindFirstChild(v)
end

local function getTool(tool: string): string?
	return workspace.PlayersContainer[lplr.Name]:FindFirstChild(tool)
end

local function getItem(type, returnval)
    local tog = {}
    if not returnval then
        error('No return value')
    end

    for i, v in items[type] do
        local tool = getTool(v)
        if entitylib.isAlive then
            if returnval == 'tog' and tool then
                return true
            elseif returnval == 'table' and (hasTool(v) or tool) then
                tog[i] = v
            end
        end
    end

    if returnval == 'tog' then
        return false
    end

    return tog
end

do
    local Killaura
    local AttackDelay = tick()

    Killaura = Utility:CreateToggle({
        Name = "Killaura",
        ToolTipText = 'Automatically attacks players around you',
        Callback = function(callback)
            if callback then
                repeat
                    local plrs = entitylib.AllPosition({
                        Range = 18,
                        Wallcheck = false,
                        Part = 'RootPart',
                        Players = true,
                        NPCs = true,
                        Limit = 10
                    })

                    if #plrs > 0 then
                        for _, v in plrs do 
                            for _, i in getItem('Melee', 'table') do
                                if AttackDelay < tick() then
                                    AttackDelay = tick() + 0.001

                                    replicatedStorage.Remotes.ItemsRemotes.SwordHit:FireServer(i, v.Character)
                                end
                            end
                        end
                    end

                    task.wait()
                until not callback
            end
        end,
    })
end

do
    local Uninject
    Uninject = Utility:CreateToggle({
        Name = 'Uninject',
        ToolTipText = 'Uninjects Pineapple',
        Callback = function(callback)
            if callback then
                pineapple:Uninject()
            end
        end
    })
end

pineapple:notif('Pineapple', 'rewrite loaded (fuck u whoever wrote that shit code)', 6)