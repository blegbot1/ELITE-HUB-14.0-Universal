-- source: ELITE_HUB_14.0.lua COMBAT+ (lines 10327-10388, 10965-11145)
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

local CombatPlusTab = _g().ELITE_HUB_CombatPlusTab
MT = CombatPlusTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: COMBAT+")
MT:CreateSection("⚔ COMBAT+")
MT:CreateToggle({
    Name = " Hitbox Expander",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_HitboxExpander = value
        getgenv().ELITE_HUB_Log("MODS", "Hitbox Expander: " .. tostring(value))
    end
})
MT:CreateSlider({
    Name = " Hitbox size",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(value)
        getgenv().ELITE_HUB_HitboxSize = value
        getgenv().ELITE_HUB_Log("MODS", "Hitbox Size: " .. tostring(value))
    end
})
local origHitboxData = {}
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if not getgenv().ELITE_HUB_HitboxExpander then
                for plrName, data in pairs(origHitboxData) do
                    local p = game:GetService("Players"):FindFirstChild(plrName)
                    if p and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            pcall(function()
                                hrp.Size = data.Size
                                hrp.Transparency = data.Transparency
                                hrp.BrickColor = data.BrickColor
                                hrp.Material = data.Material
                            end)
                        end
                    end
                end
                origHitboxData = {}
                return
            end
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if not origHitboxData[plr.Name] then
                            origHitboxData[plr.Name] = {Size = hrp.Size, Transparency = hrp.Transparency, BrickColor = hrp.BrickColor, Material = hrp.Material}
                        end
                        hrp.Size = Vector3.new(getgenv().ELITE_HUB_HitboxSize, getgenv().ELITE_HUB_HitboxSize, getgenv().ELITE_HUB_HitboxSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Really red")
                        hrp.Material = Enum.Material.ForceField
                        hrp.CanCollide = false
                    end
                end
            end
        end)
    end
end)


MT = CombatPlusTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: COMBAT+ (2)")
MT:CreateSection("⚔ COMBAT")

getgenv().ELITE_HUB_AutoParry = false
MT:CreateToggle({
    Name = " Auto Parry (Auto Block)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_AutoParry = value
        getgenv().ELITE_HUB_Log("MODS", "Auto Parry: " .. tostring(value))
        if value then
            task.spawn(function()
                while getgenv().ELITE_HUB_AutoParry do
                    task.wait(0.05)
                    pcall(function()
                        local ch = player.Character
                        if not ch then return end
                        local hrp = ch:FindFirstChild("HumanoidRootPart")
                        local hum = ch:FindFirstChildOfClass("Humanoid")
                        if not hrp or not hum or hum.Health <= 0 then return end
                        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                            if plr ~= player and plr.Character then
                                local ehrp = plr.Character:FindFirstChild("HumanoidRootPart")
                                local ehum = plr.Character:FindFirstChildOfClass("Humanoid")
                                if ehrp and ehum and ehum.Health > 0 then
                                    local dist = (ehrp.Position - hrp.Position).Magnitude
                                    if dist < 8 then
                                        local tool = ch:FindFirstChildOfClass("Tool")
                                        if tool then
                                            local handle = tool:FindFirstChild("Handle")
                                            if handle then
                                                tool:Activate()
                                            end
                                    end
                                end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

getgenv().ELITE_HUB_Reach = false
getgenv().ELITE_HUB_ReachDist = 10
MT:CreateToggle({
    Name = " Reach",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_Reach = value
        getgenv().ELITE_HUB_Log("MODS", "Reach: " .. tostring(value))
    end
})
MT:CreateSlider({
    Name = " Reach Distance",
    Range = {3, 50},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(value)
        getgenv().ELITE_HUB_ReachDist = value
    end
})
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if not getgenv().ELITE_HUB_Reach then return end
            local ch = player.Character
            if not ch then return end
            local tool = ch:FindFirstChildOfClass("Tool")
            if not tool then return end
            local handle = tool:FindFirstChild("Handle")
            if not handle then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= player and plr.Character then
                    local ehrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    local ehum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if ehrp and ehum and ehum.Health > 0 then
                        local dist = (ehrp.Position - handle.Position).Magnitude
                        if dist < getgenv().ELITE_HUB_ReachDist then
                            tool:Activate()
                        end
                    end
                end
            end
        end)
    end
end)

-- Spin Bot (РєРѕРїРёСЏ РёР· RANGE: Heartbeat + СЃРѕС…СЂР°РЅРµРЅРёРµ AutoRotate)
task.spawn(function()
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
            if not getgenv().ELITE_HUB_SpinBot then return end
            local ch = player.Character
            if not ch then return end
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local speed = getgenv().ELITE_HUB_SpinSpeed or 50
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
getgenv().ELITE_HUB_CombatSpinStop = stopSpin

getgenv().ELITE_HUB_SpinBot = false
getgenv().ELITE_HUB_SpinSpeed = 50
MT:CreateToggle({
    Name = " Spin Bot",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_SpinBot = value
        getgenv().ELITE_HUB_Log("COMBAT", "Spin Bot: " .. tostring(value))
        if value then
            startSpin()
        else
            stopSpin()
        end
    end
})
MT:CreateSlider({
    Name = " Spin Speed",
    Range = {10, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().ELITE_HUB_SpinSpeed = value
    end
})
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if not getgenv().ELITE_HUB_SpinBot then return end
            local ch = player.Character
            if ch then
                local hum = ch:FindFirstChildOfClass("Humanoid")
                if hum then hum.AutoRotate = false end
            end
        end)
    end
end)
end)
