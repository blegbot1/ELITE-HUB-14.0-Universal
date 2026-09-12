-- ELITE HUB 14.0 loader: builds shared env, creates window+tabs, runs modules
local function readModule(path)
    assert(readfile, "ELITE HUB: executor lacks readfile")
    local ok, src = pcall(readfile, path)
    assert(ok and src and src ~= "", "ELITE HUB: cannot read " .. path)
    return src
end
local function loadModuleChunk(path)
    local chunk, err = loadstring(readModule(path), "@" .. path)
    assert(chunk, "ELITE HUB: parse error in " .. path .. ": " .. tostring(err))
    return chunk
end

local Rayfield = loadModuleChunk("modules/ui_library.lua")()
local ES, L
do
    ES = {
        Animations = true,
        Lang = "EN",
    }
    pcall(function()
        if isfile("EliteHub_Config.json") then
            local data = game:GetService("HttpService"):JSONDecode(readfile("EliteHub_Config.json"))
            if data.Animations ~= nil then ES.Animations = data.Animations end
            if data.Lang then ES.Lang = data.Lang end
        end
    end)
    getgenv().EliteHubSettings = ES

    local LangData = {
        RU = {
            Settings = "",
            Language = "",
            Animations = "",
            ResetSettings = " ",
            Main = "",
            ESP = "ESP",
            Aimbot = "AIMBOT",
            Visual = "",
            Teleport = "",
            KillAll = " ",
            FEScripts = "FE ",
            Hubs = "",
            GameScripts = "  ",
            Mods = "",
            Config = "",
            SaveConfig = "  ",
            LoadConfig = "  ",
            ConfigSaved = " !",
            ConfigLoaded = " !",
            NoConfig = "  ",
            SettingsReset = " ",
            Version = "ELITE HUB 14.0 HASKER | v14.0",
            ON = "",
            OFF = "",
            ItemFinder = " ",
            ItemFinderDesc = "    ",
            Refresh = " ",
            SearchItem = "  ",
            NoItems = "  ",
            Found = "",
            items = "",
        },
        EN = {
            Settings = "SETTINGS",
            Language = "Language",
            Animations = "Animations",
            ResetSettings = "Reset Settings",
            Main = "MAIN",
            ESP = "ESP",
            Aimbot = "AIMBOT",
            Visual = "VISUAL",
            Teleport = "TELEPORT",
            KillAll = "KILL ALL",
            FEScripts = "FE SCRIPTS",
            Hubs = "HUBS",
            GameScripts = "GAME SCRIPTS",
            Mods = "MODS",
            Config = "CONFIG",
            SaveConfig = " Save Config",
            LoadConfig = " Load Config",
            ConfigSaved = "Config saved!",
            ConfigLoaded = "Config loaded!",
            NoConfig = "No config found",
            SettingsReset = "Settings reset",
            Version = "ELITE HUB 14.0 HASKER | v14.0",
            ON = "ON",
            OFF = "OFF",
            ItemFinder = "ITEM FINDER",
            ItemFinderDesc = "Find and teleport to items",
            Refresh = " Refresh",
            SearchItem = " Search Item",
            NoItems = "No items found",
            Found = "Found",
            items = "items",
        },
    }

    function L(key)
        local t = LangData[ES.Lang] or LangData.RU
        return t[key] or key
    end
end


local debugMode = true  -- РїРѕСЃС‚Р°РІРёС‚СЊ false, С‡С‚РѕР±С‹ РІС‹РєР»СЋС‡РёС‚СЊ Р»РѕРіРё

if getgenv().ELITE_HUB_HASKER_LOADED then
    Rayfield:Notify({ Title = "Already running", Content = "ELITE HUB is already loaded", Duration = 3 })
    return
end
getgenv().ELITE_HUB_HASKER_LOADED = true

task.spawn(function()
    local LG = Instance.new("ScreenGui")
    LG.Name = "EliteHubLoader"
    LG.ResetOnSpawn = false
    LG.IgnoreGuiInset = true
    LG.DisplayOrder = 999
    LG.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(8, 5, 16)
    bg.BorderSizePixel = 0
    bg.Parent = LG

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0.3, -50)
    title.Text = "ELITE HUB"
    title.TextColor3 = Color3.fromRGB(180, 120, 255)
    title.TextSize = 48
    title.Font = Enum.Font.GothamBlack
    title.TextStrokeTransparency = 0.5
    title.TextStrokeColor3 = Color3.fromRGB(100, 50, 200)
    title.Parent = bg

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Size = UDim2.new(1, 0, 0, 24)
    sub.Position = UDim2.new(0, 0, 0.3, 15)
    sub.Text = "14.0 HASKER EDITION | UPDATED"
    sub.TextColor3 = Color3.fromRGB(120, 80, 180)
    sub.TextSize = 16
    sub.Font = Enum.Font.GothamMedium
    sub.Parent = bg

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 300, 0, 4)
    barBg.Position = UDim2.new(0.5, -150, 0.3, 55)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    barBg.BorderSizePixel = 0
    barBg.Parent = bg
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
    bar.BorderSizePixel = 0
    bar.Parent = barBg
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.3, 70)
    status.Text = "Initializing..."
    status.TextColor3 = Color3.fromRGB(100, 70, 150)
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.Parent = bg

    local TweenService = game:GetService("TweenService")
    local steps = {
        {0.15, "Loading Rayfield..."},
        {0.30, "Setting up ESP..."},
        {0.45, "Setting up Aimbot..."},
        {0.55, "Loading functions..."},
        {0.70, "Creating interface..."},
        {0.85, "Applying settings..."},
        {0.95, "Finalizing..."},
        {1.0,  "Done!"},
    }
    for _, step in ipairs(steps) do
        TweenService:Create(bar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(step[1], 0, 1, 0)}):Play()
        status.Text = step[2]
        task.wait(0.3)
    end

    task.wait(0.3)
    TweenService:Create(bg, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(status, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(bar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.6)
    LG:Destroy()
end)

local formatTime = function()
    local t = os.time()
    return os.date("[%H:%M:%S]", t)
end

local function Log(category, message, ...)
    if not debugMode then return end
    local args = {...}
    local prefix = formatTime() .. " [LOG]"
    pcall(function()
        print(prefix, "[" .. tostring(category) .. "]", tostring(message))
        for _, v in ipairs(args) do print(prefix, tostring(v)) end
    end)
end
getgenv().ELITE_HUB_Log = Log

getgenv().ELITE_HUB_RUN_COUNT = (getgenv().ELITE_HUB_RUN_COUNT or 0) + 1
Log("SYSTEM", " .   #" .. tostring(getgenv().ELITE_HUB_RUN_COUNT))

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- LOADING CHECKLIST вЂ” РєРѕРЅСЃРѕР»СЊРЅР°СЏ Р·Р°РіСЂСѓР·РєР°, РїСЂРѕРІРµСЂСЏРµС‚ РІСЃС‘ РїРѕ С€Р°РіР°Рј
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
do
    local function Check(name, ok, info)
        if ok then
            print("[" .. formatTime() .. "] [BOOT]  " .. name .. (info and ("  " .. tostring(info)) or ""))
        else
            print("[" .. formatTime() .. "] [BOOT]  " .. name .. (info and ("  " .. tostring(info)) or " (N/A)"))
        end
    end

    print("")
    print("======================================================")
    print("         ELITE  HUB  14.0    HASKER")
    print("                loading...")
    print("======================================================")

    local execName = "unknown"
    pcall(function()
        local id = identifyexecutor()
        if type(id) == "table" then
            execName = id[1]
        elseif type(id) == "string" then
            execName = id
        end
    end)
    task.wait(0.1)
    Check("Executor", execName ~= "unknown", execName)

    local ver = "?"
    pcall(function() ver = version() end)
    task.wait(0.1)
    Check("Runtime", ver ~= "?" and ver ~= "unknown", tostring(ver))

    task.wait(0.1)
    local gameName = "N/A"
    pcall(function() gameName = tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name) end)
    Check("Game", gameName ~= "N/A", gameName .. " (" .. tostring(game.PlaceId) .. ")")

    task.wait(0.1)
    local pl = game:GetService("Players").LocalPlayer
    Check("Player", pl ~= nil, pl and (pl.Name .. " [" .. tostring(pl.UserId) .. "]") or "N/A")

    task.wait(0.1)
    Check("Run count", true, "#" .. tostring(getgenv().ELITE_HUB_RUN_COUNT))

    task.wait(0.1)
    local drawOk = pcall(function()
        local d = Drawing.new("Line")
        d:Remove()
        return true
    end)
    Check("Drawing API", drawOk)

    task.wait(0.1)
    local hasGetenv = type(getgenv) == "function"
    Check("getgenv()", hasGetenv)

    task.wait(0.1)
    local hs = "N/A"
    pcall(function() hs = tostring(game:GetService("HttpService")) end)
    Check("HttpService", hs ~= "N/A")

    task.wait(0.1)
    local httpGetOk = false
    pcall(function()
        game.HttpGet(game, "https://kvdb.io")
        httpGetOk = true
    end)
    task.wait(0.1)
    Check("game:HttpGet", httpGetOk, "  ")

    task.wait(0.1)
    local reqNames = {}
    if request then table.insert(reqNames, "request") end
    if http_request then table.insert(reqNames, "http_request") end
    if syn and syn.request then table.insert(reqNames, "syn.request") end
    if http and http.request then table.insert(reqNames, "http.request") end
    Check("HTTP request()", #reqNames > 0, "N/A" or (#reqNames > 0 and table.concat(reqNames, ", ") or "N/A"))

    task.wait(0.1)
    pcall(function() game:GetService("UserInputService") end)
    pcall(function() game:GetService("TweenService") end)
    Check("Services UIS/Tween/Run", true, "loaded")

    task.wait(0.1)
    pcall(function() game:GetService("RunService") end)
    Check("RunService", true, "loaded")

    task.wait(0.1)
    print("======================================================")
    print("     ALL CHECKS COMPLETE  initializing UI...")
    print("======================================================")
    print("")
end

local DrawingSupported = pcall(function()
    local d = Drawing.new("Line")
    d:Remove()
    return true
end)
Log("SYSTEM", " Drawing: " .. tostring(DrawingSupported))

local ThemePurple = {
	TextColor = Color3.fromRGB(245, 245, 255),

	Background = Color3.fromRGB(30, 20, 50),
	Topbar = Color3.fromRGB(50, 35, 80),
	Shadow = Color3.fromRGB(15, 10, 25),

	NotificationBackground = Color3.fromRGB(30, 20, 50),
	NotificationActionsBackground = Color3.fromRGB(170, 0, 255),

	TabBackground = Color3.fromRGB(60, 45, 95),
	TabStroke = Color3.fromRGB(80, 60, 120),
	TabBackgroundSelected = Color3.fromRGB(170, 0, 255),
	TabTextColor = Color3.fromRGB(240, 240, 240),
	SelectedTabTextColor = Color3.fromRGB(255, 255, 255),

	ElementBackground = Color3.fromRGB(40, 28, 66),
	ElementBackgroundHover = Color3.fromRGB(54, 38, 88),
	SecondaryElementBackground = Color3.fromRGB(30, 20, 50),
	ElementStroke = Color3.fromRGB(80, 60, 125),
	SecondaryElementStroke = Color3.fromRGB(60, 42, 100),

	SliderBackground = Color3.fromRGB(110, 90, 160),
	SliderProgress = Color3.fromRGB(170, 0, 255),
	SliderStroke = Color3.fromRGB(200, 80, 255),

	ToggleBackground = Color3.fromRGB(35, 24, 60),
	ToggleEnabled = Color3.fromRGB(170, 0, 255),
	ToggleDisabled = Color3.fromRGB(105, 95, 125),
	ToggleEnabledStroke = Color3.fromRGB(200, 80, 255),
	ToggleDisabledStroke = Color3.fromRGB(130, 120, 150),
	ToggleEnabledOuterStroke = Color3.fromRGB(110, 95, 140),
	ToggleDisabledOuterStroke = Color3.fromRGB(75, 65, 95),

	DropdownSelected = Color3.fromRGB(48, 34, 78),
	DropdownUnselected = Color3.fromRGB(35, 24, 58),

	InputBackground = Color3.fromRGB(35, 24, 58),
	InputStroke = Color3.fromRGB(80, 60, 125),
	PlaceholderColor = Color3.fromRGB(178, 168, 200)
}
local Window = Rayfield:CreateWindow({
    Name = "💎 ELITE HUB 14.0 HASKER 💎",
    LoadingTitle = "⚡🔥 Hasker Edition загружается... 🔥⚡",
    LoadingSubtitle = "💜👑 by gerkylesichakes | Версия 14.0 | Обновлено: +Mods, Chams, ESP, Aimbot, Spin Bot 👑💜",
    Theme = ThemePurple
})
Window._L = L

getgenv().ELITE_HUB_Log("UI", "Creating tabs...")
local MainTab = Window:CreateTab("🏠 " .. L("Main"), 11286187172, "Main")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Main")
local ESPTab = Window:CreateTab("👁 " .. L("ESP"), 6026568198, "ESP")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: ESP")
local CombatTab = Window:CreateTab("🎯 " .. L("Aimbot"), 7733960981, "Aimbot")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Aimbot")
local VisualTab = Window:CreateTab("🎨 " .. L("Visual"), 6022668888, "Visual")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Visual")
local TeleportTab = Window:CreateTab("🌀 " .. L("Teleport"), 6023426915, "Teleport")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Teleport")
local KillAllTab = Window:CreateTab("💀 " .. L("KillAll"), 0, "KillAll")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: KillAll")
local FEScriptsTab = Window:CreateTab("🛡 " .. L("FEScripts"), 7733960981, "FEScripts")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: FEScripts")
local HubsTab = Window:CreateTab("🌐 " .. L("Hubs"), 6022668888, "Hubs")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Hubs")
local GameScriptsTab = Window:CreateTab("🎮 " .. L("GameScripts"), 7733960981, "GameScripts")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: GameScripts")

-- РќРѕРІС‹Рµ СЂР°Р·РґРµР»СЊРЅС‹Рµ РІРєР»Р°РґРєРё РІРјРµСЃС‚Рѕ РѕРґРЅРѕР№ "РњРѕРґС‹"

local MovementTab = Window:CreateTab("🏃 " .. "MOVEMENT", 6026568198, "Movement")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: MOVEMENT")
local CombatPlusTab = Window:CreateTab("⚔ " .. "COMBAT+", 7733960981, "CombatPlus")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: COMBAT+")
local CameraTeleportTab = Window:CreateTab("📷 " .. "CAMERA", 6023426915, "CameraTeleport")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: CAMERA")


local UtilitiesTab = Window:CreateTab("🔧 " .. "UTILS", 6022668888, "Utilities")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: UTILS")
local MusicTab = Window:CreateTab("🎵 " .. "MUSIC", 6022668888, "Music")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: MUSIC")
getgenv().ELITE_HUB_ChamsTab = Window:CreateTab("🎨 " .. "CHAMS", 6026568198, "Chams")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: CHAMS")
getgenv().ELITE_HUB_PlayersTab = Window:CreateTab("👥 " .. "ИГРОКИ", 6026568198, "Players")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: ИГРОКИ")

MT = VisualTab

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- CHINESE HAT вЂ” РєРѕРЅСѓСЃРЅР°СЏ С€Р»СЏРїР°, ForceField, 3D
-- Р‘Р•Р— WeldConstraint вЂ” parts СЃР»РµРґСѓСЋС‚ Р·Р° РіРѕР»РѕРІРѕР№ С‡РµСЂРµР· Heartbeat
-- Massless + PhysicalProperties = РЅРµС‚ С„РёР·. РІР·СЂС‹РІРѕРІ
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
task.spawn(function()
local MT = VisualTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: CHINESE HAT")
MT:CreateSection("🎩 CHINESE HAT")

getgenv().ELITE_HUB_ChineseHatOn = false
getgenv().ELITE_HUB_ChineseHatY = 0.5
getgenv().ELITE_HUB_ChineseHatConeH = 1.2
getgenv().ELITE_HUB_ChineseHatR = 2.5
getgenv().ELITE_HUB_ChineseHatColor = Color3.fromRGB(255, 0, 255)
getgenv().ELITE_HUB_ChineseHatSpin = false
getgenv().ELITE_HUB_ChineseHatSpinSpeed = 50
getgenv().ELITE_HUB_ChineseHatMat = "ForceField"
local hatConn = nil
local hatParts = {}
local hatSpinParts = {}

local function RemoveHat(char)
    if hatConn then hatConn:Disconnect() hatConn = nil end
    hatParts = {}
    hatSpinParts = {}
    local old = workspace:FindFirstChild("ELITEHUB_CHINESE_HAT")
    if old then pcall(function() old:Destroy() end) end
end

local function MakePart(props)
    local p = Instance.new("Part")
    p.Size = props.Size or Vector3.new(1,1,1)
    p.Shape = props.Shape or Enum.PartType.Block
    p.Material = Enum.Material[props.Material or getgenv().ELITE_HUB_ChineseHatMat or "ForceField"]
    p.Color = props.Color or Color3.new(1,1,1)
    p.CanCollide = false
    p.Anchored = true
    p.CastShadow = false
    p.Massless = true
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.FrontSurface = Enum.SurfaceType.Smooth
    p.BackSurface = Enum.SurfaceType.Smooth
    p.LeftSurface = Enum.SurfaceType.Smooth
    p.RightSurface = Enum.SurfaceType.Smooth
    p.CustomPhysicalProperties = PhysicalProperties.new(0.001, 0, 0, 1, 1)
    return p
end

local function BuildHat(char)
    if not getgenv().ELITE_HUB_ChineseHatOn then return end
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    RemoveHat(char)
    task.wait(0.2)

    local hat = Instance.new("Model")
    hat.Name = "ELITEHUB_CHINESE_HAT"
    hat.Parent = workspace

    local R = getgenv().ELITE_HUB_ChineseHatR
    local H = getgenv().ELITE_HUB_ChineseHatConeH
    local Y = getgenv().ELITE_HUB_ChineseHatY
    local COL = getgenv().ELITE_HUB_ChineseHatColor
    local N = 48
    local headCF = head.CFrame

    for i = 0, N - 1 do
        local ang = (i / N) * math.pi * 2
        local segW = 2 * R * math.tan(math.pi / N) * 1.08

        local slat = MakePart({
            Size = Vector3.new(segW, math.sqrt(R*R + H*H), 0.03),
            Color = COL,
        })

        local bottomPos = Vector3.new(R * math.cos(ang), Y, R * math.sin(ang))
        local apexPos = Vector3.new(0, Y + H, 0)
        local center = (bottomPos + apexPos) / 2
        local dir = (apexPos - bottomPos).Unit
        local tangent = Vector3.new(-math.sin(ang), 0, math.cos(ang))

        local localCF = CFrame.fromMatrix(center, tangent, dir)
        local worldCF = headCF * localCF

        slat.CFrame = worldCF
        slat:BreakJoints()
        slat.Parent = hat
        hatParts[slat] = headCF:Inverse() * worldCF
        hatSpinParts[slat] = localCF
    end

    local tip = MakePart({
        Shape = Enum.PartType.Ball,
        Size = Vector3.new(0.15, 0.18, 0.15),
        Color = COL,
    })
    local tipLocal = CFrame.new(0, Y + H + 0.05, 0)
    tip.CFrame = headCF * tipLocal
    tip:BreakJoints()
    tip.Parent = hat
    hatParts[tip] = tipLocal
    hatSpinParts[tip] = tipLocal

    local brim = MakePart({
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(0.06, R * 2 + 0.4, R * 2 + 0.4),
        Color = COL,
    })
    local brimLocal = CFrame.new(0, Y, 0) * CFrame.Angles(0, 0, math.pi / 2)
    brim.CFrame = headCF * brimLocal
    brim:BreakJoints()
    brim.Parent = hat
    hatParts[brim] = brimLocal
    hatSpinParts[brim] = brimLocal

    for p, _ in pairs(hatParts) do
        p.Anchored = false
    end

    if hatConn then hatConn:Disconnect() hatConn = nil end
    local RunService = game:GetService("RunService")
    local spinAngle = 0
    hatConn = RunService.Heartbeat:Connect(function(dt)
        pcall(function()
            if not getgenv().ELITE_HUB_ChineseHatOn then
                hatConn:Disconnect()
                hatConn = nil
                return
            end
            local h = workspace:FindFirstChild("ELITEHUB_CHINESE_HAT")
            if not h then
                local ch = player.Character
                if ch and ch:FindFirstChild("Head") then
                    task.spawn(function() BuildHat(ch) end)
                end
                return
            end
            local hd = char:FindFirstChild("Head")
            if not hd then return end

            if getgenv().ELITE_HUB_ChineseHatSpin then
                spinAngle = spinAngle + (getgenv().ELITE_HUB_ChineseHatSpinSpeed or 50) * dt * 3
            end

            local spinCF = CFrame.Angles(0, math.rad(spinAngle), 0)
            local hdCF = hd.CFrame
            for p, localCF in pairs(hatSpinParts) do
                if p and p.Parent then
                    p.CanCollide = false
                    p.Massless = true
                    p.CFrame = hdCF * spinCF * localCF
                end
            end
        end)
    end)
end

getgenv().ELITE_HUB_BuildHat = BuildHat
getgenv().ELITE_HUB_RemoveHat = RemoveHat

MT:CreateToggle({
    Name = " Chinese Hat",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatOn = value
        getgenv().ELITE_HUB_Log("MODS", "Chinese Hat: " .. tostring(value))
        if value then
            task.spawn(function() BuildHat(player.Character) end)
        else
            RemoveHat(player.Character)
        end
    end
})

MT:CreateSlider({
    Name = " Hat Height (Y)",
    Range = {0, 1.5},
    Increment = 0.05,
    CurrentValue = 0.5,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatY = value
        if getgenv().ELITE_HUB_ChineseHatOn then
            task.spawn(function() BuildHat(player.Character) end)
        end
    end
})

MT:CreateSlider({
    Name = " Cone Height",
    Range = {0.3, 3},
    Increment = 0.1,
    CurrentValue = 1.2,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatConeH = value
        if getgenv().ELITE_HUB_ChineseHatOn then
            task.spawn(function() BuildHat(player.Character) end)
        end
    end
})

MT:CreateSlider({
    Name = " Cone Radius",
    Range = {0.5, 3},
    Increment = 0.1,
    CurrentValue = 2.5,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatR = value
        if getgenv().ELITE_HUB_ChineseHatOn then
            task.spawn(function() BuildHat(player.Character) end)
        end
    end
})

MT:CreateColorPicker({
    Name = " Hat Color",
    Color = Color3.fromRGB(255, 0, 255),
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatColor = value
        if getgenv().ELITE_HUB_ChineseHatOn then
            task.spawn(function() BuildHat(player.Character) end)
        end
    end
})

MT:CreateToggle({
    Name = " Spin",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatSpin = value
        getgenv().ELITE_HUB_Log("MODS", "Chinese Hat Spin: " .. tostring(value))
    end
})

MT:CreateSlider({
    Name = " Spin Speed",
    Range = {10, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatSpinSpeed = value
    end
})

local hatMats = {"ForceField","Neon","Glass","SmoothPlastic","Metal","DiamondPlate","Wood","WoodPlanks","Grass","Slate","Marble","Granite","Cobblestone","Brick","Sand","CorrodedMetal","Foil","Ice","LeafyGrass","Mud","Sandstone","Asphalt","Basalt","Chalk","Clay","Rock","Limestone","Pavement","Plastic","Rubber","Fabric","Carpet","Foam","Cotton","Wool"}
MT:CreateDropdown({
    Name = " Material",
    Options = hatMats,
    CurrentOption = {"ForceField"},
    Flag = "ChineseHatMat",
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatMat = value
        for p, _ in pairs(hatParts) do
            pcall(function() p.Material = Enum.Material[value] end)
        end
    end
})

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        if getgenv().ELITE_HUB_ChineseHatOn then
            BuildHat(char)
        end
    end)
end)
end)

-- ============================================================
-- FUN VISUALS (Aura, Horns, Big Head, Gold, Wings)
-- ============================================================
task.spawn(function()
local MT = VisualTab
local Players = game:GetService("Players")
local player = Players.LocalPlayer
getgenv().ELITE_HUB_Log("UI", "Section loaded: FUN VISUALS")

local function MP(props)
    local p = Instance.new("Part")
    p.Size = props.Size or Vector3.new(1,1,1)
    p.Shape = props.Shape or Enum.PartType.Block
    p.Material = Enum.Material[props.Material or "ForceField"]
    p.Color = props.Color or Color3.new(1,1,1)
    p.CanCollide = false
    p.Anchored = true
    p.CastShadow = false
    p.Massless = true
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.FrontSurface = Enum.SurfaceType.Smooth
    p.BackSurface = Enum.SurfaceType.Smooth
    p.LeftSurface = Enum.SurfaceType.Smooth
    p.RightSurface = Enum.SurfaceType.Smooth
    p.CustomPhysicalProperties = PhysicalProperties.new(0.001, 0, 0, 1, 1)
    return p
end

local function ClearModel(name)
    local old = workspace:FindFirstChild(name)
    if old then pcall(function() old:Destroy() end) end
end

local function Unanchor(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("BasePart") then d.Anchored = false end
    end
end

local function characterTorso(ch)
    if not ch then return nil end
    return ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
end

-- ============================================================
-- AURA (Halo)
-- ============================================================
getgenv().ELITE_HUB_AuraOn = false
getgenv().ELITE_HUB_AuraColor = Color3.fromRGB(255, 215, 0)
getgenv().ELITE_HUB_AuraSize = 1
getgenv().ELITE_HUB_VisualMaterial = "Neon"
getgenv().ELITE_HUB_AuraSpin = false
getgenv().ELITE_HUB_AuraSpinSpeed = 40
local auraConn = nil
local auraHalo = {}

local function RemoveAura()
    if auraConn then pcall(function() auraConn:Disconnect() end) auraConn = nil end
    auraHalo = {}
    ClearModel("ELITEHUB_AURA")
end

local function BuildAura(char)
    if not getgenv().ELITE_HUB_AuraOn then return end
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    RemoveAura()
    task.wait(0.2)
    local S = getgenv().ELITE_HUB_AuraSize or 1
    local COL = getgenv().ELITE_HUB_AuraColor
    local MAT = getgenv().ELITE_HUB_VisualMaterial or "Neon"
    local headCF = head.CFrame
    local au = Instance.new("Model")
    au.Name = "ELITEHUB_AURA"
    au.Parent = workspace
    local R = 0.6 * S
    local N = 24
    for i = 0, N - 1 do
        local ang = (i / N) * math.pi * 2
        local chord = R * 2 * math.tan(math.pi / N) * 1.5
        local seg = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.25 * S, chord, 0.25 * S), Color = COL, Material = MAT })
        local pos = Vector3.new(R * math.cos(ang), 0.95 * S + 0.05, R * math.sin(ang))
        local tang = Vector3.new(-math.sin(ang), 0, math.cos(ang))
        local ccf = CFrame.fromMatrix(pos, Vector3.new(0, 1, 0), tang)
        seg.CFrame = headCF * ccf
        seg:BreakJoints()
        seg.Parent = au
        auraHalo[seg] = ccf
    end
    Unanchor(au)
    if auraConn then pcall(function() auraConn:Disconnect() end) end
    local spinA = 0
    auraConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
        pcall(function()
            if not getgenv().ELITE_HUB_AuraOn then RemoveAura() return end
            local h = workspace:FindFirstChild("ELITEHUB_AURA")
            if not h then
                local c = player.Character
                if c and c:FindFirstChild("Head") then task.spawn(function() BuildAura(c) end) end
                return
            end
            local hd = char:FindFirstChild("Head")
            if not hd then return end
            if getgenv().ELITE_HUB_AuraSpin then
                spinA = spinA + (getgenv().ELITE_HUB_AuraSpinSpeed or 40) * dt * 3
            end
            local spinCF = CFrame.Angles(0, math.rad(spinA), 0)
            local hdCF = hd.CFrame
            for p, lcf in pairs(auraHalo) do
                if p and p.Parent then p.CFrame = hdCF * spinCF * lcf end
            end
        end)
    end)
end
getgenv().ELITE_HUB_BuildAura = BuildAura
getgenv().ELITE_HUB_RemoveAura = RemoveAura

-- ============================================================
-- HORNS (10 styles + size, head top)
-- ============================================================
getgenv().ELITE_HUB_HornsOn = false
getgenv().ELITE_HUB_HornType = 1
getgenv().ELITE_HUB_HornSize = 1
local hornConn = nil
local hornParts = {}

local HORN_TYPES = {
    { label = "Classic", p0 = Vector3.new(0.17, 0.5, -0.04), d0 = Vector3.new(0.16, 1, -0.14), d1 = Vector3.new(0.05, 1, -0.36), ns = 48, step = 0.022, db = 0.085, disc = 0.2, tip = 0.08, spikes = nil },
    { label = "Goat", p0 = Vector3.new(0.16, 0.5, 0), d0 = Vector3.new(0.1, 1, -0.06), d1 = Vector3.new(-0.06, 1, -0.2), ns = 40, step = 0.02, db = 0.075, disc = 0.17, tip = 0.06, spikes = nil },
    { label = "Bull", p0 = Vector3.new(0.2, 0.42, 0.05), d0 = Vector3.new(0.3, 0.75, 0.3), d1 = Vector3.new(0.55, 0.35, 0.5), ns = 30, step = 0.032, db = 0.125, disc = 0.26, tip = 0.09, spikes = nil },
    { label = "Ram", p0 = Vector3.new(0.22, 0.48, 0), d0 = Vector3.new(0.4, 0.55, 0.1), d1 = Vector3.new(-0.05, 0.9, -0.25), ns = 56, step = 0.022, db = 0.105, disc = 0.24, tip = 0.08, spikes = nil },
    { label = "Imp", p0 = Vector3.new(0.14, 0.5, 0), d0 = Vector3.new(0.06, 1, 0), d1 = Vector3.new(0.03, 1, -0.1), ns = 26, step = 0.02, db = 0.058, disc = 0.13, tip = 0.04, spikes = nil },
    { label = "Devil", p0 = Vector3.new(0.18, 0.48, -0.05), d0 = Vector3.new(0.1, 1, -0.22), d1 = Vector3.new(-0.02, 0.7, -0.6), ns = 52, step = 0.024, db = 0.095, disc = 0.22, tip = 0.06, spikes = nil },
    { label = "Dragon", p0 = Vector3.new(0.15, 0.5, -0.04), d0 = Vector3.new(0.13, 1, -0.16), d1 = Vector3.new(0.03, 0.9, -0.42), ns = 44, step = 0.02, db = 0.08, disc = 0.18, tip = 0.05, spikes = { { off = Vector3.new(0, 0, -0.1), d0 = Vector3.new(0.05, 1, -0.35), d1 = Vector3.new(0, 0.8, -0.6), ns = 26, step = 0.018, db = 0.05 }, { off = Vector3.new(0.06, 0.02, 0.02), d0 = Vector3.new(0.22, 0.85, 0.2), d1 = Vector3.new(0.45, 0.55, 0.4), ns = 20, step = 0.018, db = 0.045 } } },
    { label = "King", p0 = Vector3.new(0.2, 0.5, -0.05), d0 = Vector3.new(0.16, 1, -0.16), d1 = Vector3.new(0.3, 0.5, -0.6), ns = 56, step = 0.026, db = 0.14, disc = 0.3, tip = 0.09, spikes = nil },
    { label = "Stag", p0 = Vector3.new(0.15, 0.5, 0), d0 = Vector3.new(0.1, 1, -0.2), d1 = Vector3.new(0.2, 0.8, -0.45), ns = 44, step = 0.021, db = 0.08, disc = 0.18, tip = 0.05, spikes = { { off = Vector3.new(0.06, 0.42, -0.28), d0 = Vector3.new(0.05, 1, -0.3), d1 = Vector3.new(0.3, 0.6, -0.55), ns = 24, step = 0.018, db = 0.05 } } },
    { label = "Double", p0 = Vector3.new(0.16, 0.48, 0), d0 = Vector3.new(0.12, 1, 0.05), d1 = Vector3.new(0.24, 0.85, 0.4), ns = 34, step = 0.02, db = 0.08, disc = 0.18, tip = 0.05, spikes = { { off = Vector3.new(0.03, -0.12, 0.1), d0 = Vector3.new(0.5, 0.5, 0.4), d1 = Vector3.new(0.8, 0.25, 0.55), ns = 22, step = 0.02, db = 0.06 } } }
}

local function RemoveHorns()
    if hornConn then pcall(function() hornConn:Disconnect() end) hornConn = nil end
    hornParts = {}
    ClearModel("ELITEHUB_HORNS")
end

local function BuildHorns(char)
    if not getgenv().ELITE_HUB_HornsOn then return end
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    RemoveHorns()
    task.wait(0.2)
    local S = getgenv().ELITE_HUB_HornSize or 1
    if S < 0.1 then S = 0.1 end
    local COL = getgenv().ELITE_HUB_AuraColor
    local MAT = getgenv().ELITE_HUB_VisualMaterial or "Neon"
    local headCF = head.CFrame
    local hrn = Instance.new("Model")
    hrn.Name = "ELITEHUB_HORNS"
    hrn.Parent = workspace
    local function drawHorn(side, p0v, d0v, d1v, ns, step, db, discD, tipD)
        local P0 = Vector3.new(side * p0v.X * S, p0v.Y * S, p0v.Z * S)
        if discD and discD > 0 then
            local disc = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(discD * S, 0.04 * S, discD * S), Color = COL, Material = MAT })
            local bcf = CFrame.new(P0)
            disc.CFrame = headCF * bcf
            disc:BreakJoints()
            disc.Parent = hrn
            hornParts[disc] = bcf
        end
        local d0 = Vector3.new(side * d0v.X, d0v.Y, d0v.Z).Unit
        local d1 = Vector3.new(side * d1v.X, d1v.Y, d1v.Z).Unit
        local pos = P0
        local stepLen = step * S
        for k = 0, ns - 1 do
            local t = (k + 1) / ns
            local dir = d0:Lerp(d1, t)
            dir = dir.Unit
            local L = stepLen * 3.0
            local taper = 1 - (k / ns) * 0.97
            local D = (db * taper) * S
            if D < 0.015 * S then D = 0.015 * S end
            local xvec = Vector3.new(-dir.Z, 0, dir.X)
            if xvec.Magnitude < 0.01 then xvec = Vector3.new(0, 0, 1) end
            xvec = xvec.Unit
            local cp = pos + dir * (stepLen / 2)
            local lcf = CFrame.fromMatrix(cp, xvec, dir)
            local seg = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(D, L, D), Color = COL, Material = MAT })
            seg.CFrame = headCF * lcf
            seg:BreakJoints()
            seg.Parent = hrn
            hornParts[seg] = lcf
            pos = pos + dir * stepLen
        end
        if tipD and tipD > 0 then
            local tip = MP({ Shape = Enum.PartType.Ball, Size = Vector3.new(tipD * S, tipD * 1.2 * S, tipD * S), Color = COL, Material = MAT })
            local tlcf = CFrame.new(pos)
            tip.CFrame = headCF * tlcf
            tip:BreakJoints()
            tip.Parent = hrn
            hornParts[tip] = tlcf
        end
    end
    local function sideHorn(side)
        local cfg = HORN_TYPES[tonumber(getgenv().ELITE_HUB_HornType) or 1] or HORN_TYPES[1]
        drawHorn(side, cfg.p0, cfg.d0, cfg.d1, cfg.ns, cfg.step, cfg.db, cfg.disc, cfg.tip)
        if cfg.spikes then
            for _, sp in ipairs(cfg.spikes) do
                local p0v = Vector3.new(cfg.p0.X + sp.off.X, cfg.p0.Y + sp.off.Y, cfg.p0.Z + sp.off.Z)
                drawHorn(side, p0v, sp.d0, sp.d1, sp.ns, sp.step, sp.db, 0, 0)
            end
        end
    end
    sideHorn(-1)
    sideHorn(1)
    Unanchor(hrn)
    if hornConn then pcall(function() hornConn:Disconnect() end) end
    hornConn = game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            if not getgenv().ELITE_HUB_HornsOn then RemoveHorns() return end
            local h = workspace:FindFirstChild("ELITEHUB_HORNS")
            if not h then
                local c = player.Character
                if c and c:FindFirstChild("Head") then task.spawn(function() BuildHorns(c) end) end
                return
            end
            local hd = char:FindFirstChild("Head")
            if not hd then return end
            local hdCF = hd.CFrame
            for p, lcf in pairs(hornParts) do
                if p and p.Parent then p.CFrame = hdCF * lcf end
            end
        end)
    end)
end
getgenv().ELITE_HUB_BuildHorns = BuildHorns
getgenv().ELITE_HUB_RemoveHorns = RemoveHorns

MT:CreateSection("AURA / HORNS")
MT:CreateToggle({
    Name = " Aura (Halo)",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_AuraOn = v
        getgenv().ELITE_HUB_Log("MODS", "Aura: " .. tostring(v))
        if v then task.spawn(function() BuildAura(player.Character) end) else RemoveAura() end
    end
})
MT:CreateToggle({
    Name = " Horns",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_HornsOn = v
        getgenv().ELITE_HUB_Log("MODS", "Horns: " .. tostring(v))
        if v then task.spawn(function() pcall(function() BuildHorns(player.Character) end) end) else RemoveHorns() end
    end
})
MT:CreateDropdown({
    Name = " Horn Type",
    Options = { "Classic", "Goat", "Bull", "Ram", "Imp", "Devil", "Dragon", "King", "Stag", "Double" },
    CurrentOption = "Classic",
    Callback = function(opt)
        for i, ht in ipairs(HORN_TYPES) do
            if ht.label == opt then getgenv().ELITE_HUB_HornType = i break end
        end
        getgenv().ELITE_HUB_Log("MODS", "Horns type: " .. opt)
        if getgenv().ELITE_HUB_HornsOn then task.spawn(function() pcall(function() BuildHorns(player.Character) end) end) end
    end
})
MT:CreateSlider({
    Name = " Horn Size",
    Range = {0.5, 2.5},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(v)
        getgenv().ELITE_HUB_HornSize = v
        if getgenv().ELITE_HUB_HornsOn then task.spawn(function() pcall(function() BuildHorns(player.Character) end) end) end
    end
})
MT:CreateColorPicker({
    Name = " Aura Color",
    Color = getgenv().ELITE_HUB_AuraColor,
    Callback = function(v)
        getgenv().ELITE_HUB_AuraColor = v
        if getgenv().ELITE_HUB_AuraOn then task.spawn(function() BuildAura(player.Character) end) end
        if getgenv().ELITE_HUB_HornsOn then task.spawn(function() BuildHorns(player.Character) end) end
    end
})
MT:CreateSlider({
    Name = " Aura Size",
    Range = {0.6, 2},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(v)
        getgenv().ELITE_HUB_AuraSize = v
        if getgenv().ELITE_HUB_AuraOn then task.spawn(function() BuildAura(player.Character) end) end
    end
})
MT:CreateToggle({
    Name = " Halo Spin",
    CurrentValue = false,
    Callback = function(v) getgenv().ELITE_HUB_AuraSpin = v end
})
MT:CreateSlider({
    Name = " Halo Spin Speed",
    Range = {10, 300},
    Increment = 5,
    CurrentValue = 40,
    Callback = function(v) getgenv().ELITE_HUB_AuraSpinSpeed = v end
})
MT:CreateDropdown({
    Name = " Visual Material",
    Options = { "Neon", "SmoothPlastic", "Plastic", "Glass", "ForceField", "Metal", "Ice", "CrackedLava", "DiamondPlate", "Marble", "Obsidian", "Foil", "Wood", "Concrete", "Sand", "Stone", "Brick", "Glacier" },
    CurrentOption = "Neon",
    Callback = function(opt)
        getgenv().ELITE_HUB_VisualMaterial = opt
        getgenv().ELITE_HUB_Log("MODS", "Visual material: " .. opt)
        if getgenv().ELITE_HUB_AuraOn then task.spawn(function() BuildAura(player.Character) end) end
        if getgenv().ELITE_HUB_HornsOn then task.spawn(function() pcall(function() BuildHorns(player.Character) end) end) end
        if getgenv().ELITE_HUB_WingsOn then task.spawn(function() pcall(function() BuildWings(player.Character) end) end) end
    end
})

-- ============================================================
-- BIG HEAD
-- ============================================================
getgenv().ELITE_HUB_BigHeadOn = false
getgenv().ELITE_HUB_BigHeadScale = 1.8

getgenv().ELITE_HUB_BigHeadState = {}
local function ApplyBigHead(char)
    if not getgenv().ELITE_HUB_BigHeadOn then return end
    if not char then return end
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head then return end
    local s = getgenv().ELITE_HUB_BigHeadScale or 1.8
    pcall(function()
        local st = getgenv().ELITE_HUB_BigHeadState
        if not st.head then
            st.head = head
            st.size = head.Size
            local m = head:FindFirstChildOfClass("SpecialMesh")
            if m then st.mesh = m st.meshScale = m.Scale end
        end
        if st.head == head then
            head.Size = st.size * s
            if st.mesh and st.mesh.Parent then st.mesh.Scale = st.meshScale * s end
        end
    end)
    if hum then
        pcall(function()
            hum.HeadScale = s
            hum.HeadOffset = Vector3.new(0, (s - 1) * 0.2, 0)
        end)
    end
end

local function RestoreBigHead(char)
    pcall(function()
        local st = getgenv().ELITE_HUB_BigHeadState
        if st.head then
            if st.head.Parent then
                st.head.Size = st.size
                if st.mesh and st.mesh.Parent then st.mesh.Scale = st.meshScale end
            end
            st.head = nil st.size = nil st.mesh = nil st.meshScale = nil
        end
    end)
    if char then
        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.HeadScale = 1 hum.HeadOffset = Vector3.new(0, 0, 0) end
        end)
    end
end
getgenv().ELITE_HUB_ApplyBigHead = ApplyBigHead
getgenv().ELITE_HUB_RestoreBigHead = RestoreBigHead

MT:CreateSection("BIG HEAD")
MT:CreateToggle({
    Name = " Big Head",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_BigHeadOn = v
        getgenv().ELITE_HUB_Log("MODS", "Big Head: " .. tostring(v))
        if v then task.spawn(function() ApplyBigHead(player.Character) end) else RestoreBigHead(player.Character) end
    end
})
MT:CreateSlider({
    Name = " Head Scale",
    Range = {1, 3},
    Increment = 0.1,
    CurrentValue = 1.8,
    Callback = function(v)
        getgenv().ELITE_HUB_BigHeadScale = v
        if getgenv().ELITE_HUB_BigHeadOn then task.spawn(function() ApplyBigHead(player.Character) end) end
    end
})

-- ============================================================
-- GOLD STATUE
-- ============================================================
getgenv().ELITE_HUB_GoldOn = false
getgenv().ELITE_HUB_GoldColor = Color3.fromRGB(255, 205, 0)

local function ApplyGold(char)
    if not getgenv().ELITE_HUB_GoldOn then return end
    if not char then return end
    local col = getgenv().ELITE_HUB_GoldColor
    local hrp = char:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p ~= hrp then
            pcall(function()
                if not p:GetAttribute("EHGoldOrig") then
                    p:SetAttribute("EHGoldOrig", tostring(p.Material))
                    p:SetAttribute("EHGoldOrigCol", p.Color:ToHex())
                end
                p.Material = Enum.Material.Metal
                p.Color = col
            end)
        end
    end
end

local function RestoreGold(char)
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p:GetAttribute("EHGoldOrig") then
            pcall(function()
                p.Material = Enum.Material[p:GetAttribute("EHGoldOrig")]
                p.Color = Color3.fromHex(p:GetAttribute("EHGoldOrigCol"))
                p:SetAttribute("EHGoldOrig", nil)
            end)
        end
    end
end
getgenv().ELITE_HUB_ApplyGold = ApplyGold
getgenv().ELITE_HUB_RestoreGold = RestoreGold

MT:CreateSection("GOLD STATUE")
MT:CreateToggle({
    Name = " Gold Statue",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_GoldOn = v
        getgenv().ELITE_HUB_Log("MODS", "Gold Statue: " .. tostring(v))
        if v then task.spawn(function() ApplyGold(player.Character) end) else RestoreGold(player.Character) end
    end
})
MT:CreateColorPicker({
    Name = " Gold Color",
    Color = getgenv().ELITE_HUB_GoldColor,
    Callback = function(v)
        getgenv().ELITE_HUB_GoldColor = v
        if getgenv().ELITE_HUB_GoldOn then task.spawn(function() ApplyGold(player.Character) end) end
    end
})

-- ============================================================
-- FAERIE WINGS
-- ============================================================
getgenv().ELITE_HUB_WingsOn = false
getgenv().ELITE_HUB_WingsColor = Color3.fromRGB(255, 160, 220)
getgenv().ELITE_HUB_WingsLength = 1
getgenv().ELITE_HUB_WingsType = 1
getgenv().ELITE_HUB_WingsMembrane = false
getgenv().ELITE_HUB_WingsFlap = true
getgenv().ELITE_HUB_WingsFlapSpeed = 3
local wingConn = nil
local wingParts = {}
local wingBuildId = 0

local WING_TYPES = {
    { label = "Angel", dt = Vector3.new(0.3, 0.9, 0.3), db = Vector3.new(0.9, 0.3, 0.2), n = 30, ns = 8, l0 = 2.0, l1 = -7.0, d0 = 0.28, d1 = 0.1, backT = 0.7, bD0 = 0.22, sub = { dt = Vector3.new(0.7, -0.2, 0.3), db = Vector3.new(0.4, -0.8, 0.2), n = 18, ns = 6, l0 = 4.0, l1 = 1.5, d0 = 0.22, d1 = 0.08 } },
    { label = "Demon", dt = Vector3.new(0.2, 0.95, 0.2), db = Vector3.new(0.95, 0.2, 0.15), n = 30, ns = 9, l0 = 1.8, l1 = -8.0, d0 = 0.3, d1 = 0.12, backT = 0.75, bD0 = 0.25, sub = { dt = Vector3.new(0.8, -0.15, 0.2), db = Vector3.new(0.5, -0.85, 0.15), n = 18, ns = 7, l0 = 3.5, l1 = 1.3, d0 = 0.25, d1 = 0.09 } },
    { label = "Vampire", dt = Vector3.new(0.4, 0.85, 0.35), db = Vector3.new(0.95, 0.15, 0.1), n = 34, ns = 8, l0 = 2.2, l1 = -7.5, d0 = 0.25, d1 = 0.09, backT = 0.65, bD0 = 0.2, sub = { dt = Vector3.new(0.75, -0.25, 0.25), db = Vector3.new(0.35, -0.85, 0.2), n = 20, ns = 6, l0 = 3.8, l1 = 1.4, d0 = 0.2, d1 = 0.07 } },
    { label = "Faerie", dt = Vector3.new(0.35, 0.88, 0.3), db = Vector3.new(0.85, 0.35, 0.25), n = 22, ns = 7, l0 = 1.4, l1 = -5.5, d0 = 0.22, d1 = 0.08, backT = 0.6, bD0 = 0.18, sub = { dt = Vector3.new(0.65, -0.25, 0.3), db = Vector3.new(0.35, -0.75, 0.25), n = 12, ns = 5, l0 = 3.0, l1 = 1.2, d0 = 0.18, d1 = 0.06 } },
    { label = "Butterfly", dt = Vector3.new(0.5, 0.8, 0.3), db = Vector3.new(0.95, 0.1, 0.1), n = 22, ns = 8, l0 = 1.7, l1 = -6.5, d0 = 0.25, d1 = 0.09, backT = 0.55, bD0 = 0.2, sub = { dt = Vector3.new(0.8, -0.2, 0.2), db = Vector3.new(0.3, -0.85, 0.15), n = 12, ns = 6, l0 = 3.5, l1 = 1.3, d0 = 0.2, d1 = 0.07 } },
    { label = "Falcon", dt = Vector3.new(0.25, 0.92, 0.25), db = Vector3.new(0.88, 0.35, 0.18), n = 30, ns = 8, l0 = 2.0, l1 = -7.0, d0 = 0.25, d1 = 0.09, backT = 0.68, bD0 = 0.2, sub = { dt = Vector3.new(0.7, -0.18, 0.25), db = Vector3.new(0.4, -0.82, 0.18), n = 18, ns = 6, l0 = 3.8, l1 = 1.4, d0 = 0.2, d1 = 0.07 } },
    { label = "Dragonel", dt = Vector3.new(0.2, 0.93, 0.2), db = Vector3.new(0.92, 0.25, 0.12), n = 26, ns = 9, l0 = 1.8, l1 = -7.8, d0 = 0.28, d1 = 0.1, backT = 0.72, bD0 = 0.22, sub = { dt = Vector3.new(0.75, -0.2, 0.2), db = Vector3.new(0.45, -0.8, 0.15), n = 14, ns = 6, l0 = 3.5, l1 = 1.2, d0 = 0.22, d1 = 0.08 } },
    { label = "Raven", dt = Vector3.new(0.3, 0.88, 0.3), db = Vector3.new(0.88, 0.32, 0.2), n = 30, ns = 8, l0 = 1.9, l1 = -7.0, d0 = 0.25, d1 = 0.1, backT = 0.62, bD0 = 0.2, sub = { dt = Vector3.new(0.68, -0.22, 0.28), db = Vector3.new(0.38, -0.78, 0.22), n = 18, ns = 6, l0 = 3.5, l1 = 1.3, d0 = 0.22, d1 = 0.08 } },
    { label = "Owl", dt = Vector3.new(0.35, 0.85, 0.35), db = Vector3.new(0.85, 0.35, 0.25), n = 24, ns = 7, l0 = 1.7, l1 = -6.5, d0 = 0.3, d1 = 0.12, backT = 0.58, bD0 = 0.22, sub = { dt = Vector3.new(0.65, -0.25, 0.3), db = Vector3.new(0.35, -0.8, 0.25), n = 14, ns = 6, l0 = 3.5, l1 = 1.3, d0 = 0.25, d1 = 0.09 } },
    { label = "Phoenix", dt = Vector3.new(0.25, 0.92, 0.25), db = Vector3.new(0.9, 0.3, 0.15), n = 30, ns = 9, l0 = 2.1, l1 = -8.0, d0 = 0.25, d1 = 0.09, backT = 0.72, bD0 = 0.2, sub = { dt = Vector3.new(0.72, -0.2, 0.22), db = Vector3.new(0.42, -0.82, 0.18), n = 18, ns = 6, l0 = 4.0, l1 = 1.4, d0 = 0.22, d1 = 0.07 } },
    { label = "Double", dt = Vector3.new(0.3, 0.9, 0.3), db = Vector3.new(0.9, 0.3, 0.2), n = 26, ns = 8, l0 = 1.8, l1 = -7.0, d0 = 0.25, d1 = 0.09, backT = 0.65, bD0 = 0.2, sub = { dt = Vector3.new(0.7, -0.2, 0.3), db = Vector3.new(0.4, -0.8, 0.2), n = 16, ns = 6, l0 = 3.5, l1 = 1.3, d0 = 0.2, d1 = 0.07 } }
}

local function RemoveWings()
    if wingConn then pcall(function() wingConn:Disconnect() end) wingConn = nil end
    wingParts = {}
    ClearModel("ELITEHUB_WINGS")
end

local function BuildWings(char)
    if not getgenv().ELITE_HUB_WingsOn then return end
    if not char then return end
    local torso = characterTorso(char)
    if not torso then return end
    RemoveWings()
    local myId = wingBuildId + 1
    wingBuildId = myId
    task.wait(0.2)
    if wingBuildId ~= myId then return end
    local S = getgenv().ELITE_HUB_WingsLength or 1
    local COL = getgenv().ELITE_HUB_WingsColor
    local MAT = getgenv().ELITE_HUB_VisualMaterial or "Neon"
    local torsoCF = torso.CFrame
    local w = Instance.new("Model")
    w.Name = "ELITEHUB_WINGS"
    w.Parent = workspace
    local function wing(side)
        local wt = WING_TYPES[tonumber(getgenv().ELITE_HUB_WingsType) or 1] or WING_TYPES[1]
        local P = CFrame.new(side * 0.2, 0.02, 0.45)
        local function fan(wf0, wb0, wn, wl0, wl1, wd0v, wd1v, withBack, segPer)
            local dtf = Vector3.new(side * wf0.X, wf0.Y, wf0.Z).Unit
            local dbf = Vector3.new(side * wb0.X, wb0.Y, wb0.Z).Unit
            local nSeg = math.max(segPer or 1, math.ceil((segPer or 1) * S))
            for r = 0, wn - 1 do
                local t = r / math.max(wn - 1, 1)
                local dir = dtf:Lerp(dbf, t).Unit
                local L = (wl0 - wl1 * t) * S
                local D = (wd0v - wd1v * t)
                if D < 0.04 then D = 0.04 end
                local segLen = L / nSeg
                local xvec = Vector3.new(-dir.Z, 0, dir.X)
                if xvec.Magnitude < 0.01 then xvec = Vector3.new(0, 0, 1) end
                xvec = xvec.Unit
                for s = 0, nSeg - 1 do
                    local st = s / nSeg
                    local sD = D * (1 - st * 0.4)
                    local offset = (st + 0.5 / nSeg) * L
                    local mp = P.Position + dir * offset
                    local lcf = CFrame.fromMatrix(mp, xvec, dir)
                    local ft = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(sD * 1.8, segLen * 2.0, sD * 1.8), Color = COL, Material = MAT })
                    ft.Transparency = 0
                    ft.CFrame = torsoCF * lcf
                    ft:BreakJoints()
                    ft.Parent = w
                    wingParts[ft] = { lcf = lcf, side = side }
                end
            end
            if getgenv().ELITE_HUB_WingsMembrane then
                local memn = dtf:Cross(dbf).Unit
                for r = 0, wn - 2 do
                    local t0 = r / math.max(wn - 1, 1)
                    local t1 = (r + 1) / math.max(wn - 1, 1)
                    local dA = dtf:Lerp(dbf, t0).Unit
                    local dB = dtf:Lerp(dbf, t1).Unit
                    local LA = (wl0 - wl1 * t0) * S * 0.97
                    local LB = (wl0 - wl1 * t1) * S * 0.97
                    local dm = (dA + dB).Unit
                    local Lm = (LA + LB) / 2
                    local gap = (dA * LA - dB * LB).Magnitude
                    local pad = gap * 0.65
                    if pad < 0.18 then pad = 0.18 end
                    if pad > 0.7 then pad = 0.7 end
                    local xvec = Vector3.new(-dm.Z, 0, dm.X)
                    if xvec.Magnitude < 0.01 then xvec = Vector3.new(0, 0, 1) end
                    xvec = xvec.Unit
                    local mp0 = P.Position + dm * (Lm / 2) + memn * 0.05
                    local lcf = CFrame.fromMatrix(mp0, xvec, dm)
                    local mb = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(pad, Lm, pad), Color = COL, Material = MAT })
                    mb.Transparency = 0
                    mb.CFrame = torsoCF * lcf
                    mb:BreakJoints()
                    mb.Parent = w
                    wingParts[mb] = { lcf = lcf, side = side }
                end
            end
            if withBack then
                local dm = (dtf + dbf) / 2
                dm = dm.Unit
                local bl = math.max(math.abs(wl0), math.abs(wl1)) * (wt.backT or 0.6) * S
                local bD = wt.bD0 or 0.09
                local bx = Vector3.new(-dm.Z, 0, dm.X)
                if bx.Magnitude < 0.01 then bx = Vector3.new(0, 0, 1) end
                bx = bx.Unit
                local bmp = P.Position + dm * (bl / 2)
                local blcf = CFrame.fromMatrix(bmp, bx, dm)
                local bk = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(bD, bl, bD), Color = COL, Material = MAT })
                bk.Transparency = 0
                bk.CFrame = torsoCF * blcf
                bk:BreakJoints()
                bk.Parent = w
                    wingParts[bk] = { lcf = blcf, side = side }
            end
        end
        fan(wt.dt, wt.db, wt.n, wt.l0, wt.l1, wt.d0, wt.d1, true, wt.ns)
        if wt.sub then
            fan(wt.sub.dt, wt.sub.db, wt.sub.n, wt.sub.l0, wt.sub.l1, wt.sub.d0, wt.sub.d1, false, wt.sub.ns)
        end
    end
    wing(-1)
    wing(1)
    if wingConn then pcall(function() wingConn:Disconnect() end) end
    local t = 0
    wingConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
        pcall(function()
            if not getgenv().ELITE_HUB_WingsOn then RemoveWings() return end
            local h = workspace:FindFirstChild("ELITEHUB_WINGS")
            if not h then
                local c = player.Character
                local tc = c and (c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso"))
                if tc then task.spawn(function() BuildWings(c) end) end
                return
            end
            local ts = characterTorso(char)
            if not ts then return end
            t = t + dt
            local amp = 0
            if getgenv().ELITE_HUB_WingsFlap then
                amp = math.sin(t * (getgenv().ELITE_HUB_WingsFlapSpeed or 3)) * 0.45
            end
            local base = ts.CFrame
                for p, data in pairs(wingParts) do
                    if p and p.Parent then
                        p.CFrame = base * CFrame.Angles(0, 0, data.side * amp) * data.lcf
                    end
            end
        end)
    end)
end
getgenv().ELITE_HUB_BuildWings = BuildWings
getgenv().ELITE_HUB_RemoveWings = RemoveWings

MT:CreateSection("FAERIE WINGS")
MT:CreateToggle({
    Name = " Faerie Wings",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_WingsOn = v
        getgenv().ELITE_HUB_Log("MODS", "Wings: " .. tostring(v))
        if v then task.spawn(function() pcall(function() BuildWings(player.Character) end) end) else RemoveWings() end
    end
})
MT:CreateColorPicker({
    Name = " Wings Color",
    Color = getgenv().ELITE_HUB_WingsColor,
    Callback = function(v)
        getgenv().ELITE_HUB_WingsColor = v
        if getgenv().ELITE_HUB_WingsOn then task.spawn(function() BuildWings(player.Character) end) end
    end
})
MT:CreateDropdown({
    Name = " Wing Type",
    Options = { "Angel", "Demon", "Vampire", "Faerie", "Butterfly", "Falcon", "Dragonel", "Raven", "Owl", "Phoenix", "Double" },
    CurrentOption = "Angel",
    Callback = function(opt)
        for i, wt in ipairs(WING_TYPES) do
            if wt.label == opt then getgenv().ELITE_HUB_WingsType = i break end
        end
        getgenv().ELITE_HUB_Log("MODS", "Wings type: " .. opt)
        if getgenv().ELITE_HUB_WingsOn then task.spawn(function() pcall(function() BuildWings(player.Character) end) end) end
    end
})
MT:CreateSlider({
    Name = " Wings Length",
    Range = {0.5, 4},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(v)
        getgenv().ELITE_HUB_WingsLength = v
        if getgenv().ELITE_HUB_WingsOn then task.spawn(function() BuildWings(player.Character) end) end
    end
})
MT:CreateToggle({
    Name = " Membrane",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_WingsMembrane = v
        if getgenv().ELITE_HUB_WingsOn then task.spawn(function() BuildWings(player.Character) end) end
    end
})
MT:CreateToggle({
    Name = " Flap",
    CurrentValue = true,
    Callback = function(v) getgenv().ELITE_HUB_WingsFlap = v end
})
MT:CreateSlider({
    Name = " Flap Speed",
    Range = {1, 10},
    Increment = 0.5,
    CurrentValue = 3,
    Callback = function(v) getgenv().ELITE_HUB_WingsFlapSpeed = v end
})

-- ============================================================
-- JUMP RINGS (expanding circles on jump)
-- ============================================================
getgenv().ELITE_HUB_JumpRingsOn = false
getgenv().ELITE_HUB_JumpRingsColor = Color3.fromRGB(255, 255, 255)
getgenv().ELITE_HUB_JumpRingsCount = 3
local jumpRingConn = nil
local jumpWasGrounded = true

local function SpawnJumpRing(pos, col)
    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Anchored = true
    ring.CanCollide = false
    ring.Material = Enum.Material.Neon
    ring.Color = col
    ring.Size = Vector3.new(0.15, 2, 2)
    ring.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
    ring.Transparency = 0
    ring.Parent = workspace
    local t = 0
    local dur = 0.5
    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function(dt)
        t = t + dt
        if t >= dur or not ring or not ring.Parent then
            pcall(function() ring:Destroy() end)
            if conn then conn:Disconnect() end
            return
        end
        local p = t / dur
        local scale = 1 + p * 8
        ring.Size = Vector3.new(0.15, 2 * scale, 2 * scale)
        ring.Transparency = 0 + p * 0.8
    end)
end

local function GetGroundY(char, hrp)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(hrp.Position, Vector3.new(0, -10, 0), params)
    return result and result.Position.Y or (hrp.Position.Y - 3)
end

local function StartJumpRings()
    if jumpRingConn then pcall(function() jumpRingConn:Disconnect() end) end
    jumpWasGrounded = true
    jumpRingConn = game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            if not getgenv().ELITE_HUB_JumpRingsOn then
                pcall(function() jumpRingConn:Disconnect() end)
                jumpRingConn = nil
                return
            end
            local char = player.Character
            if not char then return end
            local h = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not h or not hrp then return end
            local state = h:GetState()
            local isGrounded = state == Enum.HumanoidStateType.Running
                or state == Enum.HumanoidStateType.RunningNoPhysics
                or state == Enum.HumanoidStateType.Landed
                or state == Enum.HumanoidStateType.Seated
            if isGrounded then
                jumpWasGrounded = true
            elseif jumpWasGrounded then
                jumpWasGrounded = false
                local groundY = GetGroundY(char, hrp)
                local col = getgenv().ELITE_HUB_JumpRingsColor
                local count = getgenv().ELITE_HUB_JumpRingsCount or 3
                local ringPos = Vector3.new(hrp.Position.X, groundY + 0.1, hrp.Position.Z)
                for i = 1, count do
                    task.delay((i - 1) * 0.08, function()
                        SpawnJumpRing(ringPos, col)
                    end)
                end
            end
        end)
    end)
end

MT:CreateSection(" JUMP RINGS")
MT:CreateToggle({
    Name = " Jump Rings",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_JumpRingsOn = v
        if v then StartJumpRings() end
    end
})
MT:CreateColorPicker({
    Name = " Rings Color",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(v) getgenv().ELITE_HUB_JumpRingsColor = v end
})
MT:CreateSlider({
    Name = " Rings Count",
    Range = {1, 8},
    Increment = 1,
    CurrentValue = 3,
    Callback = function(v) getgenv().ELITE_HUB_JumpRingsCount = v end
})

-- ============================================================
-- PLAYER HUD (target info panel + name tag + crosshair)
-- ============================================================
getgenv().ELITE_HUB_PlayerHUDOn = false
getgenv().ELITE_HUB_NameTagOn = false
getgenv().ELITE_HUB_CrosshairOn = false

local playerHudConn = nil
local currentTarget = nil
local targetScreenGui = nil
local targetBillboard = nil
local crosshairPart = nil

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local function GetLocalCharacter()
    local ch = player.Character
    if not ch then return nil, nil end
    local h = ch:FindFirstChildOfClass("Humanoid")
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    return h, hrp
end

local function FindClosestPlayerByRay()
    local myH, myHRP = GetLocalCharacter()
    if not myH or not myHRP then return nil end
    local camPos = Camera.CFrame.Position
    local ac = getgenv().ELITE_HUB_AimbotConfig
    local aimbotOn = ac and ac.Enabled
    local fovRadius = ac and ac.FOV or 200
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local best = nil
    local bestScore = math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local tH = p.Character:FindFirstChildOfClass("Humanoid")
            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
            if tH and tHRP and tH.Health > 0 then
                local toTarget = (tHRP.Position - camPos)
                local gameDist = toTarget.Magnitude
                if gameDist < 200 then
                    local score
                    if aimbotOn then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(tHRP.Position)
                        if onScreen then
                            local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                            local screenDist = (screenPoint - mousePos).Magnitude
                            if screenDist <= fovRadius then
                                score = screenDist
                            end
                        end
                    else
                        score = gameDist
                    end
                    if score and score < bestScore then
                        local params = RaycastParams.new()
                        params.FilterDescendantsInstances = {player.Character}
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        local result = workspace:Raycast(camPos, toTarget, params)
                        if not result or result.Instance:IsDescendantOf(p.Character) then
                            bestScore = score
                            best = p
                        end
                    end
                end
            end
        end
    end
    return best
end

local function GetTargetPlayer()
    local ac = getgenv().ELITE_HUB_AimbotConfig
    local aimbotOn = ac and ac.Enabled
    if aimbotOn then
        if LockedTargetPlayer and LockedTargetPlayer.Character then
            local h = LockedTargetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then return LockedTargetPlayer end
        end
        return nil
    end
    return FindClosestPlayerByRay()
end

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function CreateTargetScreenGui()
    if targetScreenGui then pcall(function() targetScreenGui:Destroy() end) end
    local sg = Instance.new("ScreenGui")
    sg.Name = "ELITEHUB_PlayerHUD"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 100
    sg.Parent = player.PlayerGui

    local frame = Instance.new("Frame")
    frame.Name = "TargetPanel"
    frame.Size = UDim2.new(0, 280, 0, 100)
    frame.Position = UDim2.new(0.5, -140, 0.15, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 2
    stroke.Parent = frame

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 60, 0, 60)
    avatar.Position = UDim2.new(0, 10, 0, 20)
    avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    avatar.BorderSizePixel = 0
    avatar.Image = ""
    avatar.Parent = frame
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 12)

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Color3.fromRGB(100, 100, 255)
    avatarStroke.Thickness = 1.5
    avatarStroke.Parent = avatar

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PlayerName"
    nameLabel.Size = UDim2.new(1, -90, 0, 22)
    nameLabel.Position = UDim2.new(0, 80, 0, 18)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = false
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Text = "Player"
    nameLabel.Parent = frame

    local hpLabel = Instance.new("TextLabel")
    hpLabel.Name = "HPText"
    hpLabel.Size = UDim2.new(1, -90, 0, 16)
    hpLabel.Position = UDim2.new(0, 80, 0, 42)
    hpLabel.BackgroundTransparency = 1
    hpLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    hpLabel.TextScaled = false
    hpLabel.TextSize = 14
    hpLabel.Font = Enum.Font.Gotham
    hpLabel.TextXAlignment = Enum.TextXAlignment.Left
    hpLabel.Text = "100 HP"
    hpLabel.Parent = frame

    local hpBarBg = Instance.new("Frame")
    hpBarBg.Name = "HPBarBG"
    hpBarBg.Size = UDim2.new(1, -20, 0, 8)
    hpBarBg.Position = UDim2.new(0, 10, 0, 72)
    hpBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    hpBarBg.BorderSizePixel = 0
    hpBarBg.Parent = frame
    Instance.new("UICorner", hpBarBg).CornerRadius = UDim.new(0, 4)

    local hpBar = Instance.new("Frame")
    hpBar.Name = "HPBar"
    hpBar.Size = UDim2.new(1, 0, 1, 0)
    hpBar.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    hpBar.BorderSizePixel = 0
    hpBar.Parent = hpBarBg
    Instance.new("UICorner", hpBar).CornerRadius = UDim.new(0, 4)

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    })
    grad.Parent = frame

    MakeDraggable(frame)
    targetScreenGui = sg
    return sg
end

local function CreateCrosshair()
    if crosshairPart then pcall(function() crosshairPart:Destroy() end) crosshairPart = nil end
    crosshairPart = "pending"
end

local function UpdateCrosshairOnHead(tgtChar)
    if not getgenv().ELITE_HUB_CrosshairOn then
        if crosshairPart and crosshairPart ~= "pending" then pcall(function() crosshairPart:Destroy() end) crosshairPart = nil end
        return
    end
    local head = tgtChar and tgtChar:FindFirstChild("Head")
    if not head then
        if crosshairPart and crosshairPart ~= "pending" then pcall(function() crosshairPart:Destroy() end) crosshairPart = nil end
        return
    end
    local existing = head:FindFirstChild("ELITEHUB_CrosshairBB")
    if existing then
        crosshairPart = existing
        return
    end
    local bb = Instance.new("BillboardGui")
    bb.Name = "ELITEHUB_CrosshairBB"
    bb.Size = UDim2.new(0, 50, 0, 50)
    bb.StudsOffset = Vector3.new(0, 0, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Adornee = head
    bb.Parent = head

    local col = Color3.fromRGB(255, 50, 50)
    local radius = 16
    local lineLen = 6
    local gap = 4
    local thick = 2

    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
    circle.Position = UDim2.new(0.5, -radius, 0.5, -radius)
    circle.BackgroundTransparency = 1
    circle.BorderSizePixel = 0
    circle.Parent = bb
    Instance.new("UICorner", circle).CornerRadius = UDim.new(0.5, 0)
    local cs = Instance.new("UIStroke")
    cs.Color = col
    cs.Thickness = thick
    cs.Parent = circle

    local function ml(name, sz, pos)
        local f = Instance.new("Frame")
        f.Name = name
        f.Size = sz
        f.Position = pos
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.BackgroundColor3 = col
        f.BorderSizePixel = 0
        f.Parent = bb
    end
    ml("Top", UDim2.new(0, thick, 0, lineLen), UDim2.new(0.5, 0, 0.5, -radius - gap - lineLen/2))
    ml("Bot", UDim2.new(0, thick, 0, lineLen), UDim2.new(0.5, 0, 0.5, radius + gap + lineLen/2))
    ml("Left", UDim2.new(0, lineLen, 0, thick), UDim2.new(0.5, -radius - gap - lineLen/2, 0.5, 0))
    ml("Right", UDim2.new(0, lineLen, 0, thick), UDim2.new(0.5, radius + gap + lineLen/2, 0.5, 0))

    crosshairPart = bb
end

local function RemoveCrosshair()
    if crosshairPart and crosshairPart ~= "pending" then
        pcall(function() crosshairPart:Destroy() end)
    end
    crosshairPart = nil
    for _, ch in ipairs(Players:GetPlayers()) do
        if ch.Character then
            local head = ch.Character:FindFirstChild("Head")
            if head then
                local old = head:FindFirstChild("ELITEHUB_CrosshairBB")
                if old then pcall(function() old:Destroy() end) end
            end
        end
    end
end

local function RemovePlayerHud()
    if playerHudConn then pcall(function() playerHudConn:Disconnect() end) playerHudConn = nil end
    currentTarget = nil
    if targetScreenGui then pcall(function() targetScreenGui:Destroy() end) targetScreenGui = nil end
    if targetBillboard then pcall(function() targetBillboard:Destroy() end) targetBillboard = nil end
    RemoveCrosshair()
end

local function GetBillboardForTarget(tgtChar)
    local head = tgtChar:FindFirstChild("Head")
    if not head then return nil end
    local existing = head:FindFirstChild("ELITEHUB_NameTag")
    if existing then return existing end
    local bb = Instance.new("BillboardGui")
    bb.Name = "ELITEHUB_NameTag"
    bb.Size = UDim2.new(0, 180, 0, 50)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Parent = head

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Parent = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 1.5
    stroke.Parent = bg

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -10, 0, 20)
    nameLabel.Position = UDim2.new(0, 5, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Text = tgtChar.Name
    nameLabel.Parent = bg

    local hpBg = Instance.new("Frame")
    hpBg.Name = "HPBarBG"
    hpBg.Size = UDim2.new(0.8, 0, 0, 6)
    hpBg.Position = UDim2.new(0.1, 0, 0, 28)
    hpBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    hpBg.BorderSizePixel = 0
    hpBg.Parent = bg
    Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 3)

    local hpFill = Instance.new("Frame")
    hpFill.Name = "HPBar"
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBg
    Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 3)

    local hpText = Instance.new("TextLabel")
    hpText.Name = "HPText"
    hpText.Size = UDim2.new(1, 0, 0, 12)
    hpText.Position = UDim2.new(0, 0, 0, 36)
    hpText.BackgroundTransparency = 1
    hpText.TextColor3 = Color3.fromRGB(200, 200, 200)
    hpText.TextScaled = true
    hpText.Font = Enum.Font.Gotham
    hpText.Text = "100 HP"
    hpText.Parent = bg

    targetBillboard = bb
    return bb
end

local function UpdateTargetHUD()
    local tgt = GetTargetPlayer()
    local changed = (tgt ~= currentTarget)
    currentTarget = tgt

    if not tgt or not tgt.Character then
        if changed then
            if targetScreenGui then
                local frame = targetScreenGui:FindFirstChild("TargetPanel")
                if frame then frame.Visible = false end
            end
            if targetBillboard then pcall(function() targetBillboard:Destroy() end) targetBillboard = nil end
            RemoveCrosshair()
        end
        return
    end

    local tgtChar = tgt.Character
    local tgtH = tgtChar:FindFirstChildOfClass("Humanoid")
    local tgtHRP = tgtChar:FindFirstChild("HumanoidRootPart")
    local tgtHead = tgtChar:FindFirstChild("Head")
    if not tgtH or not tgtHRP or not tgtHead then return end

    local hp = math.max(0, math.floor(tgtH.Health))
    local maxHp = math.max(1, math.floor(tgtH.MaxHealth))
    local ratio = hp / maxHp

    local barColor
    if ratio > 0.5 then
        barColor = Color3.fromRGB(80, 255, 80)
    elseif ratio > 0.25 then
        barColor = Color3.fromRGB(255, 200, 0)
    else
        barColor = Color3.fromRGB(255, 50, 50)
    end

    -- Screen panel
    if getgenv().ELITE_HUB_PlayerHUDOn then
        if not targetScreenGui or not targetScreenGui.Parent then
            CreateTargetScreenGui()
        end
        local frame = targetScreenGui:FindFirstChild("TargetPanel")
        if frame then
            frame.Visible = true
            frame.PlayerName.Text = tgt.Name
            frame.HPText.Text = hp .. " / " .. maxHp .. " HP"
            frame.HPText.TextColor3 = barColor
            frame.HPBar.Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0)
            frame.HPBar.BackgroundColor3 = barColor
            pcall(function()
                local content = Players:GetUserThumbnailAsync(tgt.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                if content and content ~= "" then frame.Avatar.Image = content end
            end)
        end
    end

    -- Name tag billboard
    if getgenv().ELITE_HUB_NameTagOn then
        local bb = GetBillboardForTarget(tgtChar)
        if bb then
            local bg = bb:FindFirstChildWhichIsA("Frame")
            if bg then
                bg.NameLabel.Text = tgt.Name
                bg.HPBar.HPBar.Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0)
                bg.HPBar.HPBar.BackgroundColor3 = barColor
                bg.HPText.Text = hp .. " HP"
            end
        end
    else
        local head = tgtChar:FindFirstChild("Head")
        if head then
            local old = head:FindFirstChild("ELITEHUB_NameTag")
            if old then pcall(function() old:Destroy() end) end
        end
    end

    -- Crosshair on head
    if getgenv().ELITE_HUB_CrosshairOn then
        UpdateCrosshairOnHead(tgtChar)
    else
        RemoveCrosshair()
    end
end

local function StartPlayerHUD()
    if playerHudConn then pcall(function() playerHudConn:Disconnect() end) end
    playerHudConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not getgenv().ELITE_HUB_PlayerHUDOn
                and not getgenv().ELITE_HUB_NameTagOn
                and not getgenv().ELITE_HUB_CrosshairOn then
                RemovePlayerHud()
                return
            end
            UpdateTargetHUD()
        end)
    end)
end

MT:CreateSection(" PLAYER HUD")
MT:CreateToggle({
    Name = " Target Info Panel",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_PlayerHUDOn = v
        if v then
            StartPlayerHUD()
        else
            if targetScreenGui then pcall(function() targetScreenGui:Destroy() end) targetScreenGui = nil end
            if not getgenv().ELITE_HUB_NameTagOn and not getgenv().ELITE_HUB_CrosshairOn then
                RemovePlayerHud()
            end
        end
    end
})
MT:CreateToggle({
    Name = " Name Tag (on target)",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_NameTagOn = v
        if v then
            StartPlayerHUD()
        else
            if targetBillboard then pcall(function() targetBillboard:Destroy() end) targetBillboard = nil end
            if not getgenv().ELITE_HUB_PlayerHUDOn and not getgenv().ELITE_HUB_CrosshairOn then
                RemovePlayerHud()
            end
        end
    end
})
MT:CreateToggle({
    Name = " Red Crosshair",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_CrosshairOn = v
        if v then
            StartPlayerHUD()
        else
            RemoveCrosshair()
            if not getgenv().ELITE_HUB_PlayerHUDOn and not getgenv().ELITE_HUB_NameTagOn then
                RemovePlayerHud()
            end
        end
    end
})

-- respawn re-apply for fun visuals
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        if getgenv().ELITE_HUB_AuraOn then BuildAura(char) end
        if getgenv().ELITE_HUB_HornsOn then BuildHorns(char) end
        if getgenv().ELITE_HUB_WingsOn then BuildWings(char) end
        if getgenv().ELITE_HUB_GoldOn then ApplyGold(char) end
        if getgenv().ELITE_HUB_BigHeadOn then ApplyBigHead(char) end
    end)
end)
end)

-- nametag moved to modules/nametag.lua

local function DestroyScript()
    Rayfield:Notify({
        Title = "⚡ Shutting down...",
        Content = "ELITE HUB is being unloaded",
        Duration = 1.5
    })

    task.wait(0.5)

    -- Stop Chinese Hat
    pcall(function() if hatConn then hatConn:Disconnect() hatConn = nil end end)
    pcall(function()
        local hatobj = workspace:FindFirstChild("ELITEHUB_CHINESE_HAT")
        if hatobj then hatobj:Destroy() end
    end)

    -- Stop Fun Visuals
    pcall(function() if getgenv().ELITE_HUB_RemoveAura then getgenv().ELITE_HUB_RemoveAura() end end)
    pcall(function() if getgenv().ELITE_HUB_RemoveHorns then getgenv().ELITE_HUB_RemoveHorns() end end)
    pcall(function() if getgenv().ELITE_HUB_RemoveWings then getgenv().ELITE_HUB_RemoveWings() end end)
    pcall(function() if getgenv().ELITE_HUB_RestoreGold then getgenv().ELITE_HUB_RestoreGold(player.Character) end end)
    pcall(function() if getgenv().ELITE_HUB_RestoreBigHead then getgenv().ELITE_HUB_RestoreBigHead(player.Character) end end)
    pcall(function() if jumpRingConn then jumpRingConn:Disconnect() jumpRingConn = nil end end)

    -- Stop Fly
    pcall(function()
        nowe = false
        if flyBg then flyBg:Destroy() flyBg = nil end
        if flyBv then flyBv:Destroy() flyBv = nil end
        if _G.flyCtrl then _G.flyCtrl = nil end
    end)

    -- Stop Noclip
    pcall(function() if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end end)
    noclipActive = false

    -- Stop SpinBot (Combat + Range)
    pcall(function() if getgenv().ELITE_HUB_CombatSpinStop then getgenv().ELITE_HUB_CombatSpinStop() end end)
    pcall(function() if getgenv().ELITE_HUB_RangeSpinStop then getgenv().ELITE_HUB_RangeSpinStop() end end)
    pcall(function() if spinConn then spinConn:Disconnect() spinConn = nil end end)

    -- Stop Music Player
    pcall(function()
        if getgenv().ELITE_HUB_MusicEndConn then
            pcall(function() getgenv().ELITE_HUB_MusicEndConn:Disconnect() end)
            getgenv().ELITE_HUB_MusicEndConn = nil
        end
        if getgenv().ELITE_HUB_MusicPlayer then
            getgenv().ELITE_HUB_MusicPlayer:Stop()
            getgenv().ELITE_HUB_MusicPlayer:Destroy()
            getgenv().ELITE_HUB_MusicPlayer = nil
        end
    end)
    pcall(function() getgenv().ELITE_HUB_MusicCache = {} end)

    -- Stop Anti-AFK / Rejoin
    pcall(function() if getgenv().ELITE_HUB_AntiAfkConn then getgenv().ELITE_HUB_AntiAfkConn:Disconnect() end end)
    pcall(function() if getgenv().ELITE_HUB_RejoinConn then getgenv().ELITE_HUB_RejoinConn:Disconnect() end end)

    -- Restore Chams (restore all originals, destroy highlights)
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            pcall(function()
                if getgenv().ELITE_HUB_RestoreChamOriginals then getgenv().ELITE_HUB_RestoreChamOriginals(plr) end
            end)
            pcall(function()
                if getgenv().ELITE_HUB_ChamHighlights then
                    local hl = getgenv().ELITE_HUB_ChamHighlights[plr]
                    if hl then hl:Destroy() getgenv().ELITE_HUB_ChamHighlights[plr] = nil end
                end
            end)
        end
    end)

    -- Restore Neon Body / Fire Trail
    pcall(function()
        local ch = player.Character
        if ch then
            for _, part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") and part:GetAttribute("EliteHubOrigMaterial") then
                    pcall(function()
                        part.Material = Enum.Material[part:GetAttribute("EliteHubOrigMaterial")]
                        part.Color = part:GetAttribute("EliteHubOrigColor")
                    end)
                end
                if part.Name == "EliteHubFireTrail" then
                    pcall(function() part:Destroy() end)
                end
            end
        end
    end)

    -- Restore Speed Boost
    pcall(function()
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end)

    -- Restore Lighting (Night, Fog, Fullbright)
    pcall(function()
        local l = game:GetService("Lighting")
        if getgenv().ELITE_HUB_NightOrigClock then l.ClockTime = getgenv().ELITE_HUB_NightOrigClock end
        if getgenv().ELITE_HUB_NightOrigOutdoorAmbient then l.OutdoorAmbient = getgenv().ELITE_HUB_NightOrigOutdoorAmbient end
        if getgenv().ELITE_HUB_NightOrigBrightness then l.Brightness = getgenv().ELITE_HUB_NightOrigBrightness end
        if getgenv().ELITE_HUB_NoFogOrigFogEnd ~= nil then l.FogEnd = getgenv().ELITE_HUB_NoFogOrigFogEnd end
        if getgenv().ELITE_HUB_NoFogOrigFogStart ~= nil then l.FogStart = getgenv().ELITE_HUB_NoFogOrigFogStart end
        if getgenv().ELITE_HUB_NoFogOrigFogColor then l.FogColor = getgenv().ELITE_HUB_NoFogOrigFogColor end
        if getgenv().ELITE_HUB_FullbrightBackup then
            local b = getgenv().ELITE_HUB_FullbrightBackup
            if b.FogEnd then l.FogEnd = b.FogEnd end
            if b.Technology then l.Technology = b.Technology end
        end
    end)

    -- Nil all ELITE_HUB_ globals
    for name, _ in pairs(getgenv()) do
        if string.sub(name, 1, 11) == "ELITE_HUB_" then
            pcall(function() getgenv()[name] = nil end)
        end
    end

    -- Destroy UI Screens
    pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        if pg then
            for _, gui in ipairs(pg:GetChildren()) do
                if gui:IsA("ScreenGui") and (gui.Name == "EliteHubUI" or gui.Name == "ELITE_HUB_Overlay" or gui.Name == "EliteNotif") then
                    gui:Destroy()
                end
            end
        end
    end)

    -- Destroy CoreGui overlays
    pcall(function()
        local cg = game:GetService("CoreGui")
        for _, gui in ipairs(cg:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name == "ELITE_HUB_Overlay" then
                gui:Destroy()
            end
        end
    end)

    task.wait(0.5)
end

local function LoadScript(name, url)
    task.spawn(function()
        Rayfield:Notify({
            Title = "⏳ Loading...",
            Content = name .. " is launching",
            Duration = 2
        })
        
        task.wait(0.5)
        
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        
        task.wait(0.5)
        
        if success then
            Rayfield:Notify({
                Title = "✅ Done!",
                Content = name .. " loaded",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "✅ Done!",
                Content = "Failed to load " .. name,
                Duration = 5
            })
            warn("Script Load Error:", name, err)
        end
    end)
end

local NotifyCooldown = {}
local NotifyScreenGui = Instance.new("ScreenGui")
NotifyScreenGui.Name = "EliteHubNotify"
NotifyScreenGui.ResetOnSpawn = false
NotifyScreenGui.DisplayOrder = 999
NotifyScreenGui.Parent = player:WaitForChild("PlayerGui")

local NotifyCount = 0

getgenv().ELITE_HUB_SafeNotify = function(title, content, duration, category)
    if category and getgenv().ELITE_HUB_AimbotConfig and getgenv().ELITE_HUB_AimbotConfig["Notify" .. category] == false then return end
    local key = title .. "|" .. content
    local now = tick()
    if NotifyCooldown[key] and (now - NotifyCooldown[key]) < 2 then return end
    NotifyCooldown[key] = now
    duration = duration or 2
    NotifyCount = NotifyCount + 1
    local id = NotifyCount

    local frame = Instance.new("Frame")
    frame.Name = "Notify_" .. id
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, 320, 0, 14 + (id % 5) * 66)
    frame.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = NotifyScreenGui
    frame.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(170, 0, 255)
    stroke.Thickness = 1.5
    stroke.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 30, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 35))
    })
    gradient.Rotation = 90
    gradient.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(170, 0, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -20, 0, 20)
    contentLabel.Position = UDim2.new(0, 10, 0, 30)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentLabel.TextSize = 13
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 3)
    bar.Position = UDim2.new(0, 0, 1, -3)
    bar.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
    bar.BorderSizePixel = 0
    bar.Parent = frame

    task.spawn(function()
        local tweenService = game:GetService("TweenService")
        local yPos = 14 + (id % 5) * 66
        frame.Position = UDim2.new(1, 320, 0, yPos)
        local slideIn = tweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -314, 0, yPos)
        })
        slideIn:Play()
        slideIn.Completed:Wait()

        local barTween = tweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 3)
        })
        barTween:Play()
        task.wait(duration)

        local fadeOut = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 320, 0, yPos),
            BackgroundTransparency = 1
        })
        local fadeTitle = tweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1})
        local fadeContent = tweenService:Create(contentLabel, TweenInfo.new(0.3), {TextTransparency = 1})
        fadeOut:Play()
        fadeTitle:Play()
        fadeContent:Play()
        fadeOut.Completed:Wait()
        frame:Destroy()
    end)
end
-- publish shared environment (ELITE_HUB_ prefix)
getgenv().ELITE_HUB_Rayfield = Rayfield
getgenv().EliteHubSettings = ES
getgenv().ELITE_HUB_L = L
getgenv().ELITE_HUB_Players = Players
getgenv().ELITE_HUB_Player = player
getgenv().ELITE_HUB_DestroyScript = DestroyScript
getgenv().ELITE_HUB_LoadScript = LoadScript
getgenv().ELITE_HUB_Window = Window
getgenv().ELITE_HUB_MainTab = MainTab
getgenv().ELITE_HUB_ESPTab = ESPTab
getgenv().ELITE_HUB_CombatTab = CombatTab
getgenv().ELITE_HUB_VisualTab = VisualTab
getgenv().ELITE_HUB_TeleportTab = TeleportTab
getgenv().ELITE_HUB_KillAllTab = KillAllTab
getgenv().ELITE_HUB_FEScriptsTab = FEScriptsTab
getgenv().ELITE_HUB_HubsTab = HubsTab
getgenv().ELITE_HUB_GameScriptsTab = GameScriptsTab
getgenv().ELITE_HUB_MovementTab = MovementTab
getgenv().ELITE_HUB_CombatPlusTab = CombatPlusTab
getgenv().ELITE_HUB_CameraTeleportTab = CameraTeleportTab
getgenv().ELITE_HUB_UtilitiesTab = UtilitiesTab
getgenv().ELITE_HUB_MusicTab = MusicTab
getgenv().ELITE_HUB_Log("UI", "Loading modules...")
loadModuleChunk("modules/overlay.lua")()
loadModuleChunk("modules/hubs.lua")()
loadModuleChunk("modules/fe_scripts.lua")()
loadModuleChunk("modules/game_scripts.lua")()
loadModuleChunk("modules/main.lua")()
loadModuleChunk("modules/aimbot.lua")()
loadModuleChunk("modules/esp.lua")()
loadModuleChunk("modules/chams.lua")()
loadModuleChunk("modules/players.lua")()
loadModuleChunk("modules/teleport.lua")()
loadModuleChunk("modules/kill_all.lua")()
loadModuleChunk("modules/visual.lua")()
loadModuleChunk("modules/visual_plus.lua")()
loadModuleChunk("modules/environment.lua")()
loadModuleChunk("modules/movement.lua")()
loadModuleChunk("modules/combat_plus.lua")()
loadModuleChunk("modules/camera.lua")()
loadModuleChunk("modules/utilities.lua")()
loadModuleChunk("modules/music.lua")()
loadModuleChunk("modules/range.lua")()
loadModuleChunk("modules/item_finder.lua")()
loadModuleChunk("modules/settings.lua")()
loadModuleChunk("modules/anti_fling.lua")()
loadModuleChunk("modules/watchdog.lua")()
getgenv().ELITE_HUB_HASKER_LOADED = true
getgenv().ELITE_HUB_Log("UI", "ELITE HUB modules loaded")