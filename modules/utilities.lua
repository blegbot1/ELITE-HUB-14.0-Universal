-- source: ELITE_HUB_14.0.lua UTILITIES (lines 10600-10697, 11290-11352, 11600-11624)
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

local UtilitiesTab = _g().ELITE_HUB_UtilitiesTab
MT = UtilitiesTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: UTILS")
MT:CreateSection("🔧 UTILITIES")

getgenv().ELITE_HUB_FpsOverlay = false
MT:CreateToggle({
    Name = " FPS / Ping Overlay",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_FpsOverlay = value
        getgenv().ELITE_HUB_Log("MODS", "FPS Overlay: " .. tostring(value))
        if value then
            task.spawn(function()
                if getgenv().ELITE_HUB_FpsOverlayGui then
                    pcall(function() getgenv().ELITE_HUB_FpsOverlayGui:Destroy() end)
                    getgenv().ELITE_HUB_FpsOverlayGui = nil
                end
                local gui = Instance.new("ScreenGui")
                gui.Name = "EliteHubFpsOverlay"
                gui.ResetOnSpawn = false
                gui.IgnoreGuiInset = true
                gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                getgenv().ELITE_HUB_FpsOverlayGui = gui
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(0, 220, 0, 30)
                lbl.Position = UDim2.new(0, 15, 0, 8)
                lbl.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
                lbl.BackgroundTransparency = 0.3
                lbl.TextColor3 = Color3.fromRGB(220, 180, 255)
                lbl.TextSize = 13
                lbl.Font = Enum.Font.GothamBold
                lbl.TextStrokeTransparency = 0.6
                Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 8)
                lbl.Parent = gui
                task.spawn(function()
                    local fpsAcc = 0
                    local fpsFrames = 0
                    local conn = game:GetService("RunService").RenderStepped:Connect(function(dt)
                        fpsAcc = fpsAcc + dt
                        fpsFrames = fpsFrames + 1
                    end)
                    while getgenv().ELITE_HUB_FpsOverlay and gui and gui.Parent do
                        task.wait(0.5)
                        pcall(function()
                            local ping = 0
                            pcall(function()
                                ping = math.round(game:GetService("Stats").Network.ServerStats["Data Ping"]:GetValue())
                            end)
                            local online = 0
                            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                                online = online + 1
                            end
                            local fps = fpsFrames / math.max(fpsAcc, 0.0001)
                            lbl.Text = "🌟 ELITE HUB 14.0 | FPS: " .. math.round(fps) .. " | Ping: " .. ping .. "ms | Players: " .. online
                            fpsAcc = 0
                            fpsFrames = 0
                        end)
                    end
                    conn:Disconnect()
                    pcall(function()
                        if gui and gui.Parent then gui:Destroy() end
                    end)
                    if getgenv().ELITE_HUB_FpsOverlayGui == gui then getgenv().ELITE_HUB_FpsOverlayGui = nil end
                end)
            end)
        else
            if getgenv().ELITE_HUB_FpsOverlayGui then
                pcall(function() getgenv().ELITE_HUB_FpsOverlayGui:Destroy() end)
                getgenv().ELITE_HUB_FpsOverlayGui = nil
            end
        end
    end
})


MT:CreateToggle({
    Name = " Anti-AFK",
    CurrentValue = true,
    Callback = function(value)
        getgenv().ELITE_HUB_Log("MODS", "Anti-AFK: " .. tostring(value))
        if value then
            if not getgenv().ELITE_HUB_AntiAfkConn then
                local VirtualUser = game:GetService("VirtualUser")
                getgenv().ELITE_HUB_AntiAfkConn = player.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        else
            if getgenv().ELITE_HUB_AntiAfkConn then
                getgenv().ELITE_HUB_AntiAfkConn:Disconnect()
                getgenv().ELITE_HUB_AntiAfkConn = nil
            end
        end
    end
})


MT = UtilitiesTab
MT:CreateSection("💬 CHAT")

getgenv().ELITE_HUB_ChatSpammer = false
getgenv().ELITE_HUB_ChatSpammerMsg = "ELITE HUB"
MT:CreateToggle({
    Name = " Chat Spammer",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChatSpammer = value
        getgenv().ELITE_HUB_Log("MODS", "Chat Spammer: " .. tostring(value))
        if value then
            task.spawn(function()
                while getgenv().ELITE_HUB_ChatSpammer do
                    task.wait(2)
                    pcall(function()
                        local chatEvents = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemSpeechEvents", 5)
                        if not chatEvents then return end
                        chatEvents:FindFirstChild("SayMessageRequest"):FireServer(
                            getgenv().ELITE_HUB_ChatSpammerMsg, "All"
                        )
                    end)
                end
            end)
        end
    end
})
MT:CreateInput({
    Name = " Message",
    PlaceholderText = "Enter a message...",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChatSpammerMsg = value
    end
})

MT = UtilitiesTab
MT:CreateSection("⚙ SYSTEM")

getgenv().ELITE_HUB_RejoinOnKick = false
MT:CreateToggle({
    Name = " Rejoin on Kick",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RejoinOnKick = value
        getgenv().ELITE_HUB_Log("MODS", "Rejoin on Kick: " .. tostring(value))
        if value then
            if getgenv().ELITE_HUB_RejoinConn then
                getgenv().ELITE_HUB_RejoinConn:Disconnect()
            end
            getgenv().ELITE_HUB_RejoinConn = player.CharacterRemoving:Connect(function(char)
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then return end
                task.wait(3)
                if getgenv().ELITE_HUB_RejoinOnKick then
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
                    end)
                end
            end)
        end
    end
})

MT = UtilitiesTab
MT:CreateSection("📡 SERVER")
MT:CreateButton({
    Name = " Rejoin Server",
    Callback = function()
        getgenv().ELITE_HUB_Log("SERVER", "Rejoin Server")
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
})

MT:CreateButton({
    Name = " Server Hop",
    Callback = function()
        getgenv().ELITE_HUB_Log("SERVER", "Server Hop")
        pcall(function()
            local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, srv in ipairs(servers.data) do
                if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, srv.id, player)
                    break
                end
            end
        end)
    end
})
