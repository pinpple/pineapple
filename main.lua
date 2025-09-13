--[[                                                                                                                                                                                                                                                                                                          
        GGGGGGGGGGGGG               AAA               MMMMMMMM               MMMMMMMMIIIIIIIIIINNNNNNNN        NNNNNNNN        GGGGGGGGGGGGG             CCCCCCCCCCCCCHHHHHHHHH     HHHHHHHHH               AAA               IIIIIIIIIIRRRRRRRRRRRRRRRRR        VVVVVVVV           VVVVVVVV   444444444  
     GGG::::::::::::G              A:::A              M:::::::M             M:::::::MI::::::::IN:::::::N       N::::::N     GGG::::::::::::G          CCC::::::::::::CH:::::::H     H:::::::H              A:::A              I::::::::IR::::::::::::::::R       V::::::V           V::::::V  4::::::::4  
   GG:::::::::::::::G             A:::::A             M::::::::M           M::::::::MI::::::::IN::::::::N      N::::::N   GG:::::::::::::::G        CC:::::::::::::::CH:::::::H     H:::::::H             A:::::A             I::::::::IR::::::RRRRRR:::::R      V::::::V           V::::::V 4:::::::::4  
  G:::::GGGGGGGG::::G            A:::::::A            M:::::::::M         M:::::::::MII::::::IIN:::::::::N     N::::::N  G:::::GGGGGGGG::::G       C:::::CCCCCCCC::::CHH::::::H     H::::::HH            A:::::::A            II::::::IIRR:::::R     R:::::R     V::::::V           V::::::V4::::44::::4  
 G:::::G       GGGGGG           A:::::::::A           M::::::::::M       M::::::::::M  I::::I  N::::::::::N    N::::::N G:::::G       GGGGGG      C:::::C       CCCCCC  H:::::H     H:::::H             A:::::::::A             I::::I    R::::R     R:::::R      V:::::V           V:::::V4::::4 4::::4  
G:::::G                        A:::::A:::::A          M:::::::::::M     M:::::::::::M  I::::I  N:::::::::::N   N::::::NG:::::G                   C:::::C                H:::::H     H:::::H            A:::::A:::::A            I::::I    R::::R     R:::::R       V:::::V         V:::::V4::::4  4::::4  
G:::::G                       A:::::A A:::::A         M:::::::M::::M   M::::M:::::::M  I::::I  N:::::::N::::N  N::::::NG:::::G                   C:::::C                H::::::HHHHH::::::H           A:::::A A:::::A           I::::I    R::::RRRRRR:::::R         V:::::V       V:::::V4::::4   4::::4  
G:::::G    GGGGGGGGGG        A:::::A   A:::::A        M::::::M M::::M M::::M M::::::M  I::::I  N::::::N N::::N N::::::NG:::::G    GGGGGGGGGG     C:::::C                H:::::::::::::::::H          A:::::A   A:::::A          I::::I    R:::::::::::::RR           V:::::V     V:::::V4::::444444::::444
G:::::G    G::::::::G       A:::::A     A:::::A       M::::::M  M::::M::::M  M::::::M  I::::I  N::::::N  N::::N:::::::NG:::::G    G::::::::G     C:::::C                H:::::::::::::::::H         A:::::A     A:::::A         I::::I    R::::RRRRRR:::::R           V:::::V   V:::::V 4::::::::::::::::4
G:::::G    GGGGG::::G      A:::::AAAAAAAAA:::::A      M::::::M   M:::::::M   M::::::M  I::::I  N::::::N   N:::::::::::NG:::::G    GGGGG::::G     C:::::C                H::::::HHHHH::::::H        A:::::AAAAAAAAA:::::A        I::::I    R::::R     R:::::R           V:::::V V:::::V  4444444444:::::444
G:::::G        G::::G     A:::::::::::::::::::::A     M::::::M    M:::::M    M::::::M  I::::I  N::::::N    N::::::::::NG:::::G        G::::G     C:::::C                H:::::H     H:::::H       A:::::::::::::::::::::A       I::::I    R::::R     R:::::R            V:::::V:::::V             4::::4  
 G:::::G       G::::G    A:::::AAAAAAAAAAAAA:::::A    M::::::M     MMMMM     M::::::M  I::::I  N::::::N     N:::::::::N G:::::G       G::::G      C:::::C       CCCCCC  H:::::H     H:::::H      A:::::AAAAAAAAAAAAA:::::A      I::::I    R::::R     R:::::R             V:::::::::V              4::::4  
  G:::::GGGGGGGG::::G   A:::::A             A:::::A   M::::::M               M::::::MII::::::IIN::::::N      N::::::::N  G:::::GGGGGGGG::::G       C:::::CCCCCCCC::::CHH::::::H     H::::::HH   A:::::A             A:::::A   II::::::IIRR:::::R     R:::::R              V:::::::V               4::::4  
   GG:::::::::::::::G  A:::::A               A:::::A  M::::::M               M::::::MI::::::::IN::::::N       N:::::::N   GG:::::::::::::::G        CC:::::::::::::::CH:::::::H     H:::::::H  A:::::A               A:::::A  I::::::::IR::::::R     R:::::R               V:::::V              44::::::44
     GGG::::::GGG:::G A:::::A                 A:::::A M::::::M               M::::::MI::::::::IN::::::N        N::::::N     GGG::::::GGG:::G          CCC::::::::::::CH:::::::H     H:::::::H A:::::A                 A:::::A I::::::::IR::::::R     R:::::R                V:::V               4::::::::4
        GGGGGG   GGGGAAAAAAA                   AAAAAAAMMMMMMMM               MMMMMMMMIIIIIIIIIINNNNNNNN         NNNNNNN        GGGGGG   GGGG             CCCCCCCCCCCCCHHHHHHHHH     HHHHHHHHHAAAAAAA                   AAAAAAAIIIIIIIIIIRRRRRRRR     RRRRRRR                 VVV                4444444444


                                                                                                                                                                GAMING CHAIR V4 - BEST BEDWARZ SCRIPT! (bedwarz 1, 2 and 3!)
]]

local cloneref = cloneref or function(obj)
    return obj
end

local Players = cloneref(game:GetService('Players'))
local starterPlayer = cloneref(game:GetService('StarterPlayer'))
local inputService = cloneref(game:GetService('UserInputService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local starterGui = cloneref(game:GetService('StarterGui'))

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if runService:IsStudio() then
    if not shared then
        getfenv().shared = getfenv()
    end
end

local ids = {
    [17750024818] = '17750024818.lua',
    [122483927964273] = '122483927964273.lua',
    [71480482338212] = '71480482338212.lua',
    [6872274481] = '6872274481.lua',
    [8444591321] = '6872274481.lua',
    [8560631822] = '6872274481.lua'
}

local function downloadFile(file)
    url = file:gsub('pineapple/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/pinpple/pineapple/'..readfile('pineapple/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

for i,v in ids do
    if i == game.PlaceId then
        return loadstring(downloadFile('pineapple/games/'..v))()
    end
end

return loadstring(downloadFile('pineapple/games/universal.lua'))()