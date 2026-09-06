-- ELITE HUB 14.0 — Main Module (WallHop, Fly, Noclip, Speed Boost, Mini GUI, Extra Scripts)
-- Extracted from ELITE_HUB_14.0.lua

local AdventureSection = MainTab:CreateSection("🚀 CORE FUNCTIONS")

local noclipActive = false
local noclipConnection = nil
local BindConfig = {
    Fly = "F",
    Noclip = "N",
    SpeedBoost = "V",
    SpinBot = "B"
}
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
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
local InfiniteJumpEnabled = true -- Debounce для основного wallhop

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
            Content = "WallHop включён (Бинд: " .. tostring(wallhopBindKey.Name) .. ")",
            Duration = 3
        })
    else
        if wallhopConnection then
            wallhopConnection:Disconnect()
            wallhopConnection = nil
        end
        Rayfield:Notify({
            Title = "❌ WallHop",
            Content = "WallHop выключен",
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
        pcall(updateMiniGuiButtons)
        if getgenv().ELITE_HUB_SpinBot then
            task.spawn(function()
                while getgenv().ELITE_HUB_SpinBot do
                    task.wait(0.016)
                    pcall(function()
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

local wallhopBtn = CreateMiniButton("WallhopBtn", "🧱 WallHop", 0, function() ToggleWallhop() end)
local flyBtn = CreateMiniButton("FlyBtn", "✈️ Fly", 1, function() ToggleFly() end)
local noclipBtn = CreateMiniButton("NoclipBtn", "👻 Noclip", 2, function() ToggleNoclip() end)

getgenv().ELITE_HUB_SpeedBtn = CreateMiniButton("SpeedBoostBtn", "⚡ Speed Boost", 3, function()
    ActivateSpeedBoost()
end)

getgenv().ELITE_HUB_SpinBtn = CreateMiniButton("SpinBotBtn", "🔄 Spin Bot", 4, function()
    getgenv().ELITE_HUB_SpinBot = not getgenv().ELITE_HUB_SpinBot
    getgenv().ELITE_HUB_Log("MODS", "Spin Bot: " .. tostring(getgenv().ELITE_HUB_SpinBot))
    updateMiniGuiButtons()
    if getgenv().ELITE_HUB_SpinBot then
        task.spawn(function()
            while getgenv().ELITE_HUB_SpinBot do
                task.wait(0.016)
                pcall(function()
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
        wallhopBtn.Text = "  🧱 WallHop: ON"
        wallhopBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 50)
        wallhopBtn.TextColor3 = Color3.fromRGB(120, 255, 140)
        wallhopBtn.Indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
    else
        wallhopBtn.Text = "  🧱 WallHop: OFF"
        wallhopBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
        wallhopBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
        wallhopBtn.Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end

    if nowe then
        flyBtn.Text = "  ✈️ Fly: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
        flyBtn.TextColor3 = Color3.fromRGB(120, 180, 255)
        flyBtn.Indicator.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
    else
        flyBtn.Text = "  ✈️ Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
        flyBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
        flyBtn.Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end

    if noclipActive then
        noclipBtn.Text = "  👻 Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 100)
        noclipBtn.TextColor3 = Color3.fromRGB(255, 140, 255)
        noclipBtn.Indicator.BackgroundColor3 = Color3.fromRGB(200, 80, 255)
    else
        noclipBtn.Text = "  👻 Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(40, 28, 65)
        noclipBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
        noclipBtn.Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end

    if getgenv().ELITE_HUB_SpinBot then
        getgenv().ELITE_HUB_SpinBtn.Text = "  🔄 Spin Bot: ON"
        getgenv().ELITE_HUB_SpinBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        getgenv().ELITE_HUB_SpinBtn.TextColor3 = Color3.fromRGB(255, 140, 140)
        getgenv().ELITE_HUB_SpinBtn.Indicator.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    else
        getgenv().ELITE_HUB_SpinBtn.Text = "  🔄 Spin Bot: OFF"
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
        sb.Text = "  ⚡ Speed: ON"
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
        sb.Text = "  ⚡ Speed: OFF"
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
            Content = "Fly включён (Скорость: " .. speeds .. ")",
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
            Title = "❌ Fly",
            Content = "Fly выключен",
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
            Content = "Noclip включён",
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
            Title = "❌ Noclip",
            Content = "Noclip выключен",
            Duration = 3
        })
    end
end

updateMiniGuiButtons()

MainTab:CreateButton({
    Name = "🛑 SHUTDOWN SCRIPT",
    Callback = function()
        DestroyScript()
    end
})

MainTab:CreateButton({
    Name = "🧱 WALLHOP",
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
    Name = "👻 NOCLIP",
    Callback = function()
        ToggleNoclip()
    end
})

MainTab:CreateButton({
    Name = "➕ Increase Fly Speed",
    Callback = function()
        speeds = speeds + 1
        Rayfield:Notify({
            Title = "✅ Скорость Fly",
            Content = "Скорость: " .. speeds,
            Duration = 2
        })
    end
})

MainTab:CreateButton({
    Name = "➖ Decrease Fly Speed",
    Callback = function()
        if speeds > 1 then
            speeds = speeds - 1
            Rayfield:Notify({
                Title = "✅ Скорость Fly",
                Content = "Скорость: " .. speeds,
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "❌ Ошибка",
                Content = "Минимальная скорость: 1",
                Duration = 2
            })
        end
    end
})

MainTab:CreateButton({
    Name = "📱 OPEN MINI-MENU",
    Callback = function()
        ToggleMiniMenu()
    end
})

local currentBind = wallhopBindKey.Name
MainTab:CreateInput({
    Name = "🔑 WallHop Bind",
    PlaceholderText = "Текущий: " .. currentBind,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function()
            return Enum.KeyCode[keyName]
        end)
        if success and keyEnum then
            wallhopBindKey = keyEnum
            Rayfield:Notify({
                Title = "✅ Бинд изменён",
                Content = "Новый бинд: " .. keyName,
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "❌ Ошибка",
                Content = "Неверное название клавиши!",
                Duration = 3
            })
        end
    end
})

MainTab:CreateSection("⌨️ BINDS")

MainTab:CreateInput({
    Name = "✈️ Fly Bind",
    PlaceholderText = "Текущий: " .. BindConfig.Fly,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function() return Enum.KeyCode[keyName] end)
        if success and keyEnum then
            BindConfig.Fly = keyName
            Rayfield:Notify({ Title = "✅ Бинд Fly", Content = "Новый бинд: " .. keyName, Duration = 2 })
        else
            Rayfield:Notify({ Title = "❌ Ошибка", Content = "Неверное название клавиши!", Duration = 2 })
        end
    end
})

MainTab:CreateInput({
    Name = "👻 Noclip Bind",
    PlaceholderText = "Текущий: " .. BindConfig.Noclip,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function() return Enum.KeyCode[keyName] end)
        if success and keyEnum then
            BindConfig.Noclip = keyName
            Rayfield:Notify({ Title = "✅ Бинд Noclip", Content = "Новый бинд: " .. keyName, Duration = 2 })
        else
            Rayfield:Notify({ Title = "❌ Ошибка", Content = "Неверное название клавиши!", Duration = 2 })
        end
    end
})

MainTab:CreateInput({
    Name = "⚡ Speed Boost Bind",
    PlaceholderText = "Текущий: " .. BindConfig.SpeedBoost,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function() return Enum.KeyCode[keyName] end)
        if success and keyEnum then
            BindConfig.SpeedBoost = keyName
            Rayfield:Notify({ Title = "✅ Бинд Speed Boost", Content = "Новый бинд: " .. keyName, Duration = 2 })
        else
            Rayfield:Notify({ Title = "❌ Ошибка", Content = "Неверное название клавиши!", Duration = 2 })
        end
    end
})

MainTab:CreateInput({
    Name = "🔄 Spin Bot Bind",
    PlaceholderText = "Текущий: " .. BindConfig.SpinBot,
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local keyName = Text:upper()
        local success, keyEnum = pcall(function() return Enum.KeyCode[keyName] end)
        if success and keyEnum then
            BindConfig.SpinBot = keyName
            Rayfield:Notify({ Title = "✅ Бинд Spin Bot", Content = "Новый бинд: " .. keyName, Duration = 2 })
        else
            Rayfield:Notify({ Title = "❌ Ошибка", Content = "Неверное название клавиши!", Duration = 2 })
        end
    end
})

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

--[[
    ==============================
    ОБНОВЛЕННЫЕ ДОПОЛНИТЕЛЬНЫЕ СКРИПТЫ
    ==============================
]]--
local ScriptsSection = MainTab:CreateSection("📜 EXTRA SCRIPTS")

local function LoadImprovedFlight()
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
        Name = "💃 FE Animations",
        Url = "https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"
    },
    {
        Name = "🛫 Enhanced Flight",
        Callback = LoadImprovedFlight
    },
    {
        Name = "👹 The Rake Animation",
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
                Title = "⏳ Загрузка...",
                Content = "📥 "..scriptInfo.Name.." запускается",
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
                    Title = "✅ Успех!",
                    Content = scriptInfo.Name.." успешно загружен",
                    Duration = 4
                })
            else
                Rayfield:Notify({
                    Title = "❌ Ошибка!",
                    Content = "Не удалось загрузить "..scriptInfo.Name..":\n"..tostring(err),
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
    "👹 SCP-096 Mode",
    "👻 Invisibility PRO",
    "🧟 Zombie Hacks",
    "🏎️ Fling+",
    "🧟 Simple Zombie Companion",
    "⚔️ FE GALE FIGHTER",
    "🌊 FE Neptunian V"
}

for i = 1, #scriptNames do
    MainTab:CreateButton({
        Name = scriptNames[i],
        Callback = function()
            Rayfield:Notify({
                Title = "⏳ Загрузка...",
                Content = "📥 "..scriptNames[i].." запускается",
                Duration = 3
            })

            local success, err = pcall(function()
                loadstring(game:HttpGet(scriptUrls[i], true))()
            end)

            if not success then
                Rayfield:Notify({
                    Title = "❌ Ошибка!",
                    Content = "⚠️ Не удалось загрузить:\n"..tostring(err),
                    Duration = 6
                })
            end
        end
    })
end

--[[
    ==============================
    ОСНОВНЫЕ ОБРАБОТЧИКИ
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
