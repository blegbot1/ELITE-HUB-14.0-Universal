-- source: ELITE_HUB_14.0.lua SETTINGS (lines 12543-12622)
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
local SettingsTab = Window:CreateTab("⚙ " .. L("Settings"), 0, "Settings")

local s1 = SettingsTab:CreateSection(L("Settings"))
table.insert(Window._translatables, {element = s1, key = "Settings", type = "section", prefix = ""})

local s2 = SettingsTab:CreateSection(L("Config"))
table.insert(Window._translatables, {element = s2, key = "Config", type = "section", prefix = ""})

local saveBtn = SettingsTab:CreateButton({
    Name = L("SaveConfig"),
    Callback = function()
        pcall(function()
            local data = game:GetService("HttpService"):JSONEncode({
                Animations = true,
                Lang = "EN",
            })
            writefile("EliteHub_Config.json", data)
            Rayfield:Notify({Title = "✅ OK", Content = L("ConfigSaved"), Duration = 2})
        end)
    end
})
table.insert(Window._translatables, {element = saveBtn, key = "SaveConfig", type = "button"})

local loadBtn = SettingsTab:CreateButton({
    Name = L("LoadConfig"),
    Callback = function()
        pcall(function()
            if not isfile("EliteHub_Config.json") then
                Rayfield:Notify({Title = "⚠️ Warning", Content = L("NoConfig"), Duration = 2})
                return
            end
            local data = game:GetService("HttpService"):JSONDecode(readfile("EliteHub_Config.json"))
            Window:_updateAll()
            Rayfield:Notify({Title = "✅ OK", Content = L("ConfigLoaded"), Duration = 2})
        end)
    end
})
table.insert(Window._translatables, {element = loadBtn, key = "LoadConfig", type = "button"})

local resetBtn = SettingsTab:CreateButton({
    Name = L("ResetSettings"),
    Callback = function()
        ES.Animations = true
        ES.Lang = "EN"
        Window:_updateAll()
        Rayfield:Notify({Title = "✅ OK", Content = L("SettingsReset"), Duration = 2})
    end
})
table.insert(Window._translatables, {element = resetBtn, key = "ResetSettings", type = "button"})

local verLabel = SettingsTab:CreateLabel(L("Version"))
table.insert(Window._translatables, {element = verLabel.Frame, key = "Version", type = "label"})