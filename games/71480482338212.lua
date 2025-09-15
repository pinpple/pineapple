--[[

    pineapple 🍍
    by @stav, @sus, @vxrm, @DaiPlayz, @cqrzy, @star

    game: Bedwarz 3
	game link: https://www.roblox.com/games/71480482338212/BedwarZ#!/about
	status: 🟢
]]

local cloneref = cloneref or function(obj: Instance): any?
    return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
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
    local Scaffold, BuildCon

    local roundPos = function(pos)
        return Vector3.new(math.floor(pos.X + 0.5), math.floor(pos.Y + 0.5), math.floor(pos.Z + 0.5))
    end

    local function getWoolType()
        if lplr.Team ~= 'Spectator' then
            return lplr.Team.Name..'Wool'
        end

        return 'Wool'
    end

    Scaffold = Combat:CreateToggle({
        Name = 'Scaffold',
        ToolTipText = 'Automatically bridges for you',
        Callback = function(callback)
            if callback then
                BuildCon = runService.RenderStepped:Connect(function()
                    if entitylib.isAlive then
                        local lookVec = entitylib.character.RootPart.CFrame.LookVector
                        local blockPos = roundPos((entitylib.character.RootPart.Position + lookVec * 2) - Vector3.new(0, 3, 0))

                        replicatedStorage.Remotes.ItemsRemotes.PlaceBlock:FireServer(getWoolType(), 73, blockPos)
                    end
                end)
            else
                if BuildCon then
                    BuildCon:Disconnect()
                    BuildCon = nil
                end
            end
        end
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

--[[
    specific credits @ 🍍
    
    rewrite: @stav
    killaura: @stingray, @spring67, @stav
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