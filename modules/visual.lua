-- source: ELITE_HUB_14.0.lua Visual (lines 9695-11288)
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
local VisualTab = _g().ELITE_HUB_VisualTab

MT = VisualTab
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
    Name = " Enable particles",
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
    Name = " Particle type",
    Options = {"Aura", "Trail", "Fire", "Rain", "Snow", "Sparkles", "Confetti", "Smoke", "Blood", "Glow", "Dust", "Bubble", "Lightning", "Poison", "Hex", "Lava", "Ice", "Plasma", "Leaves", "Feathers", "Stars", "Hearts", "Neon", "Chaos", "Meteor", "Electric", "Wind", "Shadow", "Crystal", "Sakura", "Galaxy", "Nuclear", "Phoenix", "Void", "Dragon"},
    CurrentOption = VisualConfig.ParticleType,
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        VisualConfig.ParticleType = v
        if VisualConfig.ParticlesEnabled then SetupParticles(player.Character) end
    end
})

VisualTab:CreateColorPicker({
    Name = " Color 1",
    Color = VisualConfig.ParticleColor,
    Callback = function(color)
        VisualConfig.ParticleColor = color
        if VisFx.Emitter then
            VisFx.Emitter.Color = ColorSequence.new(color, VisualConfig.ParticleColor2)
        end
    end
})

VisualTab:CreateColorPicker({
    Name = " Color 2 (gradient)",
    Color = VisualConfig.ParticleColor2,
    Callback = function(color)
        VisualConfig.ParticleColor2 = color
        if VisFx.Emitter then
            VisFx.Emitter.Color = ColorSequence.new(VisualConfig.ParticleColor, color)
        end
    end
})

VisualTab:CreateToggle({
    Name = " Glowing particles",
    CurrentValue = VisualConfig.ParticleGlow,
    Callback = function(value)
        VisualConfig.ParticleGlow = value
        if VisFx.Emitter then
            VisFx.Emitter.LightEmission = value and 1 or 0
        end
    end
})

VisualTab:CreateSlider({
    Name = " Particle size",
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
    Name = " Count/sec",
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
    Name = " Particle speed",
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
    Name = " Particle lifetime",
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

getgenv().ELITE_HUB_NeonBody = false
getgenv().ELITE_HUB_NeonBodyColor = Color3.fromRGB(0, 255, 255)
VisualTab:CreateSection("💡 NEON BODY")
VisualTab:CreateToggle({
    Name = " Neon Body",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_NeonBody = value
        getgenv().ELITE_HUB_Log("MODS", "Neon Body: " .. tostring(value))
        local ch = player.Character
        if not ch then return end
        for _, part in ipairs(ch:GetDescendants()) do
            if part:IsA("BasePart") then
                if value then
                    if not part:GetAttribute("EliteHubOrigMaterial") then
                        part:SetAttribute("EliteHubOrigMaterial", part.Material.Name)
                        part:SetAttribute("EliteHubOrigColor", part.Color)
                    end
                    part.Material = Enum.Material.Neon
                    part.Color = getgenv().ELITE_HUB_NeonBodyColor
                else
                    local origMat = part:GetAttribute("EliteHubOrigMaterial")
                    local origCol = part:GetAttribute("EliteHubOrigColor")
                    if origMat then
                        part.Material = Enum.Material[origMat] or Enum.Material.Plastic
                    end
                    if origCol then
                        part.Color = origCol
                    end
                    part:SetAttribute("EliteHubOrigMaterial", nil)
                    part:SetAttribute("EliteHubOrigColor", nil)
                end
            end
        end
    end
})
VisualTab:CreateColorPicker({
    Name = " Neon Color",
    Color = getgenv().ELITE_HUB_NeonBodyColor,
    Callback = function(color)
        getgenv().ELITE_HUB_NeonBodyColor = color
        if getgenv().ELITE_HUB_NeonBody then
            local ch = player.Character
            if ch then
                for _, part in ipairs(ch:GetDescendants()) do
                    if part:IsA("BasePart") and part.Material == Enum.Material.Neon then
                        part.Color = color
                    end
                end
            end
        end
    end
})
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        if getgenv().ELITE_HUB_NeonBody then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not part:GetAttribute("EliteHubOrigMaterial") then
                        part:SetAttribute("EliteHubOrigMaterial", part.Material.Name)
                        part:SetAttribute("EliteHubOrigColor", part.Color)
                    end
                    part.Material = Enum.Material.Neon
                    part.Color = getgenv().ELITE_HUB_NeonBodyColor
                end
            end
        end
    end)
end)

getgenv().ELITE_HUB_HitMarkers = false
getgenv().ELITE_HUB_HitMarkerColor = Color3.fromRGB(255, 0, 0)
getgenv().ELITE_HUB_HitMarkerSize = 30
getgenv().ELITE_HUB_HitMarkerDuration = 0.3
getgenv().ELITE_HUB_DamageNumbers = false
getgenv().ELITE_HUB_DamageNumberColor = Color3.fromRGB(255, 255, 0)

task.spawn(function()
VisualTab:CreateSection("💥 HIT EFFECTS")
VisualTab:CreateToggle({
    Name = " Hit Markers",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_HitMarkers = value
        getgenv().ELITE_HUB_Log("MODS", "Hit Markers: " .. tostring(value))
    end
})
VisualTab:CreateColorPicker({
    Name = " Hit Marker Color",
    Color = getgenv().ELITE_HUB_HitMarkerColor,
    Callback = function(color)
        getgenv().ELITE_HUB_HitMarkerColor = color
    end
})
VisualTab:CreateSlider({
    Name = " Hit Marker Size",
    Range = {10, 80},
    Increment = 5,
    CurrentValue = getgenv().ELITE_HUB_HitMarkerSize,
    Callback = function(value)
        getgenv().ELITE_HUB_HitMarkerSize = value
    end
})
VisualTab:CreateToggle({
    Name = " Damage Numbers",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_DamageNumbers = value
        getgenv().ELITE_HUB_Log("MODS", "Damage Numbers: " .. tostring(value))
    end
})
VisualTab:CreateColorPicker({
    Name = " Damage Color",
    Color = getgenv().ELITE_HUB_DamageNumberColor,
    Callback = function(color)
        getgenv().ELITE_HUB_DamageNumberColor = color
    end
})

local oldHealth = {}
local function hookCharacterDmg(plr, char)
    task.wait(1)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    oldHealth[plr.Name] = hum.Health
    hum.HealthChanged:Connect(function(newHP)
        local prev = oldHealth[plr.Name] or newHP
        local dmg = prev - newHP
        oldHealth[plr.Name] = newHP
        if dmg <= 0 then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if getgenv().ELITE_HUB_HitMarkers and plr ~= player then
            task.spawn(function()
                local gui = Instance.new("ScreenGui")
                gui.Name = "EliteHubHitMarker"
                gui.ResetOnSpawn = false
                gui.IgnoreGuiInset = true
                gui.DisplayOrder = 99999
                local s = getgenv().ELITE_HUB_HitMarkerSize
                local col = getgenv().ELITE_HUB_HitMarkerColor
                local offsets = {
                    {1, 1}, {-1, 1}, {1, -1}, {-1, -1}
                }
                for _, off in ipairs(offsets) do
                    local f = Instance.new("Frame")
                    f.AnchorPoint = Vector2.new(0.5, 0.5)
                    f.Size = UDim2.new(0, 2, 0, s)
                    f.Position = UDim2.new(0.5 + off[1] * 0.015, 0, 0.5 + off[2] * 0.015, 0)
                    f.BackgroundColor3 = col
                    f.BorderSizePixel = 0
                    f.Rotation = 45 * off[1] * off[2]
                    f.Parent = gui
                end
                pcall(function() gui.Parent = game:GetService("CoreGui") end)
                task.wait(getgenv().ELITE_HUB_HitMarkerDuration)
                gui:Destroy()
            end)
        end
        if getgenv().ELITE_HUB_DamageNumbers then
            task.spawn(function()
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "EliteHubDmgNum"
                billboard.Adornee = hrp
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(math.random(-2, 2), 2 + math.random(), 0)
                billboard.AlwaysOnTop = true
                billboard.LightInfluence = 0
                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = "-" .. math.floor(dmg)
                text.TextColor3 = getgenv().ELITE_HUB_DamageNumberColor
                text.TextStrokeTransparency = 0.3
                text.TextStrokeColor3 = Color3.new(0, 0, 0)
                text.TextScaled = true
                text.Font = Enum.Font.GothamBold
                text.Parent = billboard
                pcall(function() billboard.Parent = game:GetService("CoreGui") end)
                for i = 1, 30 do
                    task.wait(0.02)
                    billboard.StudsOffset = billboard.StudsOffset + Vector3.new(0, 0.05, 0)
                    text.TextTransparency = i / 30
                    text.TextStrokeTransparency = 0.3 + (i / 30) * 0.7
                end
                billboard:Destroy()
            end)
        end
    end)
end

for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
    if plr ~= player then
        plr.CharacterAdded:Connect(function(char) hookCharacterDmg(plr, char) end)
        if plr.Character then hookCharacterDmg(plr, plr.Character) end
    end
end
game:GetService("Players").PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char) hookCharacterDmg(plr, char) end)
end)
end)

getgenv().ELITE_HUB_FireTrail = false
getgenv().ELITE_HUB_FireTrailColor = Color3.fromRGB(255, 100, 0)
task.spawn(function()
VisualTab:CreateSection("🔥 FIRE TRAIL")
VisualTab:CreateToggle({
    Name = " Fire Trail",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_FireTrail = value
        getgenv().ELITE_HUB_Log("MODS", "Fire Trail: " .. tostring(value))
        local ch = player.Character
        if not ch then return end
        if value then
            for _, obj in ipairs(ch:GetDescendants()) do
                if obj.Name == "EliteHubFireTrail" then
                    pcall(function() obj:Destroy() end)
                end
            end
            for _, part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local fire = Instance.new("Fire")
                    fire.Name = "EliteHubFireTrail"
                    fire.Size = 2
                    fire.Heat = 1
                    fire.Color = getgenv().ELITE_HUB_FireTrailColor
                    fire.SecondaryColor = Color3.fromRGB(255, 200, 0)
                    fire.Enabled = true
                    fire.Parent = part
                end
            end
        else
            for _, obj in ipairs(ch:GetDescendants()) do
                if obj.Name == "EliteHubFireTrail" then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
})
VisualTab:CreateColorPicker({
    Name = " Fire Color",
    Color = getgenv().ELITE_HUB_FireTrailColor,
    Callback = function(color)
        getgenv().ELITE_HUB_FireTrailColor = color
        if getgenv().ELITE_HUB_FireTrail then
            local ch = player.Character
            if ch then
                for _, obj in ipairs(ch:GetDescendants()) do
                    if obj.Name == "EliteHubFireTrail" and obj:IsA("Fire") then
                        obj.Color = color
                    end
                end
            end
        end
    end
})
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        if getgenv().ELITE_HUB_FireTrail then
            for _, obj in ipairs(char:GetDescendants()) do
                if obj.Name == "EliteHubFireTrail" then
                    pcall(function() obj:Destroy() end)
                end
            end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local fire = Instance.new("Fire")
                    fire.Name = "EliteHubFireTrail"
                    fire.Size = 2
                    fire.Heat = 1
                    fire.Color = getgenv().ELITE_HUB_FireTrailColor
                    fire.SecondaryColor = Color3.fromRGB(255, 200, 0)
                    fire.Enabled = true
                    fire.Parent = part
                end
            end
        end
    end)
end)
end)
MT = VisualTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: VISUAL+")
MT:CreateSection("👁 ESP+")

getgenv().ELITE_HUB_ItemESP = false
MT:CreateToggle({
    Name = " Item ESP (items)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ItemESP = value
        getgenv().ELITE_HUB_Log("MODS", "Item ESP: " .. tostring(value))
        if not value then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:GetAttribute("EliteHubItemTag") then
                    local bb = v:FindFirstChildOfClass("BillboardGui")
                    if bb then pcall(function() bb:Destroy() end) end
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
MT = VisualTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: VISUAL+ (2)")
MT:CreateSection("👁 VISUAL+")

getgenv().ELITE_HUB_XRay = false
MT:CreateToggle({
    Name = " X-Ray (transparent walls)",
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
    Name = " Wallhack (walls disappear)",
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
MT = VisualTab
MT:CreateSection("🌍 WORLD SLIDERS")
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