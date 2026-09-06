-- ELITE HUB 14.0 — Visual Module (Particles + Chinese Hat)
-- Extracted from ELITE_HUB_14.0.lua

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

VisualTab:CreateSection("✨ PARTICLES")

VisualTab:CreateToggle({
    Name = "✨ Enable particles",
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
    Name = "🎯 Particle type",
    Options = {"Aura", "Trail", "Fire", "Rain", "Snow", "Sparkles", "Confetti", "Smoke", "Blood", "Glow", "Dust", "Bubble", "Lightning", "Poison", "Hex", "Lava", "Ice", "Plasma", "Leaves", "Feathers", "Stars", "Hearts", "Neon", "Chaos", "Meteor", "Electric", "Wind", "Shadow", "Crystal", "Sakura", "Galaxy", "Nuclear", "Phoenix", "Void", "Dragon"},
    CurrentOption = VisualConfig.ParticleType,
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        VisualConfig.ParticleType = v
        if VisualConfig.ParticlesEnabled then SetupParticles(player.Character) end
    end
})

VisualTab:CreateColorPicker({
    Name = "🎨 Color 1",
    Color = VisualConfig.ParticleColor,
    Callback = function(color)
        VisualConfig.ParticleColor = color
        if VisFx.Emitter then
            VisFx.Emitter.Color = ColorSequence.new(color, VisualConfig.ParticleColor2)
        end
    end
})

VisualTab:CreateColorPicker({
    Name = "🎨 Color 2 (gradient)",
    Color = VisualConfig.ParticleColor2,
    Callback = function(color)
        VisualConfig.ParticleColor2 = color
        if VisFx.Emitter then
            VisFx.Emitter.Color = ColorSequence.new(VisualConfig.ParticleColor, color)
        end
    end
})

VisualTab:CreateToggle({
    Name = "💡 Glowing particles",
    CurrentValue = VisualConfig.ParticleGlow,
    Callback = function(value)
        VisualConfig.ParticleGlow = value
        if VisFx.Emitter then
            VisFx.Emitter.LightEmission = value and 1 or 0
        end
    end
})

VisualTab:CreateSlider({
    Name = "⚪ Particle size",
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
    Name = "⚡ Count/sec",
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
    Name = "🚀 Particle speed",
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
    Name = "⏳ Particle lifetime",
    Range = {0.3, 5},
    Increment = 0.1,
    Suffix = "с",
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
local MT = VisualTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: CHINESE HAT")
MT:CreateSection("🎩 CHINESE HAT")

getgenv().ELITE_HUB_ChineseHatOn = false
getgenv().ELITE_HUB_ChineseHatY = 0.5
getgenv().ELITE_HUB_ChineseHatConeH = 1.2
getgenv().ELITE_HUB_ChineseHatR = 2.5
getgenv().ELITE_HUB_ChineseHatColor = Color3.fromRGB(255, 0, 255)
getgenv().ELITE_HUB_ChineseHatSpin = false
getgenv().ELITE_HUB_ChineseHatSpinSpeed = 50
local hatConn = nil
local hatParts = {}
local hatSpinParts = {}

local function RemoveHat(char)
    if hatConn then hatConn:Disconnect() hatConn = nil end
    hatParts = {}
    hatSpinParts = {}
    local old = char and char:FindFirstChild("ELITEHUB_CHINESE_HAT")
    if old then pcall(function() old:Destroy() end) end
end

local function MakePart(props)
    local p = Instance.new("Part")
    p.Size = props.Size or Vector3.new(1,1,1)
    p.Shape = props.Shape or Enum.PartType.Block
    p.Material = props.Material or Enum.Material.ForceField
    p.Color = props.Color or Color3.new(1,1,1)
    p.CanCollide = false
    p.Anchored = true
    p.CastShadow = false
    p.Massless = true
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.FrontSurface = Enum.SurfaceType.Smooth
    p.BackSurface = Enum.SurfaceType.Smooth
    p.LeftSurface = Enum.SurfaceType.Smooth
    p.RightSurface = Enum.SurfaceType.Smooth
    p.CustomPhysicalProperties = PhysicalProperties.new(0.001, 0, 0, 1, 1)
    return p
end

local function BuildHat(char)
    if not getgenv().ELITE_HUB_ChineseHatOn then return end
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    RemoveHat(char)
    task.wait(0.2)

    local hat = Instance.new("Model")
    hat.Name = "ELITEHUB_CHINESE_HAT"
    hat.Parent = char

    local R = getgenv().ELITE_HUB_ChineseHatR
    local H = getgenv().ELITE_HUB_ChineseHatConeH
    local Y = getgenv().ELITE_HUB_ChineseHatY
    local COL = getgenv().ELITE_HUB_ChineseHatColor
    local N = 48
    local headCF = head.CFrame

    for i = 0, N - 1 do
        local ang = (i / N) * math.pi * 2
        local segW = 2 * R * math.tan(math.pi / N) * 1.08

        local slat = MakePart({
            Size = Vector3.new(segW, math.sqrt(R*R + H*H), 0.03),
            Color = COL,
        })

        local bottomPos = Vector3.new(R * math.cos(ang), Y, R * math.sin(ang))
        local apexPos = Vector3.new(0, Y + H, 0)
        local center = (bottomPos + apexPos) / 2
        local dir = (apexPos - bottomPos).Unit
        local tangent = Vector3.new(-math.sin(ang), 0, math.cos(ang))

        local localCF = CFrame.fromMatrix(center, tangent, dir)
        local worldCF = headCF * localCF

        slat.CFrame = worldCF
        slat:BreakJoints()
        slat.Parent = hat
        hatParts[slat] = headCF:Inverse() * worldCF
        hatSpinParts[slat] = localCF
    end

    local tip = MakePart({
        Shape = Enum.PartType.Ball,
        Size = Vector3.new(0.15, 0.18, 0.15),
        Color = COL,
    })
    local tipLocal = CFrame.new(0, Y + H + 0.05, 0)
    tip.CFrame = headCF * tipLocal
    tip:BreakJoints()
    tip.Parent = hat
    hatParts[tip] = tipLocal
    hatSpinParts[tip] = tipLocal

    local brim = MakePart({
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(0.06, R * 2 + 0.4, R * 2 + 0.4),
        Color = COL,
    })
    local brimLocal = CFrame.new(0, Y, 0) * CFrame.Angles(0, 0, math.pi / 2)
    brim.CFrame = headCF * brimLocal
    brim:BreakJoints()
    brim.Parent = hat
    hatParts[brim] = brimLocal
    hatSpinParts[brim] = brimLocal

    for p, _ in pairs(hatParts) do
        p.Anchored = false
    end

    if hatConn then hatConn:Disconnect() hatConn = nil end
    local RunService = game:GetService("RunService")
    local spinAngle = 0
    hatConn = RunService.Heartbeat:Connect(function(dt)
        pcall(function()
            if not getgenv().ELITE_HUB_ChineseHatOn then
                hatConn:Disconnect()
                hatConn = nil
                return
            end
            local h = char and char:FindFirstChild("ELITEHUB_CHINESE_HAT")
            if not h then return end
            local hd = char:FindFirstChild("Head")
            if not hd then return end

            if getgenv().ELITE_HUB_ChineseHatSpin then
                spinAngle = spinAngle + (getgenv().ELITE_HUB_ChineseHatSpinSpeed or 50) * dt * 3
            end

            local spinCF = CFrame.Angles(0, math.rad(spinAngle), 0)
            local hdCF = hd.CFrame
            for p, localCF in pairs(hatSpinParts) do
                if p and p.Parent then
                    p.CanCollide = false
                    p.Massless = true
                    p.CFrame = hdCF * spinCF * localCF
                end
            end
        end)
    end)
end

MT:CreateToggle({
    Name = "🎩 Chinese Hat",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatOn = value
        getgenv().ELITE_HUB_Log("MODS", "Chinese Hat: " .. tostring(value))
        if value then
            task.spawn(function() BuildHat(player.Character) end)
        else
            RemoveHat(player.Character)
        end
    end
})

MT:CreateSlider({
    Name = "⬆️ Hat Height (Y)",
    Range = {0, 1.5},
    Increment = 0.05,
    CurrentValue = 0.5,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatY = value
        if getgenv().ELITE_HUB_ChineseHatOn then
            task.spawn(function() BuildHat(player.Character) end)
        end
    end
})

MT:CreateSlider({
    Name = "🔺 Cone Height",
    Range = {0.3, 3},
    Increment = 0.1,
    CurrentValue = 1.2,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatConeH = value
        if getgenv().ELITE_HUB_ChineseHatOn then
            task.spawn(function() BuildHat(player.Character) end)
        end
    end
})

MT:CreateSlider({
    Name = "📏 Cone Radius",
    Range = {0.5, 3},
    Increment = 0.1,
    CurrentValue = 2.5,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatR = value
        if getgenv().ELITE_HUB_ChineseHatOn then
            task.spawn(function() BuildHat(player.Character) end)
        end
    end
})

MT:CreateColorPicker({
    Name = "🎨 Hat Color",
    Color = Color3.fromRGB(255, 0, 255),
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatColor = value
        if getgenv().ELITE_HUB_ChineseHatOn then
            task.spawn(function() BuildHat(player.Character) end)
        end
    end
})

MT:CreateToggle({
    Name = "🔄 Spin",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatSpin = value
        getgenv().ELITE_HUB_Log("MODS", "Chinese Hat Spin: " .. tostring(value))
    end
})

MT:CreateSlider({
    Name = "🔄 Spin Speed",
    Range = {10, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().ELITE_HUB_ChineseHatSpinSpeed = value
    end
})

player.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        if getgenv().ELITE_HUB_ChineseHatOn then
            BuildHat(char)
        end
    end)
end)
end)
