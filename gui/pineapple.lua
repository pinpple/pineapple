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
}

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
if not shared.PineappleScriptLoaded then
	shared.PineappleScriptLoaded = false
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

print("reached")

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

local NotifScreenUI = Instance.new('ScreenGui', CoreGui)
NotifScreenUI.Name = Generate(10)
NotifScreenUI.ResetOnSpawn = false

print("made")

local notifMainFrame = nil
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
	if notifMainFrame == nil then
		notifMainFrame = Instance.new('ScrollingFrame')
		notifMainFrame.Parent = NotifScreenUI
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
		notifMainFrame.Parent = NotifScreenUI
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
	if shared.PinappleScriptLoaded then
		shared.PineappleScriptUninjected = true
	end
end

function Library:CreateMain(properties)
	if shared.PinappleScriptLoaded then
		warn'already loaded bruv'
	else
		local Main = {}

		properties = {
			Toggle = properties.Toggle or 'RightShift',
			EnableOnExecute = properties.EnableOnExecute or false,
			MainTextColor = properties.MainTextColor or Color3.fromRGB(255, 255, 10)
		}

		shared.PinappleScriptLoaded = true

		local ScreenGui = Instance.new('ScreenGui', CoreGui)
		ScreenGui.Name = Generate(12)
		ScreenGui.ResetOnSpawn = false

		UserInputService.InputBegan:Connect(function(keycode, gameProcessed)
			if gameProcessed then return end

			if keycode.KeyCode == Enum.KeyCode[properties.Toggle] then
				ScreenGui.Enabled = not ScreenGui.Enabled
				task.wait()
				tooltip.Visible = false
			end
		end)

		spawn(function()
			RunService.RenderStepped:Connect(function()
				if ScreenGui then
					if shared.PineappleScriptUninjected then
						task.wait(1.2)
						ScreenGui:Destroy()
						shared.PineappleScriptUninjected = false
						shared.PinappleScriptLoaded = false
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
				print(MainFrame.BackgroundColor3)
				MainFrame.BackgroundTransparency = 1
				MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MainFrame.BorderSizePixel = 0
				MainFrame.Size = UDim2.new(1, 0, 1, 0)
				MainFrame.CanvasPosition = Vector2.new(240, 0)
				MainFrame.CanvasSize = UDim2.new(1.60000002, 0, 0, 0)
				MainFrame.ScrollBarThickness = 8
				MainFrame.Visible = properties.EnableOnExecute
			end
		elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
			if MainFrame == nil then
				MainFrame = Instance.new("Frame")
				MainFrame.Parent = ScreenGui
				MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MainFrame.BackgroundTransparency = 1
				MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MainFrame.Size = UDim2.new(1, 0, 1, 0)
				MainFrame.Visible = properties.EnableOnExecute
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

		local LibraryText = Instance.new('TextLabel', MainFrame)
		LibraryText.Name = 'LibraryText'
		LibraryText.BackgroundTransparency = 1
		LibraryText.FontFace = Font.fromEnum(Enum.Font.TitilliumWeb, Enum.FontWeight.Regular)
		LibraryText.Size = UDim2.new(0, 200,0, 35)
		LibraryText.Position = UDim2.new(0.014, 0,0.028, 0)
		LibraryText.TextSize = 41
		LibraryText.TextScaled = false
		LibraryText.TextWrapped =true
		LibraryText.TextXAlignment = Enum.TextXAlignment.Left
		LibraryText.TextYAlignment = Enum.TextYAlignment.Center
		LibraryText.TextColor3 = Color3.fromRGB(255, 255, 10)
		LibraryText.Text = 'pineapple'
		LibraryText.ZIndex = 99
		LibraryText.LayoutOrder = 0
		LibraryText.Interactable = false
		LibraryText.Visible = true

		if shared.DisablePineappleImage then
		else
			local LibraryTextImage = Instance.new('ImageLabel', LibraryText)
			LibraryTextImage.BackgroundTransparency = 1
			LibraryTextImage.Name = 'ImageLabel'
			LibraryTextImage.Size = UDim2.new(0, 68 ,0, 59)
			LibraryTextImage.Position = UDim2.new(0.45, 0, -0.4, 0)
			LibraryTextImage.Image = 'rbxassetid://126819632241697'
			LibraryTextImage.ImageColor3 = Color3.fromRGB(255,255,255)
		end

		function Main:CreateTab(PropertiesToggle)
			local Tabs = {}

			PropertiesToggle = {
				Name = PropertiesToggle.Name or '',
				Image = PropertiesToggle.Image or 'rbxassetid://0',
				ImageColor = PropertiesToggle.ImageColor or Color3.fromRGB(255, 255, 255)
			}

			local Tab = Instance.new('Frame', MainFrame)
			Tab.BackgroundTransparency = 0.03
			Tab.BorderSizePixel = 0
			Tab.BackgroundColor3 = Color3.fromRGB(25,25,25)
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
			TabTitle.FontFace = Font.fromEnum(Enum.Font.Nunito, Enum.FontWeight.Regular)
			TabTitle.Text = PropertiesToggle.Text
			TabTitle.TextColor3 = Color3.fromRGB(255,255,255)
			TabTitle.TextSize = 18
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
			ImageLabel.Image = 'rbxassetid://' .. PropertiesToggle.Image
			ImageLabel.ImageColor3 = PropertiesToggle.ImageColor

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

			function Tabs:CreateToggle(ToggleButton)
				local dropdownTable = {}
				local DropdownToggles = {}

				ToggleButton = {
					Name = ToggleButton.Name,
					ToolTipText = ToggleButton.ToolTipText,
					Keybind = ToggleButton.Keybind or 'None',
					Enabled = ToggleButton.Enabled or false,
					AutoEnable = ToggleButton.AutoEnable or false,
					AutoDisable = ToggleButton.AutoDisable or false,
					Hide = ToggleButton.Hide or false,
					Callback = ToggleButton.Callback or function() end
				}

				local toggleButton = Instance.new('TextButton', TogglesList)
				toggleButton.Text = ''
				toggleButton.BorderSizePixel = 0
				toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
				toggleButton.Size = UDim2.new(1, 0,0, 25)

				if ToggleButton.ToolTipText then
					addTooltip(toggleButton, ToggleButton.ToolTipText)
				end

				if ToggleButton.Hide then
					toggleButton.Visible = false
				else
					toggleButton.Visible = true
				end

				local uigrad = Instance.new('UIGradient', toggleButton)
				uigrad.Enabled = false
				uigrad.Rotation = 0
				uigrad.Offset = Vector2.new(0,0)
				uigrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255,247,1))})

				local toggleName = Instance.new('TextLabel', toggleButton)
				toggleName.BackgroundTransparency = 1
				toggleName.BorderSizePixel = 0
				toggleName.Position = UDim2.new(0,5,0,0)
				toggleName.Size = UDim2.new(0,145,1,0)
				toggleName.Visible = true
				toggleName.FontFace = Font.fromEnum(Enum.Font.Arimo, Enum.FontWeight.Regular)
				toggleName.TextColor3 = Color3.fromRGB(255,255,255)
				toggleName.TextScaled = false
				toggleName.TextSize = 16
				toggleName.TextWrapped = true
				toggleName.Text = ToggleButton.Name
				toggleName.TextXAlignment = Enum.TextXAlignment.Left
				toggleName.TextYAlignment = Enum.TextYAlignment.Center

				local function ToggleButtonClicked()
					if ToggleButton.Enabled then
						TweenService:Create(toggleButton, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(227, 201, 1)}):Play()
						TweenService:Create(uigrad, TweenInfo.new(0.4), {Enabled = true}):Play()
					else
						TweenService:Create(toggleButton, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()  
						TweenService:Create(uigrad, TweenInfo.new(0.4), {Enabled = false}):Play()
					end
				end

				local DropdownButton = Instance.new('TextButton', toggleButton)
				DropdownButton.AnchorPoint = Vector2.new(0.5,0.5)
				DropdownButton.BackgroundTransparency = 1
				DropdownButton.Position = UDim2.new(0, 173, 0.5, 0)
				DropdownButton.Size = UDim2.new(0,20,0,20)
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
				KeybindButton.BackgroundColor3 = Color3.fromRGB(68,68,68)
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
				keybindTextbox.Position = UDim2.new(0.83, 0,0, 0)
				keybindTextbox.Size = UDim2.new(0, 30,0, 25)
				keybindTextbox.Visible = true
				keybindTextbox.ZIndex = 2

				RunService.RenderStepped:Connect(function()
					if shared.PineappleScriptUninjected then
						ToggleButton.Keybind = 'None'

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
						elseif ToggleButton.Keybind == 'Backspace' then
							ToggleButton.Keybind = 'None'
							keybindTextbox.Text = 'None'
							keybindTextbox.PlaceholderText = ''
						end  

						if not isTyping then
							if ToggleButton.Keybind ~= 'None' then
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

				function dropdownTable:CreateMiniToggle(MinitoggleProperties)
					MinitoggleProperties = {
						Name = MinitoggleProperties.Name or '',
						Enabled = MinitoggleProperties.Enabled or false,
						Callback = MinitoggleProperties.Callback or function() end
					}

					ToggleMenu.Size = UDim2.new(1,0,0,ToggleMenu.Size.Y.Offset + 25)
					local toggleButton = Instance.new('TextButton', ToggleMenu)
					toggleButton.Text = ''
					toggleButton.Visible = false
					toggleButton.BorderSizePixel = 0
					toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
					toggleButton.Size = UDim2.new(1, 0,0, 25)

					table.insert(DropdownToggles, toggleButton)

					local uigrad = Instance.new('UIGradient', toggleButton)
					uigrad.Enabled = false
					uigrad.Rotation = 0
					uigrad.Offset = Vector2.new(0,0)
					uigrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255,247,1))})

					local toggleName = Instance.new('TextLabel', toggleButton)
					toggleName.BackgroundTransparency = 1
					toggleName.BorderSizePixel = 0
					toggleName.Position = UDim2.new(0,5,0,0)
					toggleName.Size = UDim2.new(0,145,1,0)
					toggleName.Visible = true
					toggleName.FontFace = Font.fromEnum(Enum.Font.Arimo, Enum.FontWeight.Regular)
					toggleName.TextColor3 = Color3.fromRGB(255,255,255)
					toggleName.TextScaled = false
					toggleName.TextSize = 16
					toggleName.TextWrapped = true
					toggleName.Text = MinitoggleProperties.Name
					toggleName.TextXAlignment = Enum.TextXAlignment.Left
					toggleName.TextYAlignment = Enum.TextYAlignment.Center

					local function ToggleButtonClicked()
						if MinitoggleProperties.Enabled then
							TweenService:Create(toggleButton, TweenInfo.new(0.4), {Transparency = 0,BackgroundColor3 = Color3.fromRGB(227, 201, 1)}):Play()
							TweenService:Create(uigrad, TweenInfo.new(0.4), {Enabled = true}):Play()
						else
							TweenService:Create(toggleButton, TweenInfo.new(0.4), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()  
							TweenService:Create(uigrad, TweenInfo.new(0.4), {Enabled = false}):Play()
						end
					end

					if MinitoggleProperties.Enabled then
						ToggleButtonClicked()
						MinitoggleProperties.Callback(ToggleButton.Enabled)
					end

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
					SliderHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
					SliderHolderValue.TextSize = 16.000
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
					SliderHolderMain.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					SliderHolderMain.BackgroundTransparency = 0.150
					SliderHolderMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
					SliderHolderMain.BorderSizePixel = 0
					SliderHolderMain.Position = UDim2.new(1, 0, 0, -2)
					SliderHolderMain.Size = UDim2.new(0, 8, 0, 12)
					SliderHolderMain.Font = Enum.Font.SourceSans
					SliderHolderMain.Text = ''
					SliderHolderMain.TextColor3 = Color3.fromRGB(0, 0, 0)
					SliderHolderMain.TextSize = 14.000

					local function SliderDragged(input)
						local InputPos = input.Position
						Value = math.clamp((InputPos.X - SliderHolderBack.AbsolutePosition.X) / SliderHolderBack.AbsoluteSize.X, 0, 1)
						local SliderValue = math.round(Value * (sliderProperties.Max - sliderProperties.Min)) + sliderProperties.Min
						SliderHolderFront.Size = UDim2.fromScale(Value, 1)
						SliderHolderValue.Text = SliderValue
						sliderProperties.Callback(SliderValue)
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
						TextIndicator.Callback(TextIndicatorText.Text)
					end)
					return TextIndicator
				end

				DropdownButton.MouseButton1Click:Connect(function() 
					if ToggleMenu.Visible then
						for _, togglethingidk in ipairs(DropdownToggles) do
							if togglethingidk then
								togglethingidk.Visible = not togglethingidk.Visible
							end
						end

						ToggleMenu.Visible = not ToggleMenu.Visible

						TweenService:Create(DropdownButton, TweenInfo.new(0.3), {Rotation = 90}):Play()
					else
						for _, togglethingidk in ipairs(DropdownToggles) do
							if togglethingidk then
								togglethingidk.Visible = not togglethingidk.Visible
							end
						end

						ToggleMenu.Visible = not ToggleMenu.Visible

						TweenService:Create(DropdownButton, TweenInfo.new(0.3), {Rotation = 0}):Play()
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
						if ToggleButton.AutoEnable then
							if not ToggleButton.Enabled then
								ToggleButton.Enabled = true
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

			return Tabs
		end

		return Main
	end
end

shared.pineapple = Library
return Library
