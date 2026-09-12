-- source: ELITE_HUB_14.0.lua OVERLAY/STATUSBAR (lines 2090-2438)
local _g = getgenv
local Rayfield = _g().ELITE_HUB_Rayfield
local Window = _g().ELITE_HUB_Window
local ES = _g().EliteHubSettings
local L = _g().ELITE_HUB_L
local Log = _g().ELITE_HUB_Log
local Players = _g().ELITE_HUB_Players
local player = _g().ELITE_HUB_Player
local OverlayGui = _g().ELITE_HUB_OverlayGui
if OverlayGui then pcall(function() OverlayGui:Destroy() end) end
local LoadScript = _g().ELITE_HUB_LoadScript
local SafeNotify = _g().ELITE_HUB_SafeNotify
local DestroyScript = _g().ELITE_HUB_DestroyScript
local MT = Window
OverlayGui = Instance.new("ScreenGui")
_g().ELITE_HUB_OverlayGui = OverlayGui
OverlayGui.Name = "ELITE_HUB_Overlay"
OverlayGui.ResetOnSpawn = false
OverlayGui.IgnoreGuiInset = true
OverlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local _ogParent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
OverlayGui.Parent = _ogParent

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- TOP STATUS BAR вЂ” FPS / Ping / Time / Server + ELITE HUB subtitle
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
do
    local holder = Instance.new("Frame")
    holder.Name = "EliteHub_TopHolder"
    holder.Size = UDim2.new(0, 310, 0, 50)
    holder.Position = UDim2.new(0.5, 0, 0, 4)
    holder.AnchorPoint = Vector2.new(0.5, 0)
    holder.BackgroundTransparency = 1
    holder.ZIndex = 100
    holder.Parent = OverlayGui

    local bar = Instance.new("Frame")
    bar.Name = "EliteHub_TopBar"
    bar.Size = UDim2.new(1, 0, 0, 22)
    bar.Position = UDim2.new(0, 0, 0, 0)
    bar.BackgroundColor3 = Color3.fromRGB(18, 12, 34)
    bar.BackgroundTransparency = 0.02
    bar.BorderSizePixel = 0
    bar.ZIndex = 100
    bar.Parent = holder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = bar

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(150, 70, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.2
    stroke.Parent = bar

    local subtitle = Instance.new("Frame")
    subtitle.Name = "EliteHub_SubBar"
    subtitle.Size = UDim2.new(0, 180, 0, 22)
    subtitle.Position = UDim2.new(0.5, 0, 0, 28)
    subtitle.AnchorPoint = Vector2.new(0.5, 0)
    subtitle.BackgroundColor3 = Color3.fromRGB(18, 12, 34)
    subtitle.BackgroundTransparency = 0.02
    subtitle.BorderSizePixel = 0
    subtitle.ZIndex = 100
    subtitle.Parent = holder

    local subCorner = Instance.new("UICorner")
    subCorner.CornerRadius = UDim.new(0, 6)
    subCorner.Parent = subtitle

    local subStroke = Instance.new("UIStroke")
    subStroke.Color = Color3.fromRGB(150, 70, 255)
    subStroke.Thickness = 1
    subStroke.Transparency = 0.2
    subStroke.Parent = subtitle

    local subText = Instance.new("TextLabel")
    subText.Name = "SubText"
    subText.Size = UDim2.new(1, 0, 1, 0)
    subText.BackgroundTransparency = 1
    subText.Text = "E L I T E   H U B"
    subText.TextColor3 = Color3.fromRGB(170, 120, 255)
    subText.Font = Enum.Font.GothamBlack
    subText.TextSize = 13
    subText.TextXAlignment = Enum.TextXAlignment.Center
    subText.ZIndex = 101
    subText.Parent = subtitle

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 0)
    layout.Parent = bar

    local function makeLbl(name, w)
        local lbl = Instance.new("TextLabel")
        lbl.Name = name
        lbl.Size = UDim2.new(0, w, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(220, 200, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.ZIndex = 102
        lbl.Parent = bar
        return lbl
    end

    local function makeSep()
        local s = Instance.new("Frame")
        s.Name = "Sep"
        s.Size = UDim2.new(0, 1, 0, 12)
        s.BackgroundColor3 = Color3.fromRGB(150, 70, 255)
        s.BackgroundTransparency = 0.15
        s.BorderSizePixel = 0
        s.ZIndex = 102
        s.Parent = bar
        return s
    end

    local fpsLabel = makeLbl("FPS", 58)
    makeSep()
    local pingLabel = makeLbl("Ping", 58)
    makeSep()
    local timeLabel = makeLbl("Time", 56)
    makeSep()
    local serverLabel = makeLbl("Server", 42)
    serverLabel.TextSize = 10
    serverLabel.TextColor3 = Color3.fromRGB(180, 160, 230)

    local deviceLabel = makeLbl("Device", 42)
    deviceLabel.TextSize = 9
    deviceLabel.TextColor3 = Color3.fromRGB(140, 120, 200)

    local UserInputService = game:GetService("UserInputService")
    local deviceType = "PC"
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        deviceType = "PHONE"
    elseif UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
        deviceType = "TABLET"
    elseif UserInputService.GamepadEnabled then
        deviceType = "XBOX"
    end
    deviceLabel.Text = deviceType

    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local frames = 0
    local lastFpsTime = tick()

    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - lastFpsTime >= 0.5 then
            local fps = math.floor(frames / (now - lastFpsTime) + 0.5)
            frames = 0
            lastFpsTime = now
            local fpsColor = fps >= 55 and Color3.fromRGB(100, 255, 140) or fps >= 30 and Color3.fromRGB(255, 220, 80) or Color3.fromRGB(255, 80, 80)
            fpsLabel.Text = fps .. " FPS"
            fpsLabel.TextColor3 = fpsColor

            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
            local pingColor = ping < 60 and Color3.fromRGB(100, 255, 140) or ping < 120 and Color3.fromRGB(255, 220, 80) or Color3.fromRGB(255, 80, 80)
            pingLabel.Text = ping .. " ms"
            pingLabel.TextColor3 = pingColor

            local t = os.date("*t")
            timeLabel.Text = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)

            local players = #game.Players:GetPlayers()
            local maxP = game.Players.MaxPlayers
            serverLabel.Text = players .. "/" .. maxP
        end
    end)
end

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- MOBILE AIMBOT BUTTON (bottom-right, only on touch devices)
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
do
    local UserInputService = game:GetService("UserInputService")
    if UserInputService.TouchEnabled then
        local aimGui = Instance.new("ScreenGui")
        aimGui.Name = "EliteHub_MobileAim"
        aimGui.ResetOnSpawn = false
        aimGui.IgnoreGuiInset = true
        aimGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        aimGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

        local aimBtn = Instance.new("TextButton")
        aimBtn.Name = "AimbotBtn"
        aimBtn.Size = UDim2.new(0, 60, 0, 60)
        aimBtn.Position = UDim2.new(1, -75, 1, -85)
        aimBtn.AnchorPoint = Vector2.new(0, 0)
        aimBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
        aimBtn.BackgroundTransparency = 0.1
        aimBtn.Text = "AIM"
        aimBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
        aimBtn.Font = Enum.Font.GothamBlack
        aimBtn.TextSize = 14
        aimBtn.ZIndex = 200
        aimBtn.Parent = aimGui

        local aimCorner = Instance.new("UICorner")
        aimCorner.CornerRadius = UDim.new(0, 30)
        aimCorner.Parent = aimBtn

        local aimStroke = Instance.new("UIStroke")
        aimStroke.Color = Color3.fromRGB(150, 70, 255)
        aimStroke.Thickness = 2
        aimStroke.Transparency = 0.3
        aimStroke.Parent = aimBtn

        local function updateAimVisual()
            local enabled = getgenv().ELITE_HUB_AimbotEnabled or false
            if enabled then
                aimBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 180)
                aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                aimStroke.Color = Color3.fromRGB(200, 100, 255)
            else
                aimBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
                aimBtn.TextColor3 = Color3.fromRGB(200, 180, 255)
                aimStroke.Color = Color3.fromRGB(150, 70, 255)
            end
        end

        aimBtn.MouseButton1Click:Connect(function()
            getgenv().ELITE_HUB_AimbotEnabled = not (getgenv().ELITE_HUB_AimbotEnabled or false)
            if getgenv().ELITE_HUB_AimbotConfig then
                getgenv().ELITE_HUB_AimbotConfig.Enabled = getgenv().ELITE_HUB_AimbotEnabled
            end
            updateAimVisual()
        end)

        updateAimVisual()
    end
end

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

_g().ELITE_HUB_NewOverlayLine = NewOverlayLine

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

_g().ELITE_HUB_NewOverlayCircle = NewOverlayCircle