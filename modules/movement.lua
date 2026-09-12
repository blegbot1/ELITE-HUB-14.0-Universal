-- source: ELITE_HUB_14.0.lua MOVEMENT (lines 10289-10323, 11213-11264, 11407-11427)
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
local UserInputService = game:GetService("UserInputService")
local MT = Window

local MovementTab = _g().ELITE_HUB_MovementTab
local MT = MovementTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: MOVEMENT")
MT:CreateSection("🏃 MOVEMENT")

getgenv().ELITE_HUB_JumpBoost = false
MT:CreateToggle({
    Name = " Jump Boost (high jump)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_JumpBoost = value
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            if value then
                getgenv().ELITE_HUB_JumpBoostOrig = hum.JumpPower
                hum.JumpPower = 120
            else
                hum.JumpPower = getgenv().ELITE_HUB_JumpBoostOrig or 50
            end
        end
        getgenv().ELITE_HUB_Log("MODS", "Jump Boost: " .. tostring(value))
    end
})
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if getgenv().ELITE_HUB_JumpBoost then
                hum.UseJumpPower = true
                getgenv().ELITE_HUB_JumpBoostOrig = 50
                hum.JumpPower = 120
            end
            if getgenv().ELITE_HUB_WalkSpeed then
                hum.WalkSpeed = getgenv().ELITE_HUB_WalkSpeed
            end
            if getgenv().ELITE_HUB_JumpPower then
                hum.UseJumpPower = true
                hum.JumpPower = getgenv().ELITE_HUB_JumpPower
            end
        end
    end)
end)

MT = MovementTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: MOVEMENT sliders")
MT:CreateSection("🏃 SPEED")

MT:CreateSlider({
    Name = " WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        getgenv().ELITE_HUB_WalkSpeed = value
        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = value end
        end)
        getgenv().ELITE_HUB_Log("MODS", "WalkSpeed: " .. value)
    end
})

MT:CreateSlider({
    Name = " JumpPower",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().ELITE_HUB_JumpPower = value
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
MT:CreateSection("👟 JUMP")
getgenv().ELITE_HUB_InfiniteJump = false
MT:CreateToggle({
    Name = " Infinite Jump",
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
