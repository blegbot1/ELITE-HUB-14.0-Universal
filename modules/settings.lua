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
local HttpService = game:GetService("HttpService")

local s1 = SettingsTab:CreateSection(L("Settings"))
table.insert(Window._translatables, {element = s1, key = "Settings", type = "section", prefix = ""})

local CONFIG_DIR = "EliteHub_Configs/"

local function getListFile()
    return CONFIG_DIR .. "_list.json"
end

local function getConfigList()
    pcall(function()
        if not isfile(getListFile()) then
            writefile(getListFile(), HttpService:JSONEncode({}))
        end
    end)
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(getListFile()))
    end)
    return ok and data or {}
end

local function saveConfigList(list)
    pcall(function()
        writefile(getListFile(), HttpService:JSONEncode(list))
    end)
end

local function getSavedConfigs()
    local list = getConfigList()
    local names = {}
    for name, _ in pairs(list) do
        table.insert(names, name)
    end
    table.sort(names)
    return names, list
end

local function collectSettings()
    local g = _g()
    return {
        ESP = g.ELITE_HUB_ESPConfig and {
            Enabled = g.ELITE_HUB_ESPConfig.Enabled,
            Boxes = g.ELITE_HUB_ESPConfig.Boxes,
            Names = g.ELITE_HUB_ESPConfig.Names,
            Health = g.ELITE_HUB_ESPConfig.Health,
            Distance = g.ELITE_HUB_ESPConfig.Distance,
            Tracers = g.ELITE_HUB_ESPConfig.Tracers,
            Skeletons = g.ELITE_HUB_ESPConfig.Skeletons,
            HeadDots = g.ELITE_HUB_ESPConfig.HeadDots,
        } or {},
        Aimbot = g.ELITE_HUB_AimbotConfig and {
            Enabled = g.ELITE_HUB_AimbotConfig.Enabled,
            FOV = g.ELITE_HUB_AimbotConfig.FOV,
            Smoothness = g.ELITE_HUB_AimbotConfig.Smoothness,
            Prediction = g.ELITE_HUB_AimbotConfig.Prediction,
        } or {},
        Visual = {
            JumpRingsOn = g.ELITE_HUB_JumpRingsOn,
            JumpRingsRadius = g.ELITE_HUB_JumpRingsRadius,
            JumpRingsPattern = g.ELITE_HUB_JumpRingsPattern,
            PlayerHUDOn = g.ELITE_HUB_PlayerHUDOn,
            NameTagOn = g.ELITE_HUB_NameTagOn,
            CrosshairOn = g.ELITE_HUB_CrosshairOn,
            CrosshairStyle = g.ELITE_HUB_CrosshairStyle,
        },
    }
end

local function applySettings(data)
    if not data then return end
    local g = _g()
    if data.ESP then
        local e = g.ELITE_HUB_ESPConfig
        if e then
            for k, v in pairs(data.ESP) do e[k] = v end
        end
    end
    if data.Aimbot then
        local a = g.ELITE_HUB_AimbotConfig
        if a then
            for k, v in pairs(data.Aimbot) do a[k] = v end
        end
    end
    if data.Visual then
        for k, v in pairs(data.Visual) do
            g["ELITE_HUB_" .. k] = v
        end
    end
    Window:_updateAll()
end

local s2 = SettingsTab:CreateSection("💾 CONFIGS")

local selectedConfig = {name = nil}

SettingsTab:CreateInput({
    Name = " Config Name",
    PlaceholderText = "Enter config name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local name = text:match("^%s*(.-)%s*$")
        if name and #name > 0 then
            selectedConfig.name = name
        end
    end
})

local namesList, _ = getSavedConfigs()
local configDropdown = SettingsTab:CreateDropdown({
    Name = " Select Config",
    Options = #namesList > 0 and namesList or {"No configs"},
    CurrentOption = #namesList > 0 and {namesList[1]} or {"No configs"},
    Callback = function(opt)
        local v = (typeof(opt) == "table") and opt[1] or opt
        if v ~= "No configs" then
            selectedConfig.name = v
        end
    end
})

SettingsTab:CreateButton({
    Name = " Save Config",
    Callback = function()
        local name = selectedConfig.name
        if not name or #name == 0 then
            Rayfield:Notify({Title = "⚠️ Warning", Content = "Enter a config name first", Duration = 2})
            return
        end
        pcall(function()
            local list = getConfigList()
            list[name] = collectSettings()
            saveConfigList(list)
            local updatedNames = {}
            for n, _ in pairs(list) do table.insert(updatedNames, n) end
            table.sort(updatedNames)
            configDropdown:Refresh(updatedNames)
            Rayfield:Notify({Title = "✅ OK", Content = "Saved: " .. name, Duration = 2})
        end)
    end
})

SettingsTab:CreateButton({
    Name = " Load Config",
    Callback = function()
        local name = selectedConfig.name
        if not name or #name == 0 then
            Rayfield:Notify({Title = "⚠️ Warning", Content = "Select a config first", Duration = 2})
            return
        end
        pcall(function()
            local list = getConfigList()
            if list[name] then
                applySettings(list[name])
                Rayfield:Notify({Title = "✅ OK", Content = "Loaded: " .. name, Duration = 2})
            else
                Rayfield:Notify({Title = "⚠️ Warning", Content = "Config not found: " .. name, Duration = 2})
            end
        end)
    end
})

SettingsTab:CreateButton({
    Name = " Delete Config",
    Callback = function()
        local name = selectedConfig.name
        if not name or #name == 0 then
            Rayfield:Notify({Title = "⚠️ Warning", Content = "Select a config first", Duration = 2})
            return
        end
        pcall(function()
            local list = getConfigList()
            if list[name] then
                list[name] = nil
                saveConfigList(list)
                local updatedNames = {}
                for n, _ in pairs(list) do table.insert(updatedNames, n) end
                table.sort(updatedNames)
                configDropdown:Refresh(#updatedNames > 0 and updatedNames or {"No configs"})
                Rayfield:Notify({Title = "✅ OK", Content = "Deleted: " .. name, Duration = 2})
            end
        end)
    end
})

SettingsTab:CreateButton({
    Name = " Reset Settings",
    Callback = function()
        ES.Animations = true
        ES.Lang = "EN"
        Window:_updateAll()
        Rayfield:Notify({Title = "✅ OK", Content = L("SettingsReset"), Duration = 2})
    end
})

local verLabel = SettingsTab:CreateLabel(L("Version"))
table.insert(Window._translatables, {element = verLabel.Frame, key = "Version", type = "label"})
