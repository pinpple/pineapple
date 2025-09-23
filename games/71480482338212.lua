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
local UserInputService = cloneref(game:GetService('UserInputService'))
local lplr = playersService.LocalPlayer

local entitylib = loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/libraries/entity.lua'))()
local pineapple, items = loadstring(readfile('pineapple/gui/pineapple.lua'))(), {}
local esplib = loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau"))()

local Utility = pineapple:CreateTab('Utility')

local Combat = pineapple:CreateTab('Combat')

local Visual = pineapple:CreateTab('Visual')

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

local function getCurrentTool()
	if workspace[lplr.Name] and workspace[lplr.Name]:FindFirstChildOfClass('Tool') then
		return workspace[lplr.Name]:FindFirstChildOfClass('Tool')
	else
		return nil
	end
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

local function getMelee()
	local backpack = lplr.Backpack
	local character = workspace[lplr.Name] -- PlayersContainer

	for _, tool in pairs(backpack:GetChildren()) do
		if tool:IsA('Tool') then
			if items['Melee'] then
				if table.find(items['Melee'], tool.Name) then
					return tool
				end
			end
		end
	end

	for _, tool in pairs(character:GetChildren()) do
		if tool:IsA('Tool') then
			if items['Melee'] then
				if table.find(items['Melee'], tool.Name) then
					return tool
				end
			end
		end
	end
end

do
	local Killaura
	local AttackDelay = tick()

	Killaura = Utility:CreateModule({
		Name = "Killaura",
		ToolTip = 'Automatically attacks players around you',
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
							local melee = getMelee()
							if melee then
								if AttackDelay < tick() then
									AttackDelay = tick() + 0.001

									replicatedStorage.Remotes.ItemsRemotes.SwordHit:FireServer(melee.Name, v.Character)
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

	Scaffold = Combat:CreateModule({
		Name = 'Scaffold',
		ToolTip = 'Automatically bridges for you',
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
	local AutoClicker
	local CPSSlider, CPS

	AutoClicker = Combat:CreateModule({
		Name = 'Autoclicker',
		ToolTip = 'Automatically clicks',
		Callback = function(callback)
			if callback then
				repeat
					local tool = getCurrentTool()
					if tool and UserInputService:IsMouseButtonPressed(0) then
						tool:Activate()
					end
					runService.RenderStepped:Wait(.3 / CPS)
				until not callback
			end
		end
	})

	CPSSlider = AutoClicker:CreateSlider({
		Name = "CPS",
		Min = 1,
		Max = 20,
		Default = 8,
		Callback = function(callback)
			CPS = callback
		end,
	})
end

do
	local Esp, Callback

	function playerAdded(player: Player, callback: BoolValue)
		if not callback then return end
		if player == playersService.LocalPlayer then return end

		local ESPElement
		local function onCharAdded(character)
			character:WaitForChild("HumanoidRootPart", math.huge)

			ESPElement = esplib:Add({
				Name = player.Name,

				Model = character,

				Color = player.TeamColor,
				MaxDistance = 1000,

				TextSize = 17,

				ESPType = "Highlight",

				FillColor = player.TeamColor,
				OutlineColor = player.TeamColor,
				FillTransparency = 0.5,
				OutlineTransparency = 0,

				Tracer = { 
					Enabled = true,
					Color = player.TeamColor,
					From = "Mouse"
				},

				Arrow = {
					Enabled = true,
					Color = player.TeamColor
				}
			})
		end

		onCharAdded(player.Character or player.CharacterAdded:Wait())
		player.CharacterAdded:Connect(onCharAdded)
	end

	Esp = Visual:CreateModule({
		Name = 'Esp',
		ToolTip = 'View players from anywhere',
		Callback = function(callback)
			if callback then
				Callback = callback
				for _, player in pairs(playersService:GetPlayers()) do
					playerAdded(player, callback)
				end
			else
				esplib:Clear()
			end
		end
	})

	playersService.PlayerAdded:Connect(function(player)
		playerAdded(player, Callback)
	end)
end



do
	local Uninject
	Uninject = Utility:CreateModule({
		Name = 'Uninject',
		ToolTip = 'Uninjects Pineapple',
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
