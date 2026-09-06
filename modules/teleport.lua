-- ELITE HUB 14.0 — Teleport Module
-- Extracted from ELITE_HUB_14.0.lua

--[[
    ==============================
    НОВЫЙ ТЕЛЕПОРТ-СКРИПТ
    ==============================
]]--
local LocalPlayer = Players.LocalPlayer
local dropdown = nil
local selectedPlayer = nil
local autoTp = false
local onlineLabel = nil

local function TeleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer:IsA("Player") then
        Rayfield:Notify({ Title = "❌ Ошибка", Content = "Неверный игрок", Duration = 2 })
        return
    end
    local myChar = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    if myChar and targetChar then
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        if myRoot and targetRoot then
            myRoot.CFrame = targetRoot.CFrame
            Rayfield:Notify({ Title = "✅ Успех", Content = "Телепортирован к " .. targetPlayer.Name, Duration = 2 })
        end
    end
end

local function UpdateOnlineCount()
    if onlineLabel then
        onlineLabel:Set("👥 Игроков онлайн: " .. tostring(#Players:GetPlayers()))
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
    dropdown:Refresh(opts)
    UpdateOnlineCount()
    if selectedPlayer and not Players:FindFirstChild(selectedPlayer.Name) then
        selectedPlayer = nil
        dropdown:Set("")
        autoTp = false
        Rayfield:Notify({
            Title = "ℹ️ Игрок вышел",
            Content = "Выбор сброшен",
            Duration = 2
        })
    end
end

TeleportTab:CreateSection("Игроки")
onlineLabel = TeleportTab:CreateLabel("👥 Players online: 0")
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
                Title = "Выбран игрок",
                Content = selectedPlayer.Name,
                Duration = 1.5
            })
        end
    end
})

TeleportTab:CreateButton({
    Name = "🚀 Teleport to selected",
    Callback = function()
        if not selectedPlayer then
            Rayfield:Notify({ Title = "❗ Внимание", Content = "Сначала выберите игрока", Duration = 2 })
            return
        end
        TeleportToPlayer(selectedPlayer)
    end
})

TeleportTab:CreateToggle({
    Name = "⚡ Auto-teleport",
    CurrentValue = false,
    Callback = function(value)
        autoTp = value
        if value and selectedPlayer then
            Rayfield:Notify({ Title = "⚡ Авто-ТП ВКЛ", Content = "Слежение за " .. selectedPlayer.Name, Duration = 2 })
        elseif not value then
            Rayfield:Notify({ Title = "⚡ Авто-ТП ВЫКЛ", Content = "Остановлено", Duration = 2 })
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
    Title = "✅ Готово",
    Content = "Скрипт телепорта запущен. Список игроков и счётчик обновляются автоматически.",
    Duration = 4
})