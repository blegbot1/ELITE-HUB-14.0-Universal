-- source: ELITE_HUB_14.0.lua ANTI-FLING (lines 12470-12541)
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
-- рџ›ЎпёЏ ANTI-FLING вЂ” Р°РІС‚РѕРјР°С‚РёС‡РµСЃРєРё Р·Р°РїСѓСЃРєР°РµС‚СЃСЏ РїСЂРё СЃС‚Р°СЂС‚Рµ СЃРєСЂРёРїС‚Р°
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
do
    local AF_VELOCITY_THRESHOLD = 150
    local AF_ANGULAR_THRESHOLD = 20
    local AF_ENABLED = true
    local afConn = nil
    local afLastPos = nil
    local afStuckCount = 0

    local function startAntiFling()
        if afConn then return end
        afConn = game:GetService("RunService").Stepped:Connect(function()
            if not AF_ENABLED then return end
            pcall(function()
                local ch = player.Character
                if not ch then return end
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                local hum = ch:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then return end
                if hum.Health <= 0 then return end

                local vel = hrp.Velocity
                local angVel = hrp.RotVelocity
                local speed = vel.Magnitude
                local angSpeed = angVel.Magnitude

                if speed > AF_VELOCITY_THRESHOLD or angSpeed > AF_ANGULAR_THRESHOLD then
                    hrp.Velocity = Vector3.new(0, math.min(vel.Y, 50), 0)
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                    afStuckCount = afStuckCount + 1
                    if afStuckCount > 3 then
                        hrp.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 3, 0))
                        afStuckCount = 0
                    end
                else
                    afStuckCount = 0
                end

                if afLastPos then
                    local moved = (hrp.Position - afLastPos).Magnitude
                    if moved > 200 and speed < 10 then
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.RotVelocity = Vector3.new(0, 0, 0)
                    end
                end
                afLastPos = hrp.Position
            end)
        end)
    end

    local function stopAntiFling()
        if afConn then
            afConn:Disconnect()
            afConn = nil
        end
        afLastPos = nil
        afStuckCount = 0
    end

    startAntiFling()
    getgenv().ELITE_HUB_AntiFling = true
    getgenv().ELITE_HUB_StartAntiFling = startAntiFling
    getgenv().ELITE_HUB_StopAntiFling = stopAntiFling

    player.CharacterAdded:Connect(function()
        task.wait(1)
        if getgenv().ELITE_HUB_AntiFling then
            startAntiFling()
        end
    end)
end