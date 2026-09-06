-- ELITE HUB 14.0 — Aimbot Module
-- Extracted from ELITE_HUB_14.0.lua

--[[
    ==============================
    УЛУЧШЕННЫЙ AIMBOT С ПРИОРИТЕТОМ ПО ДИСТАНЦИИ
    ==============================
]]--
local AimbotSection = CombatTab:CreateSection("🎯 IMPROVED AIMBOT 3D FOV")
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
    ShowTargetArrow = false,
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
        TargetNameLabel.Text = "🔴 " .. name .. hpText .. distText
        TargetNameLabel.TextColor3 = AimbotConfig.TargetCircleColor
    else
        TargetNameLabel.Visible = false
    end

    if AimbotConfig.ShowTargetNameBig then
        TargetBigNameLabel.Visible = true
        TargetBigNameLabel.Text = "🎯 " .. name .. hpText .. distText
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

    if false and AimbotConfig.ShowTargetArrow and onScreen then
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
        LockedTargetPlayer = nil -- цель умерла / ушла с экрана -> отпускаем
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
    Log("AIMBOT", "Цикл аимбота запущен")
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
                        SafeNotify("🎯 LOCK", LockedTargetPlayer.Name, 1.5, "Lock")
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
                                SafeNotify("🧠 ANTI-AIM", LockedTargetPlayer.Name .. " повёрнут спиной!", 2, "AntiAim")
                            end
                        end
                    end

                    if LockedTargetPlayer then
                        local ch = LockedTargetPlayer.Character
                        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 and hum.Health < 30 then
                            SafeNotify("💥 LOW HP", LockedTargetPlayer.Name .. " — " .. math.floor(hum.Health) .. " HP!", 1, "LowHP")
                        end
                    end

                    if AimbotConfig.KillNotify and LockedTargetPlayer then
                        local ch = LockedTargetPlayer.Character
                        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local oldHP = PreviousTargetHP[LockedTargetPlayer]
                            if oldHP and oldHP > 0 and hum.Health <= 0 then
                                SafeNotify("💀 KILL", LockedTargetPlayer.Name .. " убит!", 2, "Kill")
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
                                SafeNotify("🔫 SHOT", LockedTargetPlayer.Name, 0.5, "Shot")
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
                        SafeNotify("❌ UNLOCK", "Цель потеряна", 1.5, "Unlock")
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
    Name = "🎯 Enable Aimbot",
    CurrentValue = AimbotConfig.Enabled,
    Flag = "AimbotEnabled",
    Callback = function(value)
        AimbotConfig.Enabled = value
        getgenv().ELITE_HUB_AimbotEnabled = value
        Log("AIMBOT", "Aimbot включен: " .. tostring(value))
        if value then
            if FOVCircle then FOVCircle.Visible = true end
            Rayfield:Notify({
                Title = "🎯 Aimbot ВКЛЮЧЁН",
                Content = "Зажмите ПКМ для прицеливания",
                Duration = 3
            })
        else
            if FOVCircle then FOVCircle.Visible = false end
            Running = false
            LockedTarget = nil
            Rayfield:Notify({
                Title = "🎯 Aimbot ВЫКЛЮЧЕН",
                Content = "Авто-прицеливание отключено",
                Duration = 2
            })
        end
    end
})

CombatTab:CreateToggle({
    Name = "👥 Ignore team",
    CurrentValue = AimbotConfig.TeamCheck,
    Callback = function(value)
        AimbotConfig.TeamCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "💀 Don't aim at dead",
    CurrentValue = AimbotConfig.AliveCheck,
    Callback = function(value)
        AimbotConfig.AliveCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "🧱 Don't aim through walls",
    CurrentValue = AimbotConfig.WallCheck,
    Callback = function(value)
        AimbotConfig.WallCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "👁️ First-person fix",
    CurrentValue = AimbotConfig.ThirdPersonFix,
    Callback = function(value)
        AimbotConfig.ThirdPersonFix = value
    end
})

CombatTab:CreateDropdown({
    Name = "🎯 Target priority",
    Options = {"Distance", "FOV", "Health"},
    CurrentOption = AimbotConfig.Priority,
    Callback = function(option)
        AimbotConfig.Priority = option
        if option == "Distance" then
            Rayfield:Notify({
                Title = "🎯 Приоритет: ДИСТАНЦИЯ",
                Content = "Целится в ближайшего игрока",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "🎯 Приоритет: FOV",
                Content = "Целится в ближайшего к курсору",
                Duration = 3
            })
        end
    end
})

CombatTab:CreateSlider({
    Name = "🔘 FOV Size",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = AimbotConfig.FOV,
    Callback = function(value)
        AimbotConfig.FOV = value
    end
})

CombatTab:CreateColorPicker({
    Name = "💜 FOV Color",
    Color = AimbotConfig.FOVColor,
    Callback = function(value)
        AimbotConfig.FOVColor = value
    end
})

CombatTab:CreateColorPicker({
    Name = "🔴 Lock Color",
    Color = AimbotConfig.LockedColor,
    Callback = function(value)
        AimbotConfig.LockedColor = value
    end
})

CombatTab:CreateSection("⚙️ EXTRA AIMBOT SETTINGS")

CombatTab:CreateToggle({
    Name = "👁️ Show FOV circle",
    CurrentValue = AimbotConfig.ShowFOV,
    Flag = "AimbotShowFOV",
    Callback = function(value)
        AimbotConfig.ShowFOV = value
        if FOVCircle then FOVCircle.Visible = value and AimbotConfig.Enabled end
    end
})

CombatTab:CreateToggle({
    Name = "🔁 Mode: Toggle / Hold",
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
    Name = "🖱️ Target key",
    Options = {"MouseButton2", "MouseButton1", "LeftControl", "X", "C", "F", "V", "Shift"},
    CurrentOption = AimbotConfig.TriggerKey,
    Callback = function(option)
        AimbotConfig.TriggerKey = option
        Rayfield:Notify({
            Title = "🖱️ Target key",
            Content = "Новая клавиша: " .. option,
            Duration = 2
        })
    end
})

CombatTab:CreateSlider({
    Name = "📏 Max target distance (studs)",
    Range = {10, 1000},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = AimbotConfig.MaxDistance,
    Callback = function(value)
        AimbotConfig.MaxDistance = value
    end
})

CombatTab:CreateSlider({
    Name = "📍 Min target distance (studs)",
    Range = {0, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = AimbotConfig.MinDistance,
    Callback = function(value)
        AimbotConfig.MinDistance = value
    end
})

CombatTab:CreateSlider({
    Name = "⚖️ Aim offset Y",
    Range = {-3, 3},
    Increment = 0.1,
    Suffix = " studs",
    CurrentValue = AimbotConfig.AimOffset,
    Callback = function(value)
        AimbotConfig.AimOffset = value
    end
})

CombatTab:CreateSlider({
    Name = "🪶 FOV circle thickness",
    Range = {1, 10},
    Increment = 1,
    Suffix = " px",
    CurrentValue = AimbotConfig.FOVThickness,
    Callback = function(value)
        AimbotConfig.FOVThickness = value
    end
})

CombatTab:CreateSlider({
    Name = "🎯 Precise FOV size",
    Range = {1, 400},
    Increment = 1,
    Suffix = " px",
    CurrentValue = AimbotConfig.FOV,
    Callback = function(value)
        AimbotConfig.FOV = value
    end
})

CombatTab:CreateDropdown({
    Name = "🎯 Body part to aim at",
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},
    CurrentOption = AimbotConfig.LockPart,
    Callback = function(option)
        AimbotConfig.LockPart = option
    end
})

CombatTab:CreateSection("🎯 TARGET INDICATOR")

CombatTab:CreateToggle({
    Name = "🔴 Show target name & HP",
    CurrentValue = AimbotConfig.ShowTargetIndicator,
    Callback = function(value)
        AimbotConfig.ShowTargetIndicator = value
    end
})

CombatTab:CreateToggle({
    Name = "➡️ Show arrow to target",
    CurrentValue = AimbotConfig.ShowTargetArrow,
    Callback = function(value)
        AimbotConfig.ShowTargetArrow = value
    end
})

CombatTab:CreateToggle({
    Name = "❤️ Show target HP",
    CurrentValue = AimbotConfig.ShowTargetHP,
    Callback = function(value)
        AimbotConfig.ShowTargetHP = value
    end
})

CombatTab:CreateSlider({
    Name = "🔤 Target text size",
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
    Name = "🎨 Target indicator color",
    Color = AimbotConfig.TargetCircleColor,
    Callback = function(value)
        AimbotConfig.TargetCircleColor = value
    end
})

CombatTab:CreateToggle({
    Name = "🦴 Show target skeleton",
    CurrentValue = AimbotConfig.ShowTargetSkeleton,
    Callback = function(value)
        AimbotConfig.ShowTargetSkeleton = value
    end
})

CombatTab:CreateColorPicker({
    Name = "🎨 Target skeleton color",
    Color = AimbotConfig.TargetSkeletonColor,
    Callback = function(value)
        AimbotConfig.TargetSkeletonColor = value
    end
})

CombatTab:CreateSlider({
    Name = "📏 Target skeleton thickness",
    Range = {1, 4},
    Increment = 1,
    CurrentValue = AimbotConfig.TargetSkeletonThickness,
    Callback = function(value)
        AimbotConfig.TargetSkeletonThickness = value
    end
})

CombatTab:CreateDropdown({
    Name = "🦴 Target skeleton type",
    Options = {"1 - Simple", "2 - Full"},
    CurrentOption = "1 - Simple",
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        if v == "2 - Full" then
            AimbotConfig.TargetSkeletonType = 2
        else
            AimbotConfig.TargetSkeletonType = 1
        end
    end
})

CombatTab:CreateSection("🔫 AUTO-SHOOT")

CombatTab:CreateToggle({
    Name = "🔫 Auto-shoot",
    CurrentValue = AimbotConfig.AutoShoot,
    Callback = function(value)
        AimbotConfig.AutoShoot = value
    end
})

CombatTab:CreateSlider({
    Name = "⏱️ Shot delay (sec)",
    Range = {0.05, 0.5},
    Increment = 0.05,
    Suffix = " sec",
    CurrentValue = AimbotConfig.AutoShootDelay,
    Callback = function(value)
        AimbotConfig.AutoShootDelay = value
    end
})

CombatTab:CreateSection("📊 TARGET VISUALS")

CombatTab:CreateToggle({
    Name = "📐 Aim line to target",
    CurrentValue = AimbotConfig.ShowAimLine,
    Callback = function(value)
        AimbotConfig.ShowAimLine = value
    end
})

CombatTab:CreateColorPicker({
    Name = "🎨 Aim line color",
    Color = AimbotConfig.AimLineColor,
    Callback = function(value)
        AimbotConfig.AimLineColor = value
    end
})

CombatTab:CreateToggle({
    Name = "🏷️ Large target name (top of screen)",
    CurrentValue = AimbotConfig.ShowTargetNameBig,
    Callback = function(value)
        AimbotConfig.ShowTargetNameBig = value
    end
})

CombatTab:CreateSection("🎯 TARGET PRIORITY")

CombatTab:CreateDropdown({
    Name = "🎯 Target selection priority",
    Options = {"Distance", "Health"},
    CurrentOption = "Distance",
    Callback = function(value)
        AimbotConfig.AimPriority = value
    end
})

CombatTab:CreateSection("🔮 PREDICTION")

CombatTab:CreateToggle({
    Name = "🔮 Motion prediction",
    CurrentValue = AimbotConfig.Prediction,
    Callback = function(value)
        AimbotConfig.Prediction = value
    end
})

CombatTab:CreateSlider({
    Name = "🔮 Сила предсказания",
    Range = {0.05, 0.5},
    Increment = 0.05,
    Suffix = "x",
    CurrentValue = AimbotConfig.PredictionFactor,
    Callback = function(value)
        AimbotConfig.PredictionFactor = value
    end
})

CombatTab:CreateSection("🧠 ANTI-AIM")

CombatTab:CreateToggle({
    Name = "🧠 Anti-Aim Detection",
    CurrentValue = AimbotConfig.AntiAimDetect,
    Callback = function(value)
        AimbotConfig.AntiAimDetect = value
    end
})

CombatTab:CreateSection("📐 FOV DISTANCE")

CombatTab:CreateToggle({
    Name = "📐 Auto-FOV by distance",
    CurrentValue = AimbotConfig.DistanceFOV,
    Callback = function(value)
        AimbotConfig.DistanceFOV = value
    end
})

CombatTab:CreateSlider({
    Name = "📐 Мин. FOV (далеко)",
    Range = {30, 100},
    Increment = 5,
    Suffix = "",
    CurrentValue = AimbotConfig.DistanceFOVMin,
    Callback = function(value)
        AimbotConfig.DistanceFOVMin = value
    end
})

CombatTab:CreateSlider({
    Name = "📐 Макс. FOV (близко)",
    Range = {100, 400},
    Increment = 10,
    Suffix = "",
    CurrentValue = AimbotConfig.DistanceFOVMax,
    Callback = function(value)
        AimbotConfig.DistanceFOVMax = value
    end
})

CombatTab:CreateSection("💀 AIMBOT NOTIFICATIONS")

CombatTab:CreateToggle({
    Name = "💀 Kill Notify",
    CurrentValue = AimbotConfig.KillNotify,
    Callback = function(value)
        AimbotConfig.KillNotify = value
    end
})

CombatTab:CreateToggle({
    Name = "🎯 Lock Notify (захват цели)",
    CurrentValue = AimbotConfig.NotifyLock,
    Callback = function(value)
        AimbotConfig.NotifyLock = value
    end
})

CombatTab:CreateToggle({
    Name = "❌ Unlock Notify (потеря цели)",
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
    Name = "💥 Low HP Notify (цель < 30 HP)",
    CurrentValue = AimbotConfig.NotifyLowHP,
    Callback = function(value)
        AimbotConfig.NotifyLowHP = value
    end
})

CombatTab:CreateToggle({
    Name = "🔫 Auto-Shot Notify (выстрел)",
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

CombatTab:CreateSection("🔒 TARGET LOCK")

CombatTab:CreateToggle({
    Name = "🔒 Persistent Lock (до смерти)",
    CurrentValue = AimbotConfig.PersistentLock,
    Callback = function(value)
        AimbotConfig.PersistentLock = value
    end
})

CombatTab:CreateSection("👥 TEAMS (friends / enemies)")

local myTeamLabel = CombatTab:CreateLabel("🎖️ Your team: —")
local function UpdateMyTeamLabel()
    local tn = GetTeamName(player)
    pcall(function()
        myTeamLabel:Set("🎖️ Ваша команда: " .. (tn or "нет"))
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
    Name = "🎖️ Team",
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
    Name = "🎯 Don't aim at friendlies",
    CurrentValue = AimbotConfig.TeamFilter,
    Flag = "AimbotTeamFilter",
    Callback = function(value)
        AimbotConfig.TeamFilter = value
    end
})

CombatTab:CreateButton({
    Name = "✅ Make team friendly",
    Callback = function()
        local n = selectedTeam
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
        pcall(RefreshTeamDD)
        pcall(UpdateESP)
    end
})

CombatTab:CreateButton({
    Name = "❌ Remove team from friends (enemy)",
    Callback = function()
        local n = selectedTeam
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
        pcall(RefreshTeamDD)
        pcall(UpdateESP)
    end
})

CombatTab:CreateButton({
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

CombatTab:CreateButton({
    Name = "🚫 All teams — enemies",
    Callback = function()
        getgenv().ELITE_HUB_FRIEND_TEAMS = {}
        Rayfield:Notify({ Title = "⚔️ Готово", Content = "Все команды теперь враги", Duration = 2 })
        pcall(RefreshTeamDD)
        pcall(UpdateESP)
    end
})

CombatTab:CreateButton({
    Name = "🔄 Refresh team list",
    Callback = function()
        pcall(RefreshTeamDD)
        Rayfield:Notify({ Title = "👥 Команды", Content = "Список команд обновлён", Duration = 2 })
    end
})

CombatTab:CreateSection("🤝 FRIENDS & TARGET (select from list)")

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
        local opts = {"(Авто)"}
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
    Name = "🚫 Don't aim at friends",
    CurrentValue = AimbotConfig.FriendCheck,
    Flag = "AimbotFriendCheck",
    Callback = function(value)
        AimbotConfig.FriendCheck = value
    end
})

CombatTab:CreateToggle({
    Name = "🛡️ Don't aim at spawning (shield)",
    CurrentValue = AimbotConfig.SpawnCheck,
    Flag = "AimbotSpawnCheck",
    Callback = function(value)
        AimbotConfig.SpawnCheck = value
    end
})

friendAddDD = CombatTab:CreateDropdown({
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
        if friendAddDD then pcall(function() friendAddDD:Clear() end) end
        RefreshAimbotDD()
    end
})

friendRmDD = CombatTab:CreateDropdown({
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
        if friendRmDD then pcall(function() friendRmDD:Clear() end) end
        RefreshAimbotDD()
    end
})

CombatTab:CreateButton({
    Name = "🧹 Clear friends list",
    Callback = function()
        local cnt = #getgenv().ELITE_HUB_FRIENDS
        getgenv().ELITE_HUB_FRIENDS = {}
        Rayfield:Notify({ Title = "🧹 Готово", Content = "Удалено друзей: " .. cnt, Duration = 2 })
        RefreshAimbotDD()
    end
})

CombatTab:CreateButton({
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

friendTargetDD = CombatTab:CreateDropdown({
    Name = "🎯 Main target (always first)",
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