-- test update
local success, ModernV2 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/opsidian279/Moded/refs/heads/main/MainV2.lua"))()
end)

if not success or not ModernV2 then
    return
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local service = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TeleportService = game:GetService("TeleportService"),
    TweenService = game:GetService("TweenService"),
    VIM = game:GetService("VirtualInputManager"),
    Lighting = game:GetService("Lighting"),
    CollectionService = game:GetService("CollectionService"),
    HttpService = game:GetService("HttpService"),
    MarketplaceService = game:GetService("MarketplaceService"),
    VirtualUser = game:GetService("VirtualUser"),
    StarterGui = game:GetService("StarterGui"),
    GuiService = game:GetService("GuiService"),
    CoreGui = game:GetService("CoreGui"),
}

local LocalPlayer = service.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Executor = "Unknown"
pcall(function()
    if identifyexecutor then
        Executor = identifyexecutor()
    end
end)

local GameName = "Unknown Game"
pcall(function()
    GameName = service.MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

ModernV2:AddTheme({
	Name = "Lumi Blue",
	Accent = Color3.fromRGB(78, 127, 252),
	Background = Color3.fromRGB(8, 8, 13),
	Surface = Color3.fromRGB(20, 22, 27),
	Outline = Color3.fromRGB(45, 48, 58),
	Text = Color3.fromRGB(255, 255, 255),
	Placeholder = Color3.fromRGB(140, 140, 155),
	Button = Color3.fromRGB(78, 127, 252),
	Icon = Color3.fromRGB(255, 255, 255),
})

-- Create the floating menu icon before/after window creation.
local MenuIcon = ModernV2:CreateMenuIcon({
	Image = "103875081318049",
	Size = 48,
	IconColor = Color3.fromRGB(255, 255, 255),
	BGColor = Color3.fromRGB(20, 22, 27),
	StrokeColor = ModernV2.AccentColor,
	StrokeThick = 1.5,
	Draggable = true,
})

-- Create the main window.
local window = ModernV2:Window({
	Title = "Lexs Hub - Premium",
	Content = "GAME: " .. GameName,
	Image = "103875081318049",
	Color = Color3.fromRGB(78, 127, 252),
	Uitransparent = 0.12,
	ShowUser = false,
	Search = true,
	ConfigEnabled = true,
	NotifyOnCallbackError = false,
	Loadingscreen = false,
	Enable3DRenderer = false,
	Keybind = "RightControl",
	Config = {
		ConfigFolder = "LEXSconfig",
		AutoSaveFile = "Default",
		AutoSave = true,
		AutoLoad = true,
		Overwrite = true,
		Format = "JSON",
		ShowAutoSaveToggle = true,
		TextGradient = true,
	},
})

window:AttachMenuIcon(MenuIcon)

window:OnDestroy(function()
    print("ModernV2 window destroyed")
end)

window:SetAccount({
	Username = game:GetService("Players").LocalPlayer.DisplayName,
	Profile = ModernV2.UserProfile,
	Expires = "LifeTime",
})

window:CreateHomeTab({
    Name = "Dashboard",
    Icon = "lucide:layout-dashboard",
    Content = "Lexs Hub Dashboard",
    DiscordInvite = "https://discord.gg/vxU74CZpGm",
    SupportedExecutors = { "Delta", "Synapse X", "Krnl", "Vortex" },
    UnsupportedExecutors = { "Xeno" },
    Segments = {
        Details = { Text = "Details", Icon = "lucide:grid-2x2" },
        Script = { Text = "Script Logs", Icon = "lucide:code" },
        UI = { Text = "UI Logs", Icon = "lucide:file-text", Show = false },
    },
    Changelog = {
        {
            Title = "ModernV2 Update",
            Date = "Latest",
            Description = "Release",
        },
    },
    UIChangelog = {
        {
            Title = "Dashboard Style",
            Description = "Home tab memakai profile card, segmented view, server card, friends card, dan Discord card.",
        },
    },
})

local config = {
    tpbeszonedelay = 30,
    autoTeleportBestZoneEnabled = false,
    AutoLoot = false,
}

local fitur = window:AddCategory({
    Name = "Features",
    Icon = "lucide:play",
    Open = true,
})

local main = fitur:AddTab({
    Name = "Main",
    Icon = "lucide:gamepad-2",
    Type = "Single",
})

local mainroll = main:AddCenterTabbox("Main Features")

local rolll = mainroll:AddTab("Roll", "circle-dot-dashed")
-- dikasih han males ganti
local GameData = {
    RSv1 = game:GetService("ReplicatedStorage"),
    autoRollingv1 = false,
    totalRollsv1 = 0,
    skipAnimationv1 = false,
}

GameData.RollServiceClientv1 = require(GameData.RSv1.Source.Features.Roll.RollServiceClient)
GameData.RollSlicev1 = require(GameData.RSv1.Source.Features.Roll.RollSlice)
GameData.RollServiceUtilsv1 = require(GameData.RSv1.Source.Features.Roll.RollServiceUtils)
GameData.Slimesv1 = require(GameData.RSv1.Source.Game.Items.Slimes)

GameData.rollInfov1 = rolll:AddParagraph({
    Name = "Roll Info",
    Content = "Not rolling yet..."
})

GameData.rollImagev1 = rolll:AddImage({
    Name = "Last Roll",
    Image = "",
    Height = 110,
    Corner = 8,
})

rolll:AddToggle({
    Name = "Skip Animation Roll",
    Default = false,
    Flag = "SkipAnimationRoll",
    Callback = function(Value)
        GameData.skipAnimationv1 = Value
    end
})

rolll:AddToggle({
    Name = "Hidden Roll",
    Default = false,
    Flag = "HiddenRoll",
    Callback = function(Value)
        GameData.RollSlicev1.hiddenRoll(Value)
    end
})

rolll:AddToggle({
    Name = "Auto Roll",
    Default = false,
    Flag = "AutoRoll",
    Callback = function(Value)
        GameData.autoRollingv1 = Value

        if Value then
            task.spawn(function()
                while GameData.autoRollingv1 do
                    GameData.RollServiceClientv1:roll()

                    local timeout = 0
                    repeat
                        task.wait(0.05)
                        timeout += 0.05
                    until GameData.RollSlicev1.rollResults()[1] ~= nil or timeout >= 5

                    if GameData.RollSlicev1.rollResults()[1] == nil then
                        task.wait(0.5)
                        continue
                    end

                    local columns = GameData.RollSlicev1.rollResults()

                    if GameData.skipAnimationv1 then
                        task.wait(0.3) 
                        GameData.RollSlicev1.rollScreenShown(false)
                        GameData.RollSlicev1.jackpotScreenShown(false)
                        GameData.RollSlicev1.rollResults({})
                        GameData.RollSlicev1.bonusRollResults({})
                        GameData.RollSlicev1.rareRollCutsceneShown(false)
                    end

                    local slimes = {}
                    local luckHits = 0
                    local lastSlimeId = nil

                    for _, column in ipairs(columns) do
                        for _, result in ipairs(column) do
                            if GameData.RollServiceUtilsv1.isLuckRoll(result) then
                                luckHits += 1
                            elseif not GameData.RollServiceUtilsv1.isBonusRoll(result) then
                                local id = result.id or "?"
                                lastSlimeId = id

                                local ok, slimeData = pcall(GameData.Slimesv1.getSlime, id)
                                local displayName = (ok and slimeData and slimeData.name) or id

                                local mutList = {}
                                if result.mutations then
                                    for mutId, _ in pairs(result.mutations) do
                                        table.insert(mutList, mutId)
                                    end
                                end

                                local mutStr = #mutList > 0 and (" [" .. table.concat(mutList, ", ") .. "]") or ""
                                table.insert(slimes, displayName .. mutStr)
                            end
                        end
                    end

                    if lastSlimeId then
                        local ok, slimeData = pcall(GameData.Slimesv1.getSlime, lastSlimeId)
                        if ok and slimeData and slimeData.image then
                            local assetId = tostring(slimeData.image):gsub("rbxassetid://", "")
                            GameData.rollImagev1:SetImage(assetId)
                        end
                    end

                    GameData.totalRollsv1 += 1
                    GameData.rollInfov1:SetContent(
                        "Total Rolls: <b>" .. GameData.totalRollsv1 .. "</b>\n" ..
                        "Got: <b>" .. table.concat(slimes, ", ") .. "</b>\n" ..
                        "Luck Hits: <b>" .. luckHits .. "</b>"
                    )

                    if not GameData.skipAnimationv1 then
                        repeat task.wait(0.05) until GameData.RollSlicev1.rollResults()[1] == nil
                            and not GameData.RollSlicev1.jackpotScreenShown()
                            and not GameData.RollSlicev1.rareRollCutsceneShown()
                    else
                        task.wait(0.3) 
                    end

                    task.wait(0.1)
                end

                GameData.rollInfov1:SetContent(
                    "Total Rolls: <b>" .. GameData.totalRollsv1 .. "</b>\n" ..
                    "Auto Roll <b>stopped</b>."
                )
            end)
        else
            GameData.autoRollingv1 = false
        end
    end
})

local fiturlain = main:AddLeftTabbox("Auto")
local fiturlainright = main:AddRightTabbox("emmm")

function TeleportBestZone()
    local zones = service.Workspace.Zones:GetChildren()
    local returnZones = {}
    for _, zone in pairs(zones) do
        local blockerName = "ClientGateBlocker_" .. zone.Name
        local gate = zone.Gate:FindFirstChild(blockerName)
        if gate then
            table.insert(returnZones, gate)
        end
    end
    local counter = 0
    for _, gateBlocker in pairs(returnZones) do
        if gateBlocker.CanCollide ~= true then
            if tonumber(gateBlocker.Parent.Parent.Name) > counter then
                counter = tonumber(gateBlocker.Parent.Parent.Name)
            end
        end
    end
    counter = counter + 1
    Teleport(counter)
end

local function autoloot()
    task.spawn(function()
        while config.AutoLoot do
            local Character = LocalPlayer.Character
            local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
            local LootFolder = service.Workspace:FindFirstChild("Loot")

            if HRP and LootFolder then
                for _, loot in ipairs(LootFolder:GetChildren()) do
                    if not config.AutoLoot then break end

                    if loot:IsA("BasePart") then
                        HRP.CFrame = loot.CFrame + Vector3.new(0,3,0)

                    elseif loot:IsA("Model") and loot.PrimaryPart then
                        HRP.CFrame = loot.PrimaryPart.CFrame + Vector3.new(0,3,0)
                    end

                    task.wait(0.5)
                end
            end

            task.wait(1)
        end
    end)
end


local shoot = fiturlain:AddTab("Shoot", "lucide:refresh-ccw")
local zone = fiturlain:AddTab("Zone", "lucide:chevrons-right-left")
local loot = fiturlain:AddTab("Loot", "lucide:refresh-ccw")

zone:AddToggle({
    Title = "Auto Teleport Best Zone",
    Default = false,
    Flag = "tpbestzone",
    Callback = function(state)
        config.autoTeleportBestZoneEnabled = state
        if state then
            task.spawn(function()
                while config.autoTeleportBestZoneEnabled do
                    TeleportBestZone()
                    task.wait(config.tpbeszonedelay)
                end
            end)
        end
    end
})

zone:AddSlider({
    Name = "Teleport Best Zone Delay",
    Default = 30,
    Min = 1,
    Max = 200,
    Type = "S",
    Flag = "RightTabboxJumpPower",
    Callback = function(value)
        config.tpbeszonedelay = tonumber(value) or 30
    end
})

loot:AddToggle({
    Name = "Auto Collect Loot",
    Default = false,
    Flag = "AutoLootTP",
    Callback = function(Value)
        config.AutoLoot = Value

        if Value then
            autoloot()
        end
    end
})
