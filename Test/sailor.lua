local success, VelarisUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/nhfudzfsrzggt/brigida/refs/heads/main/dist/main.lua", true))()
end)

if not success or not VelarisUI then
    return
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")  
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local npcFolder = Workspace:WaitForChild("NPCs")
local QuestModule = require(ReplicatedStorage.Modules.QuestConfig)
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local gameInfo
local okInfo, errInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)

if okInfo and type(errInfo) == "table" and errInfo.Name then
    gameInfo = errInfo
else
    gameInfo = { Name = "Game" }
end

local GameName = tostring(gameInfo.Name or "Game")

local Window = VelarisUI:Window({
    Title = "LexsHub | Best Script", -- Main title displayed at the top of the window
    Footer = "Premium Version", -- Footer text shown at the bottom
    Content = "BETA SCRIPT: "..GameName,
    Color = "Default", -- UI theme color (Default or custom theme)
    Version = 1.0,
    ["Tab Width"] = 120, -- Width size of the tab section
    Image = "103875081318049", -- Window icon asset ID (replace with your own)
    Configname = "Lexs_Ui", -- Configuration file name for saving settings
    Uitransparent = 0.15, -- UI transparency (0 = solid, 1 = fully transparent)
    ShowUser = false,
    Search = true, 
    Animation = true,                 -- Efek typewriter pada Title & Footer
    TypeDelay = 0.07,                  -- Jeda antar karakter (detik)
    TypePause = 2.5,                   -- Jeda setelah teks selesai (detik) 
    DiscordSet = {
        Enable = true,
        Title  = "LEXS HUB",
        Link   = "https://discord.gg/lexshub",
        Icon   = "103875081318049", 
    },
    Config = {
        AutoSave = false,
        AutoLoad = false,
    },
})

if Window then
    Nt("Window loaded!")
end

local function Nt(msg)
VelarisUI:MakeNotify({
    Title   = "Lexs Hub | Notification",
    Content = msg or "Content",
    Icon    = "rbxassetid://17495379799",
    Color   = "Default",
    Delay   = 5,
})
end

local UIS = game:GetService("UserInputService")

local device = "PC"
local color = Color3.fromRGB(0, 255, 255)
local icon = "lucide:monitor"

if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    device = "Mobile"
    color = Color3.fromRGB(0, 170, 255)
    icon = "lucide:smartphone"
elseif UIS.GamepadEnabled then
    device = "Console"
    color = Color3.fromRGB(170, 85, 255)
    icon = "lucide:gamepad-directional"
end

local executorName = "Unknown"
pcall(function()
    if identifyexecutor then
        executorName = identifyexecutor()
    end
end)

local startTime = tick()

local function formatTime(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = math.floor(sec % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

local tag = Window:Tag({
    Title = executorName .. " | 00:00:00 | " .. device,
    Color = color,
    Icon = icon
})

task.spawn(function()
    while true do
        task.wait(1)

        local elapsed = tick() - startTime
        local newText = executorName .. " | " .. formatTime(elapsed) .. " | " .. device

        if tag and tag.SetTitle then
            tag:SetTitle(newText)
        end
    end
end)

local Tabs = {
    Info = Window:AddTab({ Name = "Info", Icon = "player" }),
    Stat = Window:AddTab({ Name = "Stats", Icon = "user" }),
    Player = Window:AddTab({ Name = "Player", Icon = "lucide:users" }),
    Main = Window:AddTab({ Name = "Main", Icon = "gamepad" }),
    Auto = Window:AddTab({ Name = "Auto", Icon = "lucide:refresh-ccw" }),
    Shop = Window:AddTab({ Name = "Shop", Icon = "lucide:store" }),
    Webhook = Window:AddTab({ Name = "Webhook", Icon = "lucide:webhook" }),
    Teleport = Window:AddTab({ Name = "Teleport", Icon = "gps" }),
    Misc = Window:AddTab({ Name = "Misc", Icon = "settings" }),
    Config = Window:AddTab({ Name = "Config", Icon = "lucide:file-check" })
}

v1 = Tabs.Info:AddSection({ Title = "Info", Icon = "discord", Open = true })

v1:AddParagraph({
    Title = "Join Our Discord",
    Content = "Join Us!",
    Icon = "rbxassetid://94434236999817",  -- ganti ICON_ID dengan ID asset sebenarnya
    Color = Color3.fromRGB(70, 130, 220),
    ButtonText = "Copy Discord",
    ButtonCallback = function()
        local link = "https://discord.gg/lexshub"
        if setclipboard then
            setclipboard(link)
            Nt("Successfully Copied!")
        end
    end
})

v3 = Tabs.Stat:AddSection({ Title = "Stats Player", Icon = "18351727024", Open = true })

local paragraph = v3:AddParagraph({
    Title   = LocalPlayer.Name.." Stats",
    Content = "Loading..."
})

local function getStat(path)
    return path and path.Value or 0
end

local function updateStats()
    local data = LocalPlayer:FindFirstChild("Data")
    if not data then return end

    local exp = getStat(data:FindFirstChild("Experience"))
    local gems = getStat(data:FindFirstChild("Gems"))
    local level = getStat(data:FindFirstChild("Level"))
    local money = getStat(data:FindFirstChild("Money"))
    local statPoints = getStat(data:FindFirstChild("StatPoints"))

    paragraph:SetContent(
        "Level : "..level..
        "\nExperience : "..exp..
        "\nMoney : "..money..
        "\nGems : "..gems..
        "\nStatPoints : "..statPoints
    )
end

task.spawn(function()
    while task.wait(1) do
        pcall(updateStats)
    end
end)

local killaura = false
local killauraRange = 20
local attackSpeed = 0.2 

local remote = ReplicatedStorage:WaitForChild("CombatSystem")
    :WaitForChild("Remotes")
    :WaitForChild("RequestHit")

-- 🔥 GET ROOT PLAYER
local function getRoot()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart")
end

-- 🔥 GET NPC FOLDER
local function getNPCFolder()
    return workspace:FindFirstChild("NPCs")
end

-- 🔥 GET HUMANOID
local function getHum(model)
    return model:FindFirstChildOfClass("Humanoid")
end

-- 🔥 GET ROOT NPC
local function getNPCRoot(model)
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChildWhichIsA("BasePart")
end

-- 🔥 CHECK PLAYER
local function isPlayer(model)
    return Players:GetPlayerFromCharacter(model) ~= nil
end

-- 🔥 KILLAURA FUNCTION
local lastAttack = 0

function killauraFunc()
    if not killaura then return end

    local char = LocalPlayer.Character
    if not char then return end
    if char:FindFirstChildOfClass("ForceField") then return end

    local hrp = getRoot()
    if not hrp then return end

    local best = nil
    local dist = killauraRange

    local npcs = getNPCFolder()
    if npcs then
        for _, v in ipairs(npcs:GetDescendants()) do
            if v:IsA("Model") and not isPlayer(v) then
                local hum = getHum(v)
                local root = getNPCRoot(v)

                if hum and root and hum.Health > 0 then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < dist then
                        dist = d
                        best = v
                    end
                end
            end
        end
    end

    -- 🔥 ATTACK SPEED CONTROL
    if best and tick() - lastAttack >= attackSpeed then
        lastAttack = tick()
        pcall(function()
            remote:FireServer()
        end)
    end
end

-- 🔥 LOOP
RunService.RenderStepped:Connect(function()
    if killaura then
        killauraFunc()
    end
end)

x1 = Tabs.Player:AddSection("Player")

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

x1:AddSlider({
    Title = "Walk Speed",
    Min = 16,
    Max = 1000,
    Default = 16,
    Callback = function(v)
        local char = Player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = v
        end
    end
})

_G.CustomJumpPower = 50

local Players = game:GetService("Players")
local player = Players.LocalPlayer

x1:AddSlider({
    Title = "Jump Power",
    Content = "Adjust your jump power instantly.",
    Min = 50,
    Max = 300,
    Default = 50,
    Increment = 1,
    Callback = function(value)

        _G.CustomJumpPower = value

        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.UseJumpPower = true
            char.Humanoid.JumpPower = value
        end

    end
})

player.CharacterAdded:Connect(function(char)

    local hum = char:WaitForChild("Humanoid")

    hum.UseJumpPower = true
    hum.JumpPower = _G.CustomJumpPower

end)

local char = player.Character
if char and char:FindFirstChild("Humanoid") then
    char.Humanoid.UseJumpPower = true
    char.Humanoid.JumpPower = _G.CustomJumpPower
end

_G.InfJump = false

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

x1:AddToggle({
	Title = "Infinite Jump",
    Content = "Makes You Jmp Without Limits",
	Default = false,
	Callback = function(state)
		_G.InfJump = state
	end
})

UIS.JumpRequest:Connect(function()
	if _G.InfJump then
		local character = player.Character
		if character and character:FindFirstChildOfClass("Humanoid") then
			character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

x2 = Tabs.Main:AddSection("Main")
local farm = x2:AddTabbox({ Title = "Auto Farm" })
local boss = x2:AddTabbox({ Title = "Boss" })
local config = x2:AddTabbox({ Title = "Config" })

config:AddSlider({
    Title     = "Range",
    Min       = 5,
    Max       = 200,
    Default   = 20,
    Increment = 1,
    Callback  = function(value)
        killauraRange = value
    end
})

config:AddSlider({
    Title     = "Attack Speed",
    Min       = 0.01,
    Max       = 1,
    Default   = 0.2,
    Increment = 0.01,
    Callback  = function(value)
        attackSpeed = value
    end
})

config:AddToggle({
    Title   = "Kill Aura",
    Default = false,
    Callback = function(value)
        killaura = value
    end
})
