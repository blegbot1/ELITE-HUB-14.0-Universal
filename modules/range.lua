-- source: ELITE_HUB_14.0.lua Range (lines 11956-12467)
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

local RangeTab = Window:CreateTab("📏 " .. "RANGE", 7733960981, "Range")

local RC = {
    Color1 = Color3.fromRGB(150, 70, 255),
    Color2 = Color3.fromRGB(100, 40, 200),
    Color3 = Color3.fromRGB(200, 100, 255),
    TrailSpeed = 0.8,
    SparkleRate = 10,
    ParticleSpeed = 10,
    ParticleLife = 0.6,
    ParticleSize = 2,
}

local function createTrail(parent, c1, c2, src)
    pcall(function()
        local a0 = Instance.new("Attachment")
        a0.Position = Vector3.new(0, 0.5, 0)
        a0.Parent = parent
        local a1 = Instance.new("Attachment")
        a1.Position = Vector3.new(0, -0.5, 0)
        a1.Parent = parent
        local trail = Instance.new("Trail")
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Color = ColorSequence.new(c1 or RC.Color1, c2 or RC.Color2)
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
        trail.Lifetime = RC.TrailSpeed
        trail.MinLength = 0.1
        trail.LightEmission = 1
        trail.FaceCamera = true
        trail:SetAttribute("EliteHubEffectSource", src or "RANGE")
        trail.Parent = parent
        return trail
    end)
end

local function createSparkles(parent, color, src)
    pcall(function()
        local s = Instance.new("Sparkles")
        s.SparkleColor = color or RC.Color3
        s:SetAttribute("EliteHubEffectSource", src or "RANGE")
        s.Parent = parent
        return s
    end)
end

local function createBurstParticles(parent, color)
    pcall(function()
        local pe = Instance.new("ParticleEmitter")
        pe.Color = ColorSequence.new(color or RC.Color3)
        pe.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, RC.ParticleSize),
            NumberSequenceKeypoint.new(1, 0)
        })
        pe.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        pe.Lifetime = NumberRange.new(RC.ParticleLife * 0.5, RC.ParticleLife)
        pe.Speed = NumberRange.new(RC.ParticleSpeed * 0.5, RC.ParticleSpeed)
        pe.SpreadAngle = Vector2.new(360, 360)
        pe.Rate = 0
        pe.LightEmission = 1
        pe:SetAttribute("EliteHubEffectSource", "RANGE")
        pe.Parent = parent
        return pe
    end)
end

local function createAuraParticles(parent, color, src)
    pcall(function()
        local pe = Instance.new("ParticleEmitter")
        pe.Color = ColorSequence.new(color or RC.Color1)
        pe.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.5, 0.1),
            NumberSequenceKeypoint.new(1, 0)
        })
        pe.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        pe.Lifetime = NumberRange.new(0.5, 1)
        pe.Speed = NumberRange.new(1, 3)
        pe.SpreadAngle = Vector2.new(180, 180)
        pe.Rate = RC.SparkleRate
        pe.LightEmission = 1
        pe.RotSpeed = NumberRange.new(-100, 100)
        pe:SetAttribute("EliteHubEffectSource", src or "RANGE")
        pe.Parent = parent
        return pe
    end)
end

local function clearEffects(char, source)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in ipairs(hrp:GetChildren()) do
            if v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") then
                if source == nil or v:GetAttribute("EliteHubEffectSource") == source then
                    v:Destroy()
                end
            end
        end
    end
end

local re1 = RangeTab:CreateSection("✨ EFFECTS")

RangeTab:CreateSlider({
    Name = " FOV",
    Range = {30, 120},
    Increment = 5,
    CurrentValue = 70,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
        getgenv().ELITE_HUB_Log("RANGE", "FOV: " .. value)
    end
})

local re2 = RangeTab:CreateSection("🔄 SPIN BOT")

local spinAngle = 0
local spinConn = nil
local prevAutoRotate = nil

local function startSpin()
    if spinConn then return end
    pcall(function()
        local ch = player.Character
        if ch then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum then
                prevAutoRotate = hum.AutoRotate
                hum.AutoRotate = false
            end
        end
    end)
    local RunService = game:GetService("RunService")
    spinConn = RunService.Heartbeat:Connect(function(dt)
        pcall(function()
            if not getgenv().ELITE_HUB_RangeSpin then return end
            local ch = player.Character
            if not ch then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if getgenv().ELITE_HUB_RangeSpinDuringMove == false then
                local moving = false
                pcall(function()
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    moving = hum and hum.MoveDirection.Magnitude > 0.1
                end)
                if moving then return end
            end

            local speed = getgenv().ELITE_HUB_RangeSpinSpeed or 50
            local delta = speed * dt * 3
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(delta), 0)
        end)
    end)
end

local function stopSpin()
    if spinConn then
        spinConn:Disconnect()
        spinConn = nil
    end
    pcall(function()
        local ch = player.Character
        if ch then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = prevAutoRotate ~= nil and prevAutoRotate or true
                prevAutoRotate = nil
            end
        end
    end)
end
getgenv().ELITE_HUB_RangeSpinStop = stopSpin

getgenv().ELITE_HUB_RangeSpin = false
getgenv().ELITE_HUB_RangeSpinSpeed = 50
getgenv().ELITE_HUB_RangeSpinDuringMove = true

RangeTab:CreateToggle({
    Name = " Spin Bot",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RangeSpin = value
        getgenv().ELITE_HUB_Log("RANGE", "Spin Bot: " .. tostring(value))
        if value then
            startSpin()
        else
            stopSpin()
        end
        pcall(function()
            local ch = player.Character
            if ch then
                if value then
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        createTrail(hrp, RC.Color1, RC.Color2, "SPIN")
                        createSparkles(hrp, RC.Color3, "SPIN")
                        createAuraParticles(hrp, RC.Color1, "SPIN")
                    end
                else
                    clearEffects(ch, "SPIN")
                end
            end
        end)
    end
})

RangeTab:CreateSlider({
    Name = " Spin Speed",
    Range = {10, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().ELITE_HUB_RangeSpinSpeed = value
    end
})

RangeTab:CreateToggle({
    Name = " Spin During Movement",
    CurrentValue = true,
    Callback = function(value)
        getgenv().ELITE_HUB_RangeSpinDuringMove = value
    end
})

local re3 = RangeTab:CreateSection("⚡ SPEED BOOST")

getgenv().ELITE_HUB_RangeSpeed = false
getgenv().ELITE_HUB_RangeSpeedVal = 24

RangeTab:CreateToggle({
    Name = " Speed Boost",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RangeSpeed = value
        getgenv().ELITE_HUB_Log("RANGE", "Speed: " .. tostring(value))
        pcall(function()
            local ch = player.Character
            if ch then
                if value then
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        createTrail(hrp, RC.Color1, RC.Color2, "SPEED")
                        createAuraParticles(hrp, RC.Color3, "SPEED")
                    end
                else
                    clearEffects(ch, "SPEED")
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = 16 end
                end
            end
        end)
    end
})

RangeTab:CreateSlider({
    Name = " Speed Value",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 24,
    Callback = function(value)
        getgenv().ELITE_HUB_RangeSpeedVal = value
    end
})

task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if not getgenv().ELITE_HUB_RangeSpeed then return end
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = getgenv().ELITE_HUB_RangeSpeedVal end
        end)
    end
end)
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    pcall(function()
        if getgenv().ELITE_HUB_RangeSpin then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                createTrail(hrp, RC.Color1, RC.Color2, "SPIN")
                createSparkles(hrp, RC.Color3, "SPIN")
                createAuraParticles(hrp, RC.Color1, "SPIN")
            end
            startSpin()
        end
    end)
    pcall(function()
        if getgenv().ELITE_HUB_RangeSpeed then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                createTrail(hrp, RC.Color1, RC.Color2, "SPEED")
                createAuraParticles(hrp, RC.Color3, "SPEED")
            end
        end
    end)
end)