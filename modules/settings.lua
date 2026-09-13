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
pcall(function() makefolder(CONFIG_DIR) end)

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

local function serColor(c)
    if typeof(c) == "Color3" then
        return {R = c.R, G = c.G, B = c.B}
    end
    return c
end

local function deColor(v)
    if type(v) == "table" and v.R ~= nil and v.G ~= nil and v.B ~= nil and v.__class == nil then
        return Color3.new(v.R, v.G, v.B)
    end
    return v
end

local function serTable(t)
    if type(t) ~= "table" then return t end
    local out = {}
    for k, v in pairs(t) do
        if typeof(v) == "Color3" then
            out[k] = serColor(v)
        elseif type(v) == "table" then
            out[k] = serTable(v)
        else
            out[k] = v
        end
    end
    return out
end

local function deTable(t)
    if type(t) ~= "table" then return t end
    local out = {}
    for k, v in pairs(t) do
        if type(v) == "table" and v.R ~= nil and v.G ~= nil and v.B ~= nil and v.__class == nil then
            out[k] = Color3.new(v.R, v.G, v.B)
        elseif type(v) == "table" then
            out[k] = deTable(v)
        else
            out[k] = v
        end
    end
    return out
end

local function collectTable(src, keys)
    local out = {}
    for _, k in ipairs(keys) do
        local v = src[k]
        if v ~= nil then
            if typeof(v) == "Color3" then
                out[k] = serColor(v)
            elseif type(v) == "table" and k == "ChamsMaterial" then
                out[k] = tostring(v)
            elseif type(v) == "table" then
                out[k] = serTable(v)
            else
                out[k] = v
            end
        end
    end
    return out
end

local ESP_KEYS = {
    "Enabled","TeamCheck","ShowTeammates","Boxes","BoxStyle","Names","Health","Distance",
    "Tracers","TracersForTeammates","ShowDead","Box3DFilled","UpdateFrequency",
    "EnemyColor","TeammateColor","OutlineColor","TextColor","TracerColor","Box3DColor","DeadColor",
    "TextSize","FillTransparency","TracerThickness","Box3DThickness","Box3DSize","CornerLength",
    "FriendCheck","FriendColor","HighlightTarget","ShowArrows","ArrowsColor","ESPOutlineColor",
    "SmoothArrows","SnapLines","SnapLinesColor","HighlightLockTarget","LockTargetColor",
    "Skeletons","SkeletonColor","SkeletonThickness","SkeletonType",
    "HeadDots","HeadDotColor","HeadDotSize","MaxESPDistance",
    "ShowScriptUserTag","ScriptUserTagColor","ShowHealthBar","HealthBarColor","HealthBarWidth","HealthBarHeight",
    "HighlightClosest","HighlightClosestColor",
    "ChamsEnabled","ChamsFillColor","ChamsFillTransparency","ChamsOutlineColor","ChamsOutlineTransparency",
    "ChamsTeamCheck","ChamsSelf","ChamsTeammates",
    "Crosshair","CrosshairColor","CrosshairSize","CrosshairThickness","CrosshairSpread",
    "LowHPWarning","LowHPThreshold","LowHPColor",
    "WeaponDisplay","WeaponDisplayColor"
}

local AIMBOT_KEYS = {
    "Enabled","TeamCheck","AliveCheck","WallCheck","FOV","ShowFOV","FOVColor","LockedColor",
    "TriggerKey","Toggle","LockPart","ThirdPersonFix","Priority","MaxDistance","MinDistance",
    "AimOffset","FOVThickness","FriendCheck","SpawnCheck","TeamFilter","EnemyPriority",
    "ShowTargetIndicator","ShowTargetArrow","ShowTargetHP","TargetIndicatorSize","TargetCircleColor",
    "ShowTargetSkeleton","TargetSkeletonColor","TargetSkeletonThickness","TargetSkeletonType",
    "AutoShoot","AutoShootDelay","ShowAimLine","AimLineColor","ShowTargetNameBig",
    "Prediction","PredictionFactor","AntiAimDetect",
    "DistanceFOV","DistanceFOVMin","DistanceFOVMax",
    "KillNotify","NotifyLock","NotifyUnlock","NotifyAntiAim","NotifyLowHP","NotifyShot",
    "NotifyPlayerJoin","NotifyPlayerLeave","NotifyTargetLost",
    "PersistentLock","PulseTarget","PulseColor","PulseSize","PulseSpeed",
    "TargetHealthBarTop","TargetHealthBarMounted"
}

local VISUAL_GLOBALS = {
    "ELITE_HUB_JumpRingsOn","ELITE_HUB_JumpRingsRadius","ELITE_HUB_JumpRingsPattern",
    "ELITE_HUB_JumpRingsColor","ELITE_HUB_JumpRingsCount",
    "ELITE_HUB_PlayerHUDOn","ELITE_HUB_NameTagOn",
    "ELITE_HUB_CrosshairOn","ELITE_HUB_CrosshairStyle","ELITE_HUB_CrosshairColor","ELITE_HUB_CrosshairSpeed",
    "ELITE_HUB_NeonBody","ELITE_HUB_NeonBodyColor",
    "ELITE_HUB_HitMarkers","ELITE_HUB_HitMarkerColor","ELITE_HUB_HitMarkerSize","ELITE_HUB_HitMarkerDuration",
    "ELITE_HUB_DamageNumbers","ELITE_HUB_DamageNumberColor",
    "ELITE_HUB_FireTrail","ELITE_HUB_FireTrailColor",
    "ELITE_HUB_ItemESP",
    "ELITE_HUB_XRay","ELITE_HUB_Wallhack",
    "ELITE_HUB_SkyboxEnabled","ELITE_HUB_SkyboxId",
    "ELITE_HUB_RgbOn","ELITE_HUB_RgbSpeed",
    "ELITE_HUB_RealisticAtmosphere",
    "ELITE_HUB_OverlaySize","ELITE_HUB_OverlayFrameDelay",
    "ELITE_HUB_OverlaySoundVol","ELITE_HUB_OverlaySoundPlaying"
}

local RANGE_GLOBALS = {
    "ELITE_HUB_RangeSpin","ELITE_HUB_RangeSpinSpeed","ELITE_HUB_RangeSpinDuringMove",
    "ELITE_HUB_RangeSpeed","ELITE_HUB_RangeSpeedVal",
    "ELITE_HUB_RangeWeaponChams","ELITE_HUB_RangeWeaponColor",
    "ELITE_HUB_RangeWeaponMat","ELITE_HUB_RangeRangedAura","ELITE_HUB_RangeHitboxSize"
}

local MUSIC_GLOBALS = {
    "ELITE_HUB_MusicVolume","ELITE_HUB_MusicShuffle","ELITE_HUB_MusicRepeatOne","ELITE_HUB_MusicPlaybackSpeed"
}

local MOVEMENT_GLOBALS = {
    "ELITE_HUB_JumpBoost","ELITE_HUB_WalkSpeed","ELITE_HUB_JumpPower","ELITE_HUB_InfiniteJump"
}

local COMBAT_GLOBALS = {
    "ELITE_HUB_HitboxExpander","ELITE_HUB_HitboxSize",
    "ELITE_HUB_AutoParry","ELITE_HUB_Reach","ELITE_HUB_ReachDist"
}

local CAMERA_GLOBALS = {
    "ELITE_HUB_FreeCam","ELITE_HUB_ClickTP","ELITE_HUB_AutoRespawn",
    "ELITE_HUB_KillSound","ELITE_HUB_BunnyHop"
}

local function collectGlobals(keys)
    local g = _g()
    local out = {}
    for _, k in ipairs(keys) do
        local v = g[k]
        if v ~= nil then
            if typeof(v) == "Color3" then
                out[k] = serColor(v)
            elseif type(v) == "table" then
                out[k] = serTable(v)
            else
                out[k] = v
            end
        end
    end
    return out
end

local function collectSettings()
    local g = _g()
    return {
        ESP = g.ELITE_HUB_ESPConfig and collectTable(g.ELITE_HUB_ESPConfig, ESP_KEYS) or {},
        Aimbot = g.ELITE_HUB_AimbotConfig and collectTable(g.ELITE_HUB_AimbotConfig, AIMBOT_KEYS) or {},
        Visual = collectGlobals(VISUAL_GLOBALS),
        Range = collectGlobals(RANGE_GLOBALS),
        Music = collectGlobals(MUSIC_GLOBALS),
        Movement = collectGlobals(MOVEMENT_GLOBALS),
        Combat = collectGlobals(COMBAT_GLOBALS),
        Camera = collectGlobals(CAMERA_GLOBALS),
    }
end

local function applySettings(data)
    if not data then return end
    local g = _g()

    if data.ESP then
        local e = g.ELITE_HUB_ESPConfig
        if e then
            for k, v in pairs(data.ESP) do e[k] = deColor(v) end
        end
    end

    if data.Aimbot then
        local a = g.ELITE_HUB_AimbotConfig
        if a then
            for k, v in pairs(data.Aimbot) do a[k] = deColor(v) end
        end
    end

    local allGlobals = {}
    for _, list in ipairs({VISUAL_GLOBALS, RANGE_GLOBALS, MUSIC_GLOBALS, MOVEMENT_GLOBALS, COMBAT_GLOBALS, CAMERA_GLOBALS}) do
        for _, k in ipairs(list) do table.insert(allGlobals, k) end
    end

    for _, section in ipairs({data.Visual, data.Range, data.Music, data.Movement, data.Combat, data.Camera}) do
        if section then
            for k, v in pairs(section) do
                g[k] = deColor(v)
            end
        end
    end

    pcall(function()
        if g.ELITE_HUB_UpdateESP then g.ELITE_HUB_UpdateESP() end
    end)
    pcall(function()
        if g.ELITE_HUB_ApplyVisualSky then g.ELITE_HUB_ApplyVisualSky() end
    end)
    pcall(function()
        if g.ELITE_HUB_SetupParticles then g.ELITE_HUB_SetupParticles() end
    end)
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
        local g = _g()
        if g.ELITE_HUB_ESPConfig then
            for k, v in pairs(g.ELITE_HUB_ESPConfig) do
                if type(v) == "boolean" then g.ELITE_HUB_ESPConfig[k] = false
                elseif type(v) == "number" then g.ELITE_HUB_ESPConfig[k] = 0
                end
            end
            g.ELITE_HUB_ESPConfig.Boxes = true
            g.ELITE_HUB_ESPConfig.Names = true
            g.ELITE_HUB_ESPConfig.Health = true
            g.ELITE_HUB_ESPConfig.Distance = true
            g.ELITE_HUB_ESPConfig.Tracers = true
            g.ELITE_HUB_ESPConfig.Skeletons = true
            g.ELITE_HUB_ESPConfig.TeamCheck = true
            g.ELITE_HUB_ESPConfig.ShowTeammates = true
            g.ELITE_HUB_ESPConfig.ShowDead = true
        end
        if g.ELITE_HUB_AimbotConfig then
            for k, v in pairs(g.ELITE_HUB_AimbotConfig) do
                if type(v) == "boolean" then g.ELITE_HUB_AimbotConfig[k] = false
                elseif type(v) == "number" then g.ELITE_HUB_AimbotConfig[k] = 0
                end
            end
            g.ELITE_HUB_AimbotConfig.FOV = 120
            g.ELITE_HUB_AimbotConfig.TriggerKey = "MouseButton2"
            g.ELITE_HUB_AimbotConfig.LockPart = "Head"
            g.ELITE_HUB_AimbotConfig.MaxDistance = 999
            g.ELITE_HUB_AimbotConfig.TeamCheck = true
            g.ELITE_HUB_AimbotConfig.AliveCheck = true
            g.ELITE_HUB_AimbotConfig.WallCheck = true
            g.ELITE_HUB_AimbotConfig.ShowFOV = true
            g.ELITE_HUB_AimbotConfig.PersistentLock = true
        end
        local resetLists = {VISUAL_GLOBALS, RANGE_GLOBALS, MUSIC_GLOBALS, MOVEMENT_GLOBALS, COMBAT_GLOBALS, CAMERA_GLOBALS}
        for _, list in ipairs(resetLists) do
            for _, k in ipairs(list) do
                g[k] = false
            end
        end
        pcall(function() if g.ELITE_HUB_UpdateESP then g.ELITE_HUB_UpdateESP() end end)
        Window:_updateAll()
        Rayfield:Notify({Title = "✅ OK", Content = L("SettingsReset"), Duration = 2})
    end
})

local verLabel = SettingsTab:CreateLabel(L("Version"))
table.insert(Window._translatables, {element = verLabel.Frame, key = "Version", type = "label"})
