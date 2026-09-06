-- ELITE HUB 14.0 — Movement Module (Jump Boost, Speed, Infinite Jump, Bunny Hop)
-- Extracted from ELITE_HUB_14.0.lua

task.spawn(function()
local MT = MovementTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: MOVEMENT")
MT:CreateSection("🏃 MOVEMENT")

getgenv().ELITE_HUB_JumpBoost = false
MT:CreateToggle({
    Name = "🦘 Jump Boost (high jump)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_JumpBoost = value
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = value and 120 or 50
        end
        getgenv().ELITE_HUB_Log("MODS", "Jump Boost: " .. tostring(value))
    end
})
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if getgenv().ELITE_HUB_JumpBoost then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.UseJumpPower = true; hum.JumpPower = 120 end
    end
end)

MT = MovementTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: MOVEMENT sliders")
MT:CreateSection("⚡ SPEED")

MT:CreateSlider({
    Name = "🏃 WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = value end
        end)
        getgenv().ELITE_HUB_Log("MODS", "WalkSpeed: " .. value)
    end
})

MT:CreateSlider({
    Name = "🦘 JumpPower",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 50,
    Callback = function(value)
        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = value
            end
        end)
        getgenv().ELITE_HUB_Log("MODS", "JumpPower: " .. value)
    end
})

MT = MovementTab
MT:CreateSection("🦘 JUMP")
getgenv().ELITE_HUB_InfiniteJump = false
MT:CreateToggle({
    Name = "🦘 Infinite Jump",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_InfiniteJump = value
        getgenv().ELITE_HUB_Log("MODS", "Infinite Jump: " .. tostring(value))
    end
})
UserInputService.JumpRequest:Connect(function()
    if not getgenv().ELITE_HUB_InfiniteJump then return end
    local ch = player.Character
    if ch then
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

getgenv().ELITE_HUB_BunnyHop = false
MT = MovementTab
MT:CreateToggle({
    Name = "🐰 Bunny Hop",
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
