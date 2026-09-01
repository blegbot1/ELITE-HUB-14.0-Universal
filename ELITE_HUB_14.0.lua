local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local debugMode = true  --  false,   

if getgenv().ELITE_HUB_HASKER_LOADED then
    Rayfield:Notify({ Title = "⚠️ Уже запущен", Content = "ELITE HUB уже загружен", Duration = 3 })
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
    sub.Text = "14.0 HASKER EDITION | "
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
    status.Text = "..."
    status.TextColor3 = Color3.fromRGB(100, 70, 150)
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.Parent = bg

    local TweenService = game:GetService("TweenService")
    local steps = {
        {0.15, " Rayfield..."},
        {0.30, " ESP..."},
        {0.45, " Aimbot..."},
        {0.55, " ..."},
        {0.70, " ..."},
        {0.85, " ..."},
        {0.95, "..."},
        {1.0,  "!"},
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
    Name = "🌟💎 ELITE HUB 14.0 HASKER 💎🌟",
    LoadingTitle = "⚡🔥 Hasker Edition загружается... 🔥⚡",
    LoadingSubtitle = "💜👑 by gerkylesichakes | Версия 14.0 | Все функции включены: +Mods, Chams, ESP, Aimbot, Spin Bot 👑💜",
    Theme = ThemePurple
})

local MainTab = Window:CreateTab("🏠 ОСНОВНОЕ", 11286187172)
local ESPTab = Window:CreateTab("👁️ ESP", 6026568198)
local CombatTab = Window:CreateTab("🎯 AIMBOT", 7733960981)
local VisualTab = Window:CreateTab("🎨 ВИЗУАЛ", 6022668888)
local TeleportTab = Window:CreateTab("🌀 ТЕЛЕПОРТ", 6023426915)
local KillAllTab = Window:CreateTab("⚔️ УБИТЬ ВСЕХ", 0)
local FEScriptsTab = Window:CreateTab("🎭 FE СКРИПТЫ", 7733960981)
local HubsTab = Window:CreateTab("🚀 ХАБЫ", 6022668888)
local GameScriptsTab = Window:CreateTab("🎯 СКРИПТЫ ДЛЯ ИГР", 7733960981)
getgenv().ELITE_HUB_ModsTab = Window:CreateTab("⚡ 闪电 МОДЫ", 6026568198)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local OverlayGui = Instance.new("ScreenGui")
OverlayGui.Name = "ELITE_HUB_Overlay"
OverlayGui.ResetOnSpawn = false
OverlayGui.IgnoreGuiInset = true
OverlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local _ogParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
OverlayGui.Parent = _ogParent

local function NewOverlayLine()
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.ZIndex = 50
    frame.Visible = false
    frame.Parent = OverlayGui

    local line = {
        _f = frame,
        _from = Vector2.new(0, 0),
        _to = Vector2.new(0, 0),
        _thickness = 2,
        _shown = false
    }

    local function layout()
        local f = line._f
        local dx = line._to.X - line._from.X
        local dy = line._to.Y - line._from.Y
        local len = math.sqrt(dx * dx + dy * dy)
        if len < 0.001 then
            f.Visible = false
            return
        end
        f.Size = UDim2.new(0, len, 0, line._thickness)
        f.Position = UDim2.new(0, (line._from.X + line._to.X) / 2, 0, (line._from.Y + line._to.Y) / 2)
        f.Rotation = math.deg(math.atan2(dy, dx))
        f.Visible = line._shown
    end

    local mt = {}
    mt.__index = function(_, k)
        if k == "From" then return line._from end
        if k == "To" then return line._to end
        if k == "Visible" then return line._shown end
        if k == "Color" then return line._f.BackgroundColor3 end
        if k == "Remove" then
            return function()
                if line._f then line._f:Destroy() end
            end
        end
        return nil
    end
    mt.__newindex = function(_, k, v)
        if k == "From" then line._from = v; layout() return end
        if k == "To" then line._to = v; layout() return end
        if k == "Color" then line._f.BackgroundColor3 = v return end
        if k == "Thickness" then
            line._thickness = v
            layout()
            return
        end
        if k == "Visible" then
            line._shown = v
            line._f.Visible = v
            return
        end
        rawset(line, k, v)
    end

    return setmetatable({}, mt)
end

local function NewOverlayCircle()
    local segmentCount = 48
    local segments = {}
    for i = 1, segmentCount do
        segments[i] = NewOverlayLine()
    end

    local circle = {
        _seg = segments,
        _radius = 100,
        _position = Vector2.new(0, 0),
        _thickness = 3,
        _color = Color3.new(1, 0, 0),
        _shown = false,
        _filled = false
    }

    local function layout()
        local n = #circle._seg
        for i = 1, n do
            local aPrev = ((i - 1) / n) * 2 * math.pi
            local aCur = (i / n) * 2 * math.pi
            local p1 = circle._position + Vector2.new(math.cos(aPrev), math.sin(aPrev)) * circle._radius
            local p2 = circle._position + Vector2.new(math.cos(aCur), math.sin(aCur)) * circle._radius
            local seg = circle._seg[i]
            seg.Color = circle._color
            seg.Thickness = circle._thickness
            seg.From = p1
            seg.To = p2
            seg.Visible = circle._shown
        end
    end

    local mt = {}
    mt.__index = function(_, k)
        if k == "Radius" then return circle._radius end
        if k == "Position" then return circle._position end
        if k == "Visible" then return circle._shown end
        if k == "Color" then return circle._color end
        if k == "Thickness" then return circle._thickness end
        if k == "Remove" then
            return function()
                for _, seg in ipairs(circle._seg) do
                    seg:Remove()
                end
            end
        end
        return nil
    end
    mt.__newindex = function(_, k, v)
        if k == "Radius" then circle._radius = v; layout() return end
        if k == "Position" then circle._position = v; layout() return end
        if k == "Color" then circle._color = v; layout() return end
        if k == "Thickness" then circle._thickness = v; layout() return end
        if k == "Filled" then circle._filled = v return end
        if k == "Visible" then circle._shown = v; layout() return end
        rawset(circle, k, v)
    end

    return setmetatable({}, mt)
end

local function DestroyScript()
    Log("SYSTEM", "Выключение скрипта")
    Rayfield:Notify({
        Title = "🛑 Выключение...",
        Content = "Скрипт выключается",
        Duration = 2
    })
    task.wait(1)
    getgenv().ELITE_HUB_HASKER_LOADED = false
    Rayfield:Destroy()
end

local function LoadScript(name, url)
    task.spawn(function()
        Rayfield:Notify({
            Title = "⏳ Загрузка...",
            Content = name .. " запускается",
            Duration = 2
        })
        
        task.wait(0.5)
        
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        
        task.wait(0.5)
        
        if success then
            Rayfield:Notify({
                Title = "✅ Успешно!",
                Content = name .. " загружен",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "❌ Ошибка!",
                Content = "Не удалось загрузить " .. name,
                Duration = 5
            })
            warn("Script Load Error:", name, err)
        end
    end)
end

--[[
    ==============================
     
    ==============================
]]--
local HubsSection = HubsTab:CreateSection("🎮 УНИВЕРСАЛЬНЫЕ ХАБЫ")

HubsTab:CreateButton({
    Name = "🎮 Ghub V15",
    Callback = function()
        LoadScript("🎮 Ghub V15", "https://raw.githubusercontent.com/gclich/GHUBV15_X_ZENXOS-MAINLOADER/refs/heads/main/GHUB-X-ZENXOS-V15.txt")
    end
})

HubsTab:CreateButton({
    Name = "❄️ Blizzard Hub V2",
    Callback = function()
        LoadScript("❄️ Blizzard Hub V2", "https://raw.githubusercontent.com/uaahjajajqoqiqkqhwhwhw/Blizzard-Hub-Official/main/Blizzard%20Hub%20V2.lua")
    end
})
HubsTab:CreateButton({
    Name = "🐯 Tiger X",
    Callback = function()
        LoadScript("🐯 Tiger X", "https://raw.githubusercontent.com/balintTheDevX/Tiger-X-V3/main/Tiger%20X%20V3.5%20Fixed")
    end
})

HubsTab:CreateButton({
    Name = "🎨 Bido Skins V1.8",
    Callback = function()
        LoadScript("🎨 Bido Skins V1.8", "https://raw.githubusercontent.com/BidoSkinsYT/BidoSkinsYT/main/Bido%20Skins%20V1.8")
    end
})

HubsTab:CreateButton({
    Name = "🌀 Draught Hub V5",
    Callback = function()
        LoadScript("🌀 Draught Hub V5", "https://raw.githubusercontent.com/SabrXH/Draught-Hub-V5/refs/heads/main/Script.lua")
    end
})

HubsTab:CreateButton({
    Name = "🍊 OrangeX Hub",
    Callback = function()
        LoadScript("🍊 OrangeX Hub", "https://raw.githubusercontent.com/ImJosh66/Ab2rW/main/ORANGEX%20V5%20RELEASED%20ORANGEX%20ON%20TOP%20.txt")
    end
})
HubsTab:CreateButton({
    Name = "👻 Ghost Hub",
    Callback = function()
        LoadScript("👻 Ghost Hub", "https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub")
    end
})

HubsTab:CreateButton({
    Name = "⚡ Nullware Hub V3",
    Callback = function()
        getgenv().Theme = "Blue"
        LoadScript("⚡ Nullware Hub V3", "https://gist.githubusercontent.com/M6HqVBcddw2qaN4s/2d722888a388017c18028cd434c43a25/raw/dcccf1027fe4b90780e47767aaf584389c9d7771/EULma3fU90PUOKUn?identifier=".. (function()local a=""for b=1,256 do local c=math.random(1,3)a=a..string.char(c==1 and math.random(48,57)or c==2 and math.random(97,122)or c==3 and math.random(65,90))end;return a end)())
    end
})

HubsTab:CreateButton({
    Name = "🔧 Haxker_6666666 Hub",
    Callback = function()
        LoadScript("🔧 Haxker_6666666 Hub", "https://raw.githubusercontent.com/FreeRobloxScripts1/Haxker_6666666-Hub/main/loader")
    end
})

HubsTab:CreateButton({
    Name = "🌙 Moon UI",
    Callback = function()
        LoadScript("🌙 Moon UI", "https://raw.githubusercontent.com/IlikeyocutgHAH12/MoonUI-v10-/main/MoonUI%20v10")
    end
})

HubsTab:CreateButton({
    Name = "💪 GigaChad Hub v3.5",
    Callback = function()
        LoadScript("💪 GigaChad Hub v3.5", "https://raw.githubusercontent.com/OWJBWKQLAISH/GigaChad-Hub/main/Version%20V3.5")
    end
})

HubsTab:CreateButton({
    Name = "🚀 Frixon Hub",
    Callback = function()
        LoadScript("🚀 Frixon Hub", "https://gist.githubusercontent.com/RedoGaming/459eb467f3df927b07ca398a68f3b053/raw/6d1f7a2c8fefd072dc53ebbbec38c6f93c7de1ad/Frixon%2520Hub!%2520New%2520OP%2520Exploit%2520Hub%2520for%2520Roblox!")
    end
})

HubsTab:CreateButton({
    Name = "💎 Mega Hub",
    Callback = function()
        LoadScript("💎 Mega Hub", "https://raw.githubusercontent.com/WholeF00ds/Mega/main/Obfuscated%20Loader")
    end
})

HubsTab:CreateButton({
    Name = "🔰 Mini Hub",
    Callback = function()
        LoadScript("🔰 Mini Hub", "https://raw.githubusercontent.com/MiniNoobie/MINI-HUB-V2/main/FINALLY%20UPDATED%20MINI%20HUB")
    end
})

HubsTab:CreateButton({
    Name = "🎨 Davi GUI",
    Callback = function()
        LoadScript("🎨 Davi GUI", "https://raw.githubusercontent.com/Davicoderliner/davigui/main/Daviguiv2loader.lua")
    end
})

HubsTab:CreateButton({
    Name = "🅱️ B Hub",
    Callback = function()
        LoadScript("🅱️ B Hub", "https://raw.githubusercontent.com/YourLocalNzi/Ye/main/BHob6")
    end
})

HubsTab:CreateButton({
    Name = "🎯 AirHub (Aimbot/ESP)",
    Callback = function()
        LoadScript("🎯 AirHub", "https://raw.githubusercontent.com/Exunys/AirHub/main/AirHub.lua")
    end
})


HubsTab:CreateButton({
    Name = "🌟 Comet Hub",
    Callback = function()
        LoadScript("🌟 Comet Hub", "https://raw.githubusercontent.com/AokijiFlame/Hubs/Squid/CometHub.lua")
    end
})

HubsTab:CreateButton({
    Name = "🏠 CarpetHack Hub",
    Callback = function()
        LoadScript("🏠 CarpetHack Hub", "https://raw.githubusercontent.com/RobloxHackingProject/CHHub/main/CHHub.lua")
    end
})

HubsTab:CreateButton({
    Name = "⚡ Vynixu Hub",
    Callback = function()
        LoadScript("⚡ Vynixu Hub", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Loader.lua")
    end
})

HubsTab:CreateButton({
    Name = "🎮 Hydroxide Hub",
    Callback = function()
        LoadScript("🎮 Hydroxide Hub", "https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/init.lua")
    end
})

HubsTab:CreateButton({
    Name = "🔥 Owl Hub",
    Callback = function()
        LoadScript("🔥 Owl Hub", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt")
    end
})











--[[
    ==============================
      FE 
    ==============================
]]--
local FEBasicSection = FEScriptsTab:CreateSection("🎭 ОСНОВНЫЕ FE СКРИПТЫ")

FEScriptsTab:CreateButton({
    Name = "🥊 Fe Punch (R15/R6)",
    Callback = function()
        LoadScript("🥊 Fe Punch", "https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt")
    end
})

FEScriptsTab:CreateButton({
    Name = "🐱 Fe Neko (R6 only)",
    Callback = function()
        LoadScript("🐱 Fe Neko", "https://raw.githubusercontent.com/Gazer-Ha/Neko-v1/main/Extremely%20Broken")
    end
})
FEScriptsTab:CreateButton({
    Name = "💨 Fe Gale Fighter (R6 only)",
    Callback = function()
        LoadScript("⚔️ FE GALE FIGHTER", "https://pastebin.com/raw/XPGSMEw9")
    end
})
FEScriptsTab:CreateButton({
    Name = "👊 Fe KJ (R6 only)",
    Callback = function()
        LoadScript("👊 Fe KJ", "https://pastefy.app/sdAujywd/raw")
    end
})

FEScriptsTab:CreateButton({
    Name = "🔮 Fe Caducus (R6 only)",
    Callback = function()
        LoadScript("🔮 Fe Caducus", "https://pastebin.com/raw/LDL9AyQ4")
    end
})

FEScriptsTab:CreateButton({
    Name = "⚡ Fe Sonic (R6 only)",
    Callback = function()
        LoadScript("⚡ Fe Sonic", "https://pastebin.com/raw/uacVtsWe")
    end
})

FEScriptsTab:CreateButton({
    Name = "😢 Fe Sad Boy (R6 only)",
    Callback = function()
        LoadScript("😢 Fe Sad Boy", "https://pastebin.com/raw/hgPJbwF0")
    end
})

local FEUtilitiesSection = FEScriptsTab:CreateSection("🛠️ FE УТИЛИТЫ")

FEScriptsTab:CreateButton({
    Name = "👨‍💼 Fe G-Man (R6 only)",
    Callback = function()
        _G.clientsidedeffect = true
        LoadScript("👨‍💼 Fe G-Man", "https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty18.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = "🚗 Fe Car (R15/R6)",
    Callback = function()
        LoadScript("🚗 Fe Car", "https://raw.githubusercontent.com/AlexCr4sh/FeScripts/main/FeCarScript.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = "🥊 Fe Fighter (R6 only)",
    Callback = function()
        LoadScript("🥊 Fe Fighter", "https://rawscripts.net/raw/Universal-Script-FE-Fighter-inspired-by-Gale-21557")
    end
})

FEScriptsTab:CreateButton({
    Name = "🤗 Fe Hug (All Games)",
    Callback = function()
        LoadScript("🤗 Fe Hug", "https://rawscripts.net/raw/Universal-Script-Hug-Gui-R6-17818")
    end
})

FEScriptsTab:CreateButton({
    Name = "👑 Fe Honored (R6 only)",
    Callback = function()
        LoadScript("👑 Fe Honored", "https://raw.githubusercontent.com/Cortzalno666/NectoVerse-Industries-Data/master/Scripts%20Folder/Honored.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = "👻 Fe Invisible (All Games)",
    Callback = function()
        LoadScript("👻 Fe Invisible", "https://pastebin.com/raw/3Rnd9rHf")
    end
})

FEScriptsTab:CreateButton({
    Name = "🤖 Fe NPC Control (R6 only)",
    Callback = function()
        LoadScript("🤖 Fe NPC Control", "https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty13.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = "🌀 Fe Telekinesis V5",
    Callback = function()
        LoadScript("🌀 Fe Telekinesis V5", "https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty11.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = "🎨 Fe Tool Draw",
    Callback = function()
        LoadScript("🎨 Fe Tool Draw", "https://raw.githubusercontent.com/Affexter/Programs/refs/heads/main/scripts/tooldrawFE.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = "🧟 Fe Zombie (R6/R15)",
    Callback = function()
        LoadScript("🧟 Fe Zombie", "https://pastefy.app/w7KnPY70/raw")
    end
})

local FEEffectsSection = FEScriptsTab:CreateSection("✨ FE ЭФФЕКТЫ")

FEScriptsTab:CreateButton({
    Name = "🕳️ Fe Blackhole",
    Callback = function()
        LoadScript("🕳️ Fe Blackhole", "https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BringFlingPlayers")
    end
})

FEScriptsTab:CreateButton({
    Name = "🌀 Fe Radius Blackhole",
    Callback = function()
        LoadScript("🌀 Fe Radius Blackhole", "https://pastebin.com/raw/RkWYLL5t")
    end
})

FEScriptsTab:CreateButton({
    Name = "💍 Fe Super Ring V4",
    Callback = function()
        LoadScript("💍 Fe Super Ring V4", "https://rawscripts.net/raw/Natural-Disaster-Survival-Super-ring-V4-24296")
    end
})

FEScriptsTab:CreateButton({
    Name = "🔊 Fe Audio Spam",
    Callback = function()
        LoadScript("🔊 Fe Audio Spam", "https://pastebin.com/raw/kmXCTkBt")
    end
})

FEScriptsTab:CreateButton({
    Name = "⚔️ Fe Goner Divine Edge (R6 only)",
    Callback = function()
        LoadScript("⚔️ Fe Goner Divine Edge", "https://pastebin.com/raw/sFf9MeBE")
    end
})

FEScriptsTab:CreateButton({
    Name = "💎 Fe Crystal Dance (R6 only)",
    Callback = function()
        LoadScript("💎 Fe Crystal Dance", "https://pastebin.com/raw/vT1URaRJ")
    end
})

FEScriptsTab:CreateButton({
    Name = "💪 Fe Jerk (R15/R6)",
    Callback = function()
        LoadScript("💪 Fe Jerk", "https://pastefy.app/YZoglOyJ/raw")
    end
})

local GenesisFESection = FEScriptsTab:CreateSection("🌟 GENESIS FE СКРИПТЫ")

FEScriptsTab:CreateButton({
    Name = "🔨 Fe Ban Hammer",
    Callback = function()
        LoadScript("🔨 Fe Ban Hammer", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Ban%20Hammer")
    end
})

FEScriptsTab:CreateButton({
    Name = "🌊 FE Neptunian V",
    Callback = function()
        LoadScript("🌊 FE Neptunian V", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Neptunian%20V")
    end
})

FEScriptsTab:CreateButton({
    Name = "⚔️ Fe Linked Sword",
    Callback = function()
        LoadScript("⚔️ Fe Linked Sword", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Linked%20Sword")
    end
})

FEScriptsTab:CreateButton({
    Name = "⭐ Fe Star Glicher",
    Callback = function()
        LoadScript("⭐ Fe Star Glicher", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Star%20Glitcher")
    end
})

FEScriptsTab:CreateButton({
    Name = "🔫 FE AK-47 (Da Hood)",
    Callback = function()
        LoadScript("🔫 FE AK-47", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/AK-47")
    end
})

FEScriptsTab:CreateButton({
    Name = "💎 Fe Krystal Dance",
    Callback = function()
        LoadScript("💎 Fe Krystal Dance", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Krystal%20Dance")
    end
})

FEScriptsTab:CreateButton({
    Name = "👮 Fe Good Cop Bad Cop",
    Callback = function()
        LoadScript("👮 Fe Good Cop Bad Cop", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Good%20Cop%20Bad%20Cop")
    end
})

FEScriptsTab:CreateButton({
    Name = "⚔️ FE GALE FIGHTER",
    Callback = function()
        LoadScript("⚔️ FE GALE FIGHTER", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Gale%20Fighter")
    end
})

FEScriptsTab:CreateButton({
    Name = "🔫 FE Dearsister Pistol",
    Callback = function()
        LoadScript("🔫 FE Dearsister Pistol", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Dearsister")
    end
})

local FEAnimationsSection = FEScriptsTab:CreateSection("💃 FE АНИМАЦИИ")

FEScriptsTab:CreateButton({
    Name = "👨 Fe Animation Man (R6 only)",
    Callback = function()
        LoadScript("👨 Fe Animation Man", "https://pastefy.app/ZWgckZdU/raw")
    end
})
FEScriptsTab:CreateButton({
    Name = "🚶 Fe Animation Walk (R15)",
    Callback = function()
        LoadScript("🚶 Fe Animation Walk", "https://pastebin.com/raw/T7kdfUmG")
    end
})

FEScriptsTab:CreateButton({
    Name = "🕺 Fe Get Sturdy (Baseplate)",
    Callback = function()
        LoadScript("🕺 Fe Get Sturdy", "https://pastebin.com/raw/xAHFn1hh")
    end
})
FEScriptsTab:CreateButton({
    Name = "🎭 Fe Emotes (R15 only)",
    Callback = function()
        LoadScript("🎭 Fe Emotes", "https://pastebin.com/raw/eCpipCTH")
    end
})

local AdditionalFESection = FEScriptsTab:CreateSection("✨ ДОПОЛНИТЕЛЬНЫЕ FE СКРИПТЫ")
local FEUtilitiesSection2 = FEScriptsTab:CreateSection("🛠️ ПОПУЛЯРНЫЕ УТИЛИТЫ")

FEScriptsTab:CreateButton({
    Name = "♾️ Infinite Yield",
    Callback = function()
        LoadScript("♾️ Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end
})

FEScriptsTab:CreateButton({
    Name = "🔍 Dark Dex V3",
    Callback = function()
        LoadScript("🔍 Dark Dex V3", "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = "📊 Remote Spy",
    Callback = function()
        LoadScript("📊 Remote Spy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = "🎨 Unnamed ESP",
    Callback = function()
        LoadScript("🎨 Unnamed ESP", "https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = "🔧 CMD-X",
    Callback = function()
        LoadScript("🔧 CMD-X", "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source")
    end
})

FEScriptsTab:CreateButton({
    Name = "💻 Hydroxide",
    Callback = function()
        LoadScript("💻 Hydroxide", "https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/init.lua")
    end
})
FEScriptsTab:CreateButton({
    Name = "⚡ FPS Booster",
    Callback = function()
        LoadScript("⚡ FPS Booster", "https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua")
    end
})
--[[
    ==============================
       
    ==============================
]]--

local PopularGamesSection = GameScriptsTab:CreateSection("🔥 ПОПУЛЯРНЫЕ ИГРЫ")
GameScriptsTab:CreateButton({
    Name = "🏝️ Islands",
    Callback = function()
        LoadScript("🏝️ Islands", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt")
    end
})

GameScriptsTab:CreateButton({
    Name = "🏭 Jailbreak",
    Callback = function()
        LoadScript("🏭 Jailbreak", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Jailbreak/Script.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = "🐝 Bee Swarm Simulator",
    Callback = function()
        LoadScript("🐝 Bee Swarm Simulator", "https://raw.githubusercontent.com/Historia00012/HISTORIAHUB/main/BSS%20FREE")
    end
})

local SimulatorsSection = GameScriptsTab:CreateSection("🎰 СИМУЛЯТОРЫ")

GameScriptsTab:CreateButton({
    Name = "💪 Muscle Legends",
    Callback = function()
        LoadScript("💪 Muscle Legends", "https://raw.githubusercontent.com/harisiskandar178/Roblox-Script/main/Muscle%20Legend")
    end
})

GameScriptsTab:CreateButton({
    Name = "🐾 Pet Simulator X",
    Callback = function()
        LoadScript("🐾 Pet Simulator X", "https://raw.githubusercontent.com/Muhammad6196/Project-WD/main/Main.lua")
    end
})
local HorrorGamesSection = GameScriptsTab:CreateSection("👻 ХОРРОР ИГРЫ")

GameScriptsTab:CreateButton({
    Name = "🚪 Doors",
    Callback = function()
        LoadScript("🚪 Doors", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Doors/Script.lua")
    end
})
local FightingGamesSection = GameScriptsTab:CreateSection("🥊 ФАЙТИНГ ИГРЫ")
local MoreGamesSection = GameScriptsTab:CreateSection("🎲 ДОПОЛНИТЕЛЬНЫЕ ИГРЫ")
GameScriptsTab:CreateButton({
    Name = "🎮 Funky Friday",
    Callback = function()
        LoadScript("🎮 Funky Friday", "https://raw.githubusercontent.com/ShowerHead-FluxTeam/scripts/main/funky-friday-autoplay")
    end
})
local AnimeGamesSection = GameScriptsTab:CreateSection("⚡ ANIME ИГРЫ")
local TycoonGamesSection = GameScriptsTab:CreateSection("🏭 TYCOON ИГРЫ")
local ObbyGamesSection = GameScriptsTab:CreateSection("🏃 OBBY ИГРЫ")
--[[
    ==============================
      
    ==============================
]]--
local AdventureSection = MainTab:CreateSection("🚀 ОСНОВНЫЕ ФУНКЦИИ")

local noclipActive = false
local noclipConnection = nil
local BindConfig = {
    Fly = "F",
    Noclip = "N",
    SpeedBoost = "V",
    SpinBot = "B"
}
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
local InfiniteJumpEnabled = true -- Debounce   wallhop

local function getWallRaycastResult()
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return nil end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end

    raycastParams.FilterDescendantsInstances = {character}
    local detectionDistance = 2
    local closestHit = nil
    local minDistance = detectionDistance + 1
    local hrpCF = humanoidRootPart.CFrame

    for i = 0, 7 do
        local angle = math.rad(i * 45)
        local direction = (hrpCF * CFrame.Angles(0, angle, 0)).LookVector
        local ray = Workspace:Raycast(humanoidRootPart.Position, direction * detectionDistance, raycastParams)
        if ray and ray.Instance and ray.Distance < minDistance then
            minDistance = ray.Distance
            closestHit = ray
        end
    end

    local blockCastSize = Vector3.new(1.5, 1, 0.5)
    local blockCastOffset = CFrame.new(0, -1, -0.5)
    local blockCastOriginCF = hrpCF * blockCastOffset
    local blockCastDirection = hrpCF.LookVector
    local blockCastDistance = 1.5
    local blockResult = Workspace:Blockcast(blockCastOriginCF, blockCastSize, blockCastDirection * blockCastDistance, raycastParams)

    if blockResult and blockResult.Instance and blockResult.Distance < minDistance then
         minDistance = blockResult.Distance
         closestHit = blockResult
    end

    return closestHit
end

local function performWallJump()
    if not InfiniteJumpEnabled then return end

    local player = Players.LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local camera = Workspace.CurrentCamera

    if not (humanoid and rootPart and camera and humanoid:GetState() ~= Enum.HumanoidStateType.Dead) then return end

    local wallRayResult = getWallRaycastResult()

    if wallRayResult then
        InfiniteJumpEnabled = false -- Start debounce

        local maxInfluenceAngleRight = math.rad(20) -- Max angle if camera is to the RIGHT
        local maxInfluenceAngleLeft  = math.rad(-100) -- Max angle if camera is to the LEFT

        local wallNormal = wallRayResult.Normal
        local baseDirectionAwayFromWall = Vector3.new(wallNormal.X, 0, wallNormal.Z).Unit
        if baseDirectionAwayFromWall.Magnitude < 0.1 then
             local dirToHit = (wallRayResult.Position - rootPart.Position) * Vector3.new(1,0,1)
             baseDirectionAwayFromWall = -dirToHit.Unit
             if baseDirectionAwayFromWall.Magnitude < 0.1 then
                 baseDirectionAwayFromWall = -rootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
                 if baseDirectionAwayFromWall.Magnitude > 0.1 then baseDirectionAwayFromWall = baseDirectionAwayFromWall.Unit end
                 if baseDirectionAwayFromWall.Magnitude < 0.1 then baseDirectionAwayFromWall = Vector3.new(0,0,1) end
             end
        end
        baseDirectionAwayFromWall = Vector3.new(baseDirectionAwayFromWall.X, 0, baseDirectionAwayFromWall.Z).Unit
        if baseDirectionAwayFromWall.Magnitude < 0.1 then baseDirectionAwayFromWall = Vector3.new(0,0,1) end

        local cameraLook = camera.CFrame.LookVector
        local horizontalCameraLook = Vector3.new(cameraLook.X, 0, cameraLook.Z).Unit
        if horizontalCameraLook.Magnitude < 0.1 then horizontalCameraLook = baseDirectionAwayFromWall end

        local dot = math.clamp(baseDirectionAwayFromWall:Dot(horizontalCameraLook), -1, 1)
        local angleBetween = math.acos(dot)
        local cross = baseDirectionAwayFromWall:Cross(horizontalCameraLook)
        local rotationSign = -math.sign(cross.Y)
        if rotationSign == 0 then angleBetween = 0 end

        local actualInfluenceAngle
        if rotationSign == 1 then -- Camera influencing RIGHT
            actualInfluenceAngle = math.min(angleBetween, maxInfluenceAngleRight)
        elseif rotationSign == -1 then -- Camera influencing LEFT
            actualInfluenceAngle = math.min(angleBetween, maxInfluenceAngleLeft)
        else -- Aligned
            actualInfluenceAngle = 0
        end

        local adjustmentRotation = CFrame.Angles(0, actualInfluenceAngle * rotationSign, 0)
        local initialTargetLookDirection = adjustmentRotation * baseDirectionAwayFromWall

        rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + initialTargetLookDirection)

        RunService.Heartbeat:Wait()

        local didJump = false
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
             humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
             didJump = true

             rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, -1, 0)
             task.wait(0.15)
             rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, 1, 0)
        end

        if didJump then
             local directionTowardsWall = -baseDirectionAwayFromWall
             task.wait(0.05) -- Wait for flick to visually finish
             rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + directionTowardsWall)
        end

        InfiniteJumpEnabled = true -- End debounce
    end
end

local function ToggleWallhop()
    wallhopActive = not wallhopActive
    if wallhopActive then
        wallhopConnection = UserInputService.JumpRequest:Connect(function()
            if not wallhopActive then return end
            performWallJump()
        end)
        Rayfield:Notify({
            Title = "✅ WallHop",
            Content = "WallHop  (: " .. tostring(wallhopBindKey.Name) .. ")",
            Duration = 3
        })
    else
        if wallhopConnection then
            wallhopConnection:Disconnect()
            wallhopConnection = nil
        end
        Rayfield:Notify({
            Title = "✅ WallHop",
            Content = "❌ WallHop ",
            Duration = 3
        })
    end
    updateMiniGuiButtons()
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == wallhopBindKey then
        ToggleWallhop()
    end
    local success1, flyKey = pcall(function() return Enum.KeyCode[BindConfig.Fly] end)
    if success1 and flyKey and input.KeyCode == flyKey then
        ToggleFly()
    end
    local success2, noclipKey = pcall(function() return Enum.KeyCode[BindConfig.Noclip] end)
    if success2 and noclipKey and input.KeyCode == noclipKey then
        ToggleNoclip()
    end
    local success5, speedKey = pcall(function() return Enum.KeyCode[BindConfig.SpeedBoost] end)
    if success5 and speedKey and input.KeyCode == speedKey then
        ActivateSpeedBoost()
    end
    local success6, spinKey = pcall(function() return Enum.KeyCode[BindConfig.SpinBot] end)
    if success6 and spinKey and input.KeyCode == spinKey then
        getgenv().ELITE_HUB_SpinBot = not getgenv().ELITE_HUB_SpinBot
        getgenv().ELITE_HUB_Log("MODS", "Spin Bot: " .. tostring(getgenv().ELITE_HUB_SpinBot))
        if getgenv().ELITE_HUB_SpinBot then
            getgenv().ELITE_HUB_SpinAngle = 0
            task.spawn(function()
                while getgenv().ELITE_HUB_SpinBot do
                    task.wait(0.016)
                    pcall(function()
                        getgenv().ELITE_HUB_SpinAngle = (getgenv().ELITE_HUB_SpinAngle + getgenv().ELITE_HUB_SpinSpeed) % 360
                        if not flyBg then
                            local ch = player.Character
                            if ch then
                                local hrp = ch:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(getgenv().ELITE_HUB_SpinSpeed * 0.1), 0)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
end)

local miniGui = Instance.new("ScreenGui")
miniGui.Name = "MiniControlGui"
miniGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
miniGui.ResetOnSpawn = false
miniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local miniFrame = Instance.new("Frame")
miniFrame.Name = "MiniFrame"
miniFrame.Parent = miniGui
miniFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 32)
miniFrame.Size = UDim2.new(0, 200, 0, 0)
miniFrame.Position = UDim2.new(0, 14, 0.5, -140)
miniFrame.Active = true
miniFrame.Draggable = true
miniFrame.BorderSizePixel = 0
miniFrame.Visible = false
miniFrame.ClipsDescendants = true
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(0, 12)
local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(140, 60, 255)
miniStroke.Thickness = 2
miniStroke.Transparency = 0.3
miniStroke.Parent = miniFrame

local miniTitle = Instance.new("TextLabel")
miniTitle.Name = "Title"
miniTitle.Parent = miniFrame
miniTitle.BackgroundTransparency = 1
miniTitle.Size = UDim2.new(1, -40, 0, 32)
miniTitle.Position = UDim2.new(0, 12, 0, 8)
miniTitle.Text = "ELITE HUB"
miniTitle.TextColor3 = Color3.fromRGB(200, 140, 255)
miniTitle.TextSize = 15
miniTitle.TextXAlignment = Enum.TextXAlignment.Left
miniTitle.Font = Enum.Font.GothamBlack

local closeMiniGuiBtn = Instance.new("TextButton")
closeMiniGuiBtn.Name = "CloseBtn"
closeMiniGuiBtn.Parent = miniFrame
closeMiniGuiBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 70)
closeMiniGuiBtn.Size = UDim2.new(0, 22, 0, 22)
closeMiniGuiBtn.Position = UDim2.new(1, -32, 0, 8)
closeMiniGuiBtn.Text = "X"
closeMiniGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeMiniGuiBtn.TextSize = 13
closeMiniGuiBtn.Font = Enum.Font.GothamBold
closeMiniGuiBtn.BorderSizePixel = 0

local function CreateMiniButton(name, text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = miniFrame
    btn.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
    btn.Size = UDim2.new(1, -20, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, 46 + order * 38)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(170, 170, 170)
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Parent = btn
    indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    indicator.Size = UDim2.new(0, 8, 0, 8)
    indicator.Position = UDim2.new(1, -18, 0.5, -4)
    indicator.BorderSizePixel = 0
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local wallhopBtn = CreateMiniButton("WallhopBtn", "✅ WallHop", 0, function() ToggleWallhop() end)
local flyBtn = CreateMiniButton("FlyBtn", "✅ Fly", 1, function() ToggleFly() end)
local noclipBtn = CreateMiniButton("NoclipBtn", "✅ Noclip", 2, function() ToggleNoclip() end)

getgenv().ELITE_HUB_SpeedBtn = CreateMiniButton("SpeedBoostBtn", "⚡ Speed Boost", 3, function()
    ActivateSpeedBoost()
end)

getgenv().ELITE_HUB_SpinBtn = CreateMiniButton("SpinBotBtn", "🔄 Spin Bot", 4, function()
    getgenv().ELITE_HUB_SpinBot = not getgenv().ELITE_HUB_SpinBot
    getgenv().ELITE_HUB_Log("MODS", "Spin Bot: " .. tostring(getgenv().ELITE_HUB_SpinBot))
    if getgenv().ELITE_HUB_SpinBot then
        getgenv().ELITE_HUB_SpinAngle = 0
        task.spawn(function()
            while getgenv().ELITE_HUB_SpinBot do
                task.wait(0.016)
                pcall(function()
                    getgenv().ELITE_HUB_SpinAngle = (getgenv().ELITE_HUB_SpinAngle + getgenv().ELITE_HUB_SpinSpeed) % 360
                    if not flyBg then
                        local ch = player.Character
                        if ch then
                            local hrp = ch:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(getgenv().ELITE_HUB_SpinSpeed * 0.1), 0)
                            end
                        end
                    end
                end)
            end
        end)
    end
end)

function updateMiniGuiButtons()
    if wallhopActive then
        wallhopBtn.Text = "🧱 WallHop: ON"
        wallhopBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 50)
        wallhopBtn.TextColor3 = Color3.fromRGB(120, 255, 140)
        wallhopBtn.Indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
    else
        wallhopBtn.Text = "🧱 WallHop: OFF"
        wallhopBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
        wallhopBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
        wallhopBtn.Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end

    if nowe then
        flyBtn.Text = "✈️ Fly: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
        flyBtn.TextColor3 = Color3.fromRGB(120, 180, 255)
        flyBtn.Indicator.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
    else
        flyBtn.Text = "✈️ Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
        flyBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
        flyBtn.Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end

    if noclipActive then
        noclipBtn.Text = "👻 Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 100)
        noclipBtn.TextColor3 = Color3.fromRGB(255, 140, 255)
        noclipBtn.Indicator.BackgroundColor3 = Color3.fromRGB(200, 80, 255)
    else
        noclipBtn.Text = "👻 Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
        noclipBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
        noclipBtn.Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end

    if getgenv().ELITE_HUB_SpinBot then
        getgenv().ELITE_HUB_SpinBtn.Text = "🔄 Spin Bot: ON"
        getgenv().ELITE_HUB_SpinBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        getgenv().ELITE_HUB_SpinBtn.TextColor3 = Color3.fromRGB(255, 140, 140)
        getgenv().ELITE_HUB_SpinBtn.Indicator.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    else
        getgenv().ELITE_HUB_SpinBtn.Text = "🔄 Spin Bot: OFF"
        getgenv().ELITE_HUB_SpinBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
        getgenv().ELITE_HUB_SpinBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
        getgenv().ELITE_HUB_SpinBtn.Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end

local function ToggleMiniMenu()
    if miniFrame.Visible then
        miniFrame.Visible = false
    else
        local btns = 5
        local totalH = 56 + btns * 38
        miniFrame.Size = UDim2.new(0, 200, 0, totalH)
        miniFrame.Visible = true
    end
end

closeMiniGuiBtn.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
end)

getgenv().ELITE_HUB_SpeedActive = false
getgenv().ELITE_HUB_SpeedOldSpeed = nil

function ActivateSpeedBoost()
    if getgenv().ELITE_HUB_SpeedActive then
        DeactivateSpeedBoost()
        return
    end
    local ch = player.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    getgenv().ELITE_HUB_SpeedActive = true
    getgenv().ELITE_HUB_SpeedOldSpeed = hum.WalkSpeed
    hum.WalkSpeed = 50

    local sb = getgenv().ELITE_HUB_SpeedBtn
    if sb then
        sb.Text = "⚡ Speed: ON"
        sb.BackgroundColor3 = Color3.fromRGB(120, 30, 150)
        sb.TextColor3 = Color3.fromRGB(255, 100, 255)
        sb.Indicator.BackgroundColor3 = Color3.fromRGB(200, 50, 255)
    end

    local att0 = Instance.new("Attachment")
    att0.Position = Vector3.new(0.5, 0, 0)
    att0.Parent = hrp
    local att1 = Instance.new("Attachment")
    att1.Position = Vector3.new(-0.5, 0, 0)
    att1.Parent = hrp

    local trail = Instance.new("Trail")
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Lifetime = 0.6
    trail.MinLength = 0.1
    trail.LightEmission = 1
    trail.LightInfluence = 0
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 30, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 60))
    })
    trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.5),
        NumberSequenceKeypoint.new(1, 0)
    })
    trail.FaceCamera = true
    trail.Parent = hrp

    local emitter = Instance.new("ParticleEmitter")
    emitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 50, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 60))
    })
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 0)
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    emitter.Lifetime = NumberRange.new(0.3, 0.7)
    emitter.Rate = 120
    emitter.Speed = NumberRange.new(2, 5)
    emitter.SpreadAngle = Vector2.new(360, 360)
    emitter.LightEmission = 1
    emitter.LightInfluence = 0
    emitter.Parent = hrp

    getgenv().ELITE_HUB_SpeedTrail = {trail, emitter, att0, att1}
end

function DeactivateSpeedBoost()
    if not getgenv().ELITE_HUB_SpeedActive then return end
    local ch = player.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if hum and getgenv().ELITE_HUB_SpeedOldSpeed then
        hum.WalkSpeed = getgenv().ELITE_HUB_SpeedOldSpeed
    end
    getgenv().ELITE_HUB_SpeedActive = false
    getgenv().ELITE_HUB_SpeedOldSpeed = nil

    local sb = getgenv().ELITE_HUB_SpeedBtn
    if sb then
        sb.Text = "⚡ Speed: OFF"
        sb.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
        sb.TextColor3 = Color3.fromRGB(170, 170, 170)
        sb.Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end

    local parts = getgenv().ELITE_HUB_SpeedTrail
    if parts then
        for _, p in ipairs(parts) do
            if p and p.Parent then p:Destroy() end
        end
        getgenv().ELITE_HUB_SpeedTrail = nil
    end
end

player.CharacterAdded:Connect(function()
    if getgenv().ELITE_HUB_SpeedActive then
        task.wait(0.5)
        DeactivateSpeedBoost()
    end
end)

function ToggleFly()
    nowe = not nowe
    local speaker = game:GetService("Players").LocalPlayer
    local chr = speaker.Character
    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

    updateMiniGuiButtons()

    if nowe then
        for i = 1, speeds do
            task.spawn(function()
                local hb = game:GetService("RunService").Heartbeat
                tpwalking = true
                local chr = game.Players.LocalPlayer.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection)
                    end
                end
            end)
        end

        if chr and chr:FindFirstChild("Animate") then
            chr.Animate.Disabled = true
        end

        if hum then
            for i, v in next, hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end

            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
        end

        if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
            local plr = game.Players.LocalPlayer
            local torso = plr.Character.Torso
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 50
            local speed = 0

            _G.flyCtrl = {f = 0, b = 0, l = 0, r = 0}

            flyBg = Instance.new("BodyGyro", torso)
            flyBg.P = 9e4
            flyBg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyBg.cframe = torso.CFrame

            flyBv = Instance.new("BodyVelocity", torso)
            flyBv.velocity = Vector3.new(0, 0.1, 0)
            flyBv.maxForce = Vector3.new(9e9, 9e9, 9e9)

            if hum then
                hum.PlatformStand = true
            end

            task.spawn(function()
                while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                    game:GetService("RunService").RenderStepped:Wait()

                    if _G.flyCtrl.l + _G.flyCtrl.r ~= 0 or _G.flyCtrl.f + _G.flyCtrl.b ~= 0 then
                        speed = speed + 0.5 + (speed / maxspeed)
                        if speed > maxspeed then
                            speed = maxspeed
                        end
                    elseif not (_G.flyCtrl.l + _G.flyCtrl.r ~= 0 or _G.flyCtrl.f + _G.flyCtrl.b ~= 0) and speed ~= 0 then
                        speed = speed - 1
                        if speed < 0 then
                            speed = 0
                        end
                    end

                    if flyBv then
                        if (_G.flyCtrl.l + _G.flyCtrl.r) ~= 0 or (_G.flyCtrl.f + _G.flyCtrl.b) ~= 0 then
                            flyBv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (_G.flyCtrl.f + _G.flyCtrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(_G.flyCtrl.l + _G.flyCtrl.r, (_G.flyCtrl.f + _G.flyCtrl.b) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
                            lastctrl = {f = _G.flyCtrl.f, b = _G.flyCtrl.b, l = _G.flyCtrl.l, r = _G.flyCtrl.r}
                        elseif (_G.flyCtrl.l + _G.flyCtrl.r) == 0 and (_G.flyCtrl.f + _G.flyCtrl.b) == 0 and speed ~= 0 then
                            flyBv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
                        else
                            flyBv.velocity = Vector3.new(0, 0, 0)
                        end
                    end

                    if flyBg then
                        local spinY = 0
                        if getgenv().ELITE_HUB_SpinBot then
                            spinY = math.rad(getgenv().ELITE_HUB_SpinSpeed * 0.1)
                        end
                        flyBg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((_G.flyCtrl.f + _G.flyCtrl.b) * 50 * speed / maxspeed), spinY, 0)
                    end
                end

                _G.flyCtrl = {f = 0, b = 0, l = 0, r = 0}
                lastctrl = {f = 0, b = 0, l = 0, r = 0}
                speed = 0

                if flyBg then
                    flyBg:Destroy()
                    flyBg = nil
                end

                if flyBv then
                    flyBv:Destroy()
                    flyBv = nil
                end

                if hum then
                    hum.PlatformStand = false
                end

                if chr and chr:FindFirstChild("Animate") then
                    chr.Animate.Disabled = false
                end

                tpwalking = false
            end)
        else
            local plr = game.Players.LocalPlayer
            local UpperTorso = plr.Character.UpperTorso
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 50
            local speed = 0

            _G.flyCtrl = {f = 0, b = 0, l = 0, r = 0}

            flyBg = Instance.new("BodyGyro", UpperTorso)
            flyBg.P = 9e4
            flyBg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyBg.cframe = UpperTorso.CFrame

            flyBv = Instance.new("BodyVelocity", UpperTorso)
            flyBv.velocity = Vector3.new(0, 0.1, 0)
            flyBv.maxForce = Vector3.new(9e9, 9e9, 9e9)

            if hum then
                hum.PlatformStand = true
            end

            task.spawn(function()
                while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                    wait()

                    if _G.flyCtrl.l + _G.flyCtrl.r ~= 0 or _G.flyCtrl.f + _G.flyCtrl.b ~= 0 then
                        speed = speed + 0.5 + (speed / maxspeed)
                        if speed > maxspeed then
                            speed = maxspeed
                        end
                    elseif not (_G.flyCtrl.l + _G.flyCtrl.r ~= 0 or _G.flyCtrl.f + _G.flyCtrl.b ~= 0) and speed ~= 0 then
                        speed = speed - 1
                        if speed < 0 then
                            speed = 0
                        end
                    end

                    if flyBv then
                        if (_G.flyCtrl.l + _G.flyCtrl.r) ~= 0 or (_G.flyCtrl.f + _G.flyCtrl.b) ~= 0 then
                            flyBv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (_G.flyCtrl.f + _G.flyCtrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(_G.flyCtrl.l + _G.flyCtrl.r, (_G.flyCtrl.f + _G.flyCtrl.b) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
                            lastctrl = {f = _G.flyCtrl.f, b = _G.flyCtrl.b, l = _G.flyCtrl.l, r = _G.flyCtrl.r}
                        elseif (_G.flyCtrl.l + _G.flyCtrl.r) == 0 and (_G.flyCtrl.f + _G.flyCtrl.b) == 0 and speed ~= 0 then
                            flyBv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
                        else
                            flyBv.velocity = Vector3.new(0, 0, 0)
                        end
                    end

                    if flyBg then
                        local spinY = 0
                        if getgenv().ELITE_HUB_SpinBot then
                            spinY = math.rad(getgenv().ELITE_HUB_SpinSpeed * 0.1)
                        end
                        flyBg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((_G.flyCtrl.f + _G.flyCtrl.b) * 50 * speed / maxspeed), spinY, 0)
                    end
                end

                _G.flyCtrl = {f = 0, b = 0, l = 0, r = 0}
                lastctrl = {f = 0, b = 0, l = 0, r = 0}
                speed = 0

                if flyBg then
                    flyBg:Destroy()
                    flyBg = nil
                end

                if flyBv then
                    flyBv:Destroy()
                    flyBv = nil
                end

                if hum then
                    hum.PlatformStand = false
                end

                if chr and chr:FindFirstChild("Animate") then
                    chr.Animate.Disabled = false
                end

                tpwalking = false
            end)
        end

        Rayfield:Notify({
            Title = "✅ Fly",
            Content = "Fly  (: " .. speeds .. ")",
            Duration = 3
        })
    else
        tpwalking = false

        if flyBg then
            flyBg:Destroy()
            flyBg = nil
        end

        if flyBv then
            flyBv:Destroy()
            flyBv = nil
        end

        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            hum.PlatformStand = false
        end

        if chr and chr:FindFirstChild("Animate") then
            chr.Animate.Disabled = false
        end

        Rayfield:Notify({
            Title = "✅ Fly",
            Content = "❌ Fly ",
            Duration = 3
        })
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not nowe then return end

    if input.KeyCode == Enum.KeyCode.W then
        _G.flyCtrl.f = 1
    elseif input.KeyCode == Enum.KeyCode.S then
        _G.flyCtrl.b = 1
    elseif input.KeyCode == Enum.KeyCode.A then
        _G.flyCtrl.l = -1
    elseif input.KeyCode == Enum.KeyCode.D then
        _G.flyCtrl.r = 1
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not nowe then return end

    if input.KeyCode == Enum.KeyCode.W then
        _G.flyCtrl.f = 0
    elseif input.KeyCode == Enum.KeyCode.S then
        _G.flyCtrl.b = 0
    elseif input.KeyCode == Enum.KeyCode.A then
        _G.flyCtrl.l = 0
    elseif input.KeyCode == Enum.KeyCode.D then
        _G.flyCtrl.r = 0
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not nowe then return end

    if input.KeyCode == Enum.KeyCode.Space then
        local chr = game.Players.LocalPlayer.Character
        if chr and chr:FindFirstChild("HumanoidRootPart") then
            chr.HumanoidRootPart.CFrame = chr.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
        end
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        local chr = game.Players.LocalPlayer.Character
        if chr and chr:FindFirstChild("HumanoidRootPart") then
            chr.HumanoidRootPart.CFrame = chr.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
        end
    end
end)

function ToggleNoclip()
    noclipActive = not noclipActive
    updateMiniGuiButtons()

    if noclipActive then
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
local player = Players.LocalPlayer

pcall(function()
    if player.Character then
        player.Character:SetAttribute("EliteHubUser", true)
    end
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 3)
        pcall(function() char:SetAttribute("EliteHubUser", true) end)
    end)
end)
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        Rayfield:Notify({
            Title = "✅ Noclip",
            Content = "❌ Noclip ",
            Duration = 3
        })
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local player = Players.LocalPlayer
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        Rayfield:Notify({
            Title = "✅ Noclip",
            Content = "❌ Noclip ",
            Duration = 3
        })
    end
end

updateMiniGuiButtons()

MainTab:CreateButton({
    Name = "  ",
    Callback = function()
        DestroyScript()
    end
})

MainTab:CreateButton({
    Name = "✅ WallHop",
    Callback = function()
        ToggleWallhop()
    end
})

MainTab:CreateButton({
    Name = "✈️ FLY",
    Callback = function()
        ToggleFly()
    end
})

MainTab:CreateButton({
    Name = "✅ Noclip",
    Callback = function()
        ToggleNoclip()
    end
})

MainTab:CreateButton({
    Name = "✅ Fly",
    Callback = function()
        speeds = speeds + 1
        Rayfield:Notify({
            Title = "✅ Fly",
            Content = ": " .. speeds,
            Duration = 2
        })
    end
})

MainTab:CreateButton({
    Name = "✅ Fly",
    Callback = function()
        if speeds > 1 then
            speeds = speeds - 1
            Rayfield:Notify({
                Title = "✅ Fly",
                Content = ": " .. speeds,
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = " ",
                Content = " : 1",
                Duration = 2
            })
        end
    end
})

MainTab:CreateButton({
    Name = "  -",
    Callback = function()
        ToggleMiniMenu()
    end
})

local currentBind = wallhopBindKey.Name
MainTab:CreateInput({
    Name = "✅ WallHop",
    PlaceholderText = ": " .. currentBind,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function()
            return Enum.KeyCode[keyName]
        end)
        if success and keyEnum then
            wallhopBindKey = keyEnum
            Rayfield:Notify({
                Title = "  ",
                Content = " : " .. keyName,
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = " ",
                Content = "  !",
                Duration = 3
            })
        end
    end
})

MainTab:CreateSection("⌨️ FLY / NOCLIP / ESP / AIMBOT")

MainTab:CreateInput({
    Name = "✅ Fly",
    PlaceholderText = ": " .. BindConfig.Fly,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function() return Enum.KeyCode[keyName] end)
        if success and keyEnum then
            BindConfig.Fly = keyName
            Rayfield:Notify({ Title = "✅ Fly", Content = " : " .. keyName, Duration = 2 })
        else
            Rayfield:Notify({ Title = " ", Content = "  !", Duration = 2 })
        end
    end
})

MainTab:CreateInput({
    Name = "✅ Noclip",
    PlaceholderText = ": " .. BindConfig.Noclip,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function() return Enum.KeyCode[keyName] end)
        if success and keyEnum then
            BindConfig.Noclip = keyName
            Rayfield:Notify({ Title = "✅ Noclip", Content = " : " .. keyName, Duration = 2 })
        else
            Rayfield:Notify({ Title = " ", Content = "  !", Duration = 2 })
        end
    end
})

MainTab:CreateInput({
    Name = "  Speed Boost",
    PlaceholderText = ": " .. BindConfig.SpeedBoost,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function() return Enum.KeyCode[keyName] end)
        if success and keyEnum then
            BindConfig.SpeedBoost = keyName
            Rayfield:Notify({ Title = "  Speed Boost", Content = " : " .. keyName, Duration = 2 })
        else
            Rayfield:Notify({ Title = " ", Content = "  !", Duration = 2 })
        end
    end
})

MainTab:CreateInput({
    Name = "  Spin Bot",
    PlaceholderText = ": " .. BindConfig.SpinBot,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function() return Enum.KeyCode[keyName] end)
        if success and keyEnum then
            BindConfig.SpinBot = keyName
            Rayfield:Notify({ Title = "  Spin Bot", Content = " : " .. keyName, Duration = 2 })
        else
            Rayfield:Notify({ Title = " ", Content = "  !", Duration = 2 })
        end
    end
})

--[[
    ==============================
     AIMBOT    
    ==============================
]]--
local AimbotSection = CombatTab:CreateSection("🎯 УЛУЧШЕННЫЙ AIMBOT 3D FOV")
local AimbotConfig = {
    Enabled = false,
    TeamCheck = true,
    AliveCheck = true,
    WallCheck = true,
    FOV = 120,
    ShowFOV = true,
    FOVColor = Color3.fromRGB(170, 0, 255),
    LockedColor = Color3.fromRGB(255, 50, 50),
    TriggerKey = "MouseButton2",
    Toggle = false,
    LockPart = "Head",
    ThirdPersonFix = true,
    Priority = "Distance",
    MaxDistance = 999,
    MinDistance = 0,
    AimOffset = 0,
    FOVThickness = 5,
    FriendCheck = true,
    SpawnCheck = true,
    TeamFilter = true,
    ShowTargetIndicator = true,
    ShowTargetArrow = true,
    ShowTargetHP = true,
    TargetIndicatorSize = 14,
    LockPartIndex = 1,
    TargetCircleColor = Color3.fromRGB(255, 200, 0),
    ShowTargetSkeleton = true,
    TargetSkeletonColor = Color3.fromRGB(255, 200, 0),
    TargetSkeletonThickness = 2,
    TargetSkeletonType = 1,
    AutoShoot = false,
    AutoShootDelay = 0.15,
    ShowAimLine = false,
    AimLineColor = Color3.fromRGB(255, 50, 50),
    ShowTargetNameBig = false,
    Prediction = false,
    PredictionFactor = 0.15,
    AntiAimDetect = false,
    DistanceFOV = false,
    DistanceFOVMin = 60,
    DistanceFOVMax = 200,
    KillNotify = true,
    NotifyLock = true,
    NotifyUnlock = true,
    NotifyAntiAim = true,
    NotifyLowHP = true,
    NotifyShot = false,
    NotifyPlayerJoin = true,
    NotifyPlayerLeave = true,
    NotifyTargetLost = true,
    PersistentLock = true,
    PulseTarget = false,
    PulseColor = Color3.fromRGB(255, 0, 255),
    PulseSize = 8,
    PulseSpeed = 5,
    TargetHealthBarTop = true,
    TargetHealthBarMounted = false,
    IsAiming = false
}

local FOVCircle = NewOverlayCircle()
FOVCircle.Visible = AimbotConfig.ShowFOV
FOVCircle.Radius = AimbotConfig.FOV
FOVCircle.Color = AimbotConfig.FOVColor
FOVCircle.Thickness = 5
FOVCircle.Filled = false
FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
local Running = false
local LockedTarget = nil
local LockedTargetPlayer = nil

local PredictionLastPos = {}
local PredictionLastTime = {}

local PreviousTargetHP = {}

local NotifyCooldown = {}
local NotifyScreenGui = Instance.new("ScreenGui")
NotifyScreenGui.Name = "EliteHubNotify"
NotifyScreenGui.ResetOnSpawn = false
NotifyScreenGui.DisplayOrder = 999
NotifyScreenGui.Parent = player:WaitForChild("PlayerGui")

local NotifyCount = 0
local function SafeNotify(title, content, duration, category)
    if category and AimbotConfig and AimbotConfig["Notify" .. category] == false then return end
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
    frame.Position = UDim2.new(1, 320, 0.8, -70 * (id % 5))
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
        frame.Position = UDim2.new(1, 0, 0.8, -70 * (id % 5))
        local slideIn = tweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -310, 0.8, -70 * (id % 5))
        })
        slideIn:Play()
        slideIn.Completed:Wait()

        local barTween = tweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 3)
        })
        barTween:Play()
        task.wait(duration)

        local fadeOut = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 0, 0.8, -70 * (id % 5)),
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


local SkeletonLinksSimple = {
    {"UpperTorso", "Head"},
    {"UpperTorso", "LowerTorso"},
    {"LowerTorso", "HumanoidRootPart"},
    {"LeftUpperArm", "UpperTorso"},
    {"LeftLowerArm", "LeftUpperArm"},
    {"LeftHand", "LeftLowerArm"},
    {"RightUpperArm", "UpperTorso"},
    {"RightLowerArm", "RightUpperArm"},
    {"RightHand", "RightLowerArm"},
    {"LeftUpperLeg", "LowerTorso"},
    {"LeftLowerLeg", "LeftUpperLeg"},
    {"LeftFoot", "LeftLowerLeg"},
    {"RightUpperLeg", "LowerTorso"},
    {"RightLowerLeg", "RightUpperLeg"},
    {"RightFoot", "RightLowerLeg"},
}

local SkeletonLinksR15 = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
}
local SkeletonLinksR6 = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
    {"Left Leg", "LeftFoot"},
    {"Right Leg", "RightFoot"},
}
local SKELETON_MAX_LINES = 20

local function CreateSkeletonLines()
    local lines = {}
    for _ = 1, SKELETON_MAX_LINES do
        table.insert(lines, NewOverlayLine())
    end
    return lines
end

local function RemoveSkeletonLines(lines)
    if not lines then return end
    for _, l in ipairs(lines) do
        l:Remove()
    end
end

local function GetSkeletonRig(character)
    if not character then return nil end
    if character:FindFirstChild("UpperTorso") then return SkeletonLinksR15 end
    if character:FindFirstChild("Torso") then return SkeletonLinksR6 end
    return nil
end

local function UpdateSkeletonLines(character, lines, color, thickness, skeletonType)
    if not lines then return end
    local links
    if skeletonType == 2 then
        links = GetSkeletonRig(character)
    else
        links = SkeletonLinksSimple
    end
    if not links then
        links = SkeletonLinksSimple
    end

    local camera = workspace.CurrentCamera
    for i = 1, SKELETON_MAX_LINES do
        local line = lines[i]
        local pair = links[i]
        if pair then
            local a = character and character:FindFirstChild(pair[1])
            local b = character and character:FindFirstChild(pair[2])
            local pa = a and a.Position
            local pb = b and b.Position
            if pa and pb then
                local sa, _ = camera:WorldToViewportPoint(pa)
                local sb, _ = camera:WorldToViewportPoint(pb)
                line.From = Vector2.new(sa.X, sa.Y)
                line.To = Vector2.new(sb.X, sb.Y)
                line.Color = color
                line.Thickness = thickness
                line.Visible = true
            else
                line.Visible = false
            end
        elseif line then
            line.Visible = false
        end
    end
end

local TargetIndicatorGui = Instance.new("ScreenGui")
TargetIndicatorGui.Name = "ELITE_HUB_TargetGUI"
TargetIndicatorGui.ResetOnSpawn = false
TargetIndicatorGui.IgnoreGuiInset = true
TargetIndicatorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TargetIndicatorGui.Parent = OverlayGui.Parent

local TargetNameLabel = Instance.new("TextLabel")
TargetNameLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TargetNameLabel.BackgroundTransparency = 1
TargetNameLabel.Size = UDim2.new(0, 320, 0, 26)
TargetNameLabel.AnchorPoint = Vector2.new(0.5, 1)
TargetNameLabel.Text = ""
TargetNameLabel.TextColor3 = AimbotConfig.TargetCircleColor
TargetNameLabel.TextStrokeTransparency = 0
TargetNameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
TargetNameLabel.Font = Enum.Font.SourceSansBold
TargetNameLabel.TextSize = AimbotConfig.TargetIndicatorSize + 2
TargetNameLabel.ZIndex = 60
TargetNameLabel.Visible = false
TargetNameLabel.Parent = TargetIndicatorGui

local TargetArrowLines = { NewOverlayLine(), NewOverlayLine(), NewOverlayLine() }
local TargetArrowLen = 42
local TargetArrowWdt = 20

local TargetCircle = NewOverlayCircle()
TargetCircle.Thickness = 3
TargetCircle.Color = AimbotConfig.TargetCircleColor
TargetCircle.Visible = false
local TargetSkeletonLines = CreateSkeletonLines()

local AimLine = NewOverlayLine()
AimLine.Thickness = 2
AimLine.Color = AimbotConfig.AimLineColor
AimLine.Visible = false

local TargetBigNameLabel = Instance.new("TextLabel")
TargetBigNameLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TargetBigNameLabel.BackgroundTransparency = 1
TargetBigNameLabel.Size = UDim2.new(0, 500, 0, 40)
TargetBigNameLabel.AnchorPoint = Vector2.new(0.5, 0)
TargetBigNameLabel.Position = UDim2.new(0.5, 0, 0.12, 0)
TargetBigNameLabel.Text = ""
TargetBigNameLabel.TextColor3 = AimbotConfig.TargetCircleColor
TargetBigNameLabel.TextStrokeTransparency = 0
TargetBigNameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
TargetBigNameLabel.Font = Enum.Font.SourceSansBold
TargetBigNameLabel.TextSize = 32
TargetBigNameLabel.ZIndex = 61
TargetBigNameLabel.Visible = false
TargetBigNameLabel.Parent = TargetIndicatorGui

local function UpdateTargetIndicator()
    local show = AimbotConfig.Enabled and Running and LockedTarget and LockedTargetPlayer
    if not show then
        TargetNameLabel.Visible = false
        TargetCircle.Visible = false
        AimLine.Visible = false
        TargetBigNameLabel.Visible = false
        for _, l in ipairs(TargetArrowLines) do l.Visible = false end
        for _, l in ipairs(TargetSkeletonLines) do l.Visible = false end
        return
    end

    local camera = workspace.CurrentCamera
    local viewport = camera.ViewportSize
    local screenPos, onScreen = camera:WorldToViewportPoint(LockedTarget.Position)
    local vp = Vector2.new(screenPos.X, screenPos.Y)
    local indicatorPos = Vector2.new(viewport.X / 2, viewport.Y - 120)

    local name = LockedTargetPlayer.Name or "?"
    local hpText = ""
    if AimbotConfig.ShowTargetHP then
        local ch = LockedTargetPlayer.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        hpText = "  |  " .. (hum and math.floor(hum.Health) or "?") .. "/" .. (hum and math.floor(hum.MaxHealth) or "?") .. " HP"
    end
    local dist = 0
    local lroot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if lroot then
        dist = math.floor((LockedTarget.Position - lroot.Position).Magnitude)
    end
    local distText = "  |  " .. dist .. "m"

    if AimbotConfig.ShowTargetIndicator then
        TargetNameLabel.Visible = true
        TargetNameLabel.Position = UDim2.new(0, indicatorPos.X, 0, indicatorPos.Y + 30)
        TargetNameLabel.Text = " " .. name .. hpText .. distText
        TargetNameLabel.TextColor3 = AimbotConfig.TargetCircleColor
    else
        TargetNameLabel.Visible = false
    end

    if AimbotConfig.ShowTargetNameBig then
        TargetBigNameLabel.Visible = true
        TargetBigNameLabel.Text = " " .. name .. hpText .. distText
        TargetBigNameLabel.TextColor3 = AimbotConfig.TargetCircleColor
    else
        TargetBigNameLabel.Visible = false
    end

    if AimbotConfig.ShowAimLine and onScreen and Running and LockedTarget and LockedTargetPlayer then
        local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
        AimLine.From = center
        AimLine.To = vp
        AimLine.Color = AimbotConfig.AimLineColor
        AimLine.Thickness = 2
        AimLine.Visible = true
    else
        AimLine.Visible = false
    end

    if AimbotConfig.ShowTargetArrow and onScreen then
        local dir = (vp - indicatorPos)
        local len = dir.Magnitude
        if len > 0.001 then
            dir = dir / len
            local perp = Vector2.new(-dir.Y, dir.X)
            local tip = vp
            local base = vp - dir * TargetArrowLen
            local left = base - perp * TargetArrowWdt
            local right = base + perp * TargetArrowWdt
            TargetArrowLines[1].From, TargetArrowLines[1].To = tip, base
            TargetArrowLines[2].From, TargetArrowLines[2].To = tip, left
            TargetArrowLines[3].From, TargetArrowLines[3].To = tip, right
            for i = 1, 3 do
                TargetArrowLines[i].Color = AimbotConfig.TargetCircleColor
                TargetArrowLines[i].Thickness = 4
                TargetArrowLines[i].Visible = true
            end
        else
            for _, l in ipairs(TargetArrowLines) do l.Visible = false end
        end
    else
        for _, l in ipairs(TargetArrowLines) do l.Visible = false end
    end

    if onScreen then
        TargetCircle.Visible = true
        TargetCircle.Position = vp
        TargetCircle.Radius = 60
        TargetCircle.Color = AimbotConfig.TargetCircleColor
    else
        TargetCircle.Visible = false
    end

    if AimbotConfig.ShowTargetSkeleton then
        local ch = LockedTargetPlayer.Character
        UpdateSkeletonLines(ch, TargetSkeletonLines, AimbotConfig.TargetSkeletonColor, AimbotConfig.TargetSkeletonThickness, AimbotConfig.TargetSkeletonType)
    else
        for _, l in ipairs(TargetSkeletonLines) do l.Visible = false end
    end
end

local function IsVisible(targetPart)
    if not AimbotConfig.WallCheck then return true end
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignoreList = {}
    if player.Character then table.insert(ignoreList, player.Character) end
    params.FilterDescendantsInstances = ignoreList
    local result = workspace:Raycast(origin, direction, params)
    if not result then return true end
    local hit = result.Instance
    return hit and hit:IsDescendantOf(targetPart.Parent)
end

local function IsFirstPerson()
    if not AimbotConfig.ThirdPersonFix then return false end
    local character = player.Character
    if not character then return false end

    local head = character:FindFirstChild("Head")
    if not head then return false end

    local camera = workspace.CurrentCamera
    local distance = (head.Position - camera.CFrame.Position).Magnitude
    return distance < 2
end

getgenv().ELITE_HUB_FRIENDS = getgenv().ELITE_HUB_FRIENDS or {}
getgenv().ELITE_HUB_TARGET_NAME = getgenv().ELITE_HUB_TARGET_NAME or ""

local function IsFriendName(name)
    name = tostring(name or "")
    for _, f in ipairs(getgenv().ELITE_HUB_FRIENDS) do
        if tostring(f):lower() == name:lower() then return true end
    end
    return false
end

local function IsFriend(targetPlayer)
    if not targetPlayer then return false end
    return IsFriendName(targetPlayer.Name)
end

local function GetTargetPlayer()
    local targetName = tostring(getgenv().ELITE_HUB_TARGET_NAME or "")
    if targetName == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == targetName:lower() then return p end
    end
    return nil
end

getgenv().ELITE_HUB_FRIEND_TEAMS = getgenv().ELITE_HUB_FRIEND_TEAMS or {}

local function GetTeamName(p)
    if not p then return nil end
    local t = p.Team
    if t and t.Name and t.Name ~= "" then return tostring(t.Name) end
    local tc = p.TeamColor
    if tc and tc.Name and tc.Name ~= "Institutional white" then
        if tc.Name ~= "White" and tc.Name ~= "Really black" then
            return tostring(tc.Name)
        end
    end
    return nil
end

local function IsFriendlyTeamName(teamName)
    teamName = tostring(teamName or "")
    if teamName == "" then return false end
    for _, tn in ipairs(getgenv().ELITE_HUB_FRIEND_TEAMS) do
        if tostring(tn):lower() == teamName:lower() then return true end
    end
    return false
end

local function IsFriendlyTeam(p)
    if not p then return false end
    if p == player then return true end
    return IsFriendlyTeamName(GetTeamName(p))
end

local function IsSameTeam(p)
    if not p then return false end
    local my = GetTeamName(player)
    local theirs = GetTeamName(p)
    if my and theirs then return my:lower() == theirs:lower() end
    return false
end

local function GetTeamRelation(p)
    if not p then return "none" end
    if p == player then return "my" end
    local tn = GetTeamName(p)
    if not tn then return "none" end
    if IsSameTeam(p) then return "my" end
    if IsFriendlyTeamName(tn) then return "friend" end
    return "enemy"
end

local function GetAllTeamNames()
    local seen = {}
    local res = {}
    local my = GetTeamName(player)
    if my then
        seen[my:lower()] = true
        table.insert(res, my)
    end
    for _, p in ipairs(Players:GetPlayers()) do
        local tn = GetTeamName(p)
        if tn then
            local key = tn:lower()
            if not seen[key] then
                seen[key] = true
                table.insert(res, tn)
            end
        end
    end
    table.sort(res)
    return res
end

local function ToggleFriendTeam(teamName)
    teamName = tostring(teamName or "")
    if teamName == "" then return end
    local list = getgenv().ELITE_HUB_FRIEND_TEAMS
    for i = #list, 1, -1 do
        if tostring(list[i]):lower() == teamName:lower() then
            table.remove(list, i)
            return "removed"
        end
    end
    table.insert(list, teamName)
    return "added"
end

local function GetLockPart(character)
    if not character then return nil end
    local preferred = AimbotConfig.LockPart or "Head"
    local pref = character:FindFirstChild(preferred)
    if pref and IsVisible(pref) then
        return pref
    end
    local head = character:FindFirstChild("Head")
    if head and IsVisible(head) then
        return head
    end
    for _, partName in ipairs({"HumanoidRootPart", "UpperTorso", "LowerTorso"}) do
        local part = character:FindFirstChild(partName)
        if part and IsVisible(part) then
            return part
        end
    end
    return head or character:FindFirstChild(preferred) or character:FindFirstChild("HumanoidRootPart")
end

local function TargetIsValid(targetPlayer)
    if not targetPlayer then return false end
    local character = targetPlayer.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if AimbotConfig.AliveCheck and (not humanoid or humanoid.Health <= 0) then return false end
    if AimbotConfig.SpawnCheck and character:FindFirstChildOfClass("ForceField") then return false end
    local targetPart = GetLockPart(character)
    if not targetPart then return false end
    local camera = workspace.CurrentCamera
    local gameDistance = (targetPart.Position - camera.CFrame.Position).Magnitude
    if gameDistance > AimbotConfig.MaxDistance or gameDistance < AimbotConfig.MinDistance then return false end
    if AimbotConfig.PersistentLock and targetPlayer == LockedTargetPlayer then
        if IsVisible(targetPart) then
            local sPos, sOn = camera:WorldToViewportPoint(targetPart.Position)
            if sOn then
                return true, targetPart
            end
        end
        return false
    end
    if not IsVisible(targetPart) then return false end
    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return false end
    return true, targetPart
end

local function GetClosestPlayer()
    if not AimbotConfig.Enabled then return nil end

    local camera = workspace.CurrentCamera
    local localPlayer = player
    local cameraPos = camera.CFrame.Position
    local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    if LockedTargetPlayer then
        local ok, part = TargetIsValid(LockedTargetPlayer)
        if ok and part then
            return part
        end
        LockedTargetPlayer = nil --   /    -> 
    end

    local prioPlayer = GetTargetPlayer()
    if prioPlayer then
        local prioPart = GetLockPart(prioPlayer.Character)
        if prioPart then
            local ok = TargetIsValid(prioPlayer)
            if ok then
                LockedTargetPlayer = prioPlayer
                return prioPart
            end
        end
    end

    local bestTarget = nil
    local bestTargetPlayer = nil
    local bestScore = math.huge
    local bestHealth = math.huge

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        local skip = false
        if targetPlayer == localPlayer then skip = true end
        if not skip and not targetPlayer.Character then skip = true end
        if not skip and AimbotConfig.TeamCheck and targetPlayer.Team == localPlayer.Team then skip = true end
        if not skip and AimbotConfig.FriendCheck and IsFriend(targetPlayer) then skip = true end
        if not skip and AimbotConfig.TeamFilter and (IsFriendlyTeam(targetPlayer) or IsSameTeam(targetPlayer)) then skip = true end

        if not skip then
            local character = targetPlayer.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local targetPart = GetLockPart(character)

            if AimbotConfig.AliveCheck and (not humanoid or humanoid.Health <= 0) then skip = true end
            if not skip and AimbotConfig.SpawnCheck and character:FindFirstChildOfClass("ForceField") then skip = true end
            if not skip and not targetPart then skip = true end

            if not skip then
                local gameDistance = (targetPart.Position - cameraPos).Magnitude
                if gameDistance > AimbotConfig.MaxDistance then skip = true end
                if not skip and gameDistance < AimbotConfig.MinDistance then skip = true end

                if not skip then
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                        local screenDistance = (screenPoint - mousePos).Magnitude
                        if screenDistance <= AimbotConfig.FOV and IsVisible(targetPart) then
                            local hp = humanoid and humanoid.Health or 999
                            local score
                            if AimbotConfig.Priority == "Health" then
                                score = hp * 0.01 + screenDistance * 0.001
                            else
                                score = gameDistance
                            end
                            if score < bestScore then
                                bestScore = score
                                bestHealth = hp
                                bestTarget = targetPart
                                bestTargetPlayer = targetPlayer
                            end
                        end
                    end
                end
            end
        end
    end

    if bestTarget and bestTargetPlayer then
        LockedTargetPlayer = bestTargetPlayer
        return bestTarget
    end

    return nil
end

task.spawn(function()
    Log("🎯 AIMBOT", "  ")
    while task.wait() do
        pcall(function()
            local camera = workspace.CurrentCamera
            local camPos = camera.CFrame.Position

            local currentFOV = AimbotConfig.FOV
            if AimbotConfig.DistanceFOV and LockedTargetPlayer then
                local ch = LockedTargetPlayer.Character
                local rp = ch and ch:FindFirstChild("HumanoidRootPart")
                if rp then
                    local dist = (rp.Position - camPos).Magnitude
                    local pct = math.clamp(dist / 200, 0, 1)
                    currentFOV = AimbotConfig.DistanceFOVMin + (AimbotConfig.DistanceFOVMax - AimbotConfig.DistanceFOVMin) * pct
                end
            end

            if FOVCircle then
                FOVCircle.Visible = AimbotConfig.ShowFOV and AimbotConfig.Enabled
                FOVCircle.Radius = currentFOV
                FOVCircle.Color = LockedTarget and AimbotConfig.LockedColor or AimbotConfig.FOVColor
                FOVCircle.Thickness = AimbotConfig.FOVThickness or 5
                FOVCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            end
            
            if Running and AimbotConfig.Enabled then
                local target = GetClosestPlayer()
                if target then
                    local isNewTarget = LockedTargetPlayer ~= nil and LockedTargetPlayer ~= LockedTargetPlayer
                    if LockedTarget == nil then
                        SafeNotify("🎯 LOCK", LockedTargetPlayer.Name, 1.5, "🎯 LOCK")
                    end
                    LockedTarget = target
                    local targetPosition = target.Position + Vector3.new(0, AimbotConfig.AimOffset, 0)

                    if AimbotConfig.Prediction and LockedTargetPlayer then
                        local now = tick()
                        local prevPos = PredictionLastPos[LockedTargetPlayer]
                        local prevTime = PredictionLastTime[LockedTargetPlayer]
                        if prevPos and prevTime then
                            local dt = now - prevTime
                            if dt > 0 and dt < 0.5 then
                                local velocity = (target.Position - prevPos) / dt
                                targetPosition = targetPosition + velocity * AimbotConfig.PredictionFactor
                            end
                        end
                        PredictionLastPos[LockedTargetPlayer] = target.Position
                        PredictionLastTime[LockedTargetPlayer] = now
                    end

                    local currentCF = camera.CFrame
                    local newCF = CFrame.new(currentCF.Position, targetPosition)
                    camera.CFrame = newCF

                    if AimbotConfig.AntiAimDetect and LockedTargetPlayer then
                        local ch = LockedTargetPlayer.Character
                        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local lookDir = hrp.CFrame.LookVector
                            local toCamera = (camPos - hrp.Position).Unit
                            local dot = lookDir:Dot(toCamera)
                            if dot < -0.3 then
                                SafeNotify("🧠 ANTI-AIM", LockedTargetPlayer.Name .. "  !", 2, "AntiAim")
                            end
                        end
                    end

                    if LockedTargetPlayer then
                        local ch = LockedTargetPlayer.Character
                        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 and hum.Health < 30 then
                            SafeNotify("💥 LOW HP", LockedTargetPlayer.Name .. "  " .. math.floor(hum.Health) .. " HP!", 1, "LowHP")
                        end
                    end

                    if AimbotConfig.KillNotify and LockedTargetPlayer then
                        local ch = LockedTargetPlayer.Character
                        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local oldHP = PreviousTargetHP[LockedTargetPlayer]
                            if oldHP and oldHP > 0 and hum.Health <= 0 then
                                SafeNotify("💀 KILL", LockedTargetPlayer.Name .. " !", 2, "💀 KILL")
                            end
                            PreviousTargetHP[LockedTargetPlayer] = hum.Health
                        end
                    end

                    if AimbotConfig.AutoShoot then
                        local screenPos2, onScreen2 = camera:WorldToViewportPoint(target.Position)
                        if onScreen2 then
                            local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                            local screenDist = (Vector2.new(screenPos2.X, screenPos2.Y) - screenCenter).Magnitude
                            if screenDist < 30 then
                                SafeNotify("🔫 SHOT", LockedTargetPlayer.Name, 0.5, "🔫 SHOT")
                                task.delay(AimbotConfig.AutoShootDelay, function()
                                    pcall(function()
                                        local vup = game:GetService("VirtualUser")
                                        vup:Button1Down(Vector2.new(0, 0))
                                        task.wait(0.05)
                                        vup:Button1Up(Vector2.new(0, 0))
                                    end)
                                end)
                            end
                        end
                    end
                else
                    if LockedTargetPlayer then
                        SafeNotify("❌ UNLOCK", " ", 1.5, "❌ UNLOCK")
                        PredictionLastPos[LockedTargetPlayer] = nil
                        PredictionLastTime[LockedTargetPlayer] = nil
                        PreviousTargetHP[LockedTargetPlayer] = nil
                    end
                    LockedTarget = nil
                    LockedTargetPlayer = nil
                end
            else
                LockedTarget = nil
                LockedTargetPlayer = nil
            end
            UpdateTargetIndicator()
        end)
    end
end)

local function TriggerMatches(input)
    local key = AimbotConfig.TriggerKey
    local okMouse, mouseType = pcall(function() return Enum.UserInputType[key] end)
    if okMouse and mouseType and input.UserInputType == mouseType then
        return true
    end
    local okKey, keyCode = pcall(function() return Enum.KeyCode[key] end)
    if okKey and keyCode and input.KeyCode == keyCode then
        return true
    end
    return false
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if TriggerMatches(input) then
        if AimbotConfig.Toggle then
            Running = not Running
        else
            Running = true
        end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if not AimbotConfig.Toggle and TriggerMatches(input) then
        Running = false
    end
end)

CombatTab:CreateToggle({
    Name = "🎯 AIMBOT",
    CurrentValue = AimbotConfig.Enabled,
    Flag = "AimbotEnabled",
    Callback = function(value)
        AimbotConfig.Enabled = value
        Log("🎯 AIMBOT", "Aimbot : " .. tostring(value))
        if value then
            if FOVCircle then FOVCircle.Visible = true end
            Rayfield:Notify({
                Title = "🎯 AIMBOT",
                Content = "   ",
                Duration = 3
            })
        else
            if FOVCircle then FOVCircle.Visible = false end
            Running = false
            LockedTarget = nil
            Rayfield:Notify({
                Title = "🎯 AIMBOT",
                Content = "- ",
                Duration = 2
            })
        end
    end
})

CombatTab:CreateToggle({
    Name = "  ",
    CurrentValue = AimbotConfig.TeamCheck,
    Callback = function(value)
        AimbotConfig.TeamCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "   ",
    CurrentValue = AimbotConfig.AliveCheck,
    Callback = function(value)
        AimbotConfig.AliveCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "    ",
    CurrentValue = AimbotConfig.WallCheck,
    Callback = function(value)
        AimbotConfig.WallCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "  1- ",
    CurrentValue = AimbotConfig.ThirdPersonFix,
    Callback = function(value)
        AimbotConfig.ThirdPersonFix = value
    end
})

CombatTab:CreateDropdown({
    Name = "  ",
    Options = {"Distance", "FOV", "Health"},
    CurrentOption = AimbotConfig.Priority,
    Callback = function(option)
        AimbotConfig.Priority = option
        if option == "Distance" then
            Rayfield:Notify({
                Title = " : ",
                Content = "   ",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = " : FOV",
                Content = "    ",
                Duration = 3
            })
        end
    end
})

CombatTab:CreateSlider({
    Name = "🎯 Размер FOV",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = AimbotConfig.FOV,
    Callback = function(value)
        AimbotConfig.FOV = value
    end
})

CombatTab:CreateColorPicker({
    Name = "🎯 Размер FOV",
    Color = AimbotConfig.FOVColor,
    Callback = function(value)
        AimbotConfig.FOVColor = value
    end
})

CombatTab:CreateColorPicker({
    Name = "  ",
    Color = AimbotConfig.LockedColor,
    Callback = function(value)
        AimbotConfig.LockedColor = value
    end
})

CombatTab:CreateSection("⚙️ .  AIMBOT")

CombatTab:CreateToggle({
    Name = "🎯 Радиус FOV",
    CurrentValue = AimbotConfig.ShowFOV,
    Flag = "AimbotShowFOV",
    Callback = function(value)
        AimbotConfig.ShowFOV = value
        if FOVCircle then FOVCircle.Visible = value and AimbotConfig.Enabled end
    end
})

CombatTab:CreateToggle({
    Name = " :  / ",
    CurrentValue = AimbotConfig.Toggle,
    Flag = "AimbotToggle",
    Callback = function(value)
        AimbotConfig.Toggle = value
        if not value then
            Running = false
        end
    end
})

CombatTab:CreateDropdown({
    Name = "  ",
    Options = {"MouseButton2", "MouseButton1", "LeftControl", "X", "C", "F", "V", "Shift"},
    CurrentOption = AimbotConfig.TriggerKey,
    Callback = function(option)
        AimbotConfig.TriggerKey = option
        Rayfield:Notify({
            Title = "  ",
            Content = " : " .. option,
            Duration = 2
        })
    end
})

CombatTab:CreateSlider({
    Name = " .   (studs)",
    Range = {10, 1000},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = AimbotConfig.MaxDistance,
    Callback = function(value)
        AimbotConfig.MaxDistance = value
    end
})

CombatTab:CreateSlider({
    Name = " .   (studs)",
    Range = {0, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = AimbotConfig.MinDistance,
    Callback = function(value)
        AimbotConfig.MinDistance = value
    end
})

CombatTab:CreateSlider({
    Name = "    Y",
    Range = {-3, 3},
    Increment = 0.1,
    Suffix = " studs",
    CurrentValue = AimbotConfig.AimOffset,
    Callback = function(value)
        AimbotConfig.AimOffset = value
    end
})

CombatTab:CreateSlider({
    Name = "🎯 Радиус FOV",
    Range = {1, 10},
    Increment = 1,
    Suffix = " px",
    CurrentValue = AimbotConfig.FOVThickness,
    Callback = function(value)
        AimbotConfig.FOVThickness = value
    end
})

CombatTab:CreateSlider({
    Name = "   FOV",
    Range = {1, 400},
    Increment = 1,
    Suffix = " px",
    CurrentValue = AimbotConfig.FOV,
    Callback = function(value)
        AimbotConfig.FOV = value
    end
})

CombatTab:CreateDropdown({
    Name = "    ",
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},
    CurrentOption = AimbotConfig.LockPart,
    Callback = function(option)
        AimbotConfig.LockPart = option
    end
})

CombatTab:CreateSection("  ")

CombatTab:CreateToggle({
    Name = "    HP ",
    CurrentValue = AimbotConfig.ShowTargetIndicator,
    Callback = function(value)
        AimbotConfig.ShowTargetIndicator = value
    end
})

CombatTab:CreateToggle({
    Name = "    ",
    CurrentValue = AimbotConfig.ShowTargetArrow,
    Callback = function(value)
        AimbotConfig.ShowTargetArrow = value
    end
})

CombatTab:CreateToggle({
    Name = "  HP ",
    CurrentValue = AimbotConfig.ShowTargetHP,
    Callback = function(value)
        AimbotConfig.ShowTargetHP = value
    end
})

CombatTab:CreateSlider({
    Name = "   ",
    Range = {10, 24},
    Increment = 1,
    Suffix = " pt",
    CurrentValue = AimbotConfig.TargetIndicatorSize,
    Callback = function(value)
        AimbotConfig.TargetIndicatorSize = value
        TargetNameLabel.TextSize = value + 2
    end
})

CombatTab:CreateColorPicker({
    Name = "   ",
    Color = AimbotConfig.TargetCircleColor,
    Callback = function(value)
        AimbotConfig.TargetCircleColor = value
    end
})

CombatTab:CreateToggle({
    Name = "   ",
    CurrentValue = AimbotConfig.ShowTargetSkeleton,
    Callback = function(value)
        AimbotConfig.ShowTargetSkeleton = value
    end
})

CombatTab:CreateColorPicker({
    Name = "   ",
    Color = AimbotConfig.TargetSkeletonColor,
    Callback = function(value)
        AimbotConfig.TargetSkeletonColor = value
    end
})

CombatTab:CreateSlider({
    Name = "   ",
    Range = {1, 4},
    Increment = 1,
    CurrentValue = AimbotConfig.TargetSkeletonThickness,
    Callback = function(value)
        AimbotConfig.TargetSkeletonThickness = value
    end
})

CombatTab:CreateDropdown({
    Name = "   ",
    Options = {"1 - ", "2 - "},
    CurrentOption = "1 - ",
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        if v == "2 - " then
            AimbotConfig.TargetSkeletonType = 2
        else
            AimbotConfig.TargetSkeletonType = 1
        end
    end
})

CombatTab:CreateSection("🔫 АВТОСТРЕЛЬБА -")

CombatTab:CreateToggle({
    Name = " -",
    CurrentValue = AimbotConfig.AutoShoot,
    Callback = function(value)
        AimbotConfig.AutoShoot = value
    end
})

CombatTab:CreateSlider({
    Name = "   ()",
    Range = {0.05, 0.5},
    Increment = 0.05,
    Suffix = " sec",
    CurrentValue = AimbotConfig.AutoShootDelay,
    Callback = function(value)
        AimbotConfig.AutoShootDelay = value
    end
})

CombatTab:CreateSection("🎯 ВИЗУАЛИЗАЦИЯ ")

CombatTab:CreateToggle({
    Name = " -  ",
    CurrentValue = AimbotConfig.ShowAimLine,
    Callback = function(value)
        AimbotConfig.ShowAimLine = value
    end
})

CombatTab:CreateColorPicker({
    Name = "  -",
    Color = AimbotConfig.AimLineColor,
    Callback = function(value)
        AimbotConfig.AimLineColor = value
    end
})

CombatTab:CreateToggle({
    Name = "    ( )",
    CurrentValue = AimbotConfig.ShowTargetNameBig,
    Callback = function(value)
        AimbotConfig.ShowTargetNameBig = value
    end
})

CombatTab:CreateSection("🎯 ПРИОРИТЕТ ")

CombatTab:CreateDropdown({
    Name = "   ",
    Options = {"Distance", "Health"},
    CurrentOption = "Distance",
    Callback = function(value)
        AimbotConfig.AimPriority = value
    end
})

CombatTab:CreateSection("🎯 ИНДИКАТОРЫ ЦЕЛИ")

CombatTab:CreateToggle({
    Name = "  ",
    CurrentValue = AimbotConfig.Prediction,
    Callback = function(value)
        AimbotConfig.Prediction = value
    end
})

CombatTab:CreateSlider({
    Name = "  ",
    Range = {0.05, 0.5},
    Increment = 0.05,
    Suffix = "x",
    CurrentValue = AimbotConfig.PredictionFactor,
    Callback = function(value)
        AimbotConfig.PredictionFactor = value
    end
})

CombatTab:CreateSection("🛡️ ЗАЩИТА ОТ -")

CombatTab:CreateToggle({
    Name = "🧠 Anti-Aim Detection",
    CurrentValue = AimbotConfig.AntiAimDetect,
    Callback = function(value)
        AimbotConfig.AntiAimDetect = value
    end
})

CombatTab:CreateSection("🎯 РАССТОЯНИЕ  FOV")

CombatTab:CreateToggle({
    Name = " -FOV  ",
    CurrentValue = AimbotConfig.DistanceFOV,
    Callback = function(value)
        AimbotConfig.DistanceFOV = value
    end
})

CombatTab:CreateSlider({
    Name = " . FOV ()",
    Range = {30, 100},
    Increment = 5,
    Suffix = "",
    CurrentValue = AimbotConfig.DistanceFOVMin,
    Callback = function(value)
        AimbotConfig.DistanceFOVMin = value
    end
})

CombatTab:CreateSlider({
    Name = " . FOV ()",
    Range = {100, 400},
    Increment = 10,
    Suffix = "",
    CurrentValue = AimbotConfig.DistanceFOVMax,
    Callback = function(value)
        AimbotConfig.DistanceFOVMax = value
    end
})

CombatTab:CreateSection("🎯 AIMBOT")

CombatTab:CreateToggle({
    Name = "💀 Kill Notify",
    CurrentValue = AimbotConfig.KillNotify,
    Callback = function(value)
        AimbotConfig.KillNotify = value
    end
})

CombatTab:CreateToggle({
    Name = " Lock Notify ( )",
    CurrentValue = AimbotConfig.NotifyLock,
    Callback = function(value)
        AimbotConfig.NotifyLock = value
    end
})

CombatTab:CreateToggle({
    Name = " Unlock Notify ( )",
    CurrentValue = AimbotConfig.NotifyUnlock,
    Callback = function(value)
        AimbotConfig.NotifyUnlock = value
    end
})

CombatTab:CreateToggle({
    Name = "🧠 Anti-Aim Detect Notify",
    CurrentValue = AimbotConfig.NotifyAntiAim,
    Callback = function(value)
        AimbotConfig.NotifyAntiAim = value
    end
})

CombatTab:CreateToggle({
    Name = " Low HP Notify ( < 30 HP)",
    CurrentValue = AimbotConfig.NotifyLowHP,
    Callback = function(value)
        AimbotConfig.NotifyLowHP = value
    end
})

CombatTab:CreateToggle({
    Name = " Auto-Shot Notify ()",
    CurrentValue = AimbotConfig.NotifyShot,
    Callback = function(value)
        AimbotConfig.NotifyShot = value
    end
})

CombatTab:CreateToggle({
    Name = "👋 Player Join Notify",
    CurrentValue = AimbotConfig.NotifyPlayerJoin,
    Callback = function(value)
        AimbotConfig.NotifyPlayerJoin = value
    end
})

CombatTab:CreateToggle({
    Name = "👋 Player Leave Notify",
    CurrentValue = AimbotConfig.NotifyPlayerLeave,
    Callback = function(value)
        AimbotConfig.NotifyPlayerLeave = value
    end
})

CombatTab:CreateToggle({
    Name = "❌ Target Left Server Notify",
    CurrentValue = AimbotConfig.NotifyTargetLost,
    Callback = function(value)
        AimbotConfig.NotifyTargetLost = value
    end
})

CombatTab:CreateSection("🔒 ПОСТОЯННАЯ ЗАЛОЖКА ")

CombatTab:CreateToggle({
    Name = " Persistent Lock ( )",
    CurrentValue = AimbotConfig.PersistentLock,
    Callback = function(value)
        AimbotConfig.PersistentLock = value
    end
})

CombatTab:CreateSection("👥 КОМАНДЫ ( / )")

local myTeamLabel = CombatTab:CreateLabel("  : ")
local function UpdateMyTeamLabel()
    local tn = GetTeamName(player)
    pcall(function()
        myTeamLabel:Set("  : " .. (tn or ""))
    end)
end

local teamDD = nil
local selectedTeam = ""
local function RefreshTeamDD()
    if not teamDD then return end
    local opts = GetAllTeamNames()
    pcall(function() teamDD:Refresh(opts) end)
    UpdateMyTeamLabel()
end

teamDD = CombatTab:CreateDropdown({
    Name = " ",
    Options = GetAllTeamNames(),
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        selectedTeam = n or ""
    end
})

task.delay(0.5, UpdateMyTeamLabel)
pcall(function()
    if player and player.TeamChanged and player.TeamChanged.Connect then
        player.TeamChanged:Connect(function()
            UpdateMyTeamLabel()
        end)
    end
end)
UpdateMyTeamLabel()

task.spawn(function()
    while true do
        task.wait(1)
        UpdateMyTeamLabel()
    end
end)

CombatTab:CreateToggle({
    Name = "     ",
    CurrentValue = AimbotConfig.TeamFilter,
    Flag = "AimbotTeamFilter",
    Callback = function(value)
        AimbotConfig.TeamFilter = value
    end
})

CombatTab:CreateButton({
    Name = "    ",
    Callback = function()
        local n = selectedTeam
        if not n or n == "" then
            Rayfield:Notify({ Title = " ", Content = "    ", Duration = 2 })
            return
        end
        local res = ToggleFriendTeam(n)
        if res == "added" then
            Rayfield:Notify({ Title = " -", Content = n .. "   ", Duration = 2 })
        else
            Rayfield:Notify({ Title = " ", Content = n .. "    ()", Duration = 2 })
        end
        pcall(RefreshTeamDD)
        pcall(UpdateESP)
    end
})

CombatTab:CreateButton({
    Name = "      ()",
    Callback = function()
        local n = selectedTeam
        if not n or n == "" then
            Rayfield:Notify({ Title = " ", Content = "    ", Duration = 2 })
            return
        end
        local list = getgenv().ELITE_HUB_FRIEND_TEAMS
        for i = #list, 1, -1 do
            if tostring(list[i]):lower() == n:lower() then
                table.remove(list, i)
            end
        end
        Rayfield:Notify({ Title = " -", Content = n .. "  ", Duration = 2 })
        pcall(RefreshTeamDD)
        pcall(UpdateESP)
    end
})

CombatTab:CreateButton({
    Name = "  ",
    Callback = function()
        local list = getgenv().ELITE_HUB_FRIEND_TEAMS
        if #list == 0 then
            Rayfield:Notify({ Title = " ", Content = "   ( )", Duration = 2 })
        else
            Rayfield:Notify({ Title = " ", Content = table.concat(list, ", "), Duration = 5 })
        end
    end
})

CombatTab:CreateButton({
    Name = "    ",
    Callback = function()
        getgenv().ELITE_HUB_FRIEND_TEAMS = {}
        Rayfield:Notify({ Title = " ", Content = "   ", Duration = 2 })
        pcall(RefreshTeamDD)
        pcall(UpdateESP)
    end
})

CombatTab:CreateButton({
    Name = "   ",
    Callback = function()
        pcall(RefreshTeamDD)
        Rayfield:Notify({ Title = " ", Content = "  ", Duration = 2 })
    end
})

CombatTab:CreateSection("👥 УПРАВЛЕНИЕ ДРУЗЬЯМИ    (  )")

local friendAddDD = nil
local friendRmDD = nil
local friendTargetDD = nil

local function RefreshAimbotDD()
    if friendAddDD then
        local opts = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and not IsFriend(p) then table.insert(opts, p.Name) end
        end
        table.sort(opts)
        pcall(function() friendAddDD:Refresh(opts) end)
    end
    if friendRmDD then
        local opts = {}
        for _, n in ipairs(getgenv().ELITE_HUB_FRIENDS) do table.insert(opts, tostring(n)) end
        table.sort(opts)
        pcall(function() friendRmDD:Refresh(opts) end)
    end
    if friendTargetDD then
        local opts = {"()"}
        local playersList = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then table.insert(playersList, p.Name) end
        end
        table.sort(playersList)
        for _, n in ipairs(playersList) do table.insert(opts, n) end
        pcall(function() friendTargetDD:Refresh(opts) end)
    end
end

CombatTab:CreateToggle({
    Name = "    ",
    CurrentValue = AimbotConfig.FriendCheck,
    Flag = "AimbotFriendCheck",
    Callback = function(value)
        AimbotConfig.FriendCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "     ()",
    CurrentValue = AimbotConfig.SpawnCheck,
    Flag = "AimbotSpawnCheck",
    Callback = function(value)
        AimbotConfig.SpawnCheck = value
    end
})

friendAddDD = CombatTab:CreateDropdown({
    Name = "    ",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        if not n or n == "" then return end
        if IsFriendName(n) then
            Rayfield:Notify({ Title = " ", Content = n .. "   ", Duration = 2 })
        else
            table.insert(getgenv().ELITE_HUB_FRIENDS, n)
            Rayfield:Notify({ Title = "  ", Content = n, Duration = 2 })
        end
        if friendAddDD then pcall(function() friendAddDD:Clear() end) end
        RefreshAimbotDD()
    end
})

friendRmDD = CombatTab:CreateDropdown({
    Name = "   ()",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        if not n or n == "" then return end
        local list = getgenv().ELITE_HUB_FRIENDS
        for i = #list, 1, -1 do
            if tostring(list[i]):lower() == n:lower() then
                table.remove(list, i)
                Rayfield:Notify({ Title = "  ", Content = n, Duration = 2 })
                break
            end
        end
        if friendRmDD then pcall(function() friendRmDD:Clear() end) end
        RefreshAimbotDD()
    end
})

CombatTab:CreateButton({
    Name = "   ",
    Callback = function()
        local cnt = #getgenv().ELITE_HUB_FRIENDS
        getgenv().ELITE_HUB_FRIENDS = {}
        Rayfield:Notify({ Title = " ", Content = " : " .. cnt, Duration = 2 })
        RefreshAimbotDD()
    end
})

CombatTab:CreateButton({
    Name = "   ",
    Callback = function()
        local list = getgenv().ELITE_HUB_FRIENDS
        if #list == 0 then
            Rayfield:Notify({ Title = " ", Content = " ", Duration = 2 })
            return
        end
        Rayfield:Notify({ Title = "  ", Content = table.concat(list, ", "), Duration = 6 })
    end
})

friendTargetDD = CombatTab:CreateDropdown({
    Name = "   ( )",
    Options = {"()"},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        if n == "()" or n == nil or n == "" then
            getgenv().ELITE_HUB_TARGET_NAME = ""
            Rayfield:Notify({ Title = " ", Content = " ( )", Duration = 2 })
        else
            getgenv().ELITE_HUB_TARGET_NAME = n
            Rayfield:Notify({ Title = "  ", Content = n, Duration = 2 })
        end
    end
})

task.spawn(function()
    while true do
        task.wait(4)
        RefreshAimbotDD()
    end
end)
Players.PlayerAdded:Connect(RefreshAimbotDD)
Players.PlayerRemoving:Connect(RefreshAimbotDD)
task.delay(1, RefreshAimbotDD)

--[[
    ==============================
     ESP  3D BOX
    ==============================
]]--
local ESPConfig = {
    Enabled = false,
    TeamCheck = true,
    ShowTeammates = true,
    Boxes = true,
    Names = true,
    Health = true,
    Distance = true,
    Tracers = true,
    TracersForTeammates = false,
    ShowDead = true,
    Box3DEnabled = true,
    Box3DFilled = false,
    UpdateFrequency = 0.016,
    EnemyColor = Color3.fromRGB(255, 50, 50),
    TeammateColor = Color3.fromRGB(50, 255, 50),
    OutlineColor = Color3.fromRGB(255, 255, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    TracerColor = Color3.fromRGB(255, 50, 255),
    Box3DColor = Color3.fromRGB(0, 255, 0),
    DeadColor = Color3.fromRGB(255, 0, 0),
    TextSize = 14,
    FillTransparency = 0.5,
    TracerThickness = 3,
    Box3DThickness = 3,
    Box3DSize = 3.0,
    FriendCheck = false,
    FriendColor = Color3.fromRGB(0, 170, 255),
    HighlightTarget = false,
    ShowArrows = true,
    ArrowsColor = Color3.fromRGB(255, 255, 255),
    ESPOutlineColor = Color3.fromRGB(0, 0, 0),
    SmoothArrows = true,
    SnapLines = false,
    SnapLinesColor = Color3.fromRGB(0, 255, 255),
    HighlightLockTarget = true,
    LockTargetColor = Color3.fromRGB(255, 200, 0),
    Skeletons = true,
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    SkeletonThickness = 2,
    SkeletonType = 1,
    HeadDots = false,
    HeadDotColor = Color3.fromRGB(255, 0, 0),
    HeadDotSize = 6,
    ShowScriptUserTag = true,
    ScriptUserTagColor = Color3.fromRGB(200, 100, 255),
    ShowHealthBar = false,
    HealthBarColor = Color3.fromRGB(0, 255, 0),
    HealthBarWidth = 4,
    HealthBarHeight = 40,
    HighlightClosest = false,
    HighlightClosestColor = Color3.fromRGB(255, 0, 0),
    ChamsEnabled = false,
    ChamsFillColor = Color3.fromRGB(170, 0, 255),
    ChamsFillTransparency = 0.7,
    ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
    ChamsOutlineTransparency = 0,
    ChamsMaterial = Enum.Material.ForceField,
    ChamsTeamCheck = false,
    ChamsSelf = false,
    ChamsTeammates = false,
    Crosshair = false,
    CrosshairColor = Color3.fromRGB(0, 255, 255),
    CrosshairSize = 12,
    CrosshairThickness = 2,
    CrosshairSpread = false,
    LowHPWarning = false,
    LowHPThreshold = 30,
    LowHPColor = Color3.fromRGB(255, 0, 0)
}

local ESPObjects = {}
local TracerLines = {}
local Box3DObjects = {}
local ESPArrows = {}
local ESPSkeletons = {}
local ESPHeadDots = {}
local ESPHealthBars = {}

local function CreateESPArrow(targetPlayer)
    if ESPArrows[targetPlayer] then return end
    local lines = { NewOverlayLine(), NewOverlayLine(), NewOverlayLine() }
    for _, l in ipairs(lines) do
        l.Color = ESPConfig.ArrowsColor
        l.Thickness = 3
        l.Visible = false
    end
    ESPArrows[targetPlayer] = lines
end

local function DestroyESPArrow(targetPlayer)
    local lines = ESPArrows[targetPlayer]
    if lines then
        for _, l in ipairs(lines) do
            l:Remove()
        end
        ESPArrows[targetPlayer] = nil
    end
end

local function UpdateESPArrows()
    if not ESPConfig.ShowArrows then
        for _, lines in pairs(ESPArrows) do
            for _, l in ipairs(lines) do l.Visible = false end
        end
        return
    end
    local camera = workspace.CurrentCamera
    local viewport = camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
    local margin = 40
    local length = 28
    local width = 14

    for targetPlayer, lines in pairs(ESPArrows) do
        local show = false
        local char = targetPlayer.Character
        if char and targetPlayer ~= player then
            local pos = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
            if pos then
                local screenPos, onScreen = camera:WorldToViewportPoint(pos.Position)
                if not onScreen then
                    local sv = Vector2.new(screenPos.X, screenPos.Y) - center
                    if sv.Magnitude > 1 then
                        sv = sv / sv.Magnitude
                        local clamped = center + sv * (math.min((viewport.X / 2) - margin, viewport.Y / 2 - margin))
                        local base = clamped - sv * length
                        local perp = Vector2.new(-sv.Y, sv.X)
                        local left = base - perp * width
                        local right = base + perp * width
                        lines[1].From = clamped; lines[1].To = base
                        lines[2].From = clamped; lines[2].To = left
                        lines[3].From = clamped; lines[3].To = right

                        local arrowColor = ESPConfig.ArrowsColor
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        local isDead = humanoid and humanoid.Health <= 0
                        if isDead then
                            arrowColor = ESPConfig.DeadColor
                        else
                            local teamRel = GetTeamRelation(targetPlayer)
                            local isFriend = IsFriend(targetPlayer)
                            local isLockTarget = ESPConfig.HighlightLockTarget and LockedTargetPlayer == targetPlayer
                            if isLockTarget then
                                arrowColor = ESPConfig.LockTargetColor
                            elseif teamRel == "my" then
                                arrowColor = ESPConfig.TeammateColor
                            elseif teamRel == "friend" or isFriend then
                                arrowColor = ESPConfig.FriendColor
                            elseif teamRel == "enemy" then
                                arrowColor = ESPConfig.EnemyColor
                            end
                        end

                        for _, l in ipairs(lines) do
                            l.Color = arrowColor
                            l.Thickness = 3
                            l.Visible = true
                        end
                        show = true
                    end
                end
            end
        end
        if not show then
            for _, l in ipairs(lines) do l.Visible = false end
        end
    end
end

local ESPContentSnapLines = {}

local function CreateSnapLine(targetPlayer)
    if ESPContentSnapLines[targetPlayer] then return end
    ESPContentSnapLines[targetPlayer] = NewOverlayLine()
end

local function DestroySnapLine(targetPlayer)
    local line = ESPContentSnapLines[targetPlayer]
    if line then
        line:Remove()
        ESPContentSnapLines[targetPlayer] = nil
    end
end

local function UpdateSnapLines()
    if not ESPConfig.SnapLines then
        for _, line in pairs(ESPContentSnapLines) do
            if line then line.Visible = false end
        end
        return
    end
    local camera = workspace.CurrentCamera
    local viewport = camera.ViewportSize
    local from = Vector2.new(viewport.X / 2, viewport.Y + 20)

    for targetPlayer, line in pairs(ESPContentSnapLines) do
        if not (line and targetPlayer and targetPlayer.Character) then
            if line then line.Visible = false end
        else
            local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Head")
            if root then
                local sp, _ = camera:WorldToViewportPoint(root.Position)
                line.From = from
                line.To = Vector2.new(sp.X, sp.Y)
                line.Color = ESPConfig.SnapLinesColor
                line.Thickness = 2
                line.Visible = true
            else
                line.Visible = false
            end
        end
    end
end
local function IsTeammate(targetPlayer)
    if not player.Team or not targetPlayer.Team then return false end
    return player.Team == targetPlayer.Team
end

local function CreatePlayerSkeleton(targetPlayer)
    if ESPSkeletons[targetPlayer] then return end
    ESPSkeletons[targetPlayer] = CreateSkeletonLines()
end

local function DestroyPlayerSkeleton(targetPlayer)
    local lines = ESPSkeletons[targetPlayer]
    if lines then
        RemoveSkeletonLines(lines)
        ESPSkeletons[targetPlayer] = nil
    end
end

local function UpdateESPSkeletons()
    if not ESPConfig.Skeletons then
        for _, lines in pairs(ESPSkeletons) do
            for _, l in ipairs(lines) do l.Visible = false end
        end
        return
    end
    local lockTarget = (AimbotConfig.Enabled and LockedTargetPlayer) or nil
    for targetPlayer, lines in pairs(ESPSkeletons) do
        local showThis = (targetPlayer == lockTarget)
        local char = targetPlayer and targetPlayer.Character
        if not showThis or not char then
            for _, l in ipairs(lines) do l.Visible = false end
        else
            UpdateSkeletonLines(char, lines, AimbotConfig.LockedColor, ESPConfig.SkeletonThickness, ESPConfig.SkeletonType)
        end
    end
end

local function CreateHeadDot(targetPlayer)
    if ESPHeadDots[targetPlayer] then return end
    local dot = NewOverlayCircle()
    dot.Thickness = 0
    dot.Filled = true
    dot.Visible = false
    ESPHeadDots[targetPlayer] = dot
end

local function DestroyHeadDot(targetPlayer)
    local dot = ESPHeadDots[targetPlayer]
    if dot then
        dot:Remove()
        ESPHeadDots[targetPlayer] = nil
    end
end

local function UpdateHeadDots()
    if not ESPConfig.HeadDots then
        for _, dot in pairs(ESPHeadDots) do dot.Visible = false end
        return
    end
    local camera = workspace.CurrentCamera
    for targetPlayer, dot in pairs(ESPHeadDots) do
        local char = targetPlayer and targetPlayer.Character
        local head = char and char:FindFirstChild("Head")
        if head then
            local sp, onScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            if onScreen then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local isDead = humanoid and humanoid.Health <= 0
                if isDead and not ESPConfig.ShowDead then
                    dot.Visible = false
                else
                    dot.Position = Vector2.new(sp.X, sp.Y)
                    dot.Radius = ESPConfig.HeadDotSize
                    dot.Color = ESPConfig.HeadDotColor
                    dot.Visible = true
                end
            else
                dot.Visible = false
            end
        else
            dot.Visible = false
        end
    end
end

local function CreateHealthBar(targetPlayer)
    if ESPHealthBars[targetPlayer] then return end
    local bg = NewOverlayLine()
    bg.Thickness = ESPConfig.HealthBarWidth
    bg.Color = Color3.new(0, 0, 0)
    bg.Visible = false
    local fg = NewOverlayLine()
    fg.Thickness = ESPConfig.HealthBarWidth
    fg.Visible = false
    ESPHealthBars[targetPlayer] = {bg = bg, fg = fg}
end

local function DestroyHealthBar(targetPlayer)
    local bars = ESPHealthBars[targetPlayer]
    if bars then
        bars.bg:Remove()
        bars.fg:Remove()
        ESPHealthBars[targetPlayer] = nil
    end
end

local function UpdateHealthBars()
    if not ESPConfig.ShowHealthBar then
        for _, bars in pairs(ESPHealthBars) do
            bars.bg.Visible = false
            bars.fg.Visible = false
        end
        return
    end
    local camera = workspace.CurrentCamera
    local w = ESPConfig.HealthBarWidth
    for targetPlayer, bars in pairs(ESPHealthBars) do
        local char = targetPlayer and targetPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if root and head and humanoid then
            local topPos = head.Position + Vector3.new(0, 1, 0)
            local botPos = root.Position - Vector3.new(0, 2.5, 0)
            local spTop, visTop = camera:WorldToViewportPoint(topPos)
            local spBot, visBot = camera:WorldToViewportPoint(botPos)
            if visTop and visBot then
                local barX = spTop.X - 20
                local barTopY = spTop.Y
                local barBotY = spBot.Y
                local barH = barBotY - barTopY
                bars.bg.From = Vector2.new(barX, barTopY)
                bars.bg.To = Vector2.new(barX, barBotY)
                bars.bg.Thickness = w
                bars.bg.Color = Color3.new(0.2, 0.2, 0.2)
                bars.bg.Visible = true
                local maxHP = humanoid.MaxHealth
                if maxHP <= 0 then maxHP = 100 end
                local hpPct = math.clamp(humanoid.Health / maxHP, 0, 1)
                local hpH = barH * hpPct
                local hpColor = ESPConfig.HealthBarColor
                if humanoid.Health <= 0 then
                    hpH = 0
                end
                bars.fg.From = Vector2.new(barX, barBotY)
                bars.fg.To = Vector2.new(barX, barBotY - hpH)
                bars.fg.Thickness = w
                bars.fg.Color = hpColor
                bars.fg.Visible = hpH > 0
            else
                bars.bg.Visible = false
                bars.fg.Visible = false
            end
        else
            bars.bg.Visible = false
            bars.fg.Visible = false
        end
    end
end

local function ClearPlayerESP(targetPlayer)
    if ESPObjects[targetPlayer] then
        if ESPObjects[targetPlayer].Highlight then
            ESPObjects[targetPlayer].Highlight:Destroy()
        end
        if ESPObjects[targetPlayer].Billboard then
            ESPObjects[targetPlayer].Billboard:Destroy()
        end
        if ESPObjects[targetPlayer].ScriptTag then
            ESPObjects[targetPlayer].ScriptTag:Destroy()
        end
        ESPObjects[targetPlayer] = nil
    end

    if TracerLines[targetPlayer] then
        TracerLines[targetPlayer]:Remove()
        TracerLines[targetPlayer] = nil
    end

    if Box3DObjects[targetPlayer] then
        for _, line in ipairs(Box3DObjects[targetPlayer]) do
            if line then
                line:Remove()
            end
        end
        Box3DObjects[targetPlayer] = nil
    end

    DestroyESPArrow(targetPlayer)
    DestroySnapLine(targetPlayer)
    DestroyPlayerSkeleton(targetPlayer)
    DestroyHeadDot(targetPlayer)
    DestroyHealthBar(targetPlayer)
end

local function CreatePlayerESP(targetPlayer)
    if targetPlayer == player then return end
    if IsTeammate(targetPlayer) and not ESPConfig.ShowTeammates then return end
    if ESPConfig.FriendCheck and IsFriend(targetPlayer) then return end

    ClearPlayerESP(targetPlayer)

    local character = targetPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    local espGroup = {}
    local isTeammate = IsTeammate(targetPlayer)
    local isFriend = IsFriend(targetPlayer)
    local isTarget = ESPConfig.HighlightTarget and GetTargetPlayer() == targetPlayer
    local teamRel = GetTeamRelation(targetPlayer)
    local fillColor
    if isTarget then
        fillColor = ESPConfig.FriendColor
    elseif teamRel == "my" then
        fillColor = ESPConfig.TeammateColor
    elseif teamRel == "friend" or (isFriend and teamRel ~= "enemy") then
        fillColor = ESPConfig.FriendColor
    elseif teamRel == "enemy" then
        fillColor = ESPConfig.EnemyColor
    else
        fillColor = isTeammate and ESPConfig.TeammateColor or ESPConfig.EnemyColor
    end

    if ESPConfig.Boxes and rootPart then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = fillColor
        highlight.OutlineColor = ESPConfig.OutlineColor
        highlight.FillTransparency = ESPConfig.FillTransparency
        highlight.Adornee = character
        highlight.Parent = character
        espGroup.Highlight = highlight
    end

    if (ESPConfig.Names or ESPConfig.Health or ESPConfig.Distance) and rootPart then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_" .. targetPlayer.Name
        billboard.AlwaysOnTop = true
        billboard.ExtentsOffset = Vector3.new(0, 3, 0)
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.Adornee = rootPart
        billboard.Parent = rootPart
        local textLabel = Instance.new("TextLabel")
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.TextColor3 = fillColor
        textLabel.TextSize = ESPConfig.TextSize
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.Parent = billboard
        espGroup.Billboard = billboard
        espGroup.TextLabel = textLabel
    end

    if ESPConfig.ShowScriptUserTag and rootPart then
        local isScriptUser = targetPlayer:GetAttribute("EliteHubUser")
        if isScriptUser then
            local tagBillboard = Instance.new("BillboardGui")
            tagBillboard.Name = "EliteTag_" .. targetPlayer.Name
            tagBillboard.AlwaysOnTop = true
            tagBillboard.ExtentsOffset = Vector3.new(0, 4.5, 0)
            tagBillboard.Size = UDim2.new(0, 160, 0, 22)
            tagBillboard.Adornee = rootPart
            tagBillboard.Parent = rootPart

            local tagBg = Instance.new("Frame")
            tagBg.Size = UDim2.new(1, 0, 1, 0)
            tagBg.BackgroundColor3 = Color3.fromRGB(140, 50, 220)
            tagBg.BackgroundTransparency = 0.15
            tagBg.BorderSizePixel = 0
            tagBg.Parent = tagBillboard
            local tagCorner = Instance.new("UICorner")
            tagCorner.CornerRadius = UDim.new(0, 6)
            tagCorner.Parent = tagBg

            local tagLabel = Instance.new("TextLabel")
            tagLabel.BackgroundTransparency = 1
            tagLabel.Size = UDim2.new(1, 0, 1, 0)
            tagLabel.Text = "ELITE HUB"
            tagLabel.TextColor3 = ESPConfig.ScriptUserTagColor
            tagLabel.TextSize = 12
            tagLabel.Font = Enum.Font.GothamBold
            tagLabel.TextStrokeTransparency = 0
            tagLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            tagLabel.Parent = tagBg

            espGroup.ScriptTag = tagBillboard
            espGroup.ScriptTagLabel = tagLabel
            espGroup.ScriptTagBg = tagBg
        end
    end

    if ESPConfig.Tracers and (not isTeammate or ESPConfig.TracersForTeammates) then
        local tracer = NewOverlayLine()
        tracer.Visible = false
        tracer.Color = isTeammate and ESPConfig.TeammateColor or ESPConfig.TracerColor
        tracer.Thickness = ESPConfig.TracerThickness
        TracerLines[targetPlayer] = tracer
    end

    if ESPConfig.Box3DEnabled then
        local boxLines = {}
        for i = 1, 12 do
            local line = NewOverlayLine()
            line.Visible = false
            line.Color = ESPConfig.Box3DColor
            line.Thickness = ESPConfig.Box3DThickness
            table.insert(boxLines, line)
        end
        Box3DObjects[targetPlayer] = boxLines
    end

    ESPObjects[targetPlayer] = espGroup
        CreateESPArrow(targetPlayer)
        CreateSnapLine(targetPlayer)
        CreatePlayerSkeleton(targetPlayer)
        CreateHeadDot(targetPlayer)
        CreateHealthBar(targetPlayer)

    if character then
        character.AncestryChanged:Connect(function(_, parent)
            if not parent then ClearPlayerESP(targetPlayer) end
        end)
    end

    if humanoid then
        humanoid.Died:Connect(function()
            if not ESPConfig.ShowDead then
                ClearPlayerESP(targetPlayer)
            end
        end)
    end
end

local function UpdateESPText()
    local cachedTarget = GetTargetPlayer()
    for targetPlayer, espGroup in pairs(ESPObjects) do
        if espGroup.TextLabel and targetPlayer.Character then
            local character = targetPlayer.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")

            if rootPart and espGroup.Billboard and espGroup.Billboard.Parent then
                local isDead = humanoid and humanoid.Health <= 0
                local isTeammate = IsTeammate(targetPlayer)
                local text = ""

                if ESPConfig.Names then
                    text = text .. targetPlayer.Name .. (isDead and " " or "") .. "\n"
                end

                if not isDead or ESPConfig.ShowDead then
                    if ESPConfig.Health and humanoid then
                        text = text .. (isDead and " \n" or " " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. "\n")
                    end

                    if ESPConfig.Distance and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local localRoot = player.Character.HumanoidRootPart
                        if localRoot then
                            local distance = (localRoot.Position - rootPart.Position).Magnitude
                            text = text .. " " .. math.floor(distance) .. "m"
                        end
                    end
                end

                local isFriend = IsFriend(targetPlayer)
                local isTarget = ESPConfig.HighlightTarget and cachedTarget == targetPlayer
                local isLockTarget = ESPConfig.HighlightLockTarget and LockedTargetPlayer == targetPlayer
                local teamRel = GetTeamRelation(targetPlayer)
                local fillColor
                if isLockTarget then
                    fillColor = ESPConfig.LockTargetColor
                elseif isTarget then
                    fillColor = ESPConfig.FriendColor
                elseif teamRel == "my" then
                    fillColor = ESPConfig.TeammateColor
                elseif teamRel == "friend" or (isFriend and teamRel ~= "enemy") then
                    fillColor = ESPConfig.FriendColor
                elseif teamRel == "enemy" then
                    fillColor = ESPConfig.EnemyColor
                else
                    fillColor = isTeammate and ESPConfig.TeammateColor or ESPConfig.EnemyColor
                end
                if isDead then
                    espGroup.TextLabel.TextColor3 = ESPConfig.DeadColor
                    if espGroup.Highlight then
                        espGroup.Highlight.FillColor = ESPConfig.DeadColor
                    end
                else
                    espGroup.TextLabel.TextColor3 = fillColor
                    if espGroup.Highlight then
                        espGroup.Highlight.FillColor = fillColor
                    end
                end

                espGroup.TextLabel.Text = text
            end
        end
    end
end

local function UpdateTracers()
    if not ESPConfig.Enabled or not ESPConfig.Tracers then return end

    local camera = workspace.CurrentCamera
    local tracerCount = 0

    for targetPlayer, tracer in pairs(TracerLines) do
        pcall(function()
            if not (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")) then
                tracer.Visible = false
                return
            end
            local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = targetPlayer.Character.HumanoidRootPart
            local isDead = humanoid and humanoid.Health <= 0
            local isTeammate = IsTeammate(targetPlayer)

            if isDead and not ESPConfig.ShowDead then
                tracer.Visible = false
                return
            end

            local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)

            if onScreen then
                tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                tracer.Visible = true
                tracer.Color = isTeammate and ESPConfig.TeammateColor or ESPConfig.TracerColor
                tracerCount = tracerCount + 1
            else
                tracer.Visible = false
            end
        end)
    end
end

local function UpdateBox3DESP()
    if not ESPConfig.Enabled or not ESPConfig.Box3DEnabled then return end

    local camera = workspace.CurrentCamera
    local boxCount = 0

    for targetPlayer, lines in pairs(Box3DObjects) do
        pcall(function()
            local ok = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not ok then
                for _, line in ipairs(lines) do line.Visible = false end
                return
            end

            local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = targetPlayer.Character.HumanoidRootPart
            local head = targetPlayer.Character:FindFirstChild("Head")

            if not humanoid or not rootPart or not head then
                for _, line in ipairs(lines) do line.Visible = false end
                return
            end

            local isDead = humanoid.Health <= 0
            if isDead and not ESPConfig.ShowDead then
                for _, line in ipairs(lines) do line.Visible = false end
                return
            end

            local size = Vector3.new(3, 5, 3) * ESPConfig.Box3DSize
            local corners = {
                rootPart.Position + Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
                rootPart.Position + Vector3.new(size.X/2, -size.Y/2, -size.Z/2),
                rootPart.Position + Vector3.new(size.X/2, size.Y/2, -size.Z/2),
                rootPart.Position + Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
                rootPart.Position + Vector3.new(-size.X/2, -size.Y/2, size.Z/2),
                rootPart.Position + Vector3.new(size.X/2, -size.Y/2, size.Z/2),
                rootPart.Position + Vector3.new(size.X/2, size.Y/2, size.Z/2),
                rootPart.Position + Vector3.new(-size.X/2, size.Y/2, size.Z/2)
            }

            local screenCorners = {}
            local allVisible = true

            for i, corner in ipairs(corners) do
                local screenPos, visible = camera:WorldToViewportPoint(corner)
                screenCorners[i] = Vector2.new(screenPos.X, screenPos.Y)
                if not visible then allVisible = false end
            end

            if not allVisible then
                for _, line in ipairs(lines) do line.Visible = false end
                return
            end

            local connections = {
                {1, 2}, {2, 3}, {3, 4}, {4, 1}, --  
                {5, 6}, {6, 7}, {7, 8}, {8, 5}, --  
                {1, 5}, {2, 6}, {3, 7}, {4, 8}  --  
            }

            for i, connection in ipairs(connections) do
                if lines[i] then
                    lines[i].From = screenCorners[connection[1]]
                    lines[i].To = screenCorners[connection[2]]
                    lines[i].Visible = true
                    lines[i].Color = isDead and ESPConfig.DeadColor or ESPConfig.Box3DColor
                    lines[i].Thickness = ESPConfig.Box3DThickness
                end
            end
            boxCount = boxCount + 1
        end)
    end
end

getgenv().ELITE_HUB_LastChars = getgenv().ELITE_HUB_LastChars or {}

local function UpdateESP()
    for targetPlayer, _ in pairs(ESPObjects) do
        ClearPlayerESP(targetPlayer)
    end

    if not ESPConfig.Enabled then return end
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            CreatePlayerESP(targetPlayer)
        end
    end
end

local function RefreshESPOnRespawn()
    if not ESPConfig.Enabled then return end
    local players = Players:GetPlayers()
    local LK = getgenv().ELITE_HUB_LastChars
    for _, targetPlayer in ipairs(players) do
        if targetPlayer ~= player then
            local char = targetPlayer.Character
            local lastChar = LK[targetPlayer]
            if char ~= lastChar then
                LK[targetPlayer] = char
                CreatePlayerESP(targetPlayer)
            end
        end
    end
    for targetPlayer, _ in pairs(ESPObjects) do
        if not Players:FindFirstChild(targetPlayer.Name) then
            ClearPlayerESP(targetPlayer)
            LK[targetPlayer] = nil
        end
    end
end

local function InitializeESPHandlers()
    local LK = getgenv().ELITE_HUB_LastChars
    game.Players.PlayerAdded:Connect(function(targetPlayer)
        SafeNotify("👋 JOIN", targetPlayer.Name .. "   ", 2, "PlayerJoin")
        LK[targetPlayer] = targetPlayer.Character
        if ESPConfig.Enabled then
            CreatePlayerESP(targetPlayer)
        end
        targetPlayer.CharacterAdded:Connect(function()
            LK[targetPlayer] = targetPlayer.Character
            if ESPConfig.Enabled then
                CreatePlayerESP(targetPlayer)
            end
        end)
    end)

    game.Players.PlayerRemoving:Connect(function(targetPlayer)
        SafeNotify("👋 LEFT", targetPlayer.Name .. "   ", 2, "PlayerLeave")
        if targetPlayer == LockedTargetPlayer then
            SafeNotify("❌ UNLOCK", "   ", 2, "TargetLost")
            LockedTarget = nil
            LockedTargetPlayer = nil
        end
        ClearPlayerESP(targetPlayer)
        LK[targetPlayer] = nil
    end)
end

InitializeESPHandlers()
getgenv().ELITE_HUB_ESP_Timer = getgenv().ELITE_HUB_ESP_Timer or 0
RunService.RenderStepped:Connect(function(dt)
    getgenv().ELITE_HUB_ESP_Timer = getgenv().ELITE_HUB_ESP_Timer + (dt or 0.016)
    if ESPConfig.Enabled then
        if getgenv().ELITE_HUB_ESP_Timer >= 0.5 then
            getgenv().ELITE_HUB_ESP_Timer = 0
            pcall(RefreshESPOnRespawn)
        end
        pcall(UpdateESPText)
        pcall(UpdateTracers)
        pcall(UpdateESPArrows)
        pcall(UpdateSnapLines)
        pcall(UpdateESPSkeletons)
        pcall(UpdateHeadDots)
        pcall(UpdateHealthBars)
        if ESPConfig.Box3DEnabled then
            pcall(UpdateBox3DESP)
        end
    end
end)

task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local chamHighlights = {}
    local origMats = {}

    local function SaveOriginals(plr)
        local ch = plr.Character
        if not ch then return end
        origMats[plr] = {}
        for _, part in ipairs(ch:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                origMats[plr][part] = part.Material
            end
        end
    end

    local function RestoreOriginals(plr)
        if origMats[plr] then
            for part, mat in pairs(origMats[plr]) do
                if part and part.Parent then
                    pcall(function() part.Material = mat end)
                end
            end
            origMats[plr] = nil
        end
    end

    local function ApplyCham(plr)
        local ch = plr.Character
        if not ch then return end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if hum.Health <= 0 then
            if chamHighlights[plr] then
                chamHighlights[plr]:Destroy()
                chamHighlights[plr] = nil
            end
            RestoreOriginals(plr)
            return
        end

        local show = false
        if ESPConfig.ChamsEnabled then
            if plr == player then
                show = ESPConfig.ChamsSelf
            else
                local isTeam = IsTeammate(plr)
                if ESPConfig.ChamsTeamCheck and isTeam then
                    show = false
                elseif isTeam then
                    show = ESPConfig.ChamsTeammates
                else
                    show = true
                end
            end
        end

        if not show then
            if chamHighlights[plr] then
                chamHighlights[plr]:Destroy()
                chamHighlights[plr] = nil
            end
            RestoreOriginals(plr)
            return
        end

        if not origMats[plr] then
            SaveOriginals(plr)
        end

        local hl = chamHighlights[plr]
        if not hl or not hl.Parent then
            hl = Instance.new("Highlight")
            hl.Name = "EliteChamHighlight"
            hl.Adornee = ch
            hl.Parent = ch
            chamHighlights[plr] = hl
        end
        hl.FillColor = ESPConfig.ChamsFillColor
        hl.FillTransparency = ESPConfig.ChamsFillTransparency
        hl.OutlineColor = ESPConfig.ChamsOutlineColor
        hl.OutlineTransparency = ESPConfig.ChamsOutlineTransparency
        hl.Enabled = true
        hl.Adornee = ch

        local mat = ESPConfig.ChamsMaterial
        if mat then
            for _, part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    pcall(function() part.Material = mat end)
                end
            end
        end
    end

    Players.PlayerRemoving:Connect(function(plr)
        if chamHighlights[plr] then
            chamHighlights[plr]:Destroy()
            chamHighlights[plr] = nil
        end
        RestoreOriginals(plr)
    end)

    RunService.RenderStepped:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            pcall(ApplyCham, plr)
        end
    end)
end)

ESPTab:CreateToggle({
    Name = " / ESP",
    CurrentValue = ESPConfig.Enabled,
    Callback = function(value)
        ESPConfig.Enabled = value
        if value then
            ESPConfig.Boxes = true
            ESPConfig.Names = true
            ESPConfig.Health = true
            ESPConfig.Distance = true
            ESPConfig.Tracers = true
            
            UpdateESP()
            Rayfield:Notify({
                Title = "👁️ ESP",
                Content = "👁️ ESP",
                Duration = 3
            })
        else
            for targetPlayer, _ in pairs(ESPObjects) do
                ClearPlayerESP(targetPlayer)
            end
            Rayfield:Notify({
                Title = "👁️ ESP",
                Content = "👁️ ESP",
                Duration = 2
            })
        end
    end
})

ESPTab:CreateToggle({
    Name = "  ",
    CurrentValue = ESPConfig.TeamCheck,
    Callback = function(value)
        ESPConfig.TeamCheck = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "  ",
    CurrentValue = ESPConfig.ShowTeammates,
    Callback = function(value)
        ESPConfig.ShowTeammates = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " ",
    CurrentValue = ESPConfig.Boxes,
    Callback = function(value)
        ESPConfig.Boxes = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " ",
    CurrentValue = ESPConfig.Names,
    Callback = function(value)
        ESPConfig.Names = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " ",
    CurrentValue = ESPConfig.Health,
    Callback = function(value)
        ESPConfig.Health = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " ",
    CurrentValue = ESPConfig.Distance,
    Callback = function(value)
        ESPConfig.Distance = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " ",
    CurrentValue = ESPConfig.Tracers,
    Callback = function(value)
        ESPConfig.Tracers = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "   ",
    CurrentValue = ESPConfig.TracersForTeammates,
    Callback = function(value)
        ESPConfig.TracersForTeammates = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "  ",
    CurrentValue = ESPConfig.ShowDead,
    Callback = function(value)
        ESPConfig.ShowDead = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "🎯 3D Box ESP",
    CurrentValue = ESPConfig.Box3DEnabled,
    Callback = function(value)
        ESPConfig.Box3DEnabled = value
        if not value then
            for targetPlayer, lines in pairs(Box3DObjects) do
                for _, line in ipairs(lines) do
                    line:Remove()
                end
            end
            Box3DObjects = {}
        else
            UpdateESP()
        end
    end
})

ESPTab:CreateColorPicker({
    Name = "  ",
    Color = ESPConfig.EnemyColor,
    Callback = function(value)
        ESPConfig.EnemyColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "  ",
    Color = ESPConfig.TeammateColor,
    Callback = function(value)
        ESPConfig.TeammateColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "  ",
    Color = ESPConfig.DeadColor,
    Callback = function(value)
        ESPConfig.DeadColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "📦 3D Box",
    Color = ESPConfig.Box3DColor,
    Callback = function(value)
        ESPConfig.Box3DColor = value
        for targetPlayer, lines in pairs(Box3DObjects) do
            for _, line in ipairs(lines) do
                line.Color = value
            end
        end
    end
})

ESPTab:CreateSlider({
    Name = "  ",
    Range = {8, 24},
    Increment = 1,
    Suffix = "px",
    CurrentValue = ESPConfig.TextSize,
    Callback = function(value)
        ESPConfig.TextSize = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = " ",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = ESPConfig.FillTransparency,
    Callback = function(value)
        ESPConfig.FillTransparency = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = "  ",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = ESPConfig.TracerThickness,
    Callback = function(value)
        ESPConfig.TracerThickness = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = "📦 3D Box",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = ESPConfig.Box3DThickness,
    Callback = function(value)
        ESPConfig.Box3DThickness = value
        for targetPlayer, lines in pairs(Box3DObjects) do
            for _, line in ipairs(lines) do
                line.Thickness = value
            end
        end
    end
})

ESPTab:CreateSlider({
    Name = "📦 3D Box",
    Range = {0.5, 5.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = ESPConfig.Box3DSize,
    Callback = function(value)
        ESPConfig.Box3DSize = value
    end
})

ESPTab:CreateLabel(" :  (0.05 )")

ESPTab:CreateSlider({
    Name = "   ",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.FillTransparency,
    Callback = function(value)
        ESPConfig.FillTransparency = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = "  3D Box ()",
    Range = {0.5, 8.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = ESPConfig.Box3DSize,
    Callback = function(value)
        ESPConfig.Box3DSize = value
    end
})

ESPTab:CreateSection("👁️ ОСНОВНЫЕ (  )")

ESPTab:CreateToggle({
    Name = "      ",
    CurrentValue = ESPConfig.ShowArrows,
    Callback = function(value)
        ESPConfig.ShowArrows = value
    end
})

ESPTab:CreateColorPicker({
    Name = "  ",
    Color = ESPConfig.ArrowsColor,
    Callback = function(value)
        ESPConfig.ArrowsColor = value
        for _, lines in pairs(ESPArrows) do
            for _, l in ipairs(lines) do l.Color = value end
        end
    end
})

ESPTab:CreateSection("📏 РАЗМЕРЫ    ")

ESPTab:CreateColorPicker({
    Name = "  ",
    Color = ESPConfig.TextColor,
    Callback = function(value)
        ESPConfig.TextColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "   ()",
    Color = ESPConfig.TracerColor,
    Callback = function(value)
        ESPConfig.TracerColor = value
        for targetPlayer, tracer in pairs(TracerLines) do
            tracer.Color = value
        end
    end
})

ESPTab:CreateSection("👻 СТЕНЫ - (wallhack)")

ESPTab:CreateToggle({
    Name = "  -  ",
    CurrentValue = ESPConfig.SnapLines,
    Callback = function(value)
        ESPConfig.SnapLines = value
    end
})

ESPTab:CreateColorPicker({
    Name = "  -",
    Color = ESPConfig.SnapLinesColor,
    Callback = function(value)
        ESPConfig.SnapLinesColor = value
        for _, line in pairs(ESPContentSnapLines) do
            if line then line.Color = value end
        end
    end
})

ESPTab:CreateSection("🎯 AIMBOT")

ESPTab:CreateToggle({
    Name = "🎯 AIMBOT",
    CurrentValue = ESPConfig.HighlightLockTarget,
    Callback = function(value)
        ESPConfig.HighlightLockTarget = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🎯 AIMBOT",
    Color = ESPConfig.LockTargetColor,
    Callback = function(value)
        ESPConfig.LockTargetColor = value
    end
})

ESPTab:CreateSection("🎯 HP ")

ESPTab:CreateToggle({
    Name = "   ",
    CurrentValue = ESPConfig.Skeletons,
    Callback = function(value)
        ESPConfig.Skeletons = value
    end
})

ESPTab:CreateColorPicker({
    Name = "  ",
    Color = ESPConfig.SkeletonColor,
    Callback = function(value)
        ESPConfig.SkeletonColor = value
    end
})

ESPTab:CreateSlider({
    Name = "  ",
    Range = {1, 4},
    Increment = 1,
    CurrentValue = ESPConfig.SkeletonThickness,
    Callback = function(value)
        ESPConfig.SkeletonThickness = value
    end
})

ESPTab:CreateDropdown({
    Name = "  ",
    Options = {"1 - ", "2 - "},
    CurrentOption = "1 - ",
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        if v == "2 - " then
            ESPConfig.SkeletonType = 2
        else
            ESPConfig.SkeletonType = 1
        end
    end
})

ESPTab:CreateSection("📦 3D BOX ")

ESPTab:CreateToggle({
    Name = "   ",
    CurrentValue = ESPConfig.HeadDots,
    Callback = function(value)
        ESPConfig.HeadDots = value
    end
})

ESPTab:CreateColorPicker({
    Name = "    ",
    Color = ESPConfig.HeadDotColor,
    Callback = function(value)
        ESPConfig.HeadDotColor = value
    end
})

ESPTab:CreateSlider({
    Name = "    ",
    Range = {3, 12},
    Increment = 1,
    Suffix = " px",
    CurrentValue = ESPConfig.HeadDotSize,
    Callback = function(value)
        ESPConfig.HeadDotSize = value
    end
})

ESPTab:CreateToggle({
    Name = "  ELITE HUB  ",
    CurrentValue = ESPConfig.ShowScriptUserTag,
    Callback = function(value)
        ESPConfig.ShowScriptUserTag = value
    end
})

ESPTab:CreateColorPicker({
    Name = "   ",
    Color = ESPConfig.ScriptUserTagColor,
    Callback = function(value)
        ESPConfig.ScriptUserTagColor = value
    end
})

ESPTab:CreateSection("🎨 CHAMS")

task.spawn(function()
ESPTab:CreateToggle({
    Name = "🎨 Chams",
    CurrentValue = ESPConfig.ChamsEnabled,
    Callback = function(value)
        ESPConfig.ChamsEnabled = value
        getgenv().ELITE_HUB_Log("👁️ ESP", "Chams: " .. tostring(value))
    end
})

ESPTab:CreateColorPicker({
    Name = "  ",
    Color = ESPConfig.ChamsFillColor,
    Callback = function(value)
        ESPConfig.ChamsFillColor = value
    end
})

ESPTab:CreateSlider({
    Name = "  ",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.ChamsFillTransparency,
    Callback = function(value)
        ESPConfig.ChamsFillTransparency = value
    end
})

ESPTab:CreateColorPicker({
    Name = "  ",
    Color = ESPConfig.ChamsOutlineColor,
    Callback = function(value)
        ESPConfig.ChamsOutlineColor = value
    end
})

ESPTab:CreateSlider({
    Name = "  ",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.ChamsOutlineTransparency,
    Callback = function(value)
        ESPConfig.ChamsOutlineTransparency = value
    end
})

ESPTab:CreateDropdown({
    Name = "🎨 Chams",
    Options = {"ForceField", "Neon", "Glass", "SmoothPlastic", "Plastic", "Wood", "DiamondPlate", "Foil", "Ice", "Brick", "Cobblestone", "CorrodedMetal", "Grass", "Sand", "Slate", "Marble", "Granite", "Limestone"},
    CurrentOption = "ForceField",
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        ESPConfig.ChamsMaterial = Enum.Material[v] or Enum.Material.ForceField
    end
})

ESPTab:CreateToggle({
    Name = "  ",
    CurrentValue = ESPConfig.ChamsTeamCheck,
    Callback = function(value)
        ESPConfig.ChamsTeamCheck = value
    end
})

ESPTab:CreateToggle({
    Name = "   ",
    CurrentValue = ESPConfig.ChamsSelf,
    Callback = function(value)
        ESPConfig.ChamsSelf = value
    end
})

ESPTab:CreateToggle({
    Name = "   ",
    CurrentValue = ESPConfig.ChamsTeammates,
    Callback = function(value)
        ESPConfig.ChamsTeammates = value
    end
})
end)

ESPTab:CreateToggle({
    Name = "  HP  ",
    CurrentValue = ESPConfig.ShowHealthBar,
    Callback = function(value)
        ESPConfig.ShowHealthBar = value
    end
})

ESPTab:CreateColorPicker({
    Name = "   HP",
    Color = ESPConfig.HealthBarColor,
    Callback = function(v)
        ESPConfig.HealthBarColor = v
    end
})

ESPTab:CreateToggle({
    Name = "   ",
    CurrentValue = ESPConfig.HighlightClosest,
    Callback = function(value)
        ESPConfig.HighlightClosest = value
    end
})

ESPTab:CreateColorPicker({
    Name = "   ",
    Color = ESPConfig.HighlightClosestColor,
    Callback = function(value)
        ESPConfig.HighlightClosestColor = value
    end
})

ESPTab:CreateSection("👁️ СКЕЛЕТЫ ( / )")

local espMyTeamLabel = ESPTab:CreateLabel("  : ")
local function UpdateEspMyTeamLabel()
    local tn = GetTeamName(player)
    pcall(function()
        espMyTeamLabel:Set("  : " .. (tn or ""))
    end)
end

task.delay(0.5, UpdateEspMyTeamLabel)
pcall(function()
    if player and player.TeamChanged and player.TeamChanged.Connect then
        player.TeamChanged:Connect(function()
            UpdateEspMyTeamLabel()
        end)
    end
end)

local espTeamDD = nil
local espSelectedTeam = ""
local function RefreshEspTeamDD()
    if not espTeamDD then return end
    local opts = GetAllTeamNames()
    pcall(function() espTeamDD:Refresh(opts) end)
    UpdateEspMyTeamLabel()
end

espTeamDD = ESPTab:CreateDropdown({
    Name = " ",
    Options = GetAllTeamNames(),
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        espSelectedTeam = n or ""
    end
})

ESPTab:CreateLabel("   = ,  = ")

ESPTab:CreateButton({
    Name = "    ",
    Callback = function()
        local n = espSelectedTeam
        if not n or n == "" then
            Rayfield:Notify({ Title = " ", Content = "    ", Duration = 2 })
            return
        end
        local res = ToggleFriendTeam(n)
        if res == "added" then
            Rayfield:Notify({ Title = " -", Content = n .. "   ", Duration = 2 })
        else
            Rayfield:Notify({ Title = " ", Content = n .. "    ()", Duration = 2 })
        end
        pcall(RefreshEspTeamDD)
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "      ()",
    Callback = function()
        local n = espSelectedTeam
        if not n or n == "" then
            Rayfield:Notify({ Title = " ", Content = "    ", Duration = 2 })
            return
        end
        local list = getgenv().ELITE_HUB_FRIEND_TEAMS
        for i = #list, 1, -1 do
            if tostring(list[i]):lower() == n:lower() then
                table.remove(list, i)
            end
        end
        Rayfield:Notify({ Title = " -", Content = n .. "  ", Duration = 2 })
        pcall(RefreshEspTeamDD)
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "  ",
    Callback = function()
        local list = getgenv().ELITE_HUB_FRIEND_TEAMS
        if #list == 0 then
            Rayfield:Notify({ Title = " ", Content = "   ( )", Duration = 2 })
        else
            Rayfield:Notify({ Title = " ", Content = table.concat(list, ", "), Duration = 5 })
        end
    end
})

ESPTab:CreateButton({
    Name = "    ",
    Callback = function()
        getgenv().ELITE_HUB_FRIEND_TEAMS = {}
        Rayfield:Notify({ Title = " ", Content = "   ", Duration = 2 })
        pcall(RefreshEspTeamDD)
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "   ",
    Callback = function()
        pcall(RefreshEspTeamDD)
        Rayfield:Notify({ Title = " ", Content = "  ", Duration = 2 })
    end
})

task.spawn(function()
    while true do
        task.wait(1)
        UpdateEspMyTeamLabel()
    end
end)

ESPTab:CreateSection("🔦 ОСВЕЩЕНИЕ    (  )")

local espFriendAddDD = nil
local espFriendRmDD = nil
local espTargetDD = nil

local function RefreshESPDD()
    if espFriendAddDD then
        local opts = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and not IsFriend(p) then table.insert(opts, p.Name) end
        end
        table.sort(opts)
        pcall(function() espFriendAddDD:Refresh(opts) end)
    end
    if espFriendRmDD then
        local opts = {}
        for _, n in ipairs(getgenv().ELITE_HUB_FRIENDS) do table.insert(opts, tostring(n)) end
        table.sort(opts)
        pcall(function() espFriendRmDD:Refresh(opts) end)
    end
    if espTargetDD then
        local opts = {"()"}
        local playersList = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then table.insert(playersList, p.Name) end
        end
        table.sort(playersList)
        for _, n in ipairs(playersList) do table.insert(opts, n) end
        pcall(function() espTargetDD:Refresh(opts) end)
    end
end

ESPTab:CreateToggle({
    Name = "👁️ ESP",
    CurrentValue = ESPConfig.FriendCheck,
    Flag = "ESPFriendCheck",
    Callback = function(value)
        ESPConfig.FriendCheck = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "   ",
    CurrentValue = ESPConfig.HighlightTarget,
    Flag = "ESPHighlightTarget",
    Callback = function(value)
        ESPConfig.HighlightTarget = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "   / ",
    Color = ESPConfig.FriendColor,
    Callback = function(value)
        ESPConfig.FriendColor = value
        UpdateESP()
    end
})

espFriendAddDD = ESPTab:CreateDropdown({
    Name = "    ",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        if not n or n == "" then return end
        if IsFriendName(n) then
            Rayfield:Notify({ Title = " ", Content = n .. "   ", Duration = 2 })
        else
            table.insert(getgenv().ELITE_HUB_FRIENDS, n)
            Rayfield:Notify({ Title = "  ", Content = n, Duration = 2 })
        end
        if espFriendAddDD then pcall(function() espFriendAddDD:Clear() end) end
        RefreshESPDD()
        UpdateESP()
    end
})

espFriendRmDD = ESPTab:CreateDropdown({
    Name = "   ()",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        if not n or n == "" then return end
        local list = getgenv().ELITE_HUB_FRIENDS
        for i = #list, 1, -1 do
            if tostring(list[i]):lower() == n:lower() then
                table.remove(list, i)
                Rayfield:Notify({ Title = "  ", Content = n, Duration = 2 })
                break
            end
        end
        if espFriendRmDD then pcall(function() espFriendRmDD:Clear() end) end
        RefreshESPDD()
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "   ",
    Callback = function()
        local cnt = #getgenv().ELITE_HUB_FRIENDS
        getgenv().ELITE_HUB_FRIENDS = {}
        Rayfield:Notify({ Title = " ", Content = " : " .. cnt, Duration = 2 })
        RefreshESPDD()
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "   ",
    Callback = function()
        local list = getgenv().ELITE_HUB_FRIENDS
        if #list == 0 then
            Rayfield:Notify({ Title = " ", Content = " ", Duration = 2 })
            return
        end
        Rayfield:Notify({ Title = "  ", Content = table.concat(list, ", "), Duration = 6 })
    end
})

espTargetDD = ESPTab:CreateDropdown({
    Name = "   ()",
    Options = {"()"},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        if n == "()" or n == nil or n == "" then
            getgenv().ELITE_HUB_TARGET_NAME = ""
            Rayfield:Notify({ Title = " ", Content = " ( )", Duration = 2 })
        else
            getgenv().ELITE_HUB_TARGET_NAME = n
            Rayfield:Notify({ Title = "  ", Content = n, Duration = 2 })
        end
        UpdateESP()
    end
})

task.spawn(function()
    while true do
        task.wait(4)
        RefreshESPDD()
    end
end)
Players.PlayerAdded:Connect(RefreshESPDD)
Players.PlayerRemoving:Connect(RefreshESPDD)
task.delay(1, RefreshESPDD)

ESPTab:CreateSection("👁️ ESP")

ESPTab:CreateToggle({
    Name = " ESP:  ",
    CurrentValue = AimbotConfig.NotifyPlayerJoin,
    Callback = function(value)
        AimbotConfig.NotifyPlayerJoin = value
        AimbotConfig.NotifyPlayerLeave = value
    end
})

ESPTab:CreateToggle({
    Name = "    ",
    CurrentValue = AimbotConfig.NotifyPlayerJoin,
    Callback = function(value)
        AimbotConfig.NotifyPlayerJoin = value
    end
})

ESPTab:CreateToggle({
    Name = "    ",
    CurrentValue = AimbotConfig.NotifyPlayerLeave,
    Callback = function(value)
        AimbotConfig.NotifyPlayerLeave = value
    end
})

ESPTab:CreateToggle({
    Name = "    ",
    CurrentValue = AimbotConfig.NotifyTargetLost,
    Callback = function(value)
        AimbotConfig.NotifyTargetLost = value
    end
})

ESPTab:CreateSection("👁️ ТРЕЙСЕРЫ ")

ESPTab:CreateToggle({
    Name = "    HP",
    CurrentValue = ESPConfig.LowHPWarning,
    Callback = function(value)
        ESPConfig.LowHPWarning = value
    end
})

ESPTab:CreateSlider({
    Name = "   HP (%)",
    Range = {5, 60},
    Increment = 5,
    Suffix = "%",
    CurrentValue = ESPConfig.LowHPThreshold,
    Callback = function(value)
        ESPConfig.LowHPThreshold = value
    end
})

ESPTab:CreateColorPicker({
    Name = "  Vignette",
    Color = ESPConfig.LowHPColor,
    Callback = function(color)
        ESPConfig.LowHPColor = color
    end
})

ESPTab:CreateToggle({
    Name = " -  ",
    CurrentValue = AimbotConfig.PulseTarget,
    Callback = function(value)
        AimbotConfig.PulseTarget = value
    end
})

ESPTab:CreateColorPicker({
    Name = "  -",
    Color = AimbotConfig.PulseColor,
    Callback = function(color)
        AimbotConfig.PulseColor = color
    end
})

ESPTab:CreateSlider({
    Name = "  ",
    Range = {20, 200},
    Increment = 5,
    Suffix = "px",
    CurrentValue = AimbotConfig.PulseSize,
    Callback = function(value)
        AimbotConfig.PulseSize = value
    end
})

ESPTab:CreateSlider({
    Name = "  ",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = AimbotConfig.PulseSpeed,
    Callback = function(value)
        AimbotConfig.PulseSpeed = value
    end
})

ESPTab:CreateToggle({
    Name = " HP-   ",
    CurrentValue = AimbotConfig.TargetHealthBarTop,
    Callback = function(value)
        AimbotConfig.TargetHealthBarTop = value
    end
})

ESPTab:CreateToggle({
    Name = "  HP-  ",
    CurrentValue = AimbotConfig.TargetHealthBarMounted,
    Callback = function(value)
        AimbotConfig.TargetHealthBarMounted = value
    end
})

ESPTab:CreateSection("🎯 НАСТРОЙКИ ( )")

ESPTab:CreateLabel("  Fly: " .. BindConfig.Fly)
ESPTab:CreateLabel("  Noclip: " .. BindConfig.Noclip)
ESPTab:CreateLabel("  SpeedBoost: " .. BindConfig.SpeedBoost)
ESPTab:CreateLabel("  SpinBot: " .. BindConfig.SpinBot)

local VFX = {}
pcall(function()
VFX.VisualGui = Instance.new("ScreenGui")
VFX.VisualGui.Name = "EliteHubVisual"
VFX.VisualGui.ResetOnSpawn = false
VFX.VisualGui.Parent = player:WaitForChild("PlayerGui")


VFX.VignetteFrame = Instance.new("Frame")
VFX.VignetteFrame.Size = UDim2.new(1, 0, 1, 0)
VFX.VignetteFrame.BackgroundColor3 = ESPConfig.LowHPColor
VFX.VignetteFrame.BackgroundTransparency = 1
VFX.VignetteFrame.BorderSizePixel = 0
VFX.VignetteFrame.Visible = false
VFX.VignetteFrame.ZIndex = 5
VFX.VignetteFrame.Parent = VFX.VisualGui
VFX.VignetteGrad = Instance.new("UIGradient")
VFX.VignetteGrad.Rotation = 0
VFX.VignetteGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.55, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.8, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
})
VFX.VignetteGrad.Parent = VFX.VignetteFrame

VFX.PulseCircle = NewOverlayCircle()
VFX.PulseCircle.Color = AimbotConfig.PulseColor
VFX.PulseCircle.Thickness = 3
VFX.PulseCircle.Visible = false
VFX.PulseTime = 0

VFX.BarFrame = Instance.new("Frame")
VFX.BarFrame.Size = UDim2.new(0, 200, 0, 14)
VFX.BarFrame.AnchorPoint = Vector2.new(0.5, 1)
VFX.BarBg = Instance.new("Frame")
VFX.BarBg.BackgroundColor3 = Color3.new(0, 0, 0)
VFX.BarBg.BackgroundTransparency = 0.4
VFX.BarBg.Size = UDim2.new(1, 0, 1, 0)
VFX.BarBg.BorderSizePixel = 0
VFX.BarBg.Parent = VFX.BarFrame
VFX.BarFill = Instance.new("Frame")
VFX.BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
VFX.BarFill.BorderSizePixel = 0
VFX.BarFill.AnchorPoint = Vector2.new(0, 0.5)
VFX.BarFill.Position = UDim2.new(0, 0, 0.5, 0)
VFX.BarFill.Size = UDim2.new(1, 0, 1, 0)
VFX.BarFill.Parent = VFX.BarFrame
VFX.BarName = Instance.new("TextLabel")
VFX.BarName.BackgroundTransparency = 1
VFX.BarName.Size = UDim2.new(1, 0, 1, 0)
VFX.BarName.TextColor3 = Color3.new(1, 1, 1)
VFX.BarName.TextStrokeTransparency = 0
VFX.BarName.TextStrokeColor3 = Color3.new(0, 0, 0)
VFX.BarName.Font = Enum.Font.SourceSansBold
VFX.BarName.TextSize = 11
VFX.BarName.Parent = VFX.BarFrame
VFX.BarBillboard = Instance.new("BillboardGui")
VFX.BarBillboard.Size = UDim2.new(0, 220, 0, 40)
VFX.BarBillboard.AlwaysOnTop = true
VFX.BarBillboard.Adornee = nil
VFX.BarBillboard.Parent = VFX.VisualGui
VFX.BarFrame.Parent = VFX.BarBillboard
VFX.BarBillboard.Enabled = false
end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local lowHP = false
            local myChar = player.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if myHum and myHum.Health > 0 and myHum.Health <= ESPConfig.LowHPThreshold then
                lowHP = true
            end
            VFX.VignetteFrame.Visible = ESPConfig.LowHPWarning
            if ESPConfig.LowHPWarning and lowHP then
                local pulse = (math.sin(tick() * 6) + 1) / 2
                VFX.VignetteFrame.BackgroundTransparency = 0.75 - pulse * 0.35
            else
                VFX.VignetteFrame.BackgroundTransparency = 1
            end

            VFX.PulseTime = VFX.PulseTime + 0.05
            local pulseOn = AimbotConfig.PulseTarget and LockedTarget and LockedTargetPlayer
            VFX.PulseCircle.Visible = false
            if pulseOn then
                local base = AimbotConfig.PulseSize
                local pulse = (math.sin(VFX.PulseTime * AimbotConfig.PulseSpeed) + 1) / 2
                VFX.PulseCircle.Radius = base * (1 + pulse * 1.5)
                VFX.PulseCircle.Color = AimbotConfig.PulseColor
                local spp, vis = workspace.CurrentCamera:WorldToViewportPoint(LockedTarget.Position)
                if vis then
                    VFX.PulseCircle.Position = Vector2.new(spp.X, spp.Y)
                    VFX.PulseCircle.Visible = true
                end
            end

            local barOnRaw = AimbotConfig.TargetHealthBarTop and LockedTargetPlayer and LockedTargetPlayer.Character
            local tcRaw = barOnRaw and LockedTargetPlayer.Character
            local thpRaw = tcRaw and tcRaw:FindFirstChild("Head")
            local barOn = barOnRaw and thpRaw
            VFX.BarBillboard.Enabled = barOn and true or false
            if barOn then
                local tc = LockedTargetPlayer.Character
                local th = tc:FindFirstChildOfClass("Humanoid")
                local tr = tc:FindFirstChild("HumanoidRootPart")
                local thp = thpRaw
                if th and tr and thp then
                    VFX.BarBillboard.Adornee = thp
                    VFX.BarBillboard.StudsOffset = Vector3.new(0, 1.2, 0)
                    local mh = th.MaxHealth
                    if mh <= 0 then mh = 100 end
                    local hp = math.max(th.Health, 0)
                    local pct = math.clamp(hp / mh, 0, 1)
                    VFX.BarFill.Visible = pct > 0
                    VFX.BarFill.Size = UDim2.new(pct, 0, 1, 0)
                    VFX.BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    VFX.BarName.Text = LockedTargetPlayer.Name .. " [" .. math.floor(hp) .. "/" .. math.floor(mh) .. "]"
                end
            end
        end)
    end
end)

--[[
    ==============================
     -
    ==============================
]]--
local LocalPlayer = Players.LocalPlayer
local dropdown = nil
local selectedPlayer = nil
local autoTp = false
local onlineLabel = nil

local function TeleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer:IsA("Player") then
        Rayfield:Notify({ Title = " ", Content = " ", Duration = 2 })
        return
    end
    local myChar = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    if myChar and targetChar then
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if myRoot and targetRoot then
            myRoot.CFrame = targetRoot.CFrame
            Rayfield:Notify({ Title = " ", Content = "  " .. targetPlayer.Name, Duration = 2 })
        end
    end
end

local function UpdateOnlineCount()
    if onlineLabel then
        onlineLabel:Set("  : " .. tostring(#Players:GetPlayers()))
    end
end

local function UpdateDropdown()
    if not dropdown then return end
    local opts = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(opts, p.Name)
        end
    end
    table.sort(opts)
    dropdown:Refresh(opts) --    
    UpdateOnlineCount()
    if selectedPlayer and not Players:FindFirstChild(selectedPlayer.Name) then
        selectedPlayer = nil
        dropdown:Set("") -- 
        autoTp = false
        Rayfield:Notify({
            Title = "  ",
            Content = " ",
            Duration = 2
        })
    end
end

TeleportTab:CreateSection("")
onlineLabel = TeleportTab:CreateLabel("  : 0")
dropdown = TeleportTab:CreateDropdown({
    Name = " ",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        local chosen = option
        if typeof(option) == "table" then
            chosen = option[1]
        end
        selectedPlayer = nil
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Name == chosen then
                selectedPlayer = pl
                break
            end
        end
        if selectedPlayer then
            Rayfield:Notify({
                Title = " ",
                Content = selectedPlayer.Name,
                Duration = 1.5
            })
        end
    end
})

TeleportTab:CreateButton({
    Name = "   ",
    Callback = function()
        if not selectedPlayer then
            Rayfield:Notify({ Title = " ", Content = "  ", Duration = 2 })
            return
        end
        TeleportToPlayer(selectedPlayer)
    end
})

TeleportTab:CreateToggle({
    Name = " -",
    CurrentValue = false,
    Callback = function(value)
        autoTp = value
        if value and selectedPlayer then
            Rayfield:Notify({ Title = " - ", Content = "  " .. selectedPlayer.Name, Duration = 2 })
        elseif not value then
            Rayfield:Notify({ Title = " - ", Content = "", Duration = 2 })
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.12)
        if autoTp and selectedPlayer and Players:FindFirstChild(selectedPlayer.Name) then
            local myChar = LocalPlayer.Character
            local targetChar = selectedPlayer.Character
            if myChar and targetChar then
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                if myRoot and targetRoot then
                    myRoot.CFrame = targetRoot.CFrame
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        UpdateDropdown()
    end
end)

Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)

task.delay(1, UpdateDropdown)
Rayfield:Notify({
    Title = " ",
    Content = "  .      .",
    Duration = 4
})

--[[
    ==============================
       ()
    ==============================
]]--
local KillAllSection = KillAllTab:CreateSection("⚔️ УБИТЬ ВСЕХ ВРАГОВ")
local safeZoneRadius = 20
local isActive = false
local killAllEnabled = true
local ignoreTeam = true
local zonePart = Instance.new("Part")
zonePart.Shape = Enum.PartType.Ball
zonePart.Anchored = true
zonePart.CanCollide = false
zonePart.Transparency = 0.7
zonePart.Color = Color3.fromRGB(0, 255, 0)
zonePart.Material = Enum.Material.Neon
zonePart.Name = "SafeZone"
zonePart.Parent = workspace

KillAllTab:CreateToggle({
   Name = "  Safe Zone",
   CurrentValue = isActive,
   Callback = function(Value)
      isActive = Value
   end
})

KillAllTab:CreateToggle({
   Name = "  Kill All",
   CurrentValue = killAllEnabled,
   Callback = function(Value)
      killAllEnabled = Value
   end
})

KillAllTab:CreateToggle({
   Name = "  ",
   CurrentValue = ignoreTeam,
   Callback = function(Value)
      ignoreTeam = Value
   end
})

KillAllTab:CreateSlider({
   Name = "   ",
   Range = {5, 100},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = safeZoneRadius,
   Callback = function(Value)
      safeZoneRadius = Value
   end
})

task.spawn(function()
    Log("KILLALL", " Kill All ")
    while task.wait(0.1) do
        pcall(function()
            local myChar = player.Character
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

            local root = myChar.HumanoidRootPart
            zonePart.Position = root.Position
            zonePart.Size = Vector3.new(safeZoneRadius * 2, safeZoneRadius * 2, safeZoneRadius * 2)

            if not isActive then
                zonePart.Transparency = 1
                return
            else
                zonePart.Transparency = 0.7
            end

            local tool = myChar:FindFirstChildOfClass("Tool")
            if not tool or not tool:FindFirstChild("Handle") then return end

            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                    if not (ignoreTeam and player.Team and other.Team and player.Team == other.Team) then
                        local oRoot = other.Character.HumanoidRootPart
                        local dist = (oRoot.Position - root.Position).Magnitude

                        local shouldAttack = killAllEnabled or (dist > safeZoneRadius)

                        if shouldAttack and dist <= 10000 then
                            tool:Activate()
                            for _, part in pairs(other.Character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    firetouchinterest(tool.Handle, part, 0)
                                    firetouchinterest(tool.Handle, part, 1)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

--[[
    ==============================
      
    ==============================
]]--
local ScriptsSection = MainTab:CreateSection("📜 ДОПОЛНИТЕЛЬНЫЕ СКРИПТЫ")

local function LoadImprovedFlight()
local wallhopActive = false
local wallhopConnection = nil
local wallhopBindKey = Enum.KeyCode.LeftControl

local speeds = 1
local nowe = false
local tpwalking = false
local flyBg = nil
local flyBv = nil

_G.flyCtrl = {f = 0, b = 0, l = 0, r = 0}
local ctrl = _G.flyCtrl

local noclipConnection = nil

local UserInputService = game:GetService("UserInputService")
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    if isMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/MobileFly.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/FlyR15.lua"))()
    end
end

local function LoadRakeAnimation()
    local animationId = "rbxassetid://252557606"
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    local animation = Instance.new("Animation")
    animation.AnimationId = animationId

    local animationTrack = humanoid:LoadAnimation(animation)
    local defaultWalkSpeed = 50
    humanoid.WalkSpeed = defaultWalkSpeed

    local function onWalking(speed)
        if speed > 0 then
            humanoid.WalkSpeed = 50
            animationTrack:Play()
        else
            humanoid.WalkSpeed = defaultWalkSpeed
            animationTrack:Stop()
        end
    end

    humanoid.Running:Connect(onWalking)

    local backpack = player:WaitForChild("Backpack")
    
    local tool1 = Instance.new("Tool")
    tool1.Name = "double slash"
    tool1.RequiresHandle = false
    tool1.CanBeDropped = false

    local animation1 = Instance.new("Animation")
    animation1.AnimationId = "rbxassetid://105211514"

    tool1.Activated:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animTrack = humanoid:LoadAnimation(animation1)
            animTrack:Play()
        end
    end)
    tool1.Parent = backpack

    local tool2 = Instance.new("Tool")
    tool2.Name = "enrage"
    tool2.RequiresHandle = false
    tool2.CanBeDropped = false

    local animation2 = Instance.new("Animation")
    animation2.AnimationId = "rbxassetid://93648331"

    tool2.Activated:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animTrack = humanoid:LoadAnimation(animation2)
            animTrack:Play()
        end
    end)
    tool2.Parent = backpack
end

local newScripts = {
    {
        Name = "⚔️ FE Seraphic Blade",
        Url = "https://pastefy.app/59mJGQGe/raw"
    },
    {
        Name = " FE ",
        Url = "https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"
    },
    {
        Name = "  ",
        Callback = LoadImprovedFlight
    },
    {
        Name = " The Rake ",
        Callback = LoadRakeAnimation
    },
    {
        Name = "🌀 Touch Fling",
        Url = "https://rawscripts.net/raw/Universal-Script-TOUCH-FLING-30401"
    }
}


for i, scriptInfo in ipairs(newScripts) do
    MainTab:CreateButton({
        Name = scriptInfo.Name,
        Callback = function()
            Rayfield:Notify({
                Title = " ...",
                Content = " "..scriptInfo.Name.." ",
                Duration = 3
            })

            local success, err = pcall(function()
                if scriptInfo.Callback then
                    scriptInfo.Callback()
                else
                    loadstring(game:HttpGet(scriptInfo.Url, true))()
                end
            end)

            if success then
                Rayfield:Notify({
                    Title = " !",
                    Content = scriptInfo.Name.."  ",
                    Duration = 4
                })
            else
                Rayfield:Notify({
                    Title = " !",
                    Content = "   "..scriptInfo.Name..":\n"..tostring(err),
                    Duration = 6
                })
            end
        end
    })
end

local scriptUrls = {
    "https://pastefy.app/YsJgITXR/raw",
    "https://pastebin.com/raw/3Rnd9rHf",
    "https://pastefy.app/JOWniO6o/raw",
    "https://pastebin.com/raw/LgZwZ7ZB",
    "https://pastefy.app/w7KnPY70/raw",
    "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Gale%20Fighter",
    "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Neptunian%20V"
}
local scriptNames = {
    " SCP-096 ",
    "  PRO",
    "  ",
    " +",
    "  -",
    "⚔️ FE GALE FIGHTER",
    "🌊 FE Neptunian V"
}

for i = 1, #scriptNames do
    MainTab:CreateButton({
        Name = scriptNames[i],
        Callback = function()
            Rayfield:Notify({
                Title = " ...",
                Content = " "..scriptNames[i].." ",
                Duration = 3
            })

            local success, err = pcall(function()
                loadstring(game:HttpGet(scriptUrls[i], true))()
            end)

            if not success then
                Rayfield:Notify({
                    Title = " !",
                    Content = "   :\n"..tostring(err),
                    Duration = 6
                })
            end
        end
    })
end

--[[
    ==============================
     
    ==============================
]]--
game:GetService("RunService").Stepped:Connect(function()
    if noclipActive and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

player.CharacterAdded:Connect(function(character)

    if ESPConfig.Enabled then
        task.wait(2)
        UpdateESP()
    end
end)

local VisualConfig = {
    SkyEnabled = false,
    SkyColor = Color3.fromRGB(80, 120, 255),
    SkyBottomColor = Color3.fromRGB(200, 160, 120),
    SkyBrightness = 1.0,
    SkyTime = 14,
    WorldTintEnabled = false,
    WorldTintColor = Color3.fromRGB(180, 180, 220),
    FogEnabled = false,
    FogColor = Color3.fromRGB(200, 200, 255),
    FogDensity = 0.5,
    ParticlesEnabled = false,
    ParticleType = "Aura",
    ParticleColor = Color3.fromRGB(170, 0, 255),
    ParticleColor2 = Color3.fromRGB(255, 255, 255),
    ParticleSize = 0.5,
    ParticleRate = 50,
    ParticleSpeed = 3,
    ParticleLife = 1.2,
    ParticleGlow = false,
    ParticleTexture = "None"
}

local ParticlePresets = {
    Aura = { dir = Enum.NormalId.Top, speed = 2, spread = Vector2.new(360, 360), life = 1.2, num = 1, tex = nil },
    Trail = { dir = Enum.NormalId.Back, speed = 1.5, spread = Vector2.new(10, 10), life = 1.0, num = 1, tex = nil },
    Fire = { dir = Enum.NormalId.Top, speed = 3, spread = Vector2.new(25, 25), life = 0.8, num = 3, tex = "Fire", glow = true },
    Rain = { dir = Enum.NormalId.Top, speed = 8, spread = Vector2.new(360, 360), life = 1.5, num = 8, tex = nil },
    Snow = { dir = Enum.NormalId.Top, speed = 0.8, spread = Vector2.new(360, 360), life = 3, num = 4, tex = "Snow" },
    Sparkles = { dir = Enum.NormalId.Top, speed = 4, spread = Vector2.new(360, 360), life = 1, num = 2, glow = true },
    Confetti = { dir = Enum.NormalId.Top, speed = 2.5, spread = Vector2.new(360, 360), life = 2.5, num = 3, glow = true },
    Smoke = { dir = Enum.NormalId.Top, speed = 1, spread = Vector2.new(30, 30), life = 3, num = 2, glow = false },
    Blood = { dir = Enum.NormalId.Bottom, speed = 3, spread = Vector2.new(360, 360), life = 1.2, num = 5, tex = nil },
    Glow = { dir = Enum.NormalId.Top, speed = 0.5, spread = Vector2.new(360, 360), life = 1.5, num = 3, glow = true },
    Dust = { dir = Enum.NormalId.Bottom, speed = 1.5, spread = Vector2.new(360, 360), life = 2, num = 4, tex = nil },
    Bubble = { dir = Enum.NormalId.Top, speed = 1.2, spread = Vector2.new(360, 360), life = 2.5, num = 2, tex = "Bubble" },
    Lightning = { dir = Enum.NormalId.Top, speed = 10, spread = Vector2.new(15, 15), life = 0.6, num = 5, glow = true },
    Poison = { dir = Enum.NormalId.Top, speed = 2, spread = Vector2.new(360, 360), life = 2, num = 3, glow = true },
    Hex = { dir = Enum.NormalId.Top, speed = 1.8, spread = Vector2.new(360, 360), life = 2.2, num = 4, glow = true },
    Lava = { dir = Enum.NormalId.Top, speed = 2.5, spread = Vector2.new(40, 40), life = 1.5, num = 3, glow = true },
    Ice = { dir = Enum.NormalId.Top, speed = 0.6, spread = Vector2.new(360, 360), life = 2.5, num = 4, glow = true },
    Plasma = { dir = Enum.NormalId.Top, speed = 5, spread = Vector2.new(360, 360), life = 0.8, num = 4, glow = true },
    Leaves = { dir = Enum.NormalId.Top, speed = 1, spread = Vector2.new(360, 360), life = 3, num = 3, tex = nil },
    Feathers = { dir = Enum.NormalId.Top, speed = 0.8, spread = Vector2.new(360, 360), life = 3.5, num = 2, tex = nil },
    Stars = { dir = Enum.NormalId.Top, speed = 1.5, spread = Vector2.new(360, 360), life = 2, num = 3, glow = true },
    Hearts = { dir = Enum.NormalId.Top, speed = 2, spread = Vector2.new(360, 360), life = 2, num = 2, glow = true },
    Neon = { dir = Enum.NormalId.Top, speed = 3, spread = Vector2.new(360, 360), life = 1.2, num = 4, glow = true },
    Chaos = { dir = Enum.NormalId.Top, speed = 6, spread = Vector2.new(360, 360), life = 0.7, num = 6, glow = true },
    Meteor = { dir = Enum.NormalId.Top, speed = 12, spread = Vector2.new(20, 20), life = 0.5, num = 3, glow = true },
    Electric = { dir = Enum.NormalId.Top, speed = 8, spread = Vector2.new(360, 360), life = 0.4, num = 5, glow = true },
    Wind = { dir = Enum.NormalId.Back, speed = 7, spread = Vector2.new(15, 15), life = 1, num = 3, tex = nil },
    Shadow = { dir = Enum.NormalId.Top, speed = 0.4, spread = Vector2.new(360, 360), life = 4, num = 2, glow = false },
    Crystal = { dir = Enum.NormalId.Top, speed = 1.2, spread = Vector2.new(360, 360), life = 2.5, num = 3, glow = true },
    Sakura = { dir = Enum.NormalId.Top, speed = 0.6, spread = Vector2.new(360, 360), life = 4, num = 3, tex = nil },
    Galaxy = { dir = Enum.NormalId.Top, speed = 2, spread = Vector2.new(360, 360), life = 3, num = 4, glow = true },
    Nuclear = { dir = Enum.NormalId.Top, speed = 4, spread = Vector2.new(360, 360), life = 1.5, num = 5, glow = true },
    Phoenix = { dir = Enum.NormalId.Top, speed = 5, spread = Vector2.new(30, 30), life = 1.2, num = 4, tex = "Fire", glow = true },
    Void = { dir = Enum.NormalId.Top, speed = 1, spread = Vector2.new(360, 360), life = 5, num = 2, glow = false },
    Dragon = { dir = Enum.NormalId.Top, speed = 6, spread = Vector2.new(20, 20), life = 0.9, num = 5, tex = "Fire", glow = true }
}

local VisFx = {}
VisFx.Lighting = game:GetService("Lighting")
VisFx.OriginalFogEnd = VisFx.Lighting.FogEnd
VisFx.OriginalFogStart = VisFx.Lighting.FogStart
VisFx.OriginalAmbient = VisFx.Lighting.Ambient
VisFx.OriginalOutdoor = VisFx.Lighting.OutdoorAmbient
VisFx.OriginalBrightness = VisFx.Lighting.Brightness

local function ApplyVisualSky()
    pcall(function()
    local L = VisFx.Lighting
    if VisualConfig.SkyEnabled then
        if not VisFx.Atmosphere then
            for _, v in ipairs(L:GetChildren()) do
                if v:IsA("Atmosphere") then VisFx.Atmosphere = v end
            end
            if not VisFx.Atmosphere then
                VisFx.Atmosphere = Instance.new("Atmosphere")
                VisFx.Atmosphere.Parent = L
            end
        end
        VisFx.Atmosphere.Color = VisualConfig.SkyColor
        VisFx.Atmosphere.Decay = 0.05
        VisFx.Atmosphere.Density = 0.2
        VisFx.Atmosphere.Thickness = 2
        VisFx.Atmosphere.Glare = 0.2
        L.ClockTime = VisualConfig.SkyTime
        L.Brightness = VisualConfig.SkyBrightness
        L.ColorShift_Top = VisualConfig.SkyColor
        L.ColorShift_Bottom = VisualConfig.SkyBottomColor
    else
        if VisFx.Atmosphere then
            VisFx.Atmosphere.Color = Color3.new(1, 1, 1)
            VisFx.Atmosphere.Decay = 0.05
            VisFx.Atmosphere.Density = 0.1
        end
        L.ColorShift_Top = Color3.new(1, 1, 1)
        L.ColorShift_Bottom = Color3.new(1, 1, 1)
        L.Brightness = VisFx.OriginalBrightness
    end
    if VisualConfig.WorldTintEnabled then
        L.Ambient = VisualConfig.WorldTintColor
        L.OutdoorAmbient = VisualConfig.WorldTintColor
    else
        L.Ambient = VisFx.OriginalAmbient
        L.OutdoorAmbient = VisFx.OriginalOutdoor
    end
    if VisualConfig.FogEnabled then
        L.FogColor = VisualConfig.FogColor
        local density = math.clamp(VisualConfig.FogDensity, 0.05, 1)
        L.FogEnd = math.floor(5000 * (1 - density * 0.9) + 100)
        L.FogStart = L.FogEnd * 0.25
    else
        L.FogEnd = VisFx.OriginalFogEnd
        L.FogStart = VisFx.OriginalFogStart
    end
    end)
end

local function SetupParticles(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if VisFx.ParticleHolder then VisFx.ParticleHolder:Destroy() end
    local holder = Instance.new("Part")
    holder.Size = Vector3.new(1, 1, 1)
    holder.Transparency = 1
    holder.CanCollide = false
    holder.Anchored = true
    holder.Archivable = false
    holder.CFrame = hrp.CFrame
    holder.Parent = char
    local att = Instance.new("Attachment")
    att.Parent = holder

    local preset = ParticlePresets[VisualConfig.ParticleType] or ParticlePresets.Aura

    local emitter = Instance.new("ParticleEmitter")
    emitter.Parent = att
    emitter.Lifetime = NumberRange.new(VisualConfig.ParticleLife * 0.6, VisualConfig.ParticleLife)
    emitter.Rate = VisualConfig.ParticleRate
    emitter.Speed = NumberRange.new(1, preset.speed + VisualConfig.ParticleSpeed)
    emitter.SpreadAngle = preset.spread
    emitter.Size = NumberSequence.new(VisualConfig.ParticleSize)
    emitter.Transparency = NumberSequence.new(0.2)
    emitter.Color = ColorSequence.new(VisualConfig.ParticleColor, VisualConfig.ParticleColor2)
    emitter.LightEmission = VisualConfig.ParticleGlow and 1 or 0
    emitter.LightInfluence = 0.5
    emitter.EmissionDirection = preset.dir
    emitter.Enabled = true

    if preset.tex then
        pcall(function()
            if preset.tex == "Fire" then
                emitter.Texture = "rbxasset://textures/particles/fire_main.dds"
            elseif preset.tex == "Snow" then
                emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            elseif preset.tex == "Bubble" then
                emitter.Texture = "rbxasset://textures/particles/bokeh_main.dds"
            end
        end)
    end

    VisFx.ParticleHolder = holder
    VisFx.Attachment = att
    VisFx.Emitter = emitter

    if VisFx.ParticleConnection then VisFx.ParticleConnection:Disconnect() end
    VisFx.ParticleConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not VisualConfig.ParticlesEnabled then
            if VisFx.ParticleHolder then VisFx.ParticleHolder:Destroy() end
            VisFx.ParticleHolder = nil
            if VisFx.ParticleConnection then VisFx.ParticleConnection:Disconnect() end
            VisFx.ParticleConnection = nil
            return
        end
        local ch = player.Character
        local rp = ch and ch:FindFirstChild("HumanoidRootPart")
        if holder and rp then
            holder.CFrame = rp.CFrame
        end
    end)
end

VisualTab:CreateSection("🎨 ВИЗУАЛЬНЫЕ ")

VisualTab:CreateToggle({
    Name = "  ",
    CurrentValue = VisualConfig.ParticlesEnabled,
    Callback = function(value)
        VisualConfig.ParticlesEnabled = value
        if value then
            SetupParticles(player.Character)
        elseif VisFx.ParticleHolder then
            VisFx.ParticleHolder:Destroy()
            VisFx.ParticleHolder = nil
        end
    end
})

VisualTab:CreateDropdown({
    Name = "  ",
    Options = {"Aura", "Trail", "Fire", "Rain", "Snow", "Sparkles", "Confetti", "Smoke", "Blood", "Glow", "Dust", "Bubble", "Lightning", "Poison", "Hex", "Lava", "Ice", "Plasma", "Leaves", "Feathers", "Stars", "Hearts", "Neon", "Chaos", "Meteor", "Electric", "Wind", "Shadow", "Crystal", "Sakura", "Galaxy", "Nuclear", "Phoenix", "Void", "Dragon"},
    CurrentOption = VisualConfig.ParticleType,
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        VisualConfig.ParticleType = v
        if VisualConfig.ParticlesEnabled then SetupParticles(player.Character) end
    end
})

VisualTab:CreateColorPicker({
    Name = "  1",
    Color = VisualConfig.ParticleColor,
    Callback = function(color)
        VisualConfig.ParticleColor = color
        if VisFx.Emitter then
            VisFx.Emitter.Color = ColorSequence.new(color, VisualConfig.ParticleColor2)
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "  2 ()",
    Color = VisualConfig.ParticleColor2,
    Callback = function(color)
        VisualConfig.ParticleColor2 = color
        if VisFx.Emitter then
            VisFx.Emitter.Color = ColorSequence.new(VisualConfig.ParticleColor, color)
        end
    end
})

VisualTab:CreateToggle({
    Name = "  ",
    CurrentValue = VisualConfig.ParticleGlow,
    Callback = function(value)
        VisualConfig.ParticleGlow = value
        if VisFx.Emitter then
            VisFx.Emitter.LightEmission = value and 1 or 0
        end
    end
})

VisualTab:CreateSlider({
    Name = "  ",
    Range = {0.05, 3},
    Increment = 0.05,
    CurrentValue = VisualConfig.ParticleSize,
    Callback = function(value)
        VisualConfig.ParticleSize = value
        if VisFx.Emitter then
            VisFx.Emitter.Size = NumberSequence.new(value)
        end
    end
})

VisualTab:CreateSlider({
    Name = " /",
    Range = {10, 400},
    Increment = 10,
    CurrentValue = VisualConfig.ParticleRate,
    Callback = function(value)
        VisualConfig.ParticleRate = value
        if VisFx.Emitter then
            VisFx.Emitter.Rate = value
        end
    end
})

VisualTab:CreateSlider({
    Name = "  ",
    Range = {0.5, 15},
    Increment = 0.5,
    CurrentValue = VisualConfig.ParticleSpeed,
    Callback = function(value)
        VisualConfig.ParticleSpeed = value
        if VisFx.Emitter then
            local p = ParticlePresets[VisualConfig.ParticleType] or ParticlePresets.Aura
            VisFx.Emitter.Speed = NumberRange.new(1, p.speed + value)
        end
    end
})

VisualTab:CreateSlider({
    Name = "   ",
    Range = {0.3, 5},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = VisualConfig.ParticleLife,
    Callback = function(value)
        VisualConfig.ParticleLife = value
        if VisFx.Emitter then
            VisFx.Emitter.Lifetime = NumberRange.new(value * 0.6, value)
        end
    end
})

task.spawn(function()
    player.CharacterAdded:Connect(function()
        if VisualConfig.ParticlesEnabled then
            task.wait(1)
            SetupParticles(player.Character)
        end
    end)
end)

task.spawn(function()
local MT = getgenv().ELITE_HUB_ModsTab
getgenv().ELITE_HUB_Log("MODS", "  ")

MT:CreateSection("⚡ ДВИЖЕНИЕ ")

getgenv().ELITE_HUB_JumpBoost = false
MT:CreateToggle({
    Name = "🦘 Jump Boost (Прыжок)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_JumpBoost = value
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = value and 120 or 50
        end
        getgenv().ELITE_HUB_Log("MODS", "Jump Boost: " .. tostring(value))
    end
})
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if getgenv().ELITE_HUB_JumpBoost then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.UseJumpPower = true; hum.JumpPower = 120 end
    end
end)

getgenv().ELITE_HUB_HitboxExpander = false
getgenv().ELITE_HUB_HitboxSize = 10
MT:CreateSection("📦 ХИТБОКСЫ ")
MT:CreateToggle({
    Name = "📦 Hitbox Expander",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_HitboxExpander = value
        getgenv().ELITE_HUB_Log("MODS", "Hitbox Expander: " .. tostring(value))
    end
})
MT:CreateSlider({
    Name = "📦 Размер хитбокса",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(value)
        getgenv().ELITE_HUB_HitboxSize = value
        getgenv().ELITE_HUB_Log("MODS", "Hitbox Size: " .. tostring(value))
    end
})
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if not getgenv().ELITE_HUB_HitboxExpander then return end
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(getgenv().ELITE_HUB_HitboxSize, getgenv().ELITE_HUB_HitboxSize, getgenv().ELITE_HUB_HitboxSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Really red")
                        hrp.Material = Enum.Material.ForceField
                        hrp.CanCollide = false
                    end
                end
            end
        end)
    end
end)

MT:CreateSection("🎥 FREECAM & ")

getgenv().ELITE_HUB_FreeCam = false
MT:CreateToggle({
    Name = "📷 Free Cam (свободная камера)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_FreeCam = value
        getgenv().ELITE_HUB_Log("MODS", "Free Cam: " .. tostring(value))
        local cam = workspace.CurrentCamera
        if value then
            local ch = player.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                getgenv().ELITE_HUB_FreeCamCF = cam.CFrame
                getgenv().ELITE_HUB_FreeCamBP = hrp:Clone()
                getgenv().ELITE_HUB_FreeCamBP.Parent = workspace
                getgenv().ELITE_HUB_FreeCamBP.Transparency = 1
                getgenv().ELITE_HUB_FreeCamBP.Anchored = true
                getgenv().ELITE_HUB_FreeCamBP.CanCollide = false
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = getgenv().ELITE_HUB_FreeCamCF
            end
        else
            cam.CameraType = Enum.CameraType.Custom
            local bp = getgenv().ELITE_HUB_FreeCamBP
            if bp then bp:Destroy(); getgenv().ELITE_HUB_FreeCamBP = nil end
        end
    end
})
task.spawn(function()
    while task.wait(0.03) do
        pcall(function()
            if not getgenv().ELITE_HUB_FreeCam then return end
            local cam = workspace.CurrentCamera
            local speed = 2
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, -speed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, speed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                cam.CFrame = cam.CFrame * CFrame.new(-speed, 0, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                cam.CFrame = cam.CFrame * CFrame.new(speed, 0, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                cam.CFrame = cam.CFrame * CFrame.new(0, speed, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                cam.CFrame = cam.CFrame * CFrame.new(0, -speed, 0)
            end
            getgenv().ELITE_HUB_FreeCamCF = cam.CFrame
        end)
    end
end)

MT:CreateButton({
    Name = "📍 Click TP (ПКМ)",
    Callback = function()
        getgenv().ELITE_HUB_Log("MODS", "   ")
        pcall(function()
            local mouse = player:GetMouse()
            local hit = mouse.Hit
            if hit then
                local ch = player.Character
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = hit + Vector3.new(0, 3, 0)
                end
            end
        end)
    end
})

MT:CreateSection("🌙 НОЧЬ ")

getgenv().ELITE_HUB_NightMode = false
getgenv().ELITE_HUB_NightOrigClock = nil
MT:CreateToggle({
    Name = "🌙 Night Mode",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_NightMode = value
        getgenv().ELITE_HUB_Log("MODS", "Night Mode: " .. tostring(value))
        local lighting = game:GetService("Lighting")
        if value then
            getgenv().ELITE_HUB_NightOrigClock = lighting.ClockTime
            lighting.ClockTime = 0
            lighting.Ambient = Color3.fromRGB(20, 20, 40)
            lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 40)
            lighting.Brightness = 0.5
        else
            if getgenv().ELITE_HUB_NightOrigClock then
                lighting.ClockTime = getgenv().ELITE_HUB_NightOrigClock
            end
            lighting.Ambient = Color3.fromRGB(128, 128, 128)
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            lighting.Brightness = 2
        end
    end
})

MT:CreateSection("👁️ ESP+")

getgenv().ELITE_HUB_ItemESP = false
MT:CreateToggle({
    Name = "🎒 Item ESP (предметы)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ItemESP = value
        getgenv().ELITE_HUB_Log("MODS", "Item ESP: " .. tostring(value))
        if not value then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:GetAttribute("EliteHubItemTag") then
                    v:FindFirstChildOfClass("BillboardGui"):Destroy()
                    v:SetAttribute("EliteHubItemTag", nil)
                end
            end
        end
    end
})
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if not getgenv().ELITE_HUB_ItemESP then return end
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "Terrain" and not v:GetAttribute("EliteHubItemTag") then
                    local dist = (v.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 200 and v.Size.Magnitude < 15 then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 20)
                        bb.AlwaysOnTop = true
                        bb.Adornee = v
                        bb.Parent = v
                        local tl = Instance.new("TextLabel")
                        tl.BackgroundTransparency = 1
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.Text = v.Name
                        tl.TextColor3 = Color3.fromRGB(255, 200, 50)
                        tl.TextSize = 10
                        tl.Font = Enum.Font.GothamBold
                        tl.TextStrokeTransparency = 0
                        tl.Parent = bb
                        v:SetAttribute("EliteHubItemTag", true)
                    end
                end
            end
        end)
    end
end)

MT:CreateSection("🎯 НАСТРОЙКИ ")


MT:CreateToggle({
    Name = "💤 Anti-AFK (анти-АФК)",
    CurrentValue = true,
    Callback = function(value)
        getgenv().ELITE_HUB_Log("MODS", "Anti-AFK: " .. tostring(value))
        if value then
            if not getgenv().ELITE_HUB_AntiAfkConn then
                local VirtualUser = game:GetService("VirtualUser")
                getgenv().ELITE_HUB_AntiAfkConn = player.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        else
            if getgenv().ELITE_HUB_AntiAfkConn then
                getgenv().ELITE_HUB_AntiAfkConn:Disconnect()
                getgenv().ELITE_HUB_AntiAfkConn = nil
            end
        end
    end
})

MT:CreateSection("⚔️ АВТОПАРРИ ")

getgenv().ELITE_HUB_AutoParry = false
MT:CreateToggle({
    Name = " Auto Parry (Auto Block)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_AutoParry = value
        getgenv().ELITE_HUB_Log("MODS", "Auto Parry: " .. tostring(value))
        if value then
            task.spawn(function()
                while getgenv().ELITE_HUB_AutoParry do
                    task.wait(0.05)
                    pcall(function()
                        local ch = player.Character
                        if not ch then return end
                        local hrp = ch:FindFirstChild("HumanoidRootPart")
                        local hum = ch:FindFirstChildOfClass("Humanoid")
                        if not hrp or not hum or hum.Health <= 0 then return end
                        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                            if plr ~= player and plr.Character then
                                local ehrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                local ehum = plr.Character:FindFirstChildOfClass("Humanoid")
                                if ehrp and ehum and ehum.Health > 0 then
                                    local dist = (ehrp.Position - hrp.Position).Magnitude
                                    if dist < 8 then
                                        local tool = ch:FindFirstChildOfClass("Tool")
                                        if tool then
                                            local handle = tool:FindFirstChild("Handle")
                                            if handle then
                                                tool:Activate()
                                            end
                                        end
                                        hum:ChangeState(Enum.HumanoidStateType.Blocking)
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

getgenv().ELITE_HUB_Reach = false
getgenv().ELITE_HUB_ReachDist = 10
MT:CreateToggle({
    Name = " Reach",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_Reach = value
        getgenv().ELITE_HUB_Log("MODS", "Reach: " .. tostring(value))
    end
})
MT:CreateSlider({
    Name = " Reach Distance",
    Range = {3, 50},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(value)
        getgenv().ELITE_HUB_ReachDist = value
    end
})
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not getgenv().ELITE_HUB_Reach then return end
            local ch = player.Character
            if not ch then return end
            local tool = ch:FindFirstChildOfClass("Tool")
            if not tool then return end
            local handle = tool:FindFirstChild("Handle")
            if not handle then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= player and plr.Character then
                    local ehrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local ehum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if ehrp and ehum and ehum.Health > 0 then
                        local dist = (ehrp.Position - handle.Position).Magnitude
                        if dist < getgenv().ELITE_HUB_ReachDist then
                            tool:Activate()
                        end
                    end
                end
            end
        end)
    end
end)

getgenv().ELITE_HUB_SpinBot = false
getgenv().ELITE_HUB_SpinSpeed = 50
getgenv().ELITE_HUB_SpinAngle = 0
MT:CreateToggle({
    Name = "🔄 Spin Bot",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_SpinBot = value
        getgenv().ELITE_HUB_Log("MODS", "Spin Bot: " .. tostring(value))
        if value then
            getgenv().ELITE_HUB_SpinAngle = 0
            task.spawn(function()
                while getgenv().ELITE_HUB_SpinBot do
                    task.wait(0.016)
                    pcall(function()
                        getgenv().ELITE_HUB_SpinAngle = (getgenv().ELITE_HUB_SpinAngle + getgenv().ELITE_HUB_SpinSpeed) % 360
                        if not flyBg then
                            local ch = player.Character
                            if ch then
                                local hrp = ch:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(getgenv().ELITE_HUB_SpinSpeed * 0.1), 0)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})
MT:CreateSlider({
    Name = "🔄 Spin Speed",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().ELITE_HUB_SpinSpeed = value
    end
})

MT:CreateSection("🌈 РАДУГА +")

getgenv().ELITE_HUB_RainbowChams = false
MT:CreateToggle({
    Name = " Rainbow Chams",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RainbowChams = value
        getgenv().ELITE_HUB_Log("MODS", "Rainbow Chams: " .. tostring(value))
    end
})
task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        pcall(function()
            if not getgenv().ELITE_HUB_RainbowChams then return end
            if not ESPConfig.ChamsEnabled then return end
            hue = (hue + 0.01) % 1
            ESPConfig.ChamsFillColor = Color3.fromHSV(hue, 1, 1)
            ESPConfig.ChamsOutlineColor = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
        end)
    end
end)

getgenv().ELITE_HUB_XRay = false
MT:CreateToggle({
    Name = "👁️ X-Ray (сквозь стены)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_XRay = value
        getgenv().ELITE_HUB_Log("MODS", "X-Ray: " .. tostring(value))
        if value then
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "Terrain" then
                    if not part:GetAttribute("EliteHubXRay") then
                        part:SetAttribute("EliteHubXRay", part.Transparency)
                    end
                    if part.Transparency < 0.5 then
                        part.Transparency = 0.8
                    end
                end
            end
        else
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    local orig = part:GetAttribute("EliteHubXRay")
                    if orig then
                        part.Transparency = orig
                        part:SetAttribute("EliteHubXRay", nil)
                    end
                end
            end
        end
    end
})

getgenv().ELITE_HUB_Wallhack = false
MT:CreateToggle({
    Name = " Wallhack ( )",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_Wallhack = value
        getgenv().ELITE_HUB_Log("MODS", "Wallhack: " .. tostring(value))
        if value then
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "Terrain" then
                    if not part:GetAttribute("EliteHubWH") then
                        part:SetAttribute("EliteHubWH", part.Transparency)
                    end
                    part.Transparency = 1
                end
            end
        else
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    local orig = part:GetAttribute("EliteHubWH")
                    if orig then
                        part.Transparency = orig
                        part:SetAttribute("EliteHubWH", nil)
                    end
                end
            end
        end
    end
})

MT:CreateSection("🏃 СКОРОСТЬ ")

MT:CreateSlider({
    Name = " WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = value end
        end)
        getgenv().ELITE_HUB_Log("MODS", "WalkSpeed: " .. value)
    end
})

MT:CreateSlider({
    Name = " JumpPower",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 50,
    Callback = function(value)
        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = value
            end
        end)
        getgenv().ELITE_HUB_Log("MODS", "JumpPower: " .. value)
    end
})

MT:CreateSlider({
    Name = " Gravity",
    Range = {0, 300},
    Increment = 5,
    CurrentValue = 196,
    Callback = function(value)
        workspace.Gravity = value
        getgenv().ELITE_HUB_Log("MODS", "Gravity: " .. value)
    end
})

MT:CreateSlider({
    Name = " FOV",
    Range = {30, 120},
    Increment = 5,
    CurrentValue = 70,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
        getgenv().ELITE_HUB_Log("MODS", "FOV: " .. value)
    end
})

MT:CreateSection("💬 ЧАТ ")

getgenv().ELITE_HUB_ChatSpammer = false
getgenv().ELITE_HUB_ChatSpammerMsg = "ELITE HUB"
MT:CreateToggle({
    Name = " Chat Spammer",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChatSpammer = value
        getgenv().ELITE_HUB_Log("MODS", "Chat Spammer: " .. tostring(value))
        if value then
            task.spawn(function()
                while getgenv().ELITE_HUB_ChatSpammer do
                    task.wait(2)
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemSpeechEvents"):FindFirstChild("SayMessageRequest"):FireServer(
                            getgenv().ELITE_HUB_ChatSpammerMsg, "All"
                        )
                    end)
                end
            end)
        end
    end
})
MT:CreateInput({
    Name = " ",
    PlaceholderText = " ...",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChatSpammerMsg = value
    end
})

MT:CreateSection("🔄 ПЕРЕЗАПУСК ")

getgenv().ELITE_HUB_RejoinOnKick = false
MT:CreateToggle({
    Name = "🔄 Rejoin on Kick",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RejoinOnKick = value
        getgenv().ELITE_HUB_Log("MODS", "Rejoin on Kick: " .. tostring(value))
        if value then
            player.CharacterRemoving:Connect(function()
                task.wait(3)
                if getgenv().ELITE_HUB_RejoinOnKick then
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
                    end)
                end
            end)
        end
    end
})

MT:CreateButton({
    Name = "🏠 Teleport to Spawn",
    Callback = function()
        pcall(function()
            local ch = player.Character
            if ch then
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(0, 10, 0)
                    getgenv().ELITE_HUB_Log("MODS", "TP to Spawn")
                end
            end
        end)
    end
})

MT:CreateToggle({
    Name = " Fullbright",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_Log("MODS", "Fullbright: " .. tostring(value))
        local lighting = game:GetService("Lighting")
        if value then
            getgenv().ELITE_HUB_FullbrightBackup = {
                Brightness = lighting.Brightness,
                Ambient = lighting.Ambient,
                OutdoorAmbient = lighting.OutdoorAmbient,
                GlobalShadows = lighting.GlobalShadows,
                Technology = lighting.Technology
            }
            lighting.Brightness = 10
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
            lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            lighting.GlobalShadows = false
            lighting.FogEnd = 999999
        else
            local b = getgenv().ELITE_HUB_FullbrightBackup
            if b then
                lighting.Brightness = b.Brightness
                lighting.Ambient = b.Ambient
                lighting.OutdoorAmbient = b.OutdoorAmbient
                lighting.GlobalShadows = b.GlobalShadows
            end
            lighting.FogEnd = 100000
        end
    end
})

getgenv().ELITE_HUB_InfiniteJump = false
MT:CreateToggle({
    Name = "🦘 Infinite Jump",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_InfiniteJump = value
        getgenv().ELITE_HUB_Log("MODS", "Infinite Jump: " .. tostring(value))
    end
})
UserInputService.JumpRequest:Connect(function()
    if not getgenv().ELITE_HUB_InfiniteJump then return end
    local ch = player.Character
    if ch then
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

getgenv().ELITE_HUB_ClickTP = false
MT:CreateToggle({
    Name = " Click TP ()",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ClickTP = value
        getgenv().ELITE_HUB_Log("MODS", "Click TP: " .. tostring(value))
    end
})
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if not getgenv().ELITE_HUB_ClickTP then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        local ch = player.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local mouse = player:GetMouse()
                local ray = workspace:Raycast(
                    workspace.CurrentCamera.CFrame.Position,
                    (mouse.Hit.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000,
                    RaycastParams.new()
                )
                if ray then
                    hrp.CFrame = CFrame.new(ray.Position + Vector3.new(0, 3, 0))
                else
                    hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end
end)

getgenv().ELITE_HUB_AutoRespawn = false
MT:CreateToggle({
    Name = " Auto Respawn",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_AutoRespawn = value
        getgenv().ELITE_HUB_Log("MODS", "Auto Respawn: " .. tostring(value))
        if value then
            task.spawn(function()
                while getgenv().ELITE_HUB_AutoRespawn do
                    task.wait(0.5)
                    pcall(function()
                        local ch = player.Character
                        if ch then
                            local hum = ch:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health <= 0 then
                                task.wait(1)
                                player:LoadCharacter()
                            end
                        end
                    end)
                end
            end)
        end
    end
})

MT:CreateToggle({
    Name = "🎥 Third Person",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_Log("MODS", "Third Person: " .. tostring(value))
        if value then
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            player.CameraMaxZoomDistance = 999
        else
            player.CameraMaxZoomDistance = 0.5
        end
    end
})

getgenv().ELITE_HUB_KillSound = false
MT:CreateToggle({
    Name = "🔊 Kill Sound",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_KillSound = value
        getgenv().ELITE_HUB_Log("MODS", "Kill Sound: " .. tostring(value))
    end
})
task.spawn(function()
    local lastHealth = {}
    while task.wait(0.2) do
        pcall(function()
            if not getgenv().ELITE_HUB_KillSound then return end
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local prev = lastHealth[plr]
                        if prev and prev > 0 and hum.Health <= 0 then
                            local s = Instance.new("Sound")
                            s.SoundId = "rbxassetid://138081500"
                            s.Volume = 1
                            s.PlayOnRemove = false
                            s.Parent = workspace.CurrentCamera
                            s:Play()
                            game:GetService("Debris"):AddItem(s, 2)
                        end
                        lastHealth[plr] = hum.Health
                    end
                end
            end
        end)
    end
end)

getgenv().ELITE_HUB_BunnyHop = false
MT:CreateToggle({
    Name = "🐰 Bunny Hop (прыжки)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_BunnyHop = value
        getgenv().ELITE_HUB_Log("MODS", "Bunny Hop: " .. tostring(value))
        if value then
            task.spawn(function()
                while getgenv().ELITE_HUB_BunnyHop do
                    task.wait(0.1)
                    pcall(function()
                        local ch = player.Character
                        if ch then
                            local hum = ch:FindFirstChildOfClass("Humanoid")
                            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end
                    end)
                end
            end)
        end
    end
})

getgenv().ELITE_HUB_Waypoint = nil
MT:CreateButton({
    Name = " Set Waypoint",
    Callback = function()
        local ch = player.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                getgenv().ELITE_HUB_Waypoint = hrp.CFrame
                getgenv().ELITE_HUB_Log("MODS", "Waypoint set")
            end
        end
    end
})
MT:CreateButton({
    Name = " Teleport to Waypoint",
    Callback = function()
        if getgenv().ELITE_HUB_Waypoint then
            local ch = player.Character
            if ch then
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = getgenv().ELITE_HUB_Waypoint
                    getgenv().ELITE_HUB_Log("MODS", "Teleported to waypoint")
                end
            end
        end
    end
})

MT:CreateButton({
    Name = "🔄 Rejoin Server",
    Callback = function()
        getgenv().ELITE_HUB_Log("MODS", "Rejoin Server")
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
})

MT:CreateButton({
    Name = "🌐 Server Hop",
    Callback = function()
        getgenv().ELITE_HUB_Log("MODS", "Server Hop")
        pcall(function()
            local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, srv in ipairs(servers.data) do
                if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, srv.id, player)
                    break
                end
            end
        end)
    end
})

end) --  task.spawn(mods)



