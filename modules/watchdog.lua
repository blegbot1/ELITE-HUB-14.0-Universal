-- source: ELITE_HUB_14.0.lua PERSISTENT WATCHDOG (lines 12624-12722)
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
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- PERSISTENT WATCHDOG вЂ” РєР°Р¶РґС‹Рµ 2 СЃРµРєСѓРЅРґС‹ РїСЂРѕРІРµСЂСЏРµС‚ Р°РєС‚РёРІРЅС‹Рµ С„РёС‡Рё
-- Рё РїРµСЂРµРїСЂРёРјРµРЅСЏРµС‚ РµСЃР»Рё РѕРЅРё РїСЂРѕРїР°Р»Рё (СЂРµСЃРїР°РІРЅ, СЃРјРµСЂС‚СЊ, Р±Р°РіРё)
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local ch = player.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not ch or not hum or hum.Health <= 0 then return end

            -- Chinese Hat
            if getgenv().ELITE_HUB_ChineseHatOn then
                if not ch:FindFirstChild("ELITEHUB_CHINESE_HAT") then
                    pcall(function() BuildHat(ch) end)
                end
            end

            -- Neon Body
            if getgenv().ELITE_HUB_NeonBody then
                for _, part in ipairs(ch:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        pcall(function()
                            if part.Material ~= Enum.Material.Neon then
                                part.Material = Enum.Material.Neon
                            end
                            if part.Color ~= getgenv().ELITE_HUB_NeonBodyColor then
                                part.Color = getgenv().ELITE_HUB_NeonBodyColor
                            end
                        end)
                    end
                end
            end

            -- Fire Trail
            if getgenv().ELITE_HUB_FireTrail then
                local hasFire = false
                for _, obj in ipairs(ch:GetDescendants()) do
                    if obj.Name == "EliteHubFireTrail" then hasFire = true break end
                end
                if not hasFire then
                    for _, part in ipairs(ch:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            pcall(function()
                                local fire = Instance.new("Fire")
                                fire.Name = "EliteHubFireTrail"
                                fire.Size = 2
                                fire.Heat = 1
                                fire.Color = getgenv().ELITE_HUB_FireTrailColor or Color3.fromRGB(255, 68, 0)
                                fire.SecondaryColor = Color3.fromRGB(255, 200, 0)
                                fire.Enabled = true
                                fire.Parent = part
                            end)
                        end
                    end
                end
            end

            -- Noclip
            if noclipActive then
                for _, part in ipairs(ch:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.CanCollide = false end)
                    end
                end
            end

            -- Speed Boost (Range tab)
            if getgenv().ELITE_HUB_RangeSpeed then
                local spd = getgenv().ELITE_HUB_RangeSpeedVal or 24
                if hum.WalkSpeed ~= spd then
                    hum.WalkSpeed = spd
                end
            end

            -- Jump Boost
            if getgenv().ELITE_HUB_JumpBoost then
                local jp = getgenv().ELITE_HUB_JumpPower or 120
                if hum.UseJumpPower ~= true then hum.UseJumpPower = true end
                if hum.JumpPower ~= jp then hum.JumpPower = jp end
            end

            -- WalkSpeed
            if getgenv().ELITE_HUB_WalkSpeed and getgenv().ELITE_HUB_WalkSpeed > 0 then
                if hum.WalkSpeed ~= getgenv().ELITE_HUB_WalkSpeed then
                    hum.WalkSpeed = getgenv().ELITE_HUB_WalkSpeed
                end
            end

            -- JumpPower
            if getgenv().ELITE_HUB_JumpPower and getgenv().ELITE_HUB_JumpPower > 0 then
                if hum.UseJumpPower ~= true then hum.UseJumpPower = true end
                if hum.JumpPower ~= getgenv().ELITE_HUB_JumpPower then
                    hum.JumpPower = getgenv().ELITE_HUB_JumpPower
                end
            end
        end)
    end
end)