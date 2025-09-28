--[[

    pineapple 🍍
    by @stav, @sus, @vxrm, @DaiPlayz, @cqrzy, @star

    game: Bedwarz 3
	game link: https://www.roblox.com/games/71480482338212/BedwarZ#!/about
	status: 🟢
]]

--[[
TODO
Walksped Attribute
]]

local cloneref = cloneref or function(obj: Instance): any?
	return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local UserInputService = cloneref(game:GetService('UserInputService'))
local lplr = playersService.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local entitylib = require(lplr.PlayerGui.entitylib)
local pineapple, items = require(lplr.PlayerGui.LibraryCloneref), {}
local esplib = require(lplr.PlayerGui.esplib)

pineapple.Keybind = {'RightControl', 'RightShift'}

local walkspeed = lplr.Character.Humanoid.WalkSpeed
local jumppower = lplr.Character.Humanoid.JumpPower
local walkspeedConnection =  lplr.Character.Humanoid:GetAttributeChangedSignal("WalkSpeed"):Connect(function()
	walkspeed = lplr.Character.Humanoid.WalkSpeed
end)

local Combat = pineapple:CreateTab('Combat')
local Player = pineapple:CreateTab('Player')
local Movement = pineapple:CreateTab('Movement')
local Visuals = pineapple:CreateTab('Visuals')
local Exploit = pineapple:CreateTab('Exploit')

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

lplr.Character.Humanoid.UseJumpPower = true

local function getPickaxe()
	local backpack = lplr.Backpack
	local character = workspace['PlayersContainer'][lplr.Name] -- PlayersContainer

	for _, tool in pairs(backpack:GetChildren()) do
		if tool:IsA('Tool') then
			if items['Pickaxes'] then
				if table.find(items['Pickaxes'], tool.Name) then
					return tool
				end
			end
		end
	end

	for _, tool in pairs(character:GetChildren()) do
		if tool:IsA('Tool') then
			if items['Pickaxes'] then
				if table.find(items['Pickaxes'], tool.Name) then
					return tool
				end
			end
		end
	end
end

local function getMelee()
	local backpack = lplr.Backpack
	local character = workspace['PlayersContainer'][lplr.Name] -- PlayersContainer

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

	Killaura = Combat:CreateModule({
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
	local Speed
	local SpeedMode = 'CFrame'

	Speed = Combat:CreateModule({
		Name = "Speed",
		ToolTip = 'Gives you speed',
		Callback = function(callback)

			if callback then
				if callback then
					runService.Heartbeat:Connect(function(deltaTime)
						pcall(function()
							local MoveDir = lplr.Character.Humanoid.MoveDirection
							local Velo = lplr.Character.PrimaryPart.AssemblyLinearVelocity
							local SpeedVal = (true and 80 or 23) -- lplr.Character.Humanoid.WalkSpeed

							if SpeedMode.Value == 'CFrame' then
								SpeedVal -= lplr.Character.Humanoid.WalkSpeed

								lplr.Character.PrimaryPart.CFrame += (MoveDir * SpeedVal * deltaTime)
							elseif SpeedMode.Value == 'Velocity' then
								lplr.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(MoveDir.X * SpeedVal, Velo.Y, MoveDir.Z * SpeedVal)
							end
						end)
					end)
				end
			end
		end,
	})

end

local isCloned = false
local cloneChar, realChar
local binds = {}

local function generateClone(character)
	if not character then return end
	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end

	character.Archivable = true
	local copy = character:Clone()
	copy.Parent = workspace
	isCloned = true

	if character.PrimaryPart then
		character.PrimaryPart.Transparency = 1
	end
	if character:FindFirstChild("Head") and character.Head:FindFirstChild("face") then
		character.Head.face.Transparency = 1
	end

	for _,desc in ipairs(character:GetDescendants()) do
		if desc:IsA("Decal") then
			desc.Transparency = 1
		elseif desc:IsA("BasePart") then
			desc.Transparency = 1
		end
	end

	for _,cPart in ipairs(copy:GetDescendants()) do
		if cPart:IsA("BasePart") then
			for _,oPart in ipairs(character:GetDescendants()) do
				if oPart:IsA("BasePart") then
					local ncc = Instance.new("NoCollisionConstraint")
					ncc.Part0, ncc.Part1 = cPart, oPart
					ncc.Parent = cPart
				end
			end
		end
	end

	return copy, character
end

local function takeover(char)
	task.wait()
	cloneChar, realChar = generateClone(char)
	if not cloneChar then return end

	workspace.CurrentCamera.CameraSubject = cloneChar
	lplr.Character = cloneChar

	if cloneChar:FindFirstChild("Animate") then
		cloneChar.Animate.Disabled = true
		cloneChar.Animate.Disabled = false
	end

	local lastUpdate = tick()
	binds[#binds+1] = game:GetService("RunService").Heartbeat:Connect(function()
		if not (cloneChar and cloneChar.PrimaryPart) then return end
		if not (char and char.PrimaryPart) then return end

		local cRoot = cloneChar.PrimaryPart
		local rRoot = char.PrimaryPart

		pcall(function()
			if (tick() - lastUpdate) > 0.14 
				or (rRoot.Position - cRoot.Position).Magnitude > 10 then
				local direction = (cRoot.Position - rRoot.Position).Unit
				rRoot.Velocity = direction * cRoot.Velocity.Magnitude
				lastUpdate = tick()
			end
			rRoot.Velocity = Vector3.new(0, cRoot.Velocity.Y, 0)
		end)
	end)
end

do
	local disablerModule
	local charConn

	disablerModule = Combat:CreateModule({
		Name = "Disabler",
		ToolTip = "AC bypass via clone replacement",
		Callback = function(enable)
			if enable then
				charConn = lplr.CharacterAdded:Connect(function(newChar)
					repeat task.wait() until newChar
					if isCloned then return end
					takeover(newChar)
				end)
				if lplr.Character then
					takeover(lplr.Character)
				end
			else
				if charConn then charConn:Disconnect() end
				for _,b in ipairs(binds) do b:Disconnect() end

				if realChar then
					for _,child in ipairs(realChar:GetChildren()) do
						pcall(function() child.Transparency = 0 end)
					end
					lplr.Character = realChar
					workspace.CurrentCamera.CameraSubject = realChar
				end

				if cloneChar then
					cloneChar:Destroy()
					cloneChar = nil
				end
			end
		end
	})
end


--						-connections do
-


lplr.CharacterAdded:Connect(function()
	walkspeedConnection = lplr.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		walkspeed = lplr.Character.Humanoid.WalkSpeed
	end)
end)

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

	Esp = Visuals:CreateModule({
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
	local Nuker, Range = nil, 30
	local RangeSlider

	local function getNearestBed()
		for i, v in workspace.BedsContainer:GetChildren() do
			local rangePart = v:FindFirstChild("BedHitbox")

			if rangePart then
				local Distance =  (lplr.Character.HumanoidRootPart.Position - rangePart.Position).Magnitude

				if Distance <= Range then
					return v, rangePart
				end
			end
		end
		return 0
	end
	local BreakerRaycastPramas = RaycastParams.new()
	BreakerRaycastPramas.FilterDescendantsInstances = {workspace.BedsContainer}
	BreakerRaycastPramas.FilterType = Enum.RaycastFilterType.Include

	Nuker = Exploit:CreateModule({
		Name = 'Nuker',
		ToolTip = 'Mine Beds',
		Callback = function(callback)
			if callback then
				runService.Heartbeat:Connect(function()
					local Bed, part = getNearestBed()
					local Pickaxe = getPickaxe()

					if Bed and Pickaxe and lplr.Character and lplr.Character.PrimaryPart then 	
						replicatedStorage.Remotes.ItemsRemotes.MineBlock:FireServer(
							Pickaxe.Name,
							Bed.Parent,
							part.Position,
							part.Position + Vector3.new(0, 5, 0),
							(part.Position - part.Position + Vector3.new(0, 5, 0)).Unit
						)
					end
				end)
			end
		end,
	})
	RangeSlider = Nuker:CreateSlider({
		Name = "Range",
		Min = 3,
		Max = 35,
		Default = 30,
		Callback = function(callback)
			Range = callback
		end,
	})
end

do
	local SessionInfo
	local SessionInfothing
	SessionInfo = Visuals:CreateModule({
		Name = 'SessionInfo',
		ToolTip = 'View your stats',
		Callback = function(callback)
			if callback then
				local BedsBroken = lplr.Stats['Total Beds Broken']
				local Kills = lplr.leaderstats.Kills
				local Wins = lplr.Stats.Wins
				SessionInfothing = pineapple:SessionInfo(Kills, Wins, BedsBroken)
			else
				if SessionInfothing then
					SessionInfothing:Remove()
				end
			end
		end,
	})
end

do
	local Uninject
	Uninject = Visuals:CreateModule({
		Name = 'Uninject',
		ToolTip = 'Uninjects Pineapple',
		Callback = function(callback)
			if callback then
				pineapple:Uninject()
			end
		end
	})
end

pineapple:notif('Pineapple', 'Loaded!', 6)

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
