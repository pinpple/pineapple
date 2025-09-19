local Library = {
	Whitelist = {
		[1661693016] = {
			Allowed = true,
			Blacklisted = false,
			Tag = 'Developer',
			Color = Color3.fromRGB(255, 0, 0),
		},
		[4422957881] = {
			Allowed = true,
			Blacklisted = false,
			Tag = 'sus',
			Color = Color3.fromRGB(60, 0, 255),
		},
		[1376949375] = {
			Allowed = true,
			Blacklisted = false,
			Tag = 'Owner',
			Color = Color3.fromRGB(60, 0, 255),
		},
		[9463963460] = {
			Allowed = true,
			Blacklisted = false,
			Tag = 'Owner',
			Color = Color3.fromRGB(60, 0, 255),
		},
	},

	Visual = {
		Watermark = true,
		Arraylist = true,
		DisablePineappleImage = false
	},

	Tabs = {

	},

	Keybind = {'RightShift'},

	PlaceID = game.PlaceId,
}

if shared.PinappleScriptLoaded then
	warn'already loaded bruv'
else
	shared.PinappleScriptLoaded = true

	local cloneref = cloneref or function(obj)
		return obj
	end

	local HttpService = cloneref(game:GetService('HttpService'))
	local Players = cloneref(game:GetService('Players'))
	local TextChatService = cloneref(game:GetService('TextChatService'))
	local TweenService = cloneref(game:GetService('TweenService'))
	local UserInputService = cloneref(game:GetService('UserInputService'))
	local RunService = cloneref(game:GetService('RunService'))

	local CoreGui
	if RunService:IsStudio() then
		CoreGui = Players.LocalPlayer.PlayerGui
	else
		CoreGui = cloneref(game:GetService('CoreGui'))
	end

	if not shared.PineappleScriptUninjected then
		shared.PineappleScriptUninjected = false
	end

	local ConfigsFolder =  "pineapple/configs"
	local GameConfig = "pineapple/configs/" ..game.PlaceId
	local Config = {Library = {ModuleButton = {}, MiniModule = {}, Slider = {}, TextIndicator = {}, Picker = {}}}

	if not isfolder(ConfigsFolder) then makefolder(ConfigsFolder) end
	if not isfolder(GameConfig) then makefolder(GameConfig) end
	if isfile(GameConfig) then
		local GameConfig_Config = readfile(GameConfig)
		if GameConfig_Config and GameConfig_Config ~= "" then
			local Success, Settings = pcall(HttpService.JSONDecode, HttpService, GameConfig_Config)
			if Success and Settings then
				Config = Settings
			end
		end
	end

	TextChatService.OnIncomingMessage = function(Message)
		local Properties = Instance.new('TextChatMessageProperties')

		if Library['Whitelist'] and not shared.PineappleScriptUninjected and Library['Whitelist'][Message.TextSource.UserId].Allowed == true and Library['Whitelist'][Message.TextSource.UserId].Blacklisted == false then
			task.spawn(function()
				Properties.PrefixText = '<font color="#' .. Library['Whitelist'][Message.TextSource.UserId].Color:ToHex() .. '">' .. "[" .. Library['Whitelist'][Message.TextSource.UserId].Tag .. "]" .. '</font>' .. " " .. Properties.PrefixText
			end)
		end

		return Properties
	end

	local characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ[]\\/.,!@#$%^&*()-_=+{}|;:'\"<>?~`"

	local RandomGenerator = Random.new()

	function Generate(Characters: number) : string
		local list = {}
		for i=1, Characters do
			local RandomNumber = RandomGenerator:NextInteger(1, #characters)
			table.insert(list, characters:sub(RandomNumber, RandomNumber))
		end
		return table.concat(list)
	end

	local ScreenGui = Instance.new('ScreenGui', CoreGui)
	ScreenGui.Name = Generate(12)
	ScreenGui.ResetOnSpawn = false

	local gui = Instance.new('ScreenGui')
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	gui.Parent = CoreGui
	local tooltipUI = Instance.new('Frame')
	tooltipUI.Name = 'tooltipUI'
	tooltipUI.ZIndex = 9999
	tooltipUI.Size = UDim2.fromScale(1, 1)
	tooltipUI.BackgroundTransparency = 1
	tooltipUI.Parent = gui
	tooltip = Instance.new('TextLabel')
	tooltip.Name = 'Tooltip'
	tooltip.Position = UDim2.fromScale(-1, -1)
	tooltip.ZIndex = 999
	tooltip.BackgroundColor3 = Color3.fromRGB(0.0819608, 0.0788084, 0.0819608)
	tooltip.Visible = false
	tooltip.Text = ''
	tooltip.TextColor3 = Color3.fromRGB(235, 235, 235)
	tooltip.TextSize = 26
	tooltip.FontFace = Font.fromEnum(Enum.Font.Arial, Enum.FontWeight.Bold)
	tooltip.Parent = tooltipUI
	scale = Instance.new('UIScale')
	scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.6)
	scale.Parent = tooltipUI

	local fontsize = Instance.new('GetTextBoundsParams')
	fontsize.Width = math.huge

	function getfontsize(text, size, font)
		fontsize.Text = text
		fontsize.Size = size
		if typeof(font) == 'Font' then
			fontsize.Font = font
		end
		return game:GetService('TextService'):GetTextBoundsAsync(fontsize)
	end

	function addTooltip(gui, text)
		if not text then return end

		local function tooltipMoved(x, y)
			local right = x + 16 + tooltip.Size.X.Offset > (scale.Scale * 1920)
			tooltip.Position = UDim2.fromOffset(
				(right and x - (tooltip.Size.X.Offset * scale.Scale) - 16 or x + 16) / scale.Scale,
				((y + 11) - (tooltip.Size.Y.Offset)) / scale.Scale
			)
			tooltip.Visible = true
		end

		gui.MouseEnter:Connect(function(x, y)
			local tooltipSize = getfontsize(text, tooltip.TextSize, Font.fromEnum(Enum.Font.Arial, Enum.FontWeight.Bold))
			tooltip.Size = UDim2.fromOffset(tooltipSize.X + 10, tooltipSize.Y + 10)
			tooltip.Text = text
			tooltipMoved(x, y)
		end)
		gui.MouseMoved:Connect(tooltipMoved)
		gui.MouseLeave:Connect(function()
			tooltip.Visible = false
		end)
	end

	function MakeDraggable(object)
		local dragging, dragInput, dragStart, startPos

		local function update(input)
			local delta = input.Position - dragStart
			object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end

		object.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = object.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		object.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end

	local notifMainFrame = nil
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		if notifMainFrame == nil then
			notifMainFrame = Instance.new('ScrollingFrame')
			notifMainFrame.Parent = ScreenGui
			notifMainFrame.Active = true
			notifMainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			notifMainFrame.BackgroundTransparency = 1
			notifMainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notifMainFrame.BorderSizePixel = 0
			notifMainFrame.Size = UDim2.new(1, 0, 1, 0)
			notifMainFrame.CanvasPosition = Vector2.new(240, 0)
			notifMainFrame.CanvasSize = UDim2.new(1.60000002, 0, 0, 0)
			notifMainFrame.ScrollBarThickness = 8
			notifMainFrame.Visible = true
		end
	elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
		if notifMainFrame == nil then
			notifMainFrame = Instance.new('Frame')
			notifMainFrame.Parent = ScreenGui
			notifMainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			notifMainFrame.BackgroundTransparency = 1
			notifMainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notifMainFrame.Size = UDim2.new(1, 0, 1, 0)
			notifMainFrame.Visible = true
		end
	end

	local NotifFrame = Instance.new('Frame', notifMainFrame)
	NotifFrame.BackgroundTransparency = 1
	NotifFrame.Position = UDim2.new(0.73, 0,0, 0)
	NotifFrame.Size = UDim2.new(0, 313,0, 615)
	NotifFrame.ZIndex = 2

	local uilistLayout_notif = Instance.new('UIListLayout', NotifFrame)
	uilistLayout_notif.FillDirection = Enum.FillDirection.Vertical
	uilistLayout_notif.SortOrder = Enum.SortOrder.LayoutOrder
	uilistLayout_notif.VerticalAlignment = Enum.VerticalAlignment.Bottom
	uilistLayout_notif.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uilistLayout_notif.Padding = UDim.new(0, 8)

	function Library:notif(title, desc, duration, imagetype)
		local notificationFrame = Instance.new('Frame', NotifFrame)
		notificationFrame:SetAttribute('duration', duration) 
		notificationFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
		notificationFrame.BackgroundTransparency = 0.2
		notificationFrame.BorderSizePixel = 0
		notificationFrame.Size = UDim2.new(0,357,0,81)

		local notifUICorner = Instance.new('UICorner', notificationFrame)
		notifUICorner.CornerRadius = UDim.new(0, 8)

		local durationStart = UDim2.new(0, 0,0, 1)
		local durationEnd = UDim2.new(0, 357,0, 1)

		local durationLine = Instance.new('Frame', notificationFrame)
		durationLine.BorderSizePixel = 0
		durationLine.BackgroundTransparency = 0
		durationLine.BackgroundColor3 = Color3.fromRGB(255,255,255)
		durationLine.Position = UDim2.new(0,2,0.97,0)
		durationLine.Size = durationStart

		local image = Instance.new('ImageLabel', notificationFrame)
		image.BackgroundTransparency = 1
		image.Position = UDim2.new(-0.051, 0, -0.223, 0)
		image.Size = UDim2.new(0,78, 0, 73)

		if imagetype == nil then
			image.Image = 'rbxassetid://14368324807'
		elseif string.lower(imagetype) == 'info' or string.lower(imagetype) == 'information' then
			image.Image = 'rbxassetid://14368324807'
		elseif string.lower(imagetype) == 'warning' then
			image.Image = 'rbxassetid://14368361552'
		elseif string.lower(imagetype) == 'error' then
			image.Image = 'rbxassetid://14368301329'
		end

		local titleText = Instance.new('TextLabel', notificationFrame)
		titleText.BackgroundTransparency = 1
		titleText.Text = title
		titleText.Name = 'title'
		titleText.Position = UDim2.new(0.105,0,0.108,0)
		titleText.Size = UDim2.new(0, 200,0,18)
		titleText.FontFace = Font.fromEnum(Enum.Font.Arimo, Enum.FontWeight.Regular)
		titleText.TextSize = 18
		titleText.TextColor3 = Color3.fromRGB(255,255,255)
		titleText.TextXAlignment = Enum.TextXAlignment.Left

		local InformationText = Instance.new('TextLabel', notificationFrame)
		InformationText.BackgroundTransparency = 1
		InformationText.Name = 'info'
		InformationText.Text = desc
		InformationText.Position = UDim2.new(0.144, 0,0.431, 0)
		InformationText.Size = UDim2.new(0, 304,0, 28)
		InformationText.FontFace = Font.fromEnum(Enum.Font.Arimo, Enum.FontWeight.Regular)
		InformationText.TextSize = 18
		InformationText.TextColor3 = Color3.fromRGB(200,200,200)
		InformationText.TextXAlignment = Enum.TextXAlignment.Left
	end

	NotifFrame.ChildAdded:Connect(function(notificationFrame)
		local durationEnd = UDim2.new(0, 357,0, 1)
		local durationLine = notificationFrame:FindFirstChildOfClass('Frame')
		local titleText = notificationFrame:WaitForChild('title')
		local InformationText = notificationFrame:WaitForChild('info')
		local image = notificationFrame:FindFirstChildOfClass('ImageLabel')
		TweenService:Create(durationLine,TweenInfo.new(notificationFrame:GetAttribute('duration')), {Size = durationEnd}):Play()
		task.wait(notificationFrame:GetAttribute('duration'))
		TweenService:Create(notificationFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
		TweenService:Create(durationLine, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
		TweenService:Create(titleText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
		TweenService:Create(InformationText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
		TweenService:Create(image, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
	end)

	function Library:Uninject()
		if shared.PinappleScriptLoaded and not shared.PineappleScriptUninjected then
			shared.PineappleScriptUninjected = true
		end
		writefile(GameConfig, HttpService:JSONEncode(Config))
	end

	Players.PlayerRemoving:Connect(function(player)
		if player == Players.LocalPlayer then
			writefile(GameConfig, HttpService:JSONEncode(Config))
		end
	end)

	game:BindToClose(function()
		writefile(GameConfig, HttpService:JSONEncode(Config))
	end)

	spawn(function()
		RunService.RenderStepped:Connect(function()
			if ScreenGui then
				if shared.PineappleScriptUninjected then
					task.wait(1.2)
					ScreenGui:Destroy()
					shared.PineappleScriptUninjected = false
					shared.PinappleScriptLoaded = false
					shared.pineapple = nil
				end
			end
		end)
	end)

	local MainFrame = nil
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		if MainFrame == nil then
			MainFrame = Instance.new("ScrollingFrame")
			MainFrame.Parent = ScreenGui
			MainFrame.Active = true
			MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MainFrame.BackgroundTransparency = 1
			MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainFrame.BorderSizePixel = 0
			MainFrame.Size = UDim2.new(1, 0, 1, 0)
			MainFrame.CanvasPosition = Vector2.new(240, 0)
			MainFrame.CanvasSize = UDim2.new(1.60000002, 0, 0, 0)
			MainFrame.ScrollBarThickness = 8
			MainFrame.Visible = true
		end
	elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
		if MainFrame == nil then
			MainFrame = Instance.new("Frame")
			MainFrame.Parent = ScreenGui
			MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MainFrame.BackgroundTransparency = 1
			MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainFrame.Size = UDim2.new(1, 0, 1, 0)
			MainFrame.Visible = true
		end
	end

	spawn(function()
		local OldX = 0
		if MainFrame ~= nil and MainFrame.Parent then
			for _, child in ipairs(MainFrame:GetChildren()) do
				if child:IsA("GuiObject") then
					child.Position = UDim2.new(0, OldX, 0, 0)
					OldX = OldX + child.Size.X.Offset + 18
				end
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(Input, gameProcessed)
		if gameProcessed then return end
		for _, keyBind in pairs(Library["Keybind"]) do
			if Input.KeyCode == Enum.KeyCode[keyBind] then
				for _, v in ipairs(MainFrame:GetDescendants()) do
					if v:IsA("TextLabel") or v:IsA("Frame") or v:IsA("ImageButton") or v:IsA("TextBox") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame") then
						if v.Name ~= "LibraryText" then
							v.Visible = not v.Visible
						end
					end
				end
			end
			task.wait()
			tooltip.Visible = false
		end
	end)

	local LibraryText = nil

	if Library.Visual.Watermark then
		LibraryText = Instance.new('TextLabel', MainFrame)
		LibraryText.Name = 'LibraryText'
		LibraryText.BackgroundTransparency = 1
		LibraryText.FontFace = Font.new("rbxasset://fonts/families/TitilliumWeb.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		LibraryText.Size = UDim2.new(0, 200,0, 35)
		LibraryText.Position = UDim2.new(0.014, 0,0.028, 0)
		LibraryText.TextSize = 41
		LibraryText.TextScaled = false
		LibraryText.TextWrapped = true
		LibraryText.TextXAlignment = Enum.TextXAlignment.Left
		LibraryText.TextYAlignment = Enum.TextYAlignment.Center
		LibraryText.TextColor3 = Color3.fromRGB(255, 255, 10)
		LibraryText.Text = 'pineapple'
		LibraryText.ZIndex = 99
		LibraryText.LayoutOrder = 0
		LibraryText.Interactable = false
		LibraryText.Visible = true
	end

	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
		local LibraryTextImage = Instance.new('ImageButton')
		if LibraryText then
			LibraryTextImage.Parent = LibraryText
		else
			LibraryTextImage.Parent = MainFrame
		end
		LibraryTextImage.BackgroundTransparency = 1
		LibraryTextImage.Name = 'ImageLabel'
		LibraryTextImage.Size = UDim2.new(0, 68 ,0, 59)
		LibraryTextImage.Position = UDim2.new(0.45, 0, -0.4, 0)
		LibraryTextImage.Image = 'rbxassetid://126819632241697'
		LibraryTextImage.ImageColor3 = Color3.fromRGB(255,255,255)

		LibraryTextImage.MouseButton1Click:Connect(function()
			for _, v in ipairs(MainFrame:GetDescendants()) do
				if v:IsA("TextLabel") or v:IsA("Frame") or v:IsA("ImageButton") or v:IsA("TextBox") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame") then
					if v.Name ~= "LibraryText" then
						v.Visible = not v.Visible
					end
				end
			end
			task.wait()
			tooltip.Visible = false
		end)
	else
		if Library.Visual.Watermark then
			local LibraryTextImage = Instance.new('ImageLabel', LibraryText)
			LibraryTextImage.BackgroundTransparency = 1
			LibraryTextImage.Name = 'ImageLabel'
			LibraryTextImage.Size = UDim2.new(0, 68 ,0, 59)
			LibraryTextImage.Position = UDim2.new(0.45, 0, -0.4, 0)
			LibraryTextImage.Image = 'rbxassetid://126819632241697'
			LibraryTextImage.ImageColor3 = Color3.fromRGB(255,255,255)
		end
	end

	function Library:TargetInfo(Hidden, Target)
		local TargetInfo = {}

		local TargetInfoFrame = Instance.new("Frame", ScreenGui)
		TargetInfoFrame.BackgroundTransparency = 0.4
		TargetInfoFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		TargetInfoFrame.Position = UDim2.new(0,713,0,310)
		TargetInfoFrame.Size = UDim2.new(0,252,0,82)
		TargetInfoFrame.BorderSizePixel = 0

		MakeDraggable(TargetInfoFrame)

		local TargetInfoFrame_UICorner = Instance.new("UICorner", TargetInfoFrame)
		TargetInfoFrame_UICorner.CornerRadius = UDim.new(0,15)

		local TargetInfoFrame_UIStroke = Instance.new("UIStroke", TargetInfoFrame)
		TargetInfoFrame_UIStroke.Thickness = 3
		TargetInfoFrame_UIStroke.Color = Color3.fromRGB(255,157,0)
		TargetInfoFrame_UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		TargetInfoFrame_UIStroke.LineJoinMode = Enum.LineJoinMode.Round

		local TargetName = Instance.new("TextLabel", TargetInfoFrame)
		TargetName.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
		TargetName.RichText = true
		TargetName.TextColor3 = Color3.fromRGB(255,255,255)
		TargetName.TextSize = 17
		TargetName.BackgroundTransparency = 1
		TargetName.TextScaled = false
		TargetName.TextWrapped = true
		TargetName.TextXAlignment = Enum.TextXAlignment.Left
		TargetName.Text = ''
		TargetName.Size = UDim2.new(0, 171,0, 29)
		TargetName.Position = UDim2.new(0.278, 0,0.024, 0)

		local TargetInfoFrame__ = Instance.new("Frame", TargetInfoFrame)
		TargetInfoFrame__.BackgroundColor3 = Color3.fromRGB(15,15,15)
		TargetInfoFrame__.BackgroundTransparency = 0.8
		TargetInfoFrame__.BorderSizePixel = 0
		TargetInfoFrame__.Position = UDim2.new(0.278,0,0.527,0)
		TargetInfoFrame__.Size = UDim2.new(0,142,0,13)

		local TargetImage = Instance.new("ImageLabel", TargetInfoFrame__)
		TargetImage.BackgroundTransparency = 1
		TargetImage.BorderSizePixel = 0
		TargetImage.Position = UDim2.new(-0.437,0,-3,0)
		TargetImage.Size = UDim2.new(0,62,0,61)
		TargetImage.ImageColor3 = Color3.fromRGB(255,255,255)
		TargetImage.Image = "rbxassetid://0"

		local TargetInfoFrame_UICorner__ = Instance.new("UICorner", TargetInfoFrame__)
		TargetInfoFrame_UICorner__.CornerRadius = UDim.new(0,8)

		local Healthbar = Instance.new("Frame", TargetInfoFrame__)
		Healthbar.BackgroundColor3 = Color3.fromRGB(249,187,0)
		Healthbar.BorderSizePixel = 0
		Healthbar.BackgroundTransparency = 0
		Healthbar.Position = UDim2.new(0,0,0,0)
		Healthbar.Size = UDim2.new(1.15,0,1,0)

		local TargetInfoFrame_UICorner___ = Instance.new("UICorner", Healthbar)
		TargetInfoFrame_UICorner___.CornerRadius = UDim.new(0,8)

		local UIGradient = Instance.new("UIGradient", Healthbar)
		UIGradient.Rotation = 90
		UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,213,0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 247, 201)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))})

		local HealthText = Instance.new("TextLabel", TargetInfoFrame__)
		HealthText.BackgroundTransparency = 1
		HealthText.Position = UDim2.new(0,0,0,0)
		HealthText.Size = UDim2.new(1.15,0,1,0)
		HealthText.TextColor3 = Color3.fromRGB(255,255,255)
		HealthText.TextSize = 18
		HealthText.TextScaled = false
		HealthText.TextWrapped = true
		HealthText.Text = ''
		HealthText.FontFace = Font.new("rbxasset://fonts/families/Source Sans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

		local TargetInfoFrame_UICorner____ = Instance.new("UICorner", HealthText)
		TargetInfoFrame_UICorner____.CornerRadius = UDim.new(0,8)

		function TargetInfo:Hide(bool)
			if bool then
				TargetInfoFrame.Visible = false
			else
				TargetInfoFrame.Visible = true
			end
		end

		local oldTarget = nil

		if Target and Target:IsA("Player") then
			oldTarget = Target
			TargetImage.Image = "rbxthumb://type=AvatarHeadShot&id="..Target.UserId.."&w=420&h=420"
			TargetName.Text = '<font color="#ffe100">'..Target.Name..'</font>'

			local TargetChar = Target.Character or Target.CharacterAdded:Wait()
			local Humanoid = TargetChar:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				local function UpdateHealth()
					if Target ~= oldTarget then
						Target = nil
						oldTarget = nil
						return
					end
					HealthText.Text = Humanoid.Health
					Healthbar:TweenSize(UDim2.new((Humanoid.Health / Humanoid.MaxHealth), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, .1, true)
					if Humanoid.Health <= 0 then
						TargetInfo:Hide(true)
					end
				end

				UpdateHealth()
				Humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(UpdateHealth)
				Humanoid:GetPropertyChangedSignal("Health"):Connect(UpdateHealth)
			end
		end

		if Hidden then
			TargetInfoFrame.Visible = false
		else
			TargetInfoFrame.Visible = true
		end

		function TargetInfo:SetTarget(target)
			if target and target:IsA("Player") then
				oldTarget = target
				TargetImage.Image = "rbxthumb://type=AvatarHeadShot&id="..Target.UserId.."&w=420&h=420"
				TargetName.Text = '<font color="#ffe100">'..target.Name..'</font>'

				local TargetChar = target.Character or target.CharacterAdded:Wait()
				local Humanoid = TargetChar:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					local function UpdateHealth()
						if target ~= oldTarget then
							target = nil
							oldTarget = nil
							return
						end
						HealthText.Text = Humanoid.Health
						Healthbar:TweenSize(UDim2.new((Humanoid.Health / Humanoid.MaxHealth), 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, .1, true)
						if Humanoid.Health <= 0 then
							TargetInfo:Hide(true)
						end
					end

					UpdateHealth()
					Humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(UpdateHealth)
					Humanoid:GetPropertyChangedSignal("Health"):Connect(UpdateHealth)
				end
			end
		end

		shared.TargetInfo = TargetInfo
	end

	function Library:SessionInfo(PathToKills,PathToWins, PathToBedBreaks)
		if shared.SessionInfo then
			return {}
		else
			shared.SessionInfo = true
			local SessionInfo = {}

			local SessionInfoFrame = Instance.new("Frame", ScreenGui)
			SessionInfoFrame.Position = UDim2.new(0.006,0, 0.475,0)
			SessionInfoFrame.Size = UDim2.new(0,265,0,123)
			SessionInfoFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
			SessionInfoFrame.BackgroundTransparency = 0.4
			SessionInfoFrame.BorderSizePixel = 0

			MakeDraggable(SessionInfoFrame)

			local BarFrame_Session = Instance.new("Frame", SessionInfoFrame)
			BarFrame_Session.BackgroundColor3 = Color3.fromRGB(255,255,0)
			BarFrame_Session.BackgroundTransparency = 0
			BarFrame_Session.BorderSizePixel = 0
			BarFrame_Session.Position = UDim2.new(-0.001,0,-0.003,0) 
			BarFrame_Session.Size = UDim2.new(0,265,0,5)

			local SessionInfoTitle = Instance.new("TextLabel", SessionInfoFrame)
			SessionInfoTitle.BackgroundTransparency = 1
			SessionInfoTitle.Position = UDim2.new(0.11,0,0.033,0)
			SessionInfoTitle.Size = UDim2.new(0,207,0,26)
			SessionInfoTitle.FontFace = Font.fromEnum(Enum.Font.Arimo)
			SessionInfoTitle.Text = "Session info"
			SessionInfoTitle.TextColor3 = Color3.fromRGB(255,255,255)
			SessionInfoTitle.TextSize = 18
			SessionInfoTitle.TextWrapped = true

			local KillsValueText = Instance.new("TextLabel", SessionInfoFrame)
			KillsValueText.BackgroundTransparency = 1
			KillsValueText.Position = UDim2.new(-0.002, 0,0.301, 0)
			KillsValueText.Size = UDim2.new(0,265,0,26)
			KillsValueText.FontFace = Font.fromEnum(Enum.Font.Arimo)
			if PathToKills then
				KillsValueText.Text = "Kills: "..PathToKills.Value
			else
				KillsValueText.Text = "Kills: "
			end
			KillsValueText.TextColor3 = Color3.fromRGB(255,255,255)
			KillsValueText.TextSize = 16
			KillsValueText.TextXAlignment = Enum.TextXAlignment.Left
			KillsValueText.TextWrapped = true

			local WinsValueText = Instance.new("TextLabel", SessionInfoFrame)
			WinsValueText.BackgroundTransparency = 1
			WinsValueText.Position = UDim2.new(-0.002, 0,0.52, 0)
			WinsValueText.Size = UDim2.new(0,265,0,26)
			WinsValueText.FontFace = Font.fromEnum(Enum.Font.Arimo)
			if PathToWins then
				WinsValueText.Text = "Wins: "..PathToWins.Value
			else
				WinsValueText.Text = "Wins: "
			end
			WinsValueText.TextColor3 = Color3.fromRGB(255,255,255)
			WinsValueText.TextSize = 16
			WinsValueText.TextXAlignment = Enum.TextXAlignment.Left
			WinsValueText.TextWrapped = true

			local BedsBrokenValueText = Instance.new("TextLabel", SessionInfoFrame)
			BedsBrokenValueText.BackgroundTransparency = 1
			BedsBrokenValueText.Position = UDim2.new(-0.002, 0,0.735, 0)
			BedsBrokenValueText.Size = UDim2.new(0,265,0,26)
			BedsBrokenValueText.FontFace = Font.fromEnum(Enum.Font.Arimo)
			if PathToBedBreaks then
				BedsBrokenValueText.Text = "Beds Broken: "..PathToBedBreaks.Value
			else
				BedsBrokenValueText.Text = "Beds Broken: "
			end
			BedsBrokenValueText.TextColor3 = Color3.fromRGB(255,255,255)
			BedsBrokenValueText.TextSize = 16
			BedsBrokenValueText.TextXAlignment = Enum.TextXAlignment.Left
			BedsBrokenValueText.TextWrapped = true

			if PathToKills then
				PathToKills:GetPropertyChangedSignal("Value"):Connect(function()
					if PathToKills then
						KillsValueText.Text = "Kills: "..PathToKills.Value
					else
						KillsValueText.Text = "Kills: "
					end
				end)
			end

			if PathToWins then
				PathToWins:GetPropertyChangedSignal("Value"):Connect(function()
					if PathToWins then
						WinsValueText.Text = "Wins: "..PathToWins.Value
					else
						WinsValueText.Text = "Wins: "
					end
				end)
			end

			if PathToBedBreaks then
				PathToBedBreaks:GetPropertyChangedSignal("Value"):Connect(function()
					if PathToBedBreaks then
						BedsBrokenValueText.Text = "Beds Broken: "..PathToBedBreaks.Value
					else
						BedsBrokenValueText.Text = "Beds Broken: "
					end
				end)
			end

			function SessionInfo:Remove()
				SessionInfoFrame:Remove()
				shared.SessionInfo = false
			end
			return SessionInfo
		end
	end

	local HudFrame = Instance.new("Frame")
	HudFrame.Parent = ScreenGui
	HudFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HudFrame.BackgroundTransparency = 1
	HudFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HudFrame.BorderSizePixel = 0
	HudFrame.Size = UDim2.new(1, 0, 1, 0)

	local ArrayTable = {}
	local ArrayFrame = Instance.new("Frame")
	ArrayFrame.Parent = HudFrame
	ArrayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ArrayFrame.BackgroundTransparency = 1.000
	ArrayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ArrayFrame.BorderSizePixel = 0
	ArrayFrame.Position = UDim2.new(0.819999993, 0, 0.0399999991, 0)
	ArrayFrame.Size = UDim2.new(0.162, 0, 0.930000007, 0)

	local UIListLayout_4 = Instance.new("UIListLayout")
	UIListLayout_4.Parent = ArrayFrame
	UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Right

	spawn(function()
		RunService.RenderStepped:Connect(function()	
			if HudFrame and ArrayFrame then
				if Library.Visual.Arraylist then
					ArrayFrame.Visible = true
				else
					ArrayFrame.Visible = false
				end
			end
		end)
	end)

	local function AddArray(name)
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Parent = ArrayFrame
		TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextTransparency = 1
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.Text = name

		local bar = Instance.new("Frame")
		bar.Size = UDim2.new(0, 0, 1, 0)
		bar.BackgroundColor3 = Color3.new(0.670588, 0, 0.556863)
		bar.ZIndex = 1
		bar.BorderColor3 = Color3.fromRGB(255, 100, 100)
		bar.BorderSizePixel = 0
		bar.Parent = TextLabel

		local function updateBar()
			bar.AnchorPoint = Vector2.new(1, 0)
			bar.Size = UDim2.new(
				TextLabel.Size.X.Scale,
				1, 
				TextLabel.Size.Y.Scale,
				TextLabel.Size.Y.Offset
			)
			bar.Position = UDim2.new(
				TextLabel.Position.X.Scale, 
				TextLabel.Position.X.Offset + TextLabel.Size.X.Offset + 1, 
				TextLabel.Position.Y.Scale,
				TextLabel.Position.Y.Offset
			)
		end

		updateBar()
		TextLabel:GetPropertyChangedSignal("Size"):Connect(updateBar)
		TextLabel:GetPropertyChangedSignal("Position"):Connect(updateBar)

		TextLabel.TextColor3 = Color3.new(0.447059, 0, 0.670588)
		TextLabel.TextScaled = true
		TextLabel.TextSize = 18
		TextLabel.TextWrapped = true
		TextLabel.ZIndex = -1
		TextLabel.TextXAlignment = Enum.TextXAlignment.Right
		TweenService:Create(TextLabel, TweenInfo.new(1.8), {TextTransparency = 0, BackgroundTransparency = 0.750}):Play()

		local TextGradient = Instance.new("UIGradient")
		TextGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
		TextGradient.Parent = TextLabel

		local NewWidth = game.TextService:GetTextSize(name, 18, Enum.Font.SourceSans, Vector2.new(0, 0)).X
		local NewSize = UDim2.new(0.01, game.TextService:GetTextSize(name , 18, Enum.Font.SourceSans, Vector2.new(0,0)).X, 0,20)
		if name == "" then
			NewSize = UDim2.fromScale(0,0)
		end

		TextLabel.Position = UDim2.new(1, -NewWidth, 0, 0)
		TextLabel.Size = NewSize
		table.insert(ArrayTable,TextLabel)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text .. "  ", 18, Enum.Font.SourceSans, Vector2.new(0,20)).X > game.TextService:GetTextSize(b.Text .. "  ", 18, Enum.Font.SourceSans,Vector2.new(0,20)).X end)
		for i,v in ipairs(ArrayTable) do
			v.LayoutOrder = i
		end
	end

	local function RemoveArray(name)
		table.sort(ArrayTable,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,20)).X > game.TextService:GetTextSize(b.Text.."  ",18,Enum.Font.SourceSans,Vector2.new(0,20)).X end)
		local c = 0
		for i,v in ipairs(ArrayTable) do
			c += 1
			if (v.Text == name) then
				v:Destroy()
				table.remove(ArrayTable,c)
			else
				v.LayoutOrder = i
			end
		end
	end

	function Library:CreateTab(Name, Icon, IconColor)
		local PropertiesToggle = {}

		if Name == nil then Name = "" end
		if Icon == nil then Icon = "rbxassetid://0" end
		if IconColor == nil then IconColor = Color3.fromRGB(255,255,255) end		

		local Tab = Instance.new('Frame', MainFrame)
		Tab.BackgroundTransparency = 0.03
		Tab.BorderSizePixel = 0
		Tab.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
		--Tab.Position = UDim2.new(0.014,0,0.081,0)
		Tab.Size = UDim2.new(0,185,0,25)
		Tab.ZIndex = 2
		Tab.Visible = true

		if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
			MakeDraggable(Tab)
		end

		local TabTitle = Instance.new('TextLabel', Tab)
		TabTitle.BackgroundTransparency = 1
		TabTitle.Position = UDim2.new(0,5,0,0)
		TabTitle.Size = UDim2.new(0,145,1,0)
		TabTitle.Visible = true
		TabTitle.ZIndex = 2
		TabTitle.FontFace = Font.fromEnum(Enum.Font.Arial, Enum.FontWeight.Regular)
		TabTitle.Text = Name
		TabTitle.TextColor3 = Color3.fromRGB(255,255,255)
		TabTitle.TextSize = 15
		TabTitle.TextStrokeTransparency = 1
		TabTitle.TextWrapped = true
		TabTitle.TextXAlignment = Enum.TextXAlignment.Left
		TabTitle.TextYAlignment = Enum.TextYAlignment.Center
		TabTitle.BorderSizePixel = 0

		local ImageLabel = Instance.new('ImageLabel')
		ImageLabel.ZIndex = 2
		ImageLabel.Parent = Tab
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0, 172, 0.5, 0)
		ImageLabel.Size = UDim2.new(0, 18, 0, 18)
		ImageLabel.Image = 'rbxassetid://' .. Icon
		ImageLabel.ImageColor3 = IconColor

		local TogglesList = Instance.new('Frame')
		TogglesList.ZIndex = 2
		TogglesList.Parent = Tab
		TogglesList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TogglesList.BackgroundTransparency = 1
		TogglesList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TogglesList.BorderSizePixel = 0
		TogglesList.Position = UDim2.new(0, 0, 1, 0)
		TogglesList.Size = UDim2.new(1, 0, 0, 0)

		local UIListLayout = Instance.new('UIListLayout')
		UIListLayout.Parent = TogglesList
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local BarFrame = Instance.new("Frame", TogglesList)
		BarFrame.BackgroundTransparency = 1
		BarFrame.Size = UDim2.new(0, 185,0, 4.8)

		local BarFrame2 = Instance.new("Frame", BarFrame)
		BarFrame2.BackgroundTransparency = 0
		BarFrame2.BorderSizePixel = 0
		BarFrame2.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		BarFrame2.Position = UDim2.new(0,0,0,0)
		BarFrame2.Size = UDim2.new(0, 185,0, 4.8)

		function PropertiesToggle:CreateModule(ToggleButton)
			local dropdownTable = {}
			local DropdownToggles = {}

			ToggleButton = {
				Name = ToggleButton.Name,
				ToolTip = ToggleButton.ToolTip,
				Keybind = ToggleButton.Keybind or 'Unknown',
				Enabled = ToggleButton.Enabled or false,
				AutoDisable = ToggleButton.AutoDisable or false,
				Callback = ToggleButton.Callback or function() end
			}

			if not Config.Library.ModuleButton[ToggleButton.Name] then
				Config.Library.ModuleButton[ToggleButton.Name] = {
					ToolTip = ToggleButton.ToolTip,
					Keybind = ToggleButton.Keybind,
					Enabled = ToggleButton.Enabled,
				}
			else
				ToggleButton.Enabled = Config.Library.ModuleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = Config.Library.ModuleButton[ToggleButton.Name].Keybind
				ToggleButton.ToolTip = Config.Library.ModuleButton[ToggleButton.Name].ToolTip
			end

			local toggleButton = Instance.new('TextButton', TogglesList)
			toggleButton.Text = ''
			toggleButton.BorderSizePixel = 0
			toggleButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
			toggleButton.Size = UDim2.new(1, 0,0, 25)

			if ToggleButton.ToolTip then
				addTooltip(toggleButton, ToggleButton.ToolTip)
			end

			local uigrad = Instance.new('UIGradient', toggleButton)
			uigrad.Enabled = false
			uigrad.Rotation = 0
			uigrad.Offset = Vector2.new(0,0)
			uigrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255,247,1))})

			local toggleName = Instance.new('TextLabel', toggleButton)
			toggleName.BackgroundTransparency = 1
			toggleName.BorderSizePixel = 0
			if Icon == nil or Icon == "rbxassetid://0" then toggleName.Position = UDim2.new(0,5,0,0) else toggleName.Position = UDim2.new(0, 28,0, 0) end
			toggleName.Size = UDim2.new(0,145,1,0)
			toggleName.Visible = true
			toggleName.FontFace = Font.fromEnum(Enum.Font.Arimo, Enum.FontWeight.Regular)
			toggleName.TextColor3 = Color3.fromRGB(255,255,255)
			toggleName.TextScaled = false
			toggleName.TextSize = 15
			toggleName.TextWrapped = true
			toggleName.Text = ToggleButton.Name
			toggleName.TextXAlignment = Enum.TextXAlignment.Left
			toggleName.TextYAlignment = Enum.TextYAlignment.Center

			local function ToggleButtonClicked()
				if ToggleButton.Enabled then
					Config.Library.ModuleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					Library:notif("Pineapple", "Toggled "..ToggleButton.Name, 2.5, "info")
					AddArray(ToggleButton.Name)
					TweenService:Create(toggleButton, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(227, 201, 1)}):Play()
					TweenService:Create(uigrad, TweenInfo.new(0.4), {Enabled = true}):Play()
				else
					Config.Library.ModuleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					Library:notif("Pineapple", "UnToggled "..ToggleButton.Name, 2.5, "info")
					RemoveArray(ToggleButton.Name)
					TweenService:Create(toggleButton, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(45,45,45)}):Play()  
					TweenService:Create(uigrad, TweenInfo.new(0.4), {Enabled = false}):Play()
				end
			end

			local DropdownButton = Instance.new('TextButton', toggleButton)
			DropdownButton.AnchorPoint = Vector2.new(0.5,0.5)
			DropdownButton.BackgroundTransparency = 1
			DropdownButton.Position = UDim2.new(0, 173, 0.5, 0)
			DropdownButton.Size = UDim2.new(0,23,0,23)
			DropdownButton.ZIndex = 2
			DropdownButton.FontFace = Font.fromEnum(Enum.Font.SourceSans, Enum.FontWeight.Regular)
			DropdownButton.Text = '>'
			DropdownButton.TextColor3 = Color3.fromRGB(255,255,255)
			DropdownButton.TextScaled = true
			DropdownButton.TextWrapped = true

			local DropdownList = Instance.new('Frame')
			DropdownList.ZIndex = 2
			DropdownList.Parent = toggleButton
			DropdownList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownList.BackgroundTransparency = 1
			DropdownList.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownList.BorderSizePixel = 0
			DropdownList.Visible = false
			DropdownList.Position = UDim2.new(0, 0, 1, 0)
			DropdownList.Size = UDim2.new(1, 0, 0, 0)

			local UIListLayout = Instance.new('UIListLayout')
			UIListLayout.Parent = DropdownList
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			local ToggleMenu = Instance.new('Frame')
			ToggleMenu.Parent = TogglesList
			ToggleMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			--ToggleMenu.BackgroundTransparency = 1
			ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMenu.BorderSizePixel = 0
			ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
			ToggleMenu.Size = UDim2.new(1,0,0,25)
			ToggleMenu.Visible = false

			local UIListLayout = Instance.new('UIListLayout')
			UIListLayout.Parent = ToggleMenu
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			ToggleMenu.Size = UDim2.new(1,0,0,ToggleMenu.Size.Y.Offset + 25)
			local KeybindButton = Instance.new('TextButton', ToggleMenu)
			KeybindButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
			KeybindButton.BorderSizePixel = 0
			KeybindButton.Size = UDim2.new(1,0,0,25)
			KeybindButton.Visible = false
			KeybindButton.ZIndex = 2
			KeybindButton.FontFace = Font.fromEnum(Enum.Font.SourceSans, Enum.FontWeight.Regular)
			KeybindButton.Text = ''

			--local ToggleMenu = Instance.new("Frame")
			--ToggleMenu.Parent = TogglesList
			--ToggleMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			----ToggleMenu.BackgroundTransparency = 1
			--ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			--ToggleMenu.BorderSizePixel = 0
			--ToggleMenu.Position = UDim2.new(0, 0, 25, 0)
			--ToggleMenu.Size = UDim2.new(1,0,0,25)
			--ToggleMenu.Visible = false

			table.insert(DropdownToggles, KeybindButton)

			local keybindText = Instance.new('TextLabel', KeybindButton)
			keybindText.Text = 'Keybind'
			keybindText.TextColor3 = Color3.fromRGB(255,255,255)
			keybindText.FontFace = Font.fromEnum(Enum.Font.Arimo, Enum.FontWeight.Regular)
			keybindText.TextScaled = false
			keybindText.TextSize = 16
			keybindText.TextWrapped = true
			keybindText.BackgroundTransparency = 1
			keybindText.Position = UDim2.new(0,5,0,0)
			keybindText.Size = UDim2.new(0,145,1,0)
			keybindText.Visible = true
			keybindText.ZIndex = 2
			keybindText.TextXAlignment = Enum.TextXAlignment.Left

			local keybindTextbox = Instance.new('TextBox', KeybindButton)
			keybindTextbox.Text = ToggleButton.Keybind
			keybindTextbox.PlaceholderText = ''
			keybindTextbox.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
			keybindTextbox.TextColor3 = Color3.fromRGB(255,255,255)
			keybindTextbox.FontFace = Font.fromEnum(Enum.Font.SourceSans, Enum.FontWeight.Regular)
			keybindTextbox.TextScaled = false
			keybindTextbox.TextSize = 14
			keybindTextbox.TextWrapped = true
			keybindTextbox.BackgroundTransparency = 1
			keybindTextbox.Position = UDim2.new(0, 87,0, 0)
			keybindTextbox.Size = UDim2.new(0, 93,0, 25) -- 0,83,0,25
			keybindTextbox.Visible = true
			keybindTextbox.ZIndex = 2
			keybindTextbox.TextXAlignment = Enum.TextXAlignment.Right

			local KeybindText__ = Instance.new("TextLabel", toggleButton)
			KeybindText__.BackgroundTransparency = 1
			KeybindText__.Position = UDim2.new(0,90,0,-1)
			KeybindText__.TextXAlignment = Enum.TextXAlignment.Right
			KeybindText__.Size = UDim2.new(-0.387, 145,1, 0)
			KeybindText__.FontFace = Font.fromEnum(Enum.Font.Arimo)
			KeybindText__.Text = "["..ToggleButton.Keybind.."]"
			KeybindText__.TextColor3 = Color3.fromRGB(255,255,255)
			KeybindText__.TextSize = 14
			KeybindText__.TextWrapped = true

			task.spawn(function()
				RunService.RenderStepped:Connect(function()
					task.wait()
					if keybindTextbox:IsFocused() then
						KeybindText__.Text = "[".."...".."]"
					else
						KeybindText__.Text = "["..ToggleButton.Keybind.."]"
					end
				end)
			end)


			RunService.RenderStepped:Connect(function()
				if shared.PineappleScriptUninjected then
					ToggleButton.Keybind = 'Unknown'

					keybindTextbox.PlaceholderText = ''
					keybindTextbox.Text = ToggleButton.Keybind
				end
			end)

			UserInputService.InputBegan:Connect(function(Input, isTyping)
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if keybindTextbox:IsFocused() then
						ToggleButton.Keybind = Input.KeyCode.Name
						keybindTextbox.PlaceholderText = ''
						keybindTextbox.Text = Input.KeyCode.Name
						keybindTextbox:ReleaseFocus()

						Config.Library.ModuleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					elseif ToggleButton.Keybind == 'Backspace' then
						ToggleButton.Keybind = 'Unknown'
						keybindTextbox.Text = 'Unknown'
						keybindTextbox.PlaceholderText = ''

						Config.Library.ModuleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					end
					if not isTyping then
						if ToggleButton.Keybind ~= 'Unknown' then
							if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] then
								ToggleButton.Enabled = not ToggleButton.Enabled
								ToggleButtonClicked()

								if ToggleButton.Callback then
									ToggleButton.Callback(ToggleButton.Enabled)
								end
							end
						end
					end
				end
			end)

			keybindTextbox:GetPropertyChangedSignal("Text"):Connect(function()
				if #keybindTextbox.Text > 1 then
					local Character = string.split(keybindTextbox.Text, "")
					keybindTextbox.Text = string.upper(Character[1])
					ToggleButton.Keybind = string.upper(Character[1])
				end
			end)

			function dropdownTable:CreateMiniModule(MinitoggleProperties)
				MinitoggleProperties = {
					Name = MinitoggleProperties.Name or '',
					Enabled = MinitoggleProperties.Enabled or false,
					Callback = MinitoggleProperties.Callback or function() end
				}

				if not Config.Library.MiniModule[MinitoggleProperties.Name] then
					Config.Library.MiniModule[MinitoggleProperties.Name] = {
						Enabled = MinitoggleProperties.Enabled,
					}
				else
					MinitoggleProperties.Enabled = Config.Library.MiniModule[MinitoggleProperties.Name].Enabled
				end

				ToggleMenu.Size = UDim2.new(1,0,0,ToggleMenu.Size.Y.Offset + 25)
				local toggleButton = Instance.new('TextButton', ToggleMenu)
				toggleButton.Text = ''
				toggleButton.Visible = false
				toggleButton.BorderSizePixel = 0
				toggleButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
				toggleButton.Size = UDim2.new(1, 0,0, 25)

				table.insert(DropdownToggles, toggleButton)

				local toggleName = Instance.new('TextLabel', toggleButton)
				toggleName.BackgroundTransparency = 1
				toggleName.BorderSizePixel = 0
				toggleName.Position = UDim2.new(0,5,0,0)
				toggleName.Size = UDim2.new(0,145,1,0)
				toggleName.Visible = true
				toggleName.FontFace = Font.fromEnum(Enum.Font.Arimo, Enum.FontWeight.Regular)
				toggleName.TextColor3 = Color3.fromRGB(200,200,200)
				toggleName.TextScaled = false
				toggleName.TextSize = 14
				toggleName.TextWrapped = true
				toggleName.Text = MinitoggleProperties.Name
				toggleName.TextXAlignment = Enum.TextXAlignment.Left
				toggleName.TextYAlignment = Enum.TextYAlignment.Center

				local ButtonSliderBackground = Instance.new("TextButton", toggleButton)
				ButtonSliderBackground.BorderSizePixel = 0
				ButtonSliderBackground.Position = UDim2.new(-0.035, 155,0.2, 0)
				ButtonSliderBackground.Text = ""
				ButtonSliderBackground.Size = UDim2.new(0, 33,0, 12)
				ButtonSliderBackground.BackgroundColor3 = Color3.fromRGB(0, 83, 208)

				local BackgroundUICorner = Instance.new("UICorner", ButtonSliderBackground)
				BackgroundUICorner.CornerRadius = UDim.new(0, 8)

				local buttonStart = UDim2.new(0.091,0,0,0)
				local ButtonEnd = UDim2.new(0.545,0,0,0)

				local ButtonSlider = Instance.new("TextButton", ButtonSliderBackground)
				ButtonSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				ButtonSlider.Position = buttonStart
				ButtonSlider.Size = UDim2.new(0,12,0,12)
				ButtonSlider.Text = ''

				local ButtonSliderUICorner = Instance.new("UICorner", ButtonSlider)
				ButtonSliderUICorner.CornerRadius = UDim.new(1,0)

				local function ToggleButtonClicked()
					if MinitoggleProperties.Enabled then
						Config.Library.MiniModule[MinitoggleProperties.Name].Enabled = MinitoggleProperties.Enabled
						TweenService:Create(ButtonSlider, TweenInfo.new(0.4), {Position = ButtonEnd}):Play()
					else
						Config.Library.MiniModule[MinitoggleProperties.Name].Enabled = MinitoggleProperties.Enabled
						TweenService:Create(ButtonSlider, TweenInfo.new(0.4), {Position = buttonStart}):Play() 
					end
				end

				if MinitoggleProperties.Enabled then
					ToggleButtonClicked()
					MinitoggleProperties.Callback(ToggleButton.Enabled)
				end

				ButtonSlider.MouseButton1Click:Connect(function()
					MinitoggleProperties.Enabled = not MinitoggleProperties.Enabled
					ToggleButtonClicked()

					if MinitoggleProperties.Callback then
						MinitoggleProperties.Callback(MinitoggleProperties.Enabled)
					end
				end)

				ButtonSliderBackground.MouseButton1Click:Connect(function()
					MinitoggleProperties.Enabled = not MinitoggleProperties.Enabled
					ToggleButtonClicked()

					if MinitoggleProperties.Callback then
						MinitoggleProperties.Callback(MinitoggleProperties.Enabled)
					end
				end)

				toggleButton.MouseButton1Click:Connect(function()
					MinitoggleProperties.Enabled = not MinitoggleProperties.Enabled
					ToggleButtonClicked()

					if MinitoggleProperties.Callback then
						MinitoggleProperties.Callback(MinitoggleProperties.Enabled)
					end
				end)
				return MinitoggleProperties
			end

			function dropdownTable:CreateSlider(sliderProperties)
				sliderProperties = {
					Name = sliderProperties.Name,
					Min = sliderProperties.Min or 0,
					Max = sliderProperties.Max or 100,
					Default = sliderProperties.Default,
					Callback = sliderProperties.Callback or function() end
				}
				if not Config.Library.Slider[sliderProperties.Name] then
					Config.Library.Slider[sliderProperties.Name] = {
						Default = sliderProperties.Default
					}
				else
					sliderProperties.Default = Config.Library.Slider[sliderProperties.Name].Default
				end

				local Value
				local Dragged = false
				--local SliderHolder = Instance.new("Frame",TogglesList)
				--SliderHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				--SliderHolder.BackgroundTransparency = 1.000
				--SliderHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				--SliderHolder.BorderSizePixel = 0
				--SliderHolder.Size = UDim2.new(1, 0, 0, 28)

				ToggleMenu.Size = UDim2.new(1,0,0,ToggleMenu.Size.Y.Offset + 35)
				local SliderHolder = Instance.new('Frame', ToggleMenu)
				SliderHolder.Visible = false
				SliderHolder.BorderSizePixel = 0
				SliderHolder.BackgroundColor3 = Color3.fromRGB(45,45,45)
				SliderHolder.Size = UDim2.new(1, 0,0, 35)

				table.insert(DropdownToggles, SliderHolder)

				local uigrad = Instance.new('UIGradient', SliderHolder)
				uigrad.Enabled = false
				uigrad.Rotation = 0
				uigrad.Offset = Vector2.new(0,0)
				uigrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255,247,1))})

				local SliderHolderName = Instance.new('TextLabel')
				SliderHolderName.Parent = SliderHolder
				SliderHolderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.BackgroundTransparency = 1
				SliderHolderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderName.BorderSizePixel = 0
				SliderHolderName.Position = UDim2.new(0, 5, 0, 0)
				SliderHolderName.Size = UDim2.new(1, 0, 0, 15)
				SliderHolderName.Font = Enum.Font.SourceSans
				SliderHolderName.Text = sliderProperties.Name
				SliderHolderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderName.TextScaled = true
				SliderHolderName.TextSize = 16
				SliderHolderName.TextWrapped = true
				SliderHolderName.TextXAlignment = Enum.TextXAlignment.Left

				local SliderHolderValue = Instance.new('TextLabel')
				SliderHolderValue.Parent = SliderHolder
				SliderHolderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderValue.BackgroundTransparency = 1
				SliderHolderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderValue.BorderSizePixel = 0
				SliderHolderValue.Size = UDim2.new(0, 180, 0, 15)
				SliderHolderValue.Font = Enum.Font.SourceSans
				SliderHolderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderHolderValue.TextScaled = true
				SliderHolderValue.TextSize = 16
				SliderHolderValue.TextWrapped = true
				SliderHolderValue.TextXAlignment = Enum.TextXAlignment.Right

				local SliderHolderBack = Instance.new('Frame')
				SliderHolderBack.Parent = SliderHolder
				SliderHolderBack.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
				SliderHolderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderBack.BorderSizePixel = 0
				SliderHolderBack.Position = UDim2.new(0, 5, 0, 18)
				SliderHolderBack.Size = UDim2.new(0, 172, 0, 8)

				local SliderHolderFront = Instance.new('Frame')
				SliderHolderFront.Parent = SliderHolderBack
				SliderHolderFront.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
				SliderHolderFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderFront.BorderSizePixel = 0
				SliderHolderFront.Size = UDim2.new(0, 50, 1, 0)

				local SliderHolderGradient = Instance.new('UIGradient')
				SliderHolderGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(138, 230, 255))}
				SliderHolderGradient.Parent = SliderHolderFront

				local SliderHolderMain = Instance.new('TextButton')
				SliderHolderMain.Parent = SliderHolderFront
				SliderHolderMain.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				SliderHolderMain.BackgroundTransparency = 0--.150
				SliderHolderMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.BorderSizePixel = 0
				SliderHolderMain.Position = UDim2.new(1, 0, 0, -2)
				SliderHolderMain.Size = UDim2.new(0, 14, 0, 13)
				SliderHolderMain.Font = Enum.Font.SourceSans
				SliderHolderMain.Text = ''
				SliderHolderMain.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderHolderMain.TextSize = 14

				local UICorner = Instance.new("UICorner", SliderHolderMain)
				UICorner.CornerRadius = UDim.new(10,0)

				local function SliderDragged(input)
					local InputPos = input.Position
					Value = math.clamp((InputPos.X - SliderHolderBack.AbsolutePosition.X) / SliderHolderBack.AbsoluteSize.X, 0, 1)
					local SliderValue = math.round(Value * (sliderProperties.Max - sliderProperties.Min)) + sliderProperties.Min
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					SliderHolderValue.Text = SliderValue
					sliderProperties.Callback(SliderValue)

					Config.Library.Slider[sliderProperties.Name].Default = SliderValue
				end

				SliderHolderMain.MouseButton1Down:Connect(function()
					Dragged = true
				end)

				UserInputService.InputChanged:Connect(function(input)
					if Dragged and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						SliderDragged(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						Dragged = false
					end
				end)

				if sliderProperties.Default then
					SliderHolderValue.Text = sliderProperties.Default
					Value = (sliderProperties.Default - sliderProperties.Min) / (sliderProperties.Max - sliderProperties.Min)
					SliderHolderFront.Size = UDim2.fromScale(Value, 1)
					sliderProperties.Callback(sliderProperties.Default)
				end
				return sliderProperties
			end

			function dropdownTable:CreateTextIndicator(TextIndicator)
				TextIndicator = {
					Name = TextIndicator.Name,
					PlaceholderText = TextIndicator.PlaceholderText or '',
					DefaultText = TextIndicator.DefaultText or '',
					Callback = TextIndicator.Callback or function() end
				}

				if not Config.Libraries.TextIndicator[TextIndicator.Name] then
					Config.Libraries.TextIndicator[TextIndicator.Name] = {
						DefaultText = TextIndicator.DefaultText,
					}
				else
					TextIndicator.DefaultText = Config.Libraries.TextIndicator[TextIndicator.Name].DefaultText
				end

				local TextIndicatorText = Instance.new('TextBox')
				TextIndicatorText.Parent = ToggleMenu
				TextIndicatorText.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				TextIndicatorText.BackgroundTransparency = 1
				TextIndicatorText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextIndicatorText.BorderSizePixel = 0
				TextIndicatorText.LayoutOrder = -1
				TextIndicatorText.Size = UDim2.new(1, 0, 0, 25)
				TextIndicatorText.Font = Enum.Font.SourceSans
				TextIndicatorText.PlaceholderColor3 = Color3.fromRGB(220, 220, 220)
				TextIndicatorText.PlaceholderText = TextIndicator.PlaceholderText
				TextIndicatorText.Text = TextIndicator.DefaultText
				TextIndicatorText.TextScaled = true
				TextIndicatorText.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextIndicatorText.TextXAlignment = Enum.TextXAlignment.Left

				TextIndicatorText:GetPropertyChangedSignal('Text'):Connect(function()
					Config.Libraries.TextIndicator[TextIndicator.Name].DefaultText = TextIndicatorText.Text
					TextIndicator.Callback(TextIndicatorText.Text)
				end)
				return TextIndicator
			end

			function dropdownTable:CreatePicker(Picker)
				Picker = {
					Name = Picker.Name or "",
					Options = Picker.Options or {},
					Default = Picker.Default or Picker.Options[1],
					Callback = Picker.Callback or function(callback) end
				}

				if not Config.Libraries.Picker[Picker.Name] then
					Config.Libraries.Picker[Picker.Name] = {
						Default = Picker.Default,
					}
				else
					Picker.Default = Config.Libraries.Picker[Picker.Name].Default
				end

				local PickerFrame = Instance.new("Frame", TogglesList)
				PickerFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
				PickerFrame.Size = UDim2.new(1, 0,1, 60)
				PickerFrame.BorderSizePixel = 0
				PickerFrame.Visible = false

				table.insert(DropdownToggles, PickerFrame)

				local PickerName = Instance.new("TextLabel", PickerFrame)
				PickerName.BackgroundTransparency = 1
				PickerName.Position = UDim2.new(0,5,0,0)
				PickerName.Size = UDim2.new(0.178,145,0.2,0)
				PickerName.FontFace = Font.fromEnum(Enum.Font.Arimo)
				PickerName.Text = Picker.Name
				PickerName.TextColor3 = Color3.fromRGB(255,255,255)
				PickerName.TextScaled = false
				PickerName.TextSize = 16
				PickerName.TextWrapped = true

				local PickerDropdown = Instance.new('TextButton', PickerFrame)
				PickerDropdown.AnchorPoint = Vector2.new(0.5,0.5)
				PickerDropdown.BackgroundTransparency = 1
				PickerDropdown.Position = UDim2.new(0.011, 173,0.1, 0)
				PickerDropdown.Size = UDim2.new(0,20,0,20)
				PickerDropdown.ZIndex = 2
				PickerDropdown.FontFace = Font.fromEnum(Enum.Font.SourceSans, Enum.FontWeight.Regular)
				PickerDropdown.Text = '>'
				PickerDropdown.TextColor3 = Color3.fromRGB(255,255,255)
				PickerDropdown.TextScaled = true
				PickerDropdown.TextWrapped = true

				local PickerToggleFrame = Instance.new("Frame", PickerFrame)
				PickerToggleFrame.Position = UDim2.new(0.005,0,0.383,0)
				PickerToggleFrame.Size = UDim2.new(1,0,0,0)
				PickerToggleFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
				PickerToggleFrame.BorderSizePixel = 0
				PickerToggleFrame.Visible = false

				local UIListLayout = Instance.new("UIListLayout", PickerToggleFrame)
				UIListLayout.Padding = UDim.new(0,5)
				UIListLayout.FillDirection = Enum.FillDirection.Vertical
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

				local Toggles = {}

				local function ToggleButtonClickedd(Button, uigrad)
					if Button:GetAttribute("Enabled") == false then
						Button:SetAttribute("Enabled", true)
						TweenService:Create(Button, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(227, 201, 1)}):Play()
						TweenService:Create(uigrad, TweenInfo.new(0.4), {Enabled = true}):Play()
						for _, toggle in pairs(PickerToggleFrame:GetChildren()) do
							if toggle:IsA("TextButton") and toggle ~= Button then
								TweenService:Create(toggle, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()  
								TweenService:Create(toggle:FindFirstChildOfClass("UIGradient"), TweenInfo.new(0.4), {Enabled = false}):Play()
								Button:SetAttribute("Enabled", false)
							end
						end
						return true
					else
						TweenService:Create(Button, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()  
						TweenService:Create(uigrad, TweenInfo.new(0.4), {Enabled = false}):Play()
						Button:SetAttribute("Enabled", false)
						return false
					end
				end

				PickerDropdown.MouseButton1Click:Connect(function() 
					if PickerDropdown.Rotation == 0 then
						TweenService:Create(PickerDropdown, TweenInfo.new(0.2), {Rotation = 90}):Play()

						PickerToggleFrame.Visible = not PickerToggleFrame.Visible
					elseif PickerDropdown.Rotation == 90 then
						TweenService:Create(PickerDropdown, TweenInfo.new(0.2), {Rotation = 0}):Play()

						PickerToggleFrame.Visible = not PickerToggleFrame.Visible
					end
				end)

				for _, ToggleToAdd in pairs(Picker.Options) do
					if tostring(ToggleToAdd) then
						local PickerToggle = Instance.new('TextButton', PickerToggleFrame)
						PickerToggle:SetAttribute("Enabled", false)
						PickerToggle.Text = ''
						PickerToggle.BorderSizePixel = 0
						PickerToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
						PickerToggle.Size = UDim2.new(1, 0,0, 25)
						PickerToggleFrame.Size = UDim2.new(1,0,0,PickerToggleFrame.Size.Y.Offset + 25)

						table.insert(Toggles, PickerToggle)

						local uigrad = Instance.new('UIGradient', PickerToggle)
						uigrad.Enabled = false
						uigrad.Rotation = 0
						uigrad.Offset = Vector2.new(0,0)
						uigrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255,247,1))})

						local PickerToggleName = Instance.new('TextLabel', PickerToggle)
						PickerToggleName.BackgroundTransparency = 1
						PickerToggleName.BorderSizePixel = 0
						PickerToggleName.TextColor3 = Color3.fromRGB(255,255,255)
						PickerToggleName.Size = UDim2.new(0,145,1,0)
						PickerToggleName.Visible = true
						PickerToggleName.FontFace = Font.fromEnum(Enum.Font.Arimo, Enum.FontWeight.Regular)
						PickerToggleName.TextColor3 = Color3.fromRGB(255,255,255)
						PickerToggleName.TextScaled = false
						PickerToggleName.TextSize = 16
						PickerToggleName.TextWrapped = true
						PickerToggleName.Text = ToggleToAdd
						PickerToggleName.TextXAlignment = Enum.TextXAlignment.Left
						PickerToggleName.TextYAlignment = Enum.TextYAlignment.Center

						if Picker.Default then
							if ToggleToAdd == Picker.Default then
								PickerToggle:SetAttribute("Enabled", false)
								if ToggleButtonClickedd(PickerToggle, uigrad) then
									--Config.Libraries.Picker[Picker.Name].Default = ToggleToAdd
									Picker.Callback(ToggleToAdd)
								end
							end
						end

						PickerToggle.MouseButton1Click:Connect(function()
							if ToggleButtonClickedd(PickerToggle, uigrad) then
								Config.Libraries.Picker[Picker.Name].Default = ToggleToAdd
								Picker.Callback(ToggleToAdd)
							end
						end)
					end
				end
			end

			toggleButton.MouseButton2Click:Connect(function() 
				if DropdownButton.Rotation == 0 then
					TweenService:Create(DropdownButton, TweenInfo.new(0.2), {Rotation = 90}):Play()
					for _, togglethingidk in ipairs(DropdownToggles) do
						if togglethingidk then
							togglethingidk.Visible = not togglethingidk.Visible
						end
					end

					ToggleMenu.Visible = not ToggleMenu.Visible
				elseif DropdownButton.Rotation == 90 then
					TweenService:Create(DropdownButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
					--TweenService:Create(DropdownButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
					for _, togglethingidk in ipairs(DropdownToggles) do
						if togglethingidk then
							togglethingidk.Visible = not togglethingidk.Visible
						end
					end

					ToggleMenu.Visible = not ToggleMenu.Visible
				end
			end)

			DropdownButton.MouseButton1Click:Connect(function() 
				if DropdownButton.Rotation == 0 then
					TweenService:Create(DropdownButton, TweenInfo.new(0.2), {Rotation = 90}):Play()
					for _, togglethingidk in ipairs(DropdownToggles) do
						if togglethingidk then
							togglethingidk.Visible = not togglethingidk.Visible
						end
					end

					ToggleMenu.Visible = not ToggleMenu.Visible
				elseif DropdownButton.Rotation == 90 then
					TweenService:Create(DropdownButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
					--TweenService:Create(DropdownButton, TweenInfo.new(0.2), {Rotation = 0}):Play()
					for _, togglethingidk in ipairs(DropdownToggles) do
						if togglethingidk then
							togglethingidk.Visible = not togglethingidk.Visible
						end
					end

					ToggleMenu.Visible = not ToggleMenu.Visible
				end
			end)

			spawn(function()
				RunService.RenderStepped:Connect(function()
					if ToggleButton.AutoDisable then
						if ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
					if shared.PineappleScriptUninjected then
						if ToggleButton.Enabled then
							ToggleButton.Enabled = false
							ToggleButtonClicked()

							if ToggleButton.Callback then
								ToggleButton.Callback(ToggleButton.Enabled)
							end
						end
					end
				end)
			end)

			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end

			toggleButton.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				ToggleButtonClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)

			return dropdownTable
		end

		return PropertiesToggle
	end
end

shared.pineapple = Library
return Library
