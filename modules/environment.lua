-- source: ELITE_HUB_14.0.lua Environment (lines 10481-10547)
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
getgenv().ELITE_HUB_Log("UI", "Section loaded: ENV")
MT:CreateSection("🌳 ENVIRONMENT")

getgenv().ELITE_HUB_NightMode = false
getgenv().ELITE_HUB_NightOrigClock = nil
MT:CreateToggle({
    Name = " Night Mode",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_NightMode = value
        getgenv().ELITE_HUB_Log("MODS", "Night Mode: " .. tostring(value))
        local lighting = game:GetService("Lighting")
        if value then
            getgenv().ELITE_HUB_NightOrigClock = lighting.ClockTime
            getgenv().ELITE_HUB_NightOrigOutdoorAmbient = lighting.OutdoorAmbient
            getgenv().ELITE_HUB_NightOrigBrightness = lighting.Brightness
            lighting.ClockTime = 0
            lighting.Ambient = Color3.fromRGB(20, 20, 40)
            lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 40)
            lighting.Brightness = 0.5
        else
            if getgenv().ELITE_HUB_NightOrigClock then
                lighting.ClockTime = getgenv().ELITE_HUB_NightOrigClock
            end
            lighting.Ambient = Color3.fromRGB(128, 128, 128)
            if getgenv().ELITE_HUB_NightOrigOutdoorAmbient then
                lighting.OutdoorAmbient = getgenv().ELITE_HUB_NightOrigOutdoorAmbient
            end
            if getgenv().ELITE_HUB_NightOrigBrightness then
                lighting.Brightness = getgenv().ELITE_HUB_NightOrigBrightness
            end
        end
    end
})

getgenv().ELITE_HUB_NoFog = false
getgenv().ELITE_HUB_NoFogOrigFogEnd = nil
getgenv().ELITE_HUB_NoFogOrigFogStart = nil
getgenv().ELITE_HUB_NoFogOrigFogColor = nil
MT:CreateToggle({
    Name = " No Fog",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_NoFog = value
        getgenv().ELITE_HUB_Log("MODS", "No Fog: " .. tostring(value))
        local lighting = game:GetService("Lighting")
        if value then
            getgenv().ELITE_HUB_NoFogOrigFogEnd = lighting.FogEnd
            getgenv().ELITE_HUB_NoFogOrigFogStart = lighting.FogStart
            getgenv().ELITE_HUB_NoFogOrigFogColor = lighting.FogColor
            lighting.FogEnd = 10000000
            lighting.FogStart = 10000000
            lighting.FogColor = Color3.fromRGB(200, 200, 255)
        else
            if getgenv().ELITE_HUB_NoFogOrigFogEnd ~= nil then
                lighting.FogEnd = getgenv().ELITE_HUB_NoFogOrigFogEnd
            end
            if getgenv().ELITE_HUB_NoFogOrigFogStart ~= nil then
                lighting.FogStart = getgenv().ELITE_HUB_NoFogOrigFogStart
            end
            if getgenv().ELITE_HUB_NoFogOrigFogColor ~= nil then
                lighting.FogColor = getgenv().ELITE_HUB_NoFogOrigFogColor
            end
        end
    end
})