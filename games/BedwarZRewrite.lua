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
local userInputService = cloneref(game:GetService('UserInputService'))
local lplr = playersService.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local entitylib = loadstring(game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/libraries/entity.lua'))()
local pineapple, items = loadstring(readfile('pineapple/gui/pineapple.lua'))(), {}
local esplib = loadstring(game:HttpGet('https://raw.githubusercontent.com/mstudio45/MSESP/refs/heads/main/source.luau'))()

local Combat = pineapple:CreateTab('Combat')
local Movement = pineapple:CreateTab('Movement')
local Visuals = pineapple:CreateTab('Visuals')
local World = pineapple:CreateTab('World')
local Exploit = pineapple:CreateTab('Exploit')

local function downloadFile(file)
    url = file:gsub('pineapple/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/pinpple/pineapple/'..readfile('pineapple/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

local MathUtils
local suc, res = pcall(function()
    return require(replicatedStorage.Modules.MathUtils)
end)

if suc then
    MathUtils = res
else
    MathUtils = loadstring(downloadFile('pineapple/games/math.lua'))()
end