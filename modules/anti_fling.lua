local _g = getgenv
local Rayfield = _g().ELITE_HUB_Rayfield
local Window = _g().ELITE_HUB_Window
local ES = _g().EliteHubSettings
local L = _g().ELITE_HUB_L
local Log = _g().ELITE_HUB_Log
local Players = _g().ELITE_HUB_Players
local player = _g().ELITE_HUB_Player
local SafeNotify = _g().ELITE_HUB_SafeNotify
local DestroyScript = _g().ELITE_HUB_DestroyScript
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local MT = Window

do
    local AF_ENABLED = true
    local connections = {}
    local steppedConns = {}

    local function cleanupPlayer(player)
        if connections[player] then
            pcall(function() connections[player]:Disconnect() end)
            connections[player] = nil
        end
        if steppedConns[player] then
            pcall(function() steppedConns[player]:Disconnect() end)
            steppedConns[player] = nil
        end
    end

    local function setupCharacterCollision(character)
        if not AF_ENABLED then return end

        local function disableCollide(part)
            if AF_ENABLED and part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        for _, part in ipairs(character:GetChildren()) do
            disableCollide(part)
        end

        local childAddedConn = character.ChildAdded:Connect(disableCollide)

        local steppedConn = RunService.Stepped:Connect(function()
            if AF_ENABLED and character:IsDescendantOf(workspace) then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)

        character.Destroying:Connect(function()
            pcall(function() childAddedConn:Disconnect() end)
            pcall(function() steppedConn:Disconnect() end)
        end)
    end

    local function trackPlayer(trackedPlayer)
        if trackedPlayer == player then return end
        local charAddedConn = trackedPlayer.CharacterAdded:Connect(setupCharacterCollision)
        if trackedPlayer.Character then
            setupCharacterCollision(trackedPlayer.Character)
        end
        connections[trackedPlayer] = charAddedConn
    end

    local function untrackPlayer(trackedPlayer)
        cleanupPlayer(trackedPlayer)
    end

    for _, p in ipairs(Players:GetPlayers()) do
        trackPlayer(p)
    end

    Players.PlayerAdded:Connect(trackPlayer)
    Players.PlayerRemoving:Connect(untrackPlayer)

    player.CharacterAdded:Connect(function()
        task.wait(1)
        if AF_ENABLED then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    setupCharacterCollision(p.Character)
                end
            end
        end
    end)

    MT:CreateSection("🛡 ANTI-FLING")
    MT:CreateToggle({
        Name = " Anti-Fling (auto ON)",
        CurrentValue = true,
        Callback = function(value)
            AF_ENABLED = value
            getgenv().ELITE_HUB_AntiFling = value
            if value then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        setupCharacterCollision(p.Character)
                    end
                end
                SafeNotify("ANTI-FLING", "ON", 1.5, "AntiFling")
            else
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        for _, part in ipairs(p.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                            end
                        end
                    end
                end
                SafeNotify("ANTI-FLING", "OFF", 1.5, "AntiFling")
            end
        end
    })
end
