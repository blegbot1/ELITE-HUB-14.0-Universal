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
-- FUN VISUALS (Aura, Horns, Aviators, Big Head, Gold, Wings)
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
    local headCF = head.CFrame
    local au = Instance.new("Model")
    au.Name = "ELITEHUB_AURA"
    au.Parent = workspace
    local R = 0.6 * S
    local N = 64
    for i = 0, N - 1 do
        local ang = (i / N) * math.pi * 2
        local chord = R * 2 * math.tan(math.pi / N) * 1.5
        local seg = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.1 * S, chord, 0.12 * S), Color = COL, Material = "Neon" })
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
-- HORNS (sit on top of head, nothing sunk into skull)
-- ============================================================
getgenv().ELITE_HUB_HornsOn = false
local hornConn = nil
local hornParts = {}

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
    local S = getgenv().ELITE_HUB_AuraSize or 1
    local COL = getgenv().ELITE_HUB_AuraColor
    local headCF = head.CFrame
    local hrn = Instance.new("Model")
    hrn.Name = "ELITEHUB_HORNS"
    hrn.Parent = workspace
    local function sideHorn(side)
        local base = Vector3.new(side * 0.16 * S, 0.5 * S, -0.05 * S)
        for k = 0, 2 do
            local L = (0.28 + 0.18 * k) * S
            local bend = 0.18 + 0.34 * k
            local seg = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.06 * S, L, 0.06 * S), Color = COL, Material = "Neon" })
            local lcf = CFrame.new(base) * CFrame.Angles(0, 0, -bend * side) * CFrame.new(0, L / 2, 0)
            seg.CFrame = headCF * lcf
            seg:BreakJoints()
            seg.Parent = hrn
            hornParts[seg] = lcf
        end
        local tL = (0.28 + 0.18 * 2) * S
        local tBend = 0.18 + 0.34 * 2
        local tip = MP({ Shape = Enum.PartType.Ball, Size = Vector3.new(0.13 * S, 0.15 * S, 0.13 * S), Color = COL, Material = "Neon" })
        local tlcf = CFrame.new(base) * CFrame.Angles(0, 0, -tBend * side) * CFrame.new(0, tL, 0)
        tip.CFrame = headCF * tlcf
        tip:BreakJoints()
        tip.Parent = hrn
        hornParts[tip] = tlcf
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
        if getgenv().ELITE_HUB_HornsOn then task.spawn(function() BuildHorns(player.Character) end) end
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

-- ============================================================
-- AVIATORS (sunglasses)
-- ============================================================
getgenv().ELITE_HUB_AviatorsOn = false
getgenv().ELITE_HUB_AviatorsColor = Color3.fromRGB(25, 25, 30)
getgenv().ELITE_HUB_AviatorsSize = 1
local aviConn = nil
local aviParts = {}

local function RemoveAviators()
    if aviConn then pcall(function() aviConn:Disconnect() end) aviConn = nil end
    aviParts = {}
    ClearModel("ELITEHUB_AVIATORS")
end

local function BuildAviators(char)
    if not getgenv().ELITE_HUB_AviatorsOn then return end
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    RemoveAviators()
    task.wait(0.2)
    local S = getgenv().ELITE_HUB_AviatorsSize or 1
    local COL = getgenv().ELITE_HUB_AviatorsColor
    local headCF = head.CFrame
    local av = Instance.new("Model")
    av.Name = "ELITEHUB_AVIATORS"
    av.Parent = workspace
    local function lens(side)
        local p = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.05, 0.3 * S, 0.3 * S), Color = COL, Material = "Neon" })
        local lcf = CFrame.new(side * 0.19 * S, 0.02 * S, -0.56 * S) * CFrame.Angles(0, 0, math.pi / 2)
        p.CFrame = headCF * lcf
        p:BreakJoints()
        p.Parent = av
        aviParts[p] = lcf
    end
    lens(-1)
    lens(1)
    local bridge = MP({ Size = Vector3.new(0.12 * S, 0.04, 0.04), Color = COL, Material = "Neon" })
    local blcf = CFrame.new(0, 0.02 * S, -0.56 * S)
    bridge.CFrame = headCF * blcf
    bridge:BreakJoints()
    bridge.Parent = av
    aviParts[bridge] = blcf
    Unanchor(av)
    if aviConn then pcall(function() aviConn:Disconnect() end) end
    aviConn = game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            if not getgenv().ELITE_HUB_AviatorsOn then RemoveAviators() return end
            local h = workspace:FindFirstChild("ELITEHUB_AVIATORS")
            if not h then
                local c = player.Character
                if c and c:FindFirstChild("Head") then task.spawn(function() BuildAviators(c) end) end
                return
            end
            local hd = char:FindFirstChild("Head")
            if not hd then return end
            local hdCF = hd.CFrame
            for p, lcf in pairs(aviParts) do
                if p and p.Parent then p.CFrame = hdCF * lcf end
            end
        end)
    end)
end
getgenv().ELITE_HUB_BuildAviators = BuildAviators
getgenv().ELITE_HUB_RemoveAviators = RemoveAviators

MT:CreateSection("AVIATORS")
MT:CreateToggle({
    Name = " Aviators",
    CurrentValue = false,
    Callback = function(v)
        getgenv().ELITE_HUB_AviatorsOn = v
        getgenv().ELITE_HUB_Log("MODS", "Aviators: " .. tostring(v))
        if v then task.spawn(function() pcall(function() BuildAviators(player.Character) end) end) else RemoveAviators() end
    end
})
MT:CreateColorPicker({
    Name = " Lens Color",
    Color = getgenv().ELITE_HUB_AviatorsColor,
    Callback = function(v)
        getgenv().ELITE_HUB_AviatorsColor = v
        if getgenv().ELITE_HUB_AviatorsOn then task.spawn(function() BuildAviators(player.Character) end) end
    end
})
MT:CreateSlider({
    Name = " Lens Size",
    Range = {0.6, 1.6},
    Increment = 0.05,
    CurrentValue = 1,
    Callback = function(v)
        getgenv().ELITE_HUB_AviatorsSize = v
        if getgenv().ELITE_HUB_AviatorsOn then task.spawn(function() BuildAviators(player.Character) end) end
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
getgenv().ELITE_HUB_WingsSize = 1
getgenv().ELITE_HUB_WingsFlap = true
getgenv().ELITE_HUB_WingsFlapSpeed = 3
local wingConn = nil
local wingParts = {}

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
    task.wait(0.2)
    local S = getgenv().ELITE_HUB_WingsSize or 1
    local COL = getgenv().ELITE_HUB_WingsColor
    local torsoCF = torso.CFrame
    local w = Instance.new("Model")
    w.Name = "ELITEHUB_WINGS"
    w.Parent = workspace
    local function wing(side)
        local pivot = CFrame.new(side * 0.24 * S, -0.05 * S, -0.1 * S)
        for k = 0, 2 do
            local L = (1.5 + 0.45 * k) * S
            local ang = (0.35 + 0.35 * k) * side
            local ft = MP({ Shape = Enum.PartType.Cylinder, Size = Vector3.new(0.34 * S, L, 0.34 * S), Color = COL, Material = "ForceField" })
            local fl = pivot * CFrame.Angles(0, 0, ang) * CFrame.new(0, L / 2, 0)
            ft.CFrame = torsoCF * fl
            ft:BreakJoints()
            ft.Parent = w
            wingParts[ft] = fl
        end
        local core = MP({ Shape = Enum.PartType.Ball, Size = Vector3.new(0.5 * S, 0.5 * S, 0.5 * S), Color = COL, Material = "ForceField" })
        local cl = pivot
        core.CFrame = torsoCF * cl
        core:BreakJoints()
        core.Parent = w
        wingParts[core] = cl
    end
    wing(-1)
    wing(1)
    Unanchor(w)
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
            for p, lcf in pairs(wingParts) do
                if p and p.Parent then
                    local side = 1
                    if p.CFrame.Position.X < 0 then side = -1 end
                    p.CFrame = base * CFrame.Angles(0, 0, side * amp) * lcf
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
MT:CreateSlider({
    Name = " Wings Size",
    Range = {0.6, 2},
    Increment = 0.1,
    CurrentValue = 1,
    Callback = function(v)
        getgenv().ELITE_HUB_WingsSize = v
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

-- respawn re-apply for fun visuals
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        if getgenv().ELITE_HUB_AuraOn then BuildAura(char) end
        if getgenv().ELITE_HUB_AviatorsOn then BuildAviators(char) end
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
    pcall(function() if getgenv().ELITE_HUB_RemoveAviators then getgenv().ELITE_HUB_RemoveAviators() end end)
    pcall(function() if getgenv().ELITE_HUB_RemoveHorns then getgenv().ELITE_HUB_RemoveHorns() end end)
    pcall(function() if getgenv().ELITE_HUB_RemoveWings then getgenv().ELITE_HUB_RemoveWings() end end)
    pcall(function() if getgenv().ELITE_HUB_RestoreGold then getgenv().ELITE_HUB_RestoreGold(player.Character) end end)
    pcall(function() if getgenv().ELITE_HUB_RestoreBigHead then getgenv().ELITE_HUB_RestoreBigHead(player.Character) end end)

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