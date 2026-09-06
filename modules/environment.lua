-- ELITE HUB 14.0 — Environment Module (Night Mode, Gravity, FOV)
-- Extracted from ELITE_HUB_14.0.lua

MT = EnvironmentTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: ENV")
MT:CreateSection("🌙 ENVIRONMENT")

getgenv().ELITE_HUB_NightMode = false
getgenv().ELITE_HUB_NightOrigClock = nil
MT:CreateToggle({
    Name = "🌙 Night Mode",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_NightMode = value
        getgenv().ELITE_HUB_Log("MODS", "Night Mode: " .. tostring(value))
        local lighting = game:GetService("Lighting")
        if value then
            getgenv().ELITE_HUB_NightOrigClock = lighting.ClockTime
            lighting.ClockTime = 0
            lighting.Ambient = Color3.fromRGB(20, 20, 40)
            lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 40)
            lighting.Brightness = 0.5
        else
            if getgenv().ELITE_HUB_NightOrigClock then
                lighting.ClockTime = getgenv().ELITE_HUB_NightOrigClock
            end
            lighting.Ambient = Color3.fromRGB(128, 128, 128)
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            lighting.Brightness = 2
        end
    end
})

MT = EnvironmentTab
MT:CreateSection("🌍 WORLD SLIDERS")
MT:CreateSlider({
    Name = "🌍 Gravity",
    Range = {0, 300},
    Increment = 5,
    CurrentValue = 196,
    Callback = function(value)
        workspace.Gravity = value
        getgenv().ELITE_HUB_Log("MODS", "Gravity: " .. value)
    end
})

MT:CreateSlider({
    Name = "🔭 FOV",
    Range = {30, 120},
    Increment = 5,
    CurrentValue = 70,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
        getgenv().ELITE_HUB_Log("MODS", "FOV: " .. value)
    end
})
