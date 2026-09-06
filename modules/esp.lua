-- ELITE HUB 14.0 — ESP Module
-- Extracted from ELITE_HUB_14.0.lua
--[[
    ==============================
    ПОЛНЫЙ ESP С 3D BOX
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
                    text = text .. targetPlayer.Name .. (isDead and " 💀" or "") .. "\n"
                end

                if not isDead or ESPConfig.ShowDead then
                    if ESPConfig.Health and humanoid then
                        text = text .. (isDead and "💀 МЕРТВ\n" or "❤ " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. "\n")
                    end

                    if ESPConfig.Distance and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local localRoot = player.Character.HumanoidRootPart
                        if localRoot then
                            local distance = (localRoot.Position - rootPart.Position).Magnitude
                            text = text .. "📏 " .. math.floor(distance) .. "m"
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
                {1, 2}, {2, 3}, {3, 4}, {4, 1}, -- нижний квадрат
                {5, 6}, {6, 7}, {7, 8}, {8, 5}, -- верхний квадрат
                {1, 5}, {2, 6}, {3, 7}, {4, 8}  -- вертикальные линии
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
        SafeNotify("👋 JOIN", targetPlayer.Name .. " зашёл на сервер", 2, "PlayerJoin")
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
        SafeNotify("👋 LEFT", targetPlayer.Name .. " вышел с сервера", 2, "PlayerLeave")
        if targetPlayer == LockedTargetPlayer then
            SafeNotify("❌ UNLOCK", "Цель вышла с сервера", 2, "TargetLost")
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
    Name = "👁️ ESP ON/OFF",
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
                Title = "👁️ ESP ВКЛЮЧЁН",
                Content = "Все функции ESP активированы",
                Duration = 3
            })
        else
            for targetPlayer, _ in pairs(ESPObjects) do
                ClearPlayerESP(targetPlayer)
            end
            Rayfield:Notify({
                Title = "👀 ESP ВЫКЛЮЧЕН",
                Content = "ESP деактивирован",
                Duration = 2
            })
        end
    end
})

ESPTab:CreateToggle({
    Name = "👥 Ignore team",
    CurrentValue = ESPConfig.TeamCheck,
    Callback = function(value)
        ESPConfig.TeamCheck = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "💚 Show teammates",
    CurrentValue = ESPConfig.ShowTeammates,
    Callback = function(value)
        ESPConfig.ShowTeammates = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "🟦 Boxes",
    CurrentValue = ESPConfig.Boxes,
    Callback = function(value)
        ESPConfig.Boxes = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "📛 Names",
    CurrentValue = ESPConfig.Names,
    Callback = function(value)
        ESPConfig.Names = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "❤ Health",
    CurrentValue = ESPConfig.Health,
    Callback = function(value)
        ESPConfig.Health = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "📏 Distance",
    CurrentValue = ESPConfig.Distance,
    Callback = function(value)
        ESPConfig.Distance = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "➖ Tracers",
    CurrentValue = ESPConfig.Tracers,
    Callback = function(value)
        ESPConfig.Tracers = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "🧵 Teammate tracers",
    CurrentValue = ESPConfig.TracersForTeammates,
    Callback = function(value)
        ESPConfig.TracersForTeammates = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "💀 Show dead",
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
    Name = "🔴 Enemy color",
    Color = ESPConfig.EnemyColor,
    Callback = function(value)
        ESPConfig.EnemyColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "💚 Teammate color",
    Color = ESPConfig.TeammateColor,
    Callback = function(value)
        ESPConfig.TeammateColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "💀 Dead color",
    Color = ESPConfig.DeadColor,
    Callback = function(value)
        ESPConfig.DeadColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "🎯 3D Box color",
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
    Name = "🔢 Text size",
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
    Name = "🌫️ Transparency",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = ESPConfig.FillTransparency,
    Callback = function(value)
        ESPConfig.FillTransparency = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = "📏 Line thickness",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = ESPConfig.TracerThickness,
    Callback = function(value)
        ESPConfig.TracerThickness = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = "🎯 3D Box thickness",
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
    Name = "📐 3D Box size",
    Range = {0.5, 5.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = ESPConfig.Box3DSize,
    Callback = function(value)
        ESPConfig.Box3DSize = value
    end
})

ESPTab:CreateLabel("⚡ Frequency: min (0.05 sec)")

ESPTab:CreateSlider({
    Name = "🎭 Box fill transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.FillTransparency,
    Callback = function(value)
        ESPConfig.FillTransparency = value
        UpdateESP()
    end
})

ESPTab:CreateSlider({
    Name = "🟢 3D Box size (multiplier)",
    Range = {0.5, 8.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = ESPConfig.Box3DSize,
    Callback = function(value)
        ESPConfig.Box3DSize = value
    end
})

ESPTab:CreateSection("🧭 ARROWS (off-screen pointers)")

ESPTab:CreateToggle({
    Name = "🧭 Show arrows off-screen",
    CurrentValue = ESPConfig.ShowArrows,
    Callback = function(value)
        ESPConfig.ShowArrows = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🎨 Arrow color",
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
    Name = "🔤 Name color",
    Color = ESPConfig.TextColor,
    Callback = function(value)
        ESPConfig.TextColor = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "📏 Tracer color (players)",
    Color = ESPConfig.TracerColor,
    Callback = function(value)
        ESPConfig.TracerColor = value
        for targetPlayer, tracer in pairs(TracerLines) do
            tracer.Color = value
        end
    end
})

ESPTab:CreateSection("📍 SNAP LINES (wallhack)")

ESPTab:CreateToggle({
    Name = "📍 Enable snap lines",
    CurrentValue = ESPConfig.SnapLines,
    Callback = function(value)
        ESPConfig.SnapLines = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🎨 Snap line color",
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
    Name = "🎯 Highlight Aimbot target",
    CurrentValue = ESPConfig.HighlightLockTarget,
    Callback = function(value)
        ESPConfig.HighlightLockTarget = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🎨 Aimbot target highlight color",
    Color = ESPConfig.LockTargetColor,
    Callback = function(value)
        ESPConfig.LockTargetColor = value
    end
})

ESPTab:CreateSection("🦴 SKELETON")

ESPTab:CreateToggle({
    Name = "🦴 Show skeletons",
    CurrentValue = ESPConfig.Skeletons,
    Callback = function(value)
        ESPConfig.Skeletons = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🎨 Skeleton color",
    Color = ESPConfig.SkeletonColor,
    Callback = function(value)
        ESPConfig.SkeletonColor = value
    end
})

ESPTab:CreateSlider({
    Name = "📏 Skeleton thickness",
    Range = {1, 4},
    Increment = 1,
    CurrentValue = ESPConfig.SkeletonThickness,
    Callback = function(value)
        ESPConfig.SkeletonThickness = value
    end
})

ESPTab:CreateDropdown({
    Name = "🦴 Skeleton type",
    Options = {"1 - Simple", "2 - Full"},
    CurrentOption = "1 - Simple",
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        if v == "2 - Full" then
            ESPConfig.SkeletonType = 2
        else
            ESPConfig.SkeletonType = 1
        end
    end
})

ESPTab:CreateSection("🔴 EXTRA")

ESPTab:CreateToggle({
    Name = "🔴 Dots on heads",
    CurrentValue = ESPConfig.HeadDots,
    Callback = function(value)
        ESPConfig.HeadDots = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🎨 Head dots color",
    Color = ESPConfig.HeadDotColor,
    Callback = function(value)
        ESPConfig.HeadDotColor = value
    end
})

ESPTab:CreateSlider({
    Name = "📐 Head dots size",
    Range = {3, 12},
    Increment = 1,
    Suffix = " px",
    CurrentValue = ESPConfig.HeadDotSize,
    Callback = function(value)
        ESPConfig.HeadDotSize = value
    end
})

ESPTab:CreateToggle({
    Name = "🏷️ ELITE HUB tag over players",
    CurrentValue = ESPConfig.ShowScriptUserTag,
    Callback = function(value)
        ESPConfig.ShowScriptUserTag = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🎨 Script tag color",
    Color = ESPConfig.ScriptUserTagColor,
    Callback = function(value)
        ESPConfig.ScriptUserTagColor = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSection("💎 PLAYER CHAMS")

task.spawn(function()
getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "💎 Enable Chams",
    CurrentValue = ESPConfig.ChamsEnabled,
    Callback = function(value)
        ESPConfig.ChamsEnabled = value
        getgenv().ELITE_HUB_Log("CHAMS", "Chams: " .. tostring(value))
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateColorPicker({
    Name = "🎨 Fill color",
    Color = ESPConfig.ChamsFillColor,
    Callback = function(value)
        ESPConfig.ChamsFillColor = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = "🔍 Fill transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.ChamsFillTransparency,
    Callback = function(value)
        ESPConfig.ChamsFillTransparency = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateColorPicker({
    Name = "🎨 Outline color",
    Color = ESPConfig.ChamsOutlineColor,
    Callback = function(value)
        ESPConfig.ChamsOutlineColor = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = "🔍 Outline transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.ChamsOutlineTransparency,
    Callback = function(value)
        ESPConfig.ChamsOutlineTransparency = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateDropdown({
    Name = "🧊 Chams material",
    Options = {"ForceField", "Neon", "Glass", "SmoothPlastic", "Plastic", "Wood", "DiamondPlate", "Foil", "Ice", "Brick", "Cobblestone", "CorrodedMetal", "Grass", "Sand", "Slate", "Marble", "Granite", "Limestone"},
    CurrentOption = "ForceField",
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        ESPConfig.ChamsMaterial = Enum.Material[v] or Enum.Material.ForceField
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "👥 Team check",
    CurrentValue = ESPConfig.ChamsTeamCheck,
    Callback = function(value)
        ESPConfig.ChamsTeamCheck = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "👤 Show on self",
    CurrentValue = ESPConfig.ChamsSelf,
    Callback = function(value)
        ESPConfig.ChamsSelf = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "🤝 Show on teammates",
    CurrentValue = ESPConfig.ChamsTeammates,
    Callback = function(value)
        ESPConfig.ChamsTeammates = value
    end
})
end)

getgenv().ELITE_HUB_ChamsTab:CreateSection("🌈 RAINBOW CHAMS")

getgenv().ELITE_HUB_RainbowChams = false
getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "🌈 Rainbow Chams",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RainbowChams = value
        getgenv().ELITE_HUB_Log("CHAMS", "Rainbow Chams: " .. tostring(value))
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

ESPTab:CreateToggle({
    Name = "💚 HP bar under player",
    CurrentValue = ESPConfig.ShowHealthBar,
    Callback = function(value)
        ESPConfig.ShowHealthBar = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🌈 HP bar color",
    Color = ESPConfig.HealthBarColor,
    Callback = function(v)
        ESPConfig.HealthBarColor = v
    end
})

ESPTab:CreateToggle({
    Name = "🎯 Highlight closest enemy",
    CurrentValue = ESPConfig.HighlightClosest,
    Callback = function(value)
        ESPConfig.HighlightClosest = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🎨 Closest highlight color",
    Color = ESPConfig.HighlightClosestColor,
    Callback = function(value)
        ESPConfig.HighlightClosestColor = value
    end
})

ESPTab:CreateSection("👥 TEAMS (friends / enemies)")

local espMyTeamLabel = ESPTab:CreateLabel("🎖️ Your team: —")
local function UpdateEspMyTeamLabel()
    local tn = GetTeamName(player)
    pcall(function()
        espMyTeamLabel:Set("🎖️ Ваша команда: " .. (tn or "нет"))
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
    Name = "🎖️ Team",
    Options = GetAllTeamNames(),
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        espSelectedTeam = n or ""
    end
})

ESPTab:CreateLabel("🤝 Friendly = blue, enemy = red")

ESPTab:CreateButton({
    Name = "✅ Make team friendly",
    Callback = function()
        local n = espSelectedTeam
        if not n or n == "" then
            Rayfield:Notify({ Title = "👥 Команды", Content = "Сначала выберите команду в списке", Duration = 2 })
            return
        end
        local res = ToggleFriendTeam(n)
        if res == "added" then
            Rayfield:Notify({ Title = "🤝 Команда-друг", Content = n .. " теперь в дружественных", Duration = 2 })
        else
            Rayfield:Notify({ Title = "👥 Команда", Content = n .. " убрана из дружественных (враг)", Duration = 2 })
        end
        pcall(RefreshEspTeamDD)
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "❌ Remove team from friends (enemy)",
    Callback = function()
        local n = espSelectedTeam
        if not n or n == "" then
            Rayfield:Notify({ Title = "👥 Команды", Content = "Сначала выберите команду в списке", Duration = 2 })
            return
        end
        local list = getgenv().ELITE_HUB_FRIEND_TEAMS
        for i = #list, 1, -1 do
            if tostring(list[i]):lower() == n:lower() then
                table.remove(list, i)
            end
        end
        Rayfield:Notify({ Title = "⚔️ Команда-враг", Content = n .. " теперь вражеская", Duration = 2 })
        pcall(RefreshEspTeamDD)
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "📜 Friendly teams",
    Callback = function()
        local list = getgenv().ELITE_HUB_FRIEND_TEAMS
        if #list == 0 then
            Rayfield:Notify({ Title = "👥 Команды", Content = "Нет дружественных команд (все враги)", Duration = 2 })
        else
            Rayfield:Notify({ Title = "🤝 Дружественные", Content = table.concat(list, ", "), Duration = 5 })
        end
    end
})

ESPTab:CreateButton({
    Name = "🚫 All teams — enemies",
    Callback = function()
        getgenv().ELITE_HUB_FRIEND_TEAMS = {}
        Rayfield:Notify({ Title = "⚔️ Готово", Content = "Все команды теперь враги", Duration = 2 })
        pcall(RefreshEspTeamDD)
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "🔄 Refresh team list",
    Callback = function()
        pcall(RefreshEspTeamDD)
        Rayfield:Notify({ Title = "👥 Команды", Content = "Список команд обновлён", Duration = 2 })
    end
})

task.spawn(function()
    while true do
        task.wait(1)
        UpdateEspMyTeamLabel()
    end
end)

ESPTab:CreateSection("🤝 FRIENDS & TARGET (select from list)")

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
        local opts = {"(Авто)"}
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
    Name = "🚫 Hide friends in ESP",
    CurrentValue = ESPConfig.FriendCheck,
    Flag = "ESPFriendCheck",
    Callback = function(value)
        ESPConfig.FriendCheck = value
        UpdateESP()
    end
})

ESPTab:CreateToggle({
    Name = "🎯 Highlight main target",
    CurrentValue = ESPConfig.HighlightTarget,
    Flag = "ESPHighlightTarget",
    Callback = function(value)
        ESPConfig.HighlightTarget = value
        UpdateESP()
    end
})

ESPTab:CreateColorPicker({
    Name = "🔵 Friends / target color",
    Color = ESPConfig.FriendColor,
    Callback = function(value)
        ESPConfig.FriendColor = value
        UpdateESP()
    end
})

espFriendAddDD = ESPTab:CreateDropdown({
    Name = "➕ Add player to friends",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        if not n or n == "" then return end
        if IsFriendName(n) then
            Rayfield:Notify({ Title = "🤝 Друзья", Content = n .. " уже в списке", Duration = 2 })
        else
            table.insert(getgenv().ELITE_HUB_FRIENDS, n)
            Rayfield:Notify({ Title = "✅ Друг добавлен", Content = n, Duration = 2 })
        end
        if espFriendAddDD then pcall(function() espFriendAddDD:Clear() end) end
        RefreshESPDD()
        UpdateESP()
    end
})

espFriendRmDD = ESPTab:CreateDropdown({
    Name = "➖ Remove friend (select)",
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
                Rayfield:Notify({ Title = "🗑️ Друг удалён", Content = n, Duration = 2 })
                break
            end
        end
        if espFriendRmDD then pcall(function() espFriendRmDD:Clear() end) end
        RefreshESPDD()
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "🧹 Clear friends list",
    Callback = function()
        local cnt = #getgenv().ELITE_HUB_FRIENDS
        getgenv().ELITE_HUB_FRIENDS = {}
        Rayfield:Notify({ Title = "🧹 Готово", Content = "Удалено друзей: " .. cnt, Duration = 2 })
        RefreshESPDD()
        UpdateESP()
    end
})

ESPTab:CreateButton({
    Name = "📜 Show friends list",
    Callback = function()
        local list = getgenv().ELITE_HUB_FRIENDS
        if #list == 0 then
            Rayfield:Notify({ Title = "🤝 Друзья", Content = "Список пуст", Duration = 2 })
            return
        end
        Rayfield:Notify({ Title = "🤝 Список друзей", Content = table.concat(list, ", "), Duration = 6 })
    end
})

espTargetDD = ESPTab:CreateDropdown({
    Name = "🎯 Main target (highlight)",
    Options = {"(Авто)"},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        if n == "(Авто)" or n == nil or n == "" then
            getgenv().ELITE_HUB_TARGET_NAME = ""
            Rayfield:Notify({ Title = "🎯 Цель", Content = "Авто (нет приоритета)", Duration = 2 })
        else
            getgenv().ELITE_HUB_TARGET_NAME = n
            Rayfield:Notify({ Title = "🎯 Цель установлена", Content = n, Duration = 2 })
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

ESPTab:CreateSection("🔔 ESP NOTIFICATIONS")

ESPTab:CreateToggle({
    Name = "🔔 ESP: notifications on",
    CurrentValue = AimbotConfig.NotifyPlayerJoin,
    Callback = function(value)
        AimbotConfig.NotifyPlayerJoin = value
        AimbotConfig.NotifyPlayerLeave = value
    end
})

ESPTab:CreateToggle({
    Name = "👋 Notify on player join",
    CurrentValue = AimbotConfig.NotifyPlayerJoin,
    Callback = function(value)
        AimbotConfig.NotifyPlayerJoin = value
    end
})

ESPTab:CreateToggle({
    Name = "👋 Notify on player leave",
    CurrentValue = AimbotConfig.NotifyPlayerLeave,
    Callback = function(value)
        AimbotConfig.NotifyPlayerLeave = value
    end
})

ESPTab:CreateToggle({
    Name = "❌ Notify on target leave",
    CurrentValue = AimbotConfig.NotifyTargetLost,
    Callback = function(value)
        AimbotConfig.NotifyTargetLost = value
    end
})

ESPTab:CreateSection("🎨 VISUAL FEATURES")

ESPTab:CreateToggle({
    Name = "💀 Low HP warning",
    CurrentValue = ESPConfig.LowHPWarning,
    Callback = function(value)
        ESPConfig.LowHPWarning = value
    end
})

ESPTab:CreateSlider({
    Name = "❤️ Low HP threshold (%)",
    Range = {5, 60},
    Increment = 5,
    Suffix = "%",
    CurrentValue = ESPConfig.LowHPThreshold,
    Callback = function(value)
        ESPConfig.LowHPThreshold = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🔴 Vignette Color",
    Color = ESPConfig.LowHPColor,
    Callback = function(color)
        ESPConfig.LowHPColor = color
    end
})

ESPTab:CreateToggle({
    Name = "💫 Pulse ring around target",
    CurrentValue = AimbotConfig.PulseTarget,
    Callback = function(value)
        AimbotConfig.PulseTarget = value
    end
})

ESPTab:CreateColorPicker({
    Name = "🌈 Pulse ring color",
    Color = AimbotConfig.PulseColor,
    Callback = function(color)
        AimbotConfig.PulseColor = color
    end
})

ESPTab:CreateSlider({
    Name = "📐 Pulse radius",
    Range = {20, 200},
    Increment = 5,
    Suffix = "px",
    CurrentValue = AimbotConfig.PulseSize,
    Callback = function(value)
        AimbotConfig.PulseSize = value
    end
})

ESPTab:CreateSlider({
    Name = "⚡ Pulse speed",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = AimbotConfig.PulseSpeed,
    Callback = function(value)
        AimbotConfig.PulseSpeed = value
    end
})

ESPTab:CreateToggle({
    Name = "📊 Target HP bar above head",
    CurrentValue = AimbotConfig.TargetHealthBarTop,
    Callback = function(value)
        AimbotConfig.TargetHealthBarTop = value
    end
})

ESPTab:CreateToggle({
    Name = "📌 Pin HP bar to head",
    CurrentValue = AimbotConfig.TargetHealthBarMounted,
    Callback = function(value)
        AimbotConfig.TargetHealthBarMounted = value
    end
})

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
