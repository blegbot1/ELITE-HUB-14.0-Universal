-- source: ELITE_HUB_14.0.lua CAMERA & TELEPORT (lines 10389-10480, 11354-11405, 11429-11567, 11569-11598)
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

local CameraTeleportTab = _g().ELITE_HUB_CameraTeleportTab
MT = CameraTeleportTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: CAMERA")
MT:CreateSection("📷 CAMERA & TELEPORT")

getgenv().ELITE_HUB_FreeCam = false
MT:CreateToggle({
    Name = " Free Cam (free camera)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_FreeCam = value
        getgenv().ELITE_HUB_Log("MODS", "Free Cam: " .. tostring(value))
        local cam = workspace.CurrentCamera
        if value then
            local ch = player.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                getgenv().ELITE_HUB_FreeCamCF = cam.CFrame
                getgenv().ELITE_HUB_FreeCamBP = hrp:Clone()
                getgenv().ELITE_HUB_FreeCamBP.Parent = workspace
                getgenv().ELITE_HUB_FreeCamBP.Transparency = 1
                getgenv().ELITE_HUB_FreeCamBP.Anchored = true
                getgenv().ELITE_HUB_FreeCamBP.CanCollide = false
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = getgenv().ELITE_HUB_FreeCamCF
            end
        else
            cam.CameraType = Enum.CameraType.Custom
            local bp = getgenv().ELITE_HUB_FreeCamBP
            if bp then bp:Destroy(); getgenv().ELITE_HUB_FreeCamBP = nil end
        end
    end
})
task.spawn(function()
    while task.wait(0.03) do
        pcall(function()
            if not getgenv().ELITE_HUB_FreeCam then return end
            local cam = workspace.CurrentCamera
            local speed = 2
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, -speed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, speed)
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                cam.CFrame = cam.CFrame * CFrame.new(-speed, 0, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                cam.CFrame = cam.CFrame * CFrame.new(speed, 0, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                cam.CFrame = cam.CFrame * CFrame.new(0, speed, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                cam.CFrame = cam.CFrame * CFrame.new(0, -speed, 0)
            end
            getgenv().ELITE_HUB_FreeCamCF = cam.CFrame
        end)
    end
end)
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if getgenv().ELITE_HUB_FreeCam then
        getgenv().ELITE_HUB_FreeCam = false
        pcall(function()
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            local bpcam = workspace:FindFirstChild("FreeCamBP")
            if bpcam then bpcam:Destroy() end
            local bp = getgenv().ELITE_HUB_FreeCamBP
            if bp then bp:Destroy(); getgenv().ELITE_HUB_FreeCamBP = nil end
        end)
    end
end)

MT:CreateButton({
    Name = " Teleport to cursor",
    Callback = function()
        getgenv().ELITE_HUB_Log("MODS", "   ")
        pcall(function()
            local mouse = player:GetMouse()
            local hit = mouse.Hit
            if hit then
                local ch = player.Character
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = hit + Vector3.new(0, 3, 0)
                end
            end
        end)
    end
})


MT = CameraTeleportTab
MT:CreateSection("🌀 TELEPORT")
MT:CreateButton({
    Name = " Teleport to Spawn",
    Callback = function()
        pcall(function()
            local ch = player.Character
            if ch then
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(0, 10, 0)
                    getgenv().ELITE_HUB_Log("TELEPORT", "TP to Spawn")
                end
            end
        end)
    end
})

MT = UtilitiesTab
MT:CreateToggle({
    Name = " Fullbright",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_Log("MODS", "Fullbright: " .. tostring(value))
        local lighting = game:GetService("Lighting")
        if value then
            getgenv().ELITE_HUB_FullbrightBackup = {
                Brightness = lighting.Brightness,
                Ambient = lighting.Ambient,
                OutdoorAmbient = lighting.OutdoorAmbient,
                GlobalShadows = lighting.GlobalShadows,
                Technology = lighting.Technology,
                FogEnd = lighting.FogEnd
            }
            lighting.Brightness = 10
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
            lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            lighting.GlobalShadows = false
            lighting.FogEnd = 999999
        else
            local b = getgenv().ELITE_HUB_FullbrightBackup
            if b then
                lighting.Brightness = b.Brightness
                lighting.Ambient = b.Ambient
                lighting.OutdoorAmbient = b.OutdoorAmbient
                lighting.GlobalShadows = b.GlobalShadows
                lighting.Technology = b.Technology
                lighting.FogEnd = b.FogEnd
            end
        end
    end
})

MT = CameraTeleportTab
getgenv().ELITE_HUB_ClickTP = false
MT:CreateToggle({
    Name = " Click TP (RMB)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ClickTP = value
        getgenv().ELITE_HUB_Log("MODS", "Click TP: " .. tostring(value))
    end
})
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if not getgenv().ELITE_HUB_ClickTP then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        local ch = player.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local mouse = player:GetMouse()
                local ray = workspace:Raycast(
                    workspace.CurrentCamera.CFrame.Position,
                    (mouse.Hit.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000,
                    RaycastParams.new()
                )
                if ray then
                    hrp.CFrame = CFrame.new(ray.Position + Vector3.new(0, 3, 0))
                else
                    hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end
end)

getgenv().ELITE_HUB_AutoRespawn = false
MT:CreateToggle({
    Name = " Auto Respawn",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_AutoRespawn = value
        getgenv().ELITE_HUB_Log("MODS", "Auto Respawn: " .. tostring(value))
        if value then
            task.spawn(function()
                while getgenv().ELITE_HUB_AutoRespawn do
                    task.wait(0.5)
                    pcall(function()
                        local ch = player.Character
                        if ch then
                            local hum = ch:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health <= 0 then
                                task.wait(1)
                                player:LoadCharacter()
                            end
                        end
                    end)
                end
            end)
        end
    end
})

MT = CameraTeleportTab
MT:CreateToggle({
    Name = " Third Person",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_Log("MODS", "Third Person: " .. tostring(value))
        if value then
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            player.CameraMaxZoomDistance = 999
        else
            player.CameraMaxZoomDistance = 0.5
        end
    end
})

getgenv().ELITE_HUB_KillSound = false
MT:CreateToggle({
    Name = " Kill Sound",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_KillSound = value
        getgenv().ELITE_HUB_Log("MODS", "Kill Sound: " .. tostring(value))
    end
})
task.spawn(function()
    local lastHealth = {}
    while task.wait(0.2) do
        pcall(function()
            if not getgenv().ELITE_HUB_KillSound then return end
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local prev = lastHealth[plr]
                        if prev and prev > 0 and hum.Health <= 0 then
                            local s = Instance.new("Sound")
                            s.SoundId = "rbxassetid://138081500"
                            s.Volume = 1
                            s.PlayOnRemove = false
                            s.Parent = workspace.CurrentCamera
                            s:Play()
                            game:GetService("Debris"):AddItem(s, 2)
                        end
                        lastHealth[plr] = hum.Health
                    end
                end
            end
        end)
    end
end)

getgenv().ELITE_HUB_BunnyHop = false
MT = MovementTab
MT:CreateToggle({
    Name = " Bunny Hop",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_BunnyHop = value
        getgenv().ELITE_HUB_Log("MODS", "Bunny Hop: " .. tostring(value))
        if value then
            task.spawn(function()
                while getgenv().ELITE_HUB_BunnyHop do
                    task.wait(0.1)
                    pcall(function()
                        local ch = player.Character
                        if ch then
                            local hum = ch:FindFirstChildOfClass("Humanoid")
                            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end
                    end)
                end
            end)
        end
    end
})


MT = CameraTeleportTab
MT:CreateSection("📍 WAYPOINT")
MT:CreateButton({
    Name = " Set Waypoint",
    Callback = function()
        local ch = player.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                getgenv().ELITE_HUB_Waypoint = hrp.CFrame
                getgenv().ELITE_HUB_Log("TELEPORT", "Waypoint set")
            end
        end
    end
})
MT:CreateButton({
    Name = " Teleport to Waypoint",
    Callback = function()
        if getgenv().ELITE_HUB_Waypoint then
            local ch = player.Character
            if ch then
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = getgenv().ELITE_HUB_Waypoint
                    getgenv().ELITE_HUB_Log("TELEPORT", "Teleported to waypoint")
                end
            end
        end
    end
})
