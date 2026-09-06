-- ELITE HUB 14.0 — Utilities Module (Anti-AFK, Chat, Fullbright, Auto Respawn, Server Hop)
-- Extracted from ELITE_HUB_14.0.lua
MT = UtilitiesTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: UTILS")
MT:CreateSection("🎮 UTILITIES")


MT:CreateToggle({
    Name = "🛡️ Anti-AFK",
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
    Name = "💬 Chat Spammer",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChatSpammer = value
        getgenv().ELITE_HUB_Log("MODS", "Chat Spammer: " .. tostring(value))
        if value then
            task.spawn(function()
                while getgenv().ELITE_HUB_ChatSpammer do
                    task.wait(2)
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemSpeechEvents"):FindFirstChild("SayMessageRequest"):FireServer(
                            getgenv().ELITE_HUB_ChatSpammerMsg, "All"
                        )
                    end)
                end
            end)
        end
    end
})
MT:CreateInput({
    Name = "📝 Message",
    PlaceholderText = "Enter a message...",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ChatSpammerMsg = value
    end
})

MT = UtilitiesTab
MT:CreateSection("🔄 SYSTEM")

getgenv().ELITE_HUB_RejoinOnKick = false
MT:CreateToggle({
    Name = "🔄 Rejoin on Kick",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RejoinOnKick = value
        getgenv().ELITE_HUB_Log("MODS", "Rejoin on Kick: " .. tostring(value))
        if value then
            player.CharacterRemoving:Connect(function()
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
MT:CreateToggle({
    Name = "💡 Fullbright",
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
                Technology = lighting.Technology
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
            end
            lighting.FogEnd = 100000
        end
    end
})
MT:CreateToggle({
    Name = "♻️ Auto Respawn",
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
MT = UtilitiesTab
MT:CreateSection("🔁 SERVER")
MT:CreateButton({
    Name = "🔄 Rejoin Server",
    Callback = function()
        getgenv().ELITE_HUB_Log("SERVER", "Rejoin Server")
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
})

MT:CreateButton({
    Name = "🔀 Server Hop",
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