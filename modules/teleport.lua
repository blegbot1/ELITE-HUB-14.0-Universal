-- source: ELITE_HUB_14.0.lua Teleport (lines 9246-9387)
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
local TeleportTab = _g().ELITE_HUB_TeleportTab

--[[
    ==============================
    РќРћР’Р«Р™ РўР•Р›Р•РџРћР Рў-РЎРљР РРџРў
    ==============================
]]--
local LocalPlayer = Players.LocalPlayer
local dropdown = nil
local selectedPlayer = nil
local autoTp = false
local onlineLabel = nil

local function TeleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer:IsA("Player") then
        Rayfield:Notify({ Title = "🚀 Teleport", Content = "No target!", Duration = 2 })
        return
    end
    local myChar = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    if myChar and targetChar then
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if myRoot and targetRoot then
            myRoot.CFrame = targetRoot.CFrame
            Rayfield:Notify({ Title = "🚀 Teleport", Content = "Teleported to " .. targetPlayer.Name, Duration = 2 })
        end
    end
end

local function UpdateOnlineCount()
    if onlineLabel then
        onlineLabel:Set("  : " .. tostring(#Players:GetPlayers()))
    end
end

local function UpdateDropdown()
    if not dropdown then return end
    local opts = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(opts, p.Name)
        end
    end
    table.sort(opts)
    dropdown:Refresh(opts) -- РѕР±РЅРѕРІР»СЏРµРј СЃРїРёСЃРѕРє Р±РµР· РїРµСЂРµСЃРѕР·РґР°РЅРёСЏ
    UpdateOnlineCount()
    if selectedPlayer and not Players:FindFirstChild(selectedPlayer.Name) then
        selectedPlayer = nil
        dropdown:Set("") -- СЃР±СЂРѕСЃ
        autoTp = false
        Rayfield:Notify({
            Title = "🚀 Teleport",
            Content = "Player left!",
            Duration = 2
        })
    end
end

TeleportTab:CreateSection("")
onlineLabel = TeleportTab:CreateLabel(" Players online: 0")
dropdown = TeleportTab:CreateDropdown({
    Name = "Select a player",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        local chosen = option
        if typeof(option) == "table" then
            chosen = option[1]
        end
        selectedPlayer = nil
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Name == chosen then
                selectedPlayer = pl
                break
            end
        end
        if selectedPlayer then
            Rayfield:Notify({
                Title = "🚀 Selected",
                Content = selectedPlayer.Name,
                Duration = 1.5
            })
        end
    end
})

TeleportTab:CreateButton({
    Name = " Teleport to selected",
    Callback = function()
        if not selectedPlayer then
            Rayfield:Notify({ Title = "🚀 Teleport", Content = "No player selected!", Duration = 2 })
            return
        end
        TeleportToPlayer(selectedPlayer)
    end
})

TeleportTab:CreateToggle({
    Name = " Auto-teleport",
    CurrentValue = false,
    Callback = function(value)
        autoTp = value
        if value and selectedPlayer then
            Rayfield:Notify({ Title = "🚀 Auto-TP", Content = "Following " .. selectedPlayer.Name, Duration = 2 })
        elseif not value then
            Rayfield:Notify({ Title = "🚀 Auto-TP", Content = "Disabled", Duration = 2 })
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.12)
        if autoTp and selectedPlayer and Players:FindFirstChild(selectedPlayer.Name) then
            local myChar = LocalPlayer.Character
            local targetChar = selectedPlayer.Character
            if myChar and targetChar then
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                if myRoot and targetRoot then
                    myRoot.CFrame = targetRoot.CFrame
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        UpdateDropdown()
    end
end)

Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)

task.delay(1, UpdateDropdown)
Rayfield:Notify({
    Title = "ELITE HUB",
    Content = "Loaded! Have fun!",
    Duration = 4
})