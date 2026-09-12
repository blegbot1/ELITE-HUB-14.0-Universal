-- source: ELITE_HUB_14.0.lua ESP (lines 7111-9103)
local _g = getgenv
local Rayfield = _g().ELITE_HUB_Rayfield
local Window = _g().ELITE_HUB_Window
local ES = _g().EliteHubSettings
local L = _g().ELITE_HUB_L
local Log = _g().ELITE_HUB_Log
local Players = _g().ELITE_HUB_Players
local player = _g().ELITE_HUB_Player
local OverlayGui = _g().ELITE_HUB_OverlayGui
local LoadScript = _g().ELITE_HUB_LoadScript
local SafeNotify = _g().ELITE_HUB_SafeNotify
local DestroyScript = _g().ELITE_HUB_DestroyScript
local MT = Window
local ESPTab = _g().ELITE_HUB_ESPTab
local AimbotConfig = _g().ELITE_HUB_AimbotConfig
local NewOverlayCircle = _g().ELITE_HUB_NewOverlayCircle
local NewOverlayLine = _g().ELITE_HUB_NewOverlayLine
local IsFriend = _g().ELITE_HUB_IsFriend
local IsFriendName = _g().ELITE_HUB_IsFriendName
local GetPlayerRelation = _g().ELITE_HUB_GetPlayerRelation or _g().ELITE_HUB_GetTeamRelation or function() return "none" end
local UpdateSkeletonLines = _g().ELITE_HUB_UpdateSkeletonLines
local RunService = game:GetService("RunService")
local GetTargetPlayer = _g().ELITE_HUB_GetTargetPlayer
local CreateSkeletonLines = _g().ELITE_HUB_CreateSkeletonLines
local RemoveSkeletonLines = _g().ELITE_HUB_RemoveSkeletonLines

--[[
    ==============================
    РџРћР›РќР«Р™ ESP РЎ 3D BOX
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
    MaxESPDistance = 0,
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
    LowHPColor = Color3.fromRGB(255, 0, 0),
    WeaponDisplay = false,
    WeaponDisplayColor = Color3.fromRGB(255, 255, 255)
}

local ESPObjects = {}
local TracerLines = {}
local Box3DObjects = {}
local ESPArrows = {}
local ESPSkeletons = {}
local ESPHeadDots = {}
local ESPHealthBars = {}
getgenv().ELITE_HUB_ESPConfig = ESPConfig
getgenv().ELITE_HUB_ESPObjects = ESPObjects
getgenv().ELITE_HUB_TracerLines = TracerLines
getgenv().ELITE_HUB_Box3DObjects = Box3DObjects
getgenv().ELITE_HUB_ESPArrows = ESPArrows
getgenv().ELITE_HUB_ESPSkeletons = ESPSkeletons
getgenv().ELITE_HUB_ESPHeadDots = ESPHeadDots
getgenv().ELITE_HUB_ESPHealthBars = ESPHealthBars

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
                            local teamRel = GetPlayerRelation(targetPlayer)
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
getgenv().ELITE_HUB_IsTeammate = IsTeammate

local function GetWeaponInfo(targetPlayer)
    local char = targetPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not tool then
        local backpack = targetPlayer:FindFirstChild("Backpack")
        if backpack then
            tool = backpack:FindFirstChildOfClass("Tool")
        end
    end
    if tool then
        return tool.Name, tool.TextureId
    end
    return nil, nil
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
        local char = targetPlayer and targetPlayer.Character
        if not char then
            for _, l in ipairs(lines) do l.Visible = false end
        else
            local col = (targetPlayer == lockTarget) and AimbotConfig.LockedColor or ESPConfig.SkeletonColor
            UpdateSkeletonLines(char, lines, col, ESPConfig.SkeletonThickness, ESPConfig.SkeletonType)
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
        if ESPObjects[targetPlayer].WeaponBillboard then pcall(function() ESPObjects[targetPlayer].WeaponBillboard:Remove() end) end
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
    local teamRel = GetPlayerRelation(targetPlayer)
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

    if ESPConfig.WeaponDisplay and rootPart then
        local wBillboard = Instance.new("BillboardGui")
        wBillboard.Name = "ESP_Weapon_" .. targetPlayer.Name
        wBillboard.AlwaysOnTop = true
        wBillboard.ExtentsOffset = Vector3.new(0, -1.5, 0)
        wBillboard.Size = UDim2.new(0, 200, 0, 30)
        wBillboard.Adornee = rootPart
        wBillboard.Parent = rootPart

        local wFrame = Instance.new("Frame")
        wFrame.Size = UDim2.new(1, 0, 1, 0)
        wFrame.BackgroundTransparency = 1
        wFrame.Parent = wBillboard

        local wImg = Instance.new("ImageLabel")
        wImg.Name = "WeaponIcon"
        wImg.Size = UDim2.new(0, 24, 0, 24)
        wImg.Position = UDim2.new(0.5, -40, 0.5, -12)
        wImg.BackgroundTransparency = 1
        wImg.Image = ""
        wImg.Visible = false
        wImg.Parent = wFrame

        local wLabel = Instance.new("TextLabel")
        wLabel.Name = "WeaponText"
        wLabel.Size = UDim2.new(0, 80, 1, 0)
        wLabel.Position = UDim2.new(0.5, -40, 0, 0)
        wLabel.BackgroundTransparency = 1
        wLabel.TextColor3 = ESPConfig.WeaponDisplayColor
        wLabel.TextSize = 12
        wLabel.Font = Enum.Font.SourceSansBold
        wLabel.TextStrokeTransparency = 0
        wLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        wLabel.Text = ""
        wLabel.Parent = wFrame

        espGroup.WeaponBillboard = wBillboard
        espGroup.WeaponIcon = wImg
        espGroup.WeaponLabel = wLabel
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

    if espGroup._ancestryConn then pcall(function() espGroup._ancestryConn:Disconnect() end) end
    if espGroup._diedConn then pcall(function() espGroup._diedConn:Disconnect() end) end

    if character then
        espGroup._ancestryConn = character.AncestryChanged:Connect(function(_, parent)
            if not parent then ClearPlayerESP(targetPlayer) end
        end)
    end

    if humanoid then
        espGroup._diedConn = humanoid.Died:Connect(function()
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
                local teamRel = GetPlayerRelation(targetPlayer)
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

                if espGroup.WeaponLabel then
                    if ESPConfig.WeaponDisplay and not isDead then
                        local wName, wIcon = GetWeaponInfo(targetPlayer)
                        if wName then
                            if wIcon and wIcon ~= "" then
                                espGroup.WeaponIcon.Image = wIcon
                                espGroup.WeaponIcon.Visible = true
                                espGroup.WeaponLabel.Text = ""
                            else
                                espGroup.WeaponLabel.Text = wName
                                espGroup.WeaponIcon.Visible = false
                            end
                            espGroup.WeaponLabel.TextColor3 = fillColor
                            espGroup.WeaponLabel.Visible = true
                        else
                            espGroup.WeaponLabel.Visible = false
                            espGroup.WeaponIcon.Visible = false
                        end
                    else
                        espGroup.WeaponLabel.Visible = false
                        espGroup.WeaponIcon.Visible = false
                    end
                end
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
                for i = 1, 8 do
                    local sp = camera:WorldToViewportPoint(corners[i])
                    screenCorners[i] = Vector2.new(math.clamp(sp.X, 0, camera.ViewportSize.X), math.clamp(sp.Y, 0, camera.ViewportSize.Y))
                end
            end

            local connections = {
                {1, 2}, {2, 3}, {3, 4}, {4, 1}, -- РЅРёР¶РЅРёР№ РєРІР°РґСЂР°С‚
                {5, 6}, {6, 7}, {7, 8}, {8, 5}, -- РІРµСЂС…РЅРёР№ РєРІР°РґСЂР°С‚
                {1, 5}, {2, 6}, {3, 7}, {4, 8}  -- РІРµСЂС‚РёРєР°Р»СЊРЅС‹Рµ Р»РёРЅРёРё
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

local espUpdateDebounce = false
local function UpdateESP()
    if espUpdateDebounce then return end
    espUpdateDebounce = true
    task.delay(0.1, function() espUpdateDebounce = false end)
    local playersToClear = {}
    for targetPlayer, _ in pairs(ESPObjects) do
        table.insert(playersToClear, targetPlayer)
    end
    for _, tp in ipairs(playersToClear) do
        ClearPlayerESP(tp)
    end

    if not ESPConfig.Enabled then return end
    local maxDist = ESPConfig.MaxESPDistance or 0
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local skip = false
            if maxDist > 0 and myRoot then
                local char = targetPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - myRoot.Position).Magnitude > maxDist then
                    skip = true
                end
            end
            if skip then
                ClearPlayerESP(targetPlayer)
            else
                CreatePlayerESP(targetPlayer)
            end
        end
    end
end
getgenv().ELITE_HUB_UpdateESP = UpdateESP

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
    local playersToRemove = {}
    for targetPlayer, _ in pairs(ESPObjects) do
        if not Players:FindFirstChild(targetPlayer.Name) then
            table.insert(playersToRemove, targetPlayer)
        end
    end
    for _, tp in ipairs(playersToRemove) do
        ClearPlayerESP(tp)
        LK[tp] = nil
    end
end

local function InitializeESPHandlers()
    local LK = getgenv().ELITE_HUB_LastChars
    game.Players.PlayerAdded:Connect(function(targetPlayer)
        SafeNotify(" JOIN", targetPlayer.Name .. "   ", 2, "PlayerJoin")
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
        SafeNotify(" LEFT", targetPlayer.Name .. "   ", 2, "PlayerLeave")
        if targetPlayer == LockedTargetPlayer then
            SafeNotify(" UNLOCK", "   ", 2, "TargetLost")
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
ESPTab:CreateToggle({
    Name = " ESP ON/OFF",
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
                Title = "👁 ESP",
                Content = "  ESP ",
                Duration = 3
            })
        else
            local playersToClear2 = {}
            for targetPlayer, _ in pairs(ESPObjects) do
                table.insert(playersToClear2, targetPlayer)
            end
            for _, tp in ipairs(playersToClear2) do
                ClearPlayerESP(tp)
            end
            Rayfield:Notify({
                Title = "👁 ESP",
                Content = "ESP ",
                Duration = 2
            })
        end
    end
})

ESPTab:CreateToggle({
    Name = " Ignore team",
    CurrentValue = ESPConfig.TeamCheck,
    Callback = function(value)
        ESPConfig.TeamCheck = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " Show teammates",
    CurrentValue = ESPConfig.ShowTeammates,
    Callback = function(value)
        ESPConfig.ShowTeammates = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " Boxes",
    CurrentValue = ESPConfig.Boxes,
    Callback = function(value)
        ESPConfig.Boxes = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " Names",
    CurrentValue = ESPConfig.Names,
    Callback = function(value)
        ESPConfig.Names = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " Health",
    CurrentValue = ESPConfig.Health,
    Callback = function(value)
        ESPConfig.Health = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " Distance",
    CurrentValue = ESPConfig.Distance,
    Callback = function(value)
        ESPConfig.Distance = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " Tracers",
    CurrentValue = ESPConfig.Tracers,
    Callback = function(value)
        ESPConfig.Tracers = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " Teammate tracers",
    CurrentValue = ESPConfig.TracersForTeammates,
    Callback = function(value)
        ESPConfig.TracersForTeammates = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " Show dead",
    CurrentValue = ESPConfig.ShowDead,
    Callback = function(value)
        ESPConfig.ShowDead = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " 3D Box ESP",
    CurrentValue = ESPConfig.Box3DEnabled,
    Callback = function(value)
        ESPConfig.Box3DEnabled = value
        if not value then
            for targetPlayer, lines in pairs(Box3DObjects) do
                for _, line in ipairs(lines) do
                    line:Remove()
                end
            end
            for k in pairs(Box3DObjects) do Box3DObjects[k] = nil end
            getgenv().ELITE_HUB_Box3DObjects = Box3DObjects
        else
            UpdateESP()
        end
    end
})

ESPTab:CreateColorPicker({
    Name = " Enemy color",
    Color = ESPConfig.EnemyColor,
    Callback = function(value)
        ESPConfig.EnemyColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = " Teammate color",
    Color = ESPConfig.TeammateColor,
    Callback = function(value)
        ESPConfig.TeammateColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = " Dead color",
    Color = ESPConfig.DeadColor,
    Callback = function(value)
        ESPConfig.DeadColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = " 3D Box color",
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
    Name = " Text size",
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
    Name = " Line thickness",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = ESPConfig.TracerThickness,
    Callback = function(value)
        ESPConfig.TracerThickness = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = " 3D Box thickness",
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
    Name = " 3D Box size",
    Range = {0.5, 8.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = ESPConfig.Box3DSize,
    Callback = function(value)
        ESPConfig.Box3DSize = value
    end
})

ESPTab:CreateSlider({
    Name = " Box fill transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.FillTransparency,
    Callback = function(value)
        ESPConfig.FillTransparency = value
        UpdateESP()
    end
})

ESPTab:CreateSection("⬅ ARROWS (off-screen pointers)")

ESPTab:CreateToggle({
    Name = " Show arrows off-screen",
    CurrentValue = ESPConfig.ShowArrows,
    Callback = function(value)
        ESPConfig.ShowArrows = value
    end
})

ESPTab:CreateColorPicker({
    Name = " Arrow color",
    Color = ESPConfig.ArrowsColor,
    Callback = function(value)
        ESPConfig.ArrowsColor = value
        for _, lines in pairs(ESPArrows) do
            for _, l in ipairs(lines) do l.Color = value end
        end
    end
})

ESPTab:CreateSection("🎨 TEXT & TRACER COLORS")

ESPTab:CreateColorPicker({
    Name = " Name color",
    Color = ESPConfig.TextColor,
    Callback = function(value)
        ESPConfig.TextColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = " Tracer color (players)",
    Color = ESPConfig.TracerColor,
    Callback = function(value)
        ESPConfig.TracerColor = value
        for targetPlayer, tracer in pairs(TracerLines) do
            if tracer then pcall(function() tracer.Color = value end) end
        end
    end
})

ESPTab:CreateSection("📸 SNAP LINES (wallhack)")

ESPTab:CreateToggle({
    Name = " Enable snap lines",
    CurrentValue = ESPConfig.SnapLines,
    Callback = function(value)
        ESPConfig.SnapLines = value
    end
})

ESPTab:CreateColorPicker({
    Name = " Snap line color",
    Color = ESPConfig.SnapLinesColor,
    Callback = function(value)
        ESPConfig.SnapLinesColor = value
        for _, line in pairs(ESPContentSnapLines) do
            if line then line.Color = value end
        end
    end
})

ESPTab:CreateSection("🎯 AIMBOT TARGET HIGHLIGHT")

ESPTab:CreateToggle({
    Name = " Highlight Aimbot target",
    CurrentValue = ESPConfig.HighlightLockTarget,
    Callback = function(value)
        ESPConfig.HighlightLockTarget = value
    end
})

ESPTab:CreateColorPicker({
    Name = " Aimbot target highlight color",
    Color = ESPConfig.LockTargetColor,
    Callback = function(value)
        ESPConfig.LockTargetColor = value
    end
})

ESPTab:CreateSection("💀 SKELETON")

ESPTab:CreateToggle({
    Name = " Show skeletons",
    CurrentValue = ESPConfig.Skeletons,
    Callback = function(value)
        ESPConfig.Skeletons = value
    end
})

ESPTab:CreateColorPicker({
    Name = " Skeleton color",
    Color = ESPConfig.SkeletonColor,
    Callback = function(value)
        ESPConfig.SkeletonColor = value
    end
})

ESPTab:CreateSlider({
    Name = " Skeleton thickness",
    Range = {1, 4},
    Increment = 1,
    CurrentValue = ESPConfig.SkeletonThickness,
    Callback = function(value)
        ESPConfig.SkeletonThickness = value
    end
})

ESPTab:CreateDropdown({
    Name = " Skeleton type",
    Options = {"R15 / R6"},
    CurrentOption = {"R15 / R6"},
    Callback = function(value)
        ESPConfig.SkeletonType = 2
    end
})

ESPTab:CreateSection("➕ EXTRA")

ESPTab:CreateToggle({
    Name = " Weapon Display",
    CurrentValue = ESPConfig.WeaponDisplay,
    Callback = function(value)
        ESPConfig.WeaponDisplay = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = " Weapon color",
    Color = ESPConfig.WeaponDisplayColor,
    Callback = function(value)
        ESPConfig.WeaponDisplayColor = value
    end
})

ESPTab:CreateSlider({
    Name = " Max ESP distance",
    Range = {0, 1000},
    Increment = 25,
    Suffix = " studs (0 = ∞)",
    CurrentValue = ESPConfig.MaxESPDistance,
    Callback = function(value)
        ESPConfig.MaxESPDistance = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = " Dots on heads",
    CurrentValue = ESPConfig.HeadDots,
    Callback = function(value)
        ESPConfig.HeadDots = value
    end
})

ESPTab:CreateColorPicker({
    Name = " Head dots color",
    Color = ESPConfig.HeadDotColor,
    Callback = function(value)
        ESPConfig.HeadDotColor = value
    end
})

ESPTab:CreateSlider({
    Name = " Head dots size",
    Range = {3, 12},
    Increment = 1,
    Suffix = " px",
    CurrentValue = ESPConfig.HeadDotSize,
    Callback = function(value)
        ESPConfig.HeadDotSize = value
    end
})

ESPTab:CreateToggle({
    Name = " ELITE HUB tag over players",
    CurrentValue = ESPConfig.ShowScriptUserTag,
    Callback = function(value)
        ESPConfig.ShowScriptUserTag = value
    end
})

ESPTab:CreateColorPicker({
    Name = " Script tag color",
    Color = ESPConfig.ScriptUserTagColor,
    Callback = function(value)
        ESPConfig.ScriptUserTagColor = value
    end
})

ESPTab:CreateToggle({
    Name = " HP bar under player",
    CurrentValue = ESPConfig.ShowHealthBar,
    Callback = function(value)
        ESPConfig.ShowHealthBar = value
    end
})

ESPTab:CreateColorPicker({
    Name = " HP bar color",
    Color = ESPConfig.HealthBarColor,
    Callback = function(v)
        ESPConfig.HealthBarColor = v
    end
})

ESPTab:CreateToggle({
    Name = " Highlight closest enemy",
    CurrentValue = ESPConfig.HighlightClosest,
    Callback = function(value)
        ESPConfig.HighlightClosest = value
    end
})

ESPTab:CreateColorPicker({
    Name = " Closest highlight color",
    Color = ESPConfig.HighlightClosestColor,
    Callback = function(value)
        ESPConfig.HighlightClosestColor = value
    end
})

-- (управление друзьями/врагами перенесено во вкладку ИГРОКИ)

ESPTab:CreateSection("🔔 ESP NOTIFICATIONS")

ESPTab:CreateToggle({
    Name = " ESP: notifications on",
    CurrentValue = AimbotConfig.NotifyPlayerJoin,
    Callback = function(value)
        AimbotConfig.NotifyPlayerJoin = value
        AimbotConfig.NotifyPlayerLeave = value
    end
})

ESPTab:CreateToggle({
    Name = " Notify on player join",
    CurrentValue = AimbotConfig.NotifyPlayerJoin,
    Callback = function(value)
        AimbotConfig.NotifyPlayerJoin = value
    end
})

ESPTab:CreateToggle({
    Name = " Notify on player leave",
    CurrentValue = AimbotConfig.NotifyPlayerLeave,
    Callback = function(value)
        AimbotConfig.NotifyPlayerLeave = value
    end
})

ESPTab:CreateToggle({
    Name = " Notify on target leave",
    CurrentValue = AimbotConfig.NotifyTargetLost,
    Callback = function(value)
        AimbotConfig.NotifyTargetLost = value
    end
})

ESPTab:CreateSection("👁 VISUAL FEATURES")

ESPTab:CreateToggle({
    Name = " Low HP warning",
    CurrentValue = ESPConfig.LowHPWarning,
    Callback = function(value)
        ESPConfig.LowHPWarning = value
    end
})

ESPTab:CreateSlider({
    Name = " Low HP threshold (%)",
    Range = {5, 60},
    Increment = 5,
    Suffix = "%",
    CurrentValue = ESPConfig.LowHPThreshold,
    Callback = function(value)
        ESPConfig.LowHPThreshold = value
    end
})

ESPTab:CreateColorPicker({
    Name = " Vignette Color",
    Color = ESPConfig.LowHPColor,
    Callback = function(color)
        ESPConfig.LowHPColor = color
    end
})

ESPTab:CreateToggle({
    Name = " Pulse ring around target",
    CurrentValue = AimbotConfig.PulseTarget,
    Callback = function(value)
        AimbotConfig.PulseTarget = value
    end
})

ESPTab:CreateColorPicker({
    Name = " Pulse ring color",
    Color = AimbotConfig.PulseColor,
    Callback = function(color)
        AimbotConfig.PulseColor = color
    end
})

ESPTab:CreateSlider({
    Name = " Pulse radius",
    Range = {20, 200},
    Increment = 5,
    Suffix = "px",
    CurrentValue = AimbotConfig.PulseSize,
    Callback = function(value)
        AimbotConfig.PulseSize = value
    end
})

ESPTab:CreateSlider({
    Name = " Pulse speed",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = AimbotConfig.PulseSpeed,
    Callback = function(value)
        AimbotConfig.PulseSpeed = value
    end
})