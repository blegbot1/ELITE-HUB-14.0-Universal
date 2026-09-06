-- ELITE HUB 14.0 — Settings Module
-- Extracted from ELITE_HUB_14.0.lua

local SettingsTab = Window:CreateTab("⚙️ " .. L("Settings"), 0, "Settings")

local s1 = SettingsTab:CreateSection(L("Settings"))
table.insert(Window._translatables, {element = s1, key = "Settings", type = "section", prefix = ""})

local langDrop = SettingsTab:CreateDropdown({
    Name = L("Language"),
    Options = {"RU", "EN"},
    CurrentOption = ES.Lang,
    Callback = function(opt)
        ES.Lang = opt
        Window:_updateAll()
        pcall(function()
            writefile("EliteHub_Config.json", game:GetService("HttpService"):JSONEncode({Animations = ES.Animations, Lang = ES.Lang}))
        end)
    end
})
table.insert(Window._translatables, {element = langDrop.Frame, key = "Language", type = "dropdown"})

local animToggle = SettingsTab:CreateToggle({
    Name = L("Animations"),
    CurrentValue = ES.Animations,
    Callback = function(val)
        ES.Animations = val
        pcall(function()
            writefile("EliteHub_Config.json", game:GetService("HttpService"):JSONEncode({Animations = ES.Animations, Lang = ES.Lang}))
        end)
    end
})
table.insert(Window._translatables, {element = animToggle.Frame, key = "Animations", type = "toggle"})

local s2 = SettingsTab:CreateSection(L("Config"))
table.insert(Window._translatables, {element = s2, key = "Config", type = "section", prefix = ""})

local saveBtn = SettingsTab:CreateButton({
    Name = L("SaveConfig"),
    Callback = function()
        pcall(function()
            local data = game:GetService("HttpService"):JSONEncode({
                Animations = ES.Animations,
                Lang = ES.Lang,
            })
            writefile("EliteHub_Config.json", data)
            Rayfield:Notify({Title = "OK", Content = L("ConfigSaved"), Duration = 2})
        end)
    end
})
table.insert(Window._translatables, {element = saveBtn, key = "SaveConfig", type = "button"})

local loadBtn = SettingsTab:CreateButton({
    Name = L("LoadConfig"),
    Callback = function()
        pcall(function()
            if not isfile("EliteHub_Config.json") then
                Rayfield:Notify({Title = "!", Content = L("NoConfig"), Duration = 2})
                return
            end
            local data = game:GetService("HttpService"):JSONDecode(readfile("EliteHub_Config.json"))
            if data.Animations ~= nil then ES.Animations = data.Animations end
            if data.Lang then ES.Lang = data.Lang end
            Window:_updateAll()
            Rayfield:Notify({Title = "OK", Content = L("ConfigLoaded"), Duration = 2})
        end)
    end
})
table.insert(Window._translatables, {element = loadBtn, key = "LoadConfig", type = "button"})

local resetBtn = SettingsTab:CreateButton({
    Name = L("ResetSettings"),
    Callback = function()
        ES.Animations = true
        ES.Lang = "RU"
        Window:_updateAll()
        Rayfield:Notify({Title = "OK", Content = L("SettingsReset"), Duration = 2})
    end
})
table.insert(Window._translatables, {element = resetBtn, key = "ResetSettings", type = "button"})

local verLabel = SettingsTab:CreateLabel(L("Version"))
table.insert(Window._translatables, {element = verLabel.Frame, key = "Version", type = "label"})

end) -- конец task.spawn(mods)
