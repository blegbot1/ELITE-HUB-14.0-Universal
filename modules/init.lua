-- ELITE HUB 14.0 — Init Module (Settings, Language, Loading, Window)
-- Extracted from ELITE_HUB_14.0.lua

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
            Settings = "НАСТРОЙКИ",
            Language = "Язык",
            Animations = "Анимации",
            ResetSettings = "Сбросить настройки",
            Main = "ОСНОВНОЕ",
            ESP = "ESP",
            Aimbot = "AIMBOT",
            Visual = "ВИЗУАЛ",
            Teleport = "ТЕЛЕПОРТ",
            KillAll = "УБИТЬ ВСЕХ",
            FEScripts = "FE СКРИПТЫ",
            Hubs = "ХАБЫ",
            GameScripts = "СКРИПТЫ ДЛЯ ИГР",
            Mods = "МОДЫ",
            Config = "КОНФИГИ",
            SaveConfig = "💾 Сохранить конфиг",
            LoadConfig = "📂 Загрузить конфиг",
            ConfigSaved = "Конфиг сохранён!",
            ConfigLoaded = "Конфиг загружен!",
            NoConfig = "Конфиг не найден",
            SettingsReset = "Настройки сброшены",
            Version = "ELITE HUB 14.0 HASKER | v14.0",
            ON = "ВКЛ",
            OFF = "ВЫКЛ",
            ItemFinder = "ПОИСК ПРЕДМЕТОВ",
            ItemFinderDesc = "Найти и телепортироваться к предметам",
            Refresh = "🔄 Обновить",
            SearchItem = "🔍 Поиск предмета",
            NoItems = "Предметы не найдены",
            Found = "Найдено",
            items = "предметов",
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
            SaveConfig = "💾 Save Config",
            LoadConfig = "📂 Load Config",
            ConfigSaved = "Config saved!",
            ConfigLoaded = "Config loaded!",
            NoConfig = "No config found",
            SettingsReset = "Settings reset",
            Version = "ELITE HUB 14.0 HASKER | v14.0",
            ON = "ON",
            OFF = "OFF",
            ItemFinder = "ITEM FINDER",
            ItemFinderDesc = "Find and teleport to items",
            Refresh = "🔄 Refresh",
            SearchItem = "🔍 Search Item",
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


local debugMode = true  -- поставить false, чтобы выключить логи

if getgenv().ELITE_HUB_HASKER_LOADED then
    Rayfield:Notify({ Title = "⚠️ Already running", Content = "ELITE HUB is already loaded", Duration = 3 })
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
Log("SYSTEM", "Скрипт запущен. Общий запуск #" .. tostring(getgenv().ELITE_HUB_RUN_COUNT))

-- ═══════════════════════════════════════════════════════════════════
-- LOADING CHECKLIST — консольная загрузка, проверяет всё по шагам
-- ═══════════════════════════════════════════════════════════════════
do
    local function Check(name, ok, info)
        if ok then
            print("[" .. formatTime() .. "] [BOOT] ✅ " .. name .. (info and (" — " .. tostring(info)) or ""))
        else
            print("[" .. formatTime() .. "] [BOOT] ❌ " .. name .. (info and (" — " .. tostring(info)) or " (N/A)"))
        end
    end

    print("")
    print("======================================================")
    print("         ELITE  HUB  14.0  —  HASKER")
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
    Check("game:HttpGet", httpGetOk, "для облака наметок")

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
    print("     ALL CHECKS COMPLETE — initializing UI...")
    print("======================================================")
    print("")
end

local DrawingSupported = pcall(function()
    local d = Drawing.new("Line")
    d:Remove()
    return true
end)
Log("SYSTEM", "Поддержка Drawing: " .. tostring(DrawingSupported))

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
    Name = "🌟💎 ELITE HUB 14.0 HASKER 💎🌟",
    LoadingTitle = "⚡🔥 Hasker Edition загружается... 🔥⚡",
    LoadingSubtitle = "💜👑 by gerkylesichakes | Версия 14.0 | Обновлено: +Mods, Chams, ESP, Aimbot, Spin Bot 👑💜",
    Theme = ThemePurple
})
Window._L = L

getgenv().ELITE_HUB_Log("UI", "Creating tabs...")
local MainTab = Window:CreateTab("🏠 " .. L("Main"), 11286187172, "Main")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Main")
local ESPTab = Window:CreateTab("👁️ " .. L("ESP"), 6026568198, "ESP")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: ESP")
local CombatTab = Window:CreateTab("🎯 " .. L("Aimbot"), 7733960981, "Aimbot")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Aimbot")
local VisualTab = Window:CreateTab("🎨 " .. L("Visual"), 6022668888, "Visual")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Visual")
local TeleportTab = Window:CreateTab("🌀 " .. L("Teleport"), 6023426915, "Teleport")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Teleport")
local KillAllTab = Window:CreateTab("⚔️ " .. L("KillAll"), 0, "KillAll")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: KillAll")
local FEScriptsTab = Window:CreateTab("🎭 " .. L("FEScripts"), 7733960981, "FEScripts")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: FEScripts")
local HubsTab = Window:CreateTab("🚀 " .. L("Hubs"), 6022668888, "Hubs")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: Hubs")
local GameScriptsTab = Window:CreateTab("🎯 " .. L("GameScripts"), 7733960981, "GameScripts")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: GameScripts")

-- Новые раздельные вкладки вместо одной "Моды"
local NametagTab = Window:CreateTab("🏷️ " .. "NAMETAG", 0, "Nametag")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: NAMETAG")
local MovementTab = Window:CreateTab("🏃 " .. "MOVEMENT", 6026568198, "Movement")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: MOVEMENT")
local CombatPlusTab = Window:CreateTab("🥊 " .. "COMBAT+", 7733960981, "CombatPlus")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: COMBAT+")
local CameraTeleportTab = Window:CreateTab("📷 " .. "CAMERA", 6023426915, "CameraTeleport")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: CAMERA")
local EnvironmentTab = Window:CreateTab("🌙 " .. "ENV", 6022668888, "Environment")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: ENV")
local VisualPlusTab = Window:CreateTab("🌈 " .. "VISUAL+", 6026568198, "VisualPlus")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: VISUAL+")
local UtilitiesTab = Window:CreateTab("🎮 " .. "UTILS", 6022668888, "Utilities")
getgenv().ELITE_HUB_Log("UI", "Tab loaded: UTILS")
getgenv().ELITE_HUB_ChamsTab = Window:CreateTab("🌈 " .. "CHAMS", 6026568198, "Chams")
