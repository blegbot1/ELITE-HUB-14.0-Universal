-- source: ELITE_HUB_14.0.lua Aimbot (lines 5469-7109)
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
local CombatTab = _g().ELITE_HUB_CombatTab
local NewOverlayCircle = _g().ELITE_HUB_NewOverlayCircle
local NewOverlayLine = _g().ELITE_HUB_NewOverlayLine

--[[
    ==============================
    РЈР›РЈР§РЁР•РќРќР«Р™ AIMBOT РЎ РџР РРћР РРўР•РўРћРњ РџРћ Р”РРЎРўРђРќР¦РР
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
    EnemyPriority = true,
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
getgenv().ELITE_HUB_AimbotConfig = AimbotConfig

local FOVCircle = NewOverlayCircle()
FOVCircle.Visible = AimbotConfig.ShowFOV
FOVCircle.Radius = AimbotConfig.FOV
FOVCircle.Color = AimbotConfig.FOVColor
FOVCircle.Thickness = 5
FOVCircle.Filled = false
FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
local Running = false
LockedTarget = nil
LockedTargetPlayer = nil

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
-- Monolith 'local function SafeNotify' omitted; core ELITE_HUB_SafeNotify used instead


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
    {"Left Leg", "Left Hip"},
    {"Right Leg", "Right Hip"},
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

_g().ELITE_HUB_UpdateSkeletonLines = UpdateSkeletonLines

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
        AimLine.To = Vector2.new(center.X, center.Y - 160)
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

_g().ELITE_HUB_IsFriendName = IsFriendName
_g().ELITE_HUB_IsFriend = IsFriend
_g().ELITE_HUB_CreateSkeletonLines = CreateSkeletonLines
_g().ELITE_HUB_RemoveSkeletonLines = RemoveSkeletonLines
_g().ELITE_HUB_GetTargetPlayer = GetTargetPlayer

local function GetTargetPlayer()
    local targetName = tostring(getgenv().ELITE_HUB_TARGET_NAME or "")
    if targetName == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == targetName:lower() then return p end
    end
    return nil
end

getgenv().ELITE_HUB_FRIEND_TEAMS = getgenv().ELITE_HUB_FRIEND_TEAMS or {}

function GetTeamName(p)
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

function IsFriendlyTeamName(teamName)
    teamName = tostring(teamName or "")
    if teamName == "" then return false end
    for _, tn in ipairs(getgenv().ELITE_HUB_FRIEND_TEAMS) do
        if tostring(tn):lower() == teamName:lower() then return true end
    end
    return false
end

function IsFriendlyTeam(p)
    if not p then return false end
    if p == player then return true end
    return IsFriendlyTeamName(GetTeamName(p))
end

function IsSameTeam(p)
    if not p then return false end
    local my = GetTeamName(player)
    local theirs = GetTeamName(p)
    if my and theirs then return my:lower() == theirs:lower() end
    return false
end

function GetTeamRelation(p)
    if not p then return "none" end
    if p == player then return "my" end
    local tn = GetTeamName(p)
    if not tn then return "none" end
    if IsSameTeam(p) then return "my" end
    if IsFriendlyTeamName(tn) then return "friend" end
    return "enemy"
end

getgenv().ELITE_HUB_ENEMIES = getgenv().ELITE_HUB_ENEMIES or {}
getgenv().ELITE_HUB_ENEMY_TEAMS = getgenv().ELITE_HUB_ENEMY_TEAMS or {}

function GetPlayerRelation(p)
    if not p then return "none" end
    if p == player then return "my" end
    local lname = tostring(p.Name or ""):lower()
    for _, f in ipairs(getgenv().ELITE_HUB_FRIENDS) do
        if tostring(f):lower() == lname then return "friend" end
    end
    for _, f in ipairs(getgenv().ELITE_HUB_ENEMIES) do
        if tostring(f):lower() == lname then return "enemy" end
    end
    local tn = GetTeamName(p)
    if tn then
        for _, f in ipairs(getgenv().ELITE_HUB_FRIEND_TEAMS) do
            if tostring(f):lower() == tn:lower() then return "friend" end
        end
        for _, f in ipairs(getgenv().ELITE_HUB_ENEMY_TEAMS) do
            if tostring(f):lower() == tn:lower() then return "enemy" end
        end
    end
    return GetTeamRelation(p)
end
_g().ELITE_HUB_GetPlayerRelation = GetPlayerRelation

function GetAllTeamNames()
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
        return true, targetPart
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
        LockedTargetPlayer = nil -- С†РµР»СЊ СѓРјРµСЂР»Р° / СѓС€Р»Р° СЃ СЌРєСЂР°РЅР° -> РѕС‚РїСѓСЃРєР°РµРј
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
    local bestEnemyTarget = nil
    local bestEnemyPlayer = nil
    local bestEnemyScore = math.huge

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        local skip = false
        if targetPlayer == localPlayer then skip = true end
        if not skip and not targetPlayer.Character then skip = true end
        if not skip and AimbotConfig.TeamCheck and targetPlayer.Team == localPlayer.Team then skip = true end
        if not skip and AimbotConfig.FriendCheck and GetPlayerRelation(targetPlayer) == "friend" then skip = true end
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
                            local isEnemy = AimbotConfig.EnemyPriority and GetPlayerRelation(targetPlayer) == "enemy"
                            if isEnemy and score < bestEnemyScore then
                                bestEnemyScore = score
                                bestEnemyTarget = targetPart
                                bestEnemyPlayer = targetPlayer
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

    local chosen = bestEnemyTarget
    local chosenPlayer = bestEnemyPlayer
    if not chosen then
        chosen = bestTarget
        chosenPlayer = bestTargetPlayer
    end
    if chosen and chosenPlayer then
        LockedTargetPlayer = chosenPlayer
        return chosen
    end

    return nil
end

task.spawn(function()
    Log("AIMBOT", "  ")
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
                    local prevTarget = LockedTargetPlayer
                    LockedTargetPlayer = target
                    if LockedTarget == nil then
                        SafeNotify(" LOCK", LockedTargetPlayer.Name, 1.5, "Lock")
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
                                SafeNotify("🛡 ANTI-AIM", LockedTargetPlayer.Name .. "  !", 2, "AntiAim")
                            end
                        end
                    end

                    if LockedTargetPlayer then
                        local ch = LockedTargetPlayer.Character
                        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 and hum.Health < 30 then
                            SafeNotify(" LOW HP", LockedTargetPlayer.Name .. "  " .. math.floor(hum.Health) .. " HP!", 1, "LowHP")
                        end
                    end

                    if AimbotConfig.KillNotify and LockedTargetPlayer then
                        local ch = LockedTargetPlayer.Character
                        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local oldHP = PreviousTargetHP[LockedTargetPlayer]
                            if oldHP and oldHP > 0 and hum.Health <= 0 then
                                SafeNotify(" KILL", LockedTargetPlayer.Name .. " !", 2, "Kill")
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
                                SafeNotify(" SHOT", LockedTargetPlayer.Name, 0.5, "Shot")
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
                        SafeNotify(" UNLOCK", " ", 1.5, "Unlock")
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
    Name = " Enable Aimbot",
    CurrentValue = AimbotConfig.Enabled,
    Flag = "AimbotEnabled",
    Callback = function(value)
        AimbotConfig.Enabled = value
        getgenv().ELITE_HUB_AimbotEnabled = value
        Log("AIMBOT", "Aimbot : " .. tostring(value))
        if value then
            if FOVCircle then FOVCircle.Visible = true end
            Rayfield:Notify({
                Title = "🎯 Aimbot",
                Content = "Enabled",
                Duration = 3
            })
        else
            if FOVCircle then FOVCircle.Visible = false end
            Running = false
            LockedTarget = nil
            Rayfield:Notify({
                Title = "🎯 Aimbot",
                Content = "Disabled",
                Duration = 2
            })
        end
    end
})

CombatTab:CreateToggle({
    Name = " Ignore team",
    CurrentValue = AimbotConfig.TeamCheck,
    Callback = function(value)
        AimbotConfig.TeamCheck = value
    end
})

CombatTab:CreateToggle({
    Name = " Don't aim at dead",
    CurrentValue = AimbotConfig.AliveCheck,
    Callback = function(value)
        AimbotConfig.AliveCheck = value
    end
})

CombatTab:CreateToggle({
    Name = " Don't aim through walls",
    CurrentValue = AimbotConfig.WallCheck,
    Callback = function(value)
        AimbotConfig.WallCheck = value
    end
})

CombatTab:CreateToggle({
    Name = " First-person fix",
    CurrentValue = AimbotConfig.ThirdPersonFix,
    Callback = function(value)
        AimbotConfig.ThirdPersonFix = value
    end
})

CombatTab:CreateDropdown({
    Name = " Target priority",
    Options = {"Distance", "FOV", "Health"},
    CurrentOption = AimbotConfig.Priority,
    Callback = function(option)
        AimbotConfig.Priority = option
        if option == "Distance" then
            Rayfield:Notify({
                Title = "🎯 Target",
                Content = "Enabled",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "🎯 FOV Lock",
                Content = "Lock enabled",
                Duration = 3
            })
        end
    end
})

CombatTab:CreateSlider({
    Name = " FOV Size",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = AimbotConfig.FOV,
    Callback = function(value)
        AimbotConfig.FOV = value
    end
})

CombatTab:CreateColorPicker({
    Name = " FOV Color",
    Color = AimbotConfig.FOVColor,
    Callback = function(value)
        AimbotConfig.FOVColor = value
    end
})

CombatTab:CreateColorPicker({
    Name = " Lock Color",
    Color = AimbotConfig.LockedColor,
    Callback = function(value)
        AimbotConfig.LockedColor = value
    end
})

CombatTab:CreateSection("⚙ EXTRA AIMBOT SETTINGS")

CombatTab:CreateToggle({
    Name = " Show FOV circle",
    CurrentValue = AimbotConfig.ShowFOV,
    Flag = "AimbotShowFOV",
    Callback = function(value)
        AimbotConfig.ShowFOV = value
        if FOVCircle then FOVCircle.Visible = value and AimbotConfig.Enabled end
    end
})

CombatTab:CreateToggle({
    Name = " Mode: Toggle / Hold",
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
    Name = " Target key",
    Options = {"MouseButton2", "MouseButton1", "LeftControl", "X", "C", "F", "V", "Shift"},
    CurrentOption = AimbotConfig.TriggerKey,
    Callback = function(option)
        AimbotConfig.TriggerKey = option
        Rayfield:Notify({
            Title = "🎯 Target Key",
            Content = "Key: " .. option,
            Duration = 2
        })
    end
})

CombatTab:CreateSlider({
    Name = " Max target distance (studs)",
    Range = {10, 1000},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = AimbotConfig.MaxDistance,
    Callback = function(value)
        AimbotConfig.MaxDistance = value
    end
})

CombatTab:CreateSlider({
    Name = " Min target distance (studs)",
    Range = {0, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = AimbotConfig.MinDistance,
    Callback = function(value)
        AimbotConfig.MinDistance = value
    end
})

CombatTab:CreateSlider({
    Name = " Aim offset Y",
    Range = {-3, 3},
    Increment = 0.1,
    Suffix = " studs",
    CurrentValue = AimbotConfig.AimOffset,
    Callback = function(value)
        AimbotConfig.AimOffset = value
    end
})

CombatTab:CreateSlider({
    Name = " FOV circle thickness",
    Range = {1, 10},
    Increment = 1,
    Suffix = " px",
    CurrentValue = AimbotConfig.FOVThickness,
    Callback = function(value)
        AimbotConfig.FOVThickness = value
    end
})

CombatTab:CreateSlider({
    Name = " Precise FOV size",
    Range = {1, 400},
    Increment = 1,
    Suffix = " px",
    CurrentValue = AimbotConfig.FOV,
    Callback = function(value)
        AimbotConfig.FOV = value
    end
})

CombatTab:CreateDropdown({
    Name = " Body part to aim at",
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},
    CurrentOption = AimbotConfig.LockPart,
    Callback = function(option)
        AimbotConfig.LockPart = option
    end
})

CombatTab:CreateSection("📍 TARGET INDICATOR")

CombatTab:CreateToggle({
    Name = " Show target name & HP",
    CurrentValue = AimbotConfig.ShowTargetIndicator,
    Callback = function(value)
        AimbotConfig.ShowTargetIndicator = value
    end
})

CombatTab:CreateToggle({
    Name = " Show arrow to target",
    CurrentValue = AimbotConfig.ShowTargetArrow,
    Callback = function(value)
        AimbotConfig.ShowTargetArrow = value
    end
})

CombatTab:CreateToggle({
    Name = " Show target HP",
    CurrentValue = AimbotConfig.ShowTargetHP,
    Callback = function(value)
        AimbotConfig.ShowTargetHP = value
    end
})

CombatTab:CreateSlider({
    Name = " Target text size",
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
    Name = " Target indicator color",
    Color = AimbotConfig.TargetCircleColor,
    Callback = function(value)
        AimbotConfig.TargetCircleColor = value
    end
})

CombatTab:CreateToggle({
    Name = " Show target skeleton",
    CurrentValue = AimbotConfig.ShowTargetSkeleton,
    Callback = function(value)
        AimbotConfig.ShowTargetSkeleton = value
    end
})

CombatTab:CreateColorPicker({
    Name = " Target skeleton color",
    Color = AimbotConfig.TargetSkeletonColor,
    Callback = function(value)
        AimbotConfig.TargetSkeletonColor = value
    end
})

CombatTab:CreateSlider({
    Name = " Target skeleton thickness",
    Range = {1, 4},
    Increment = 1,
    CurrentValue = AimbotConfig.TargetSkeletonThickness,
    Callback = function(value)
        AimbotConfig.TargetSkeletonThickness = value
    end
})

CombatTab:CreateDropdown({
    Name = " Target skeleton type",
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
    Name = " Auto-shoot",
    CurrentValue = AimbotConfig.AutoShoot,
    Callback = function(value)
        AimbotConfig.AutoShoot = value
    end
})

CombatTab:CreateSlider({
    Name = " Shot delay (sec)",
    Range = {0.05, 0.5},
    Increment = 0.05,
    Suffix = " sec",
    CurrentValue = AimbotConfig.AutoShootDelay,
    Callback = function(value)
        AimbotConfig.AutoShootDelay = value
    end
})

CombatTab:CreateSection("👁 TARGET VISUALS")

CombatTab:CreateToggle({
    Name = " Aim line to target",
    CurrentValue = AimbotConfig.ShowAimLine,
    Callback = function(value)
        AimbotConfig.ShowAimLine = value
    end
})

CombatTab:CreateColorPicker({
    Name = " Aim line color",
    Color = AimbotConfig.AimLineColor,
    Callback = function(value)
        AimbotConfig.AimLineColor = value
    end
})

CombatTab:CreateToggle({
    Name = " Large target name (top of screen)",
    CurrentValue = AimbotConfig.ShowTargetNameBig,
    Callback = function(value)
        AimbotConfig.ShowTargetNameBig = value
    end
})

CombatTab:CreateSection("🔢 TARGET PRIORITY")

CombatTab:CreateDropdown({
    Name = " Target selection priority",
    Options = {"Distance", "Health"},
    CurrentOption = "Distance",
    Callback = function(value)
        AimbotConfig.Priority = value
    end
})

CombatTab:CreateSection("🔮 PREDICTION")

CombatTab:CreateToggle({
    Name = " Motion prediction",
    CurrentValue = AimbotConfig.Prediction,
    Callback = function(value)
        AimbotConfig.Prediction = value
    end
})

CombatTab:CreateSlider({
    Name = " Prediction Factor",
    Range = {0.05, 0.5},
    Increment = 0.05,
    Suffix = "x",
    CurrentValue = AimbotConfig.PredictionFactor,
    Callback = function(value)
        AimbotConfig.PredictionFactor = value
    end
})

CombatTab:CreateSection(" ANTI-AIM")

CombatTab:CreateToggle({
    Name = " Anti-Aim Detection",
    CurrentValue = AimbotConfig.AntiAimDetect,
    Callback = function(value)
        AimbotConfig.AntiAimDetect = value
    end
})

CombatTab:CreateSection("📏 FOV DISTANCE")

CombatTab:CreateToggle({
    Name = " Auto-FOV by distance",
    CurrentValue = AimbotConfig.DistanceFOV,
    Callback = function(value)
        AimbotConfig.DistanceFOV = value
    end
})

CombatTab:CreateSlider({
    Name = " Min FOV (studs)",
    Range = {30, 100},
    Increment = 5,
    Suffix = "",
    CurrentValue = AimbotConfig.DistanceFOVMin,
    Callback = function(value)
        AimbotConfig.DistanceFOVMin = value
    end
})

CombatTab:CreateSlider({
    Name = " Max FOV (studs)",
    Range = {100, 400},
    Increment = 10,
    Suffix = "",
    CurrentValue = AimbotConfig.DistanceFOVMax,
    Callback = function(value)
        AimbotConfig.DistanceFOVMax = value
    end
})

CombatTab:CreateSection("🔔 AIMBOT NOTIFICATIONS")

CombatTab:CreateToggle({
    Name = " Kill Notify",
    CurrentValue = AimbotConfig.KillNotify,
    Callback = function(value)
        AimbotConfig.KillNotify = value
    end
})

CombatTab:CreateToggle({
    Name = " Lock Notify",
    CurrentValue = AimbotConfig.NotifyLock,
    Callback = function(value)
        AimbotConfig.NotifyLock = value
    end
})

CombatTab:CreateToggle({
    Name = " Unlock Notify",
    CurrentValue = AimbotConfig.NotifyUnlock,
    Callback = function(value)
        AimbotConfig.NotifyUnlock = value
    end
})

CombatTab:CreateToggle({
    Name = " Anti-Aim Detect Notify",
    CurrentValue = AimbotConfig.NotifyAntiAim,
    Callback = function(value)
        AimbotConfig.NotifyAntiAim = value
    end
})

CombatTab:CreateToggle({
    Name = " Low HP Notify (< 30 HP)",
    CurrentValue = AimbotConfig.NotifyLowHP,
    Callback = function(value)
        AimbotConfig.NotifyLowHP = value
    end
})

CombatTab:CreateToggle({
    Name = " Auto-Shot Notify",
    CurrentValue = AimbotConfig.NotifyShot,
    Callback = function(value)
        AimbotConfig.NotifyShot = value
    end
})

CombatTab:CreateToggle({
    Name = " Player Join Notify",
    CurrentValue = AimbotConfig.NotifyPlayerJoin,
    Callback = function(value)
        AimbotConfig.NotifyPlayerJoin = value
    end
})

CombatTab:CreateToggle({
    Name = " Player Leave Notify",
    CurrentValue = AimbotConfig.NotifyPlayerLeave,
    Callback = function(value)
        AimbotConfig.NotifyPlayerLeave = value
    end
})

CombatTab:CreateToggle({
    Name = " Target Left Server Notify",
    CurrentValue = AimbotConfig.NotifyTargetLost,
    Callback = function(value)
        AimbotConfig.NotifyTargetLost = value
    end
})

CombatTab:CreateSection("🔒 TARGET LOCK")

CombatTab:CreateToggle({
    Name = " Persistent Lock",
    CurrentValue = AimbotConfig.PersistentLock,
    Callback = function(value)
        AimbotConfig.PersistentLock = value
    end
})

CombatTab:CreateSection("🎯 LOCK OPTIONS")

CombatTab:CreateToggle({
    Name = " Don't aim at friendlies",
    CurrentValue = AimbotConfig.TeamFilter,
    Flag = "AimbotTeamFilter",
    Callback = function(value)
        AimbotConfig.TeamFilter = value
    end
})

CombatTab:CreateToggle({
    Name = " Don't aim at spawning (shield)",
    CurrentValue = AimbotConfig.SpawnCheck,
    Flag = "AimbotSpawnCheck",
    Callback = function(value)
        AimbotConfig.SpawnCheck = value
    end
})

CombatTab:CreateToggle({
    Name = " Enemy priority",
    CurrentValue = AimbotConfig.EnemyPriority,
    Flag = "AimbotEnemyPriority",
    Callback = function(value)
        AimbotConfig.EnemyPriority = value
    end
})

local targetDD = nil
local function RefreshTargetDD()
    if not targetDD then return end
    local opts = {"()"}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then table.insert(opts, p.Name) end
    end
    table.sort(opts)
    pcall(function() targetDD:Refresh(opts) end)
end

targetDD = CombatTab:CreateDropdown({
    Name = " Main target (always first)",
    Options = {"()"},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        if n == "()" or n == nil or n == "" then
            getgenv().ELITE_HUB_TARGET_NAME = ""
        else
            getgenv().ELITE_HUB_TARGET_NAME = n
        end
    end
})

task.spawn(function()
    while true do
        task.wait(4)
        RefreshTargetDD()
    end
end)
Players.PlayerAdded:Connect(RefreshTargetDD)
Players.PlayerRemoving:Connect(RefreshTargetDD)
task.delay(1, RefreshTargetDD)