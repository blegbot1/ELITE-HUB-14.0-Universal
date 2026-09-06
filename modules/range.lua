-- ELITE HUB 14.0 — Range Module (Effects, Spin Bot, Speed Boost)
-- Extracted from ELITE_HUB_14.0.lua
local RangeTab = Window:CreateTab("🎯 " .. "RANGE", 7733960981, "Range")

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

local function createTrail(parent, c1, c2)
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
        trail.Parent = parent
        return trail
    end)
end

local function createSparkles(parent, color)
    pcall(function()
        local s = Instance.new("Sparkles")
        s.SparkleColor = color or RC.Color3
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
        pe.Parent = parent
        return pe
    end)
end

local function createAuraParticles(parent, color)
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
        pe.Parent = parent
        return pe
    end)
end

local function clearEffects(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in ipairs(hrp:GetChildren()) do
            if v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") then
                v:Destroy()
            end
        end
    end
end

local re1 = RangeTab:CreateSection("🎨 EFFECTS")

RangeTab:CreateSlider({
    Name = "🎨 R",
    Range = {0, 255},
    Increment = 5,
    CurrentValue = 150,
    Callback = function(value)
        RC.Color1 = Color3.fromRGB(value, RC.Color1.G * 255, RC.Color1.B * 255)
    end
})

RangeTab:CreateSlider({
    Name = "🎨 G",
    Range = {0, 255},
    Increment = 5,
    CurrentValue = 70,
    Callback = function(value)
        local c = RC.Color1
        RC.Color1 = Color3.fromRGB(c.R * 255, value, c.B * 255)
    end
})

RangeTab:CreateSlider({
    Name = "🎨 B",
    Range = {0, 255},
    Increment = 5,
    CurrentValue = 255,
    Callback = function(value)
        local c = RC.Color1
        RC.Color1 = Color3.fromRGB(c.R * 255, c.G * 255, value)
    end
})

RangeTab:CreateSlider({
    Name = "⏱️ Trail Lifetime",
    Range = {0.2, 2},
    Increment = 0.1,
    CurrentValue = 0.8,
    Callback = function(value)
        RC.TrailSpeed = value
    end
})

RangeTab:CreateSlider({
    Name = "✨ Sparkle Rate",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(value)
        RC.SparkleRate = value
    end
})

RangeTab:CreateSlider({
    Name = "💨 Particle Speed",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(value)
        RC.ParticleSpeed = value
    end
})

RangeTab:CreateSlider({
    Name = "⏱️ Particle Life",
    Range = {0.1, 2},
    Increment = 0.1,
    CurrentValue = 0.6,
    Callback = function(value)
        RC.ParticleLife = value
    end
})

RangeTab:CreateSlider({
    Name = "📦 Particle Size",
    Range = {0.5, 5},
    Increment = 0.5,
    CurrentValue = 2,
    Callback = function(value)
        RC.ParticleSize = value
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

getgenv().ELITE_HUB_RangeSpin = false
getgenv().ELITE_HUB_RangeSpinSpeed = 50
getgenv().ELITE_HUB_RangeSpinDuringMove = true

RangeTab:CreateToggle({
    Name = "🔄 Spin Bot",
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
                        createTrail(hrp, RC.Color1, RC.Color2)
                        createSparkles(hrp, RC.Color3)
                        createAuraParticles(hrp, RC.Color1)
                    end
                else
                    clearEffects(ch)
                end
            end
        end)
    end
})

RangeTab:CreateSlider({
    Name = "🔄 Spin Speed",
    Range = {10, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().ELITE_HUB_RangeSpinSpeed = value
    end
})

RangeTab:CreateToggle({
    Name = "🏃 Spin During Movement",
    CurrentValue = true,
    Callback = function(value)
        getgenv().ELITE_HUB_RangeSpinDuringMove = value
    end
})

local re3 = RangeTab:CreateSection("🏃 SPEED BOOST")

getgenv().ELITE_HUB_RangeSpeed = false
getgenv().ELITE_HUB_RangeSpeedVal = 24

RangeTab:CreateToggle({
    Name = "🏃 Speed Boost",
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
                        createTrail(hrp, RC.Color1, RC.Color2)
                        createAuraParticles(hrp, RC.Color3)
                    end
                else
                    clearEffects(ch)
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = 16 end
                end
            end
        end)
    end
})

RangeTab:CreateSlider({
    Name = "🏃 Speed Value",
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
