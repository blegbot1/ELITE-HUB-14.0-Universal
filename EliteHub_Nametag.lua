-- EliteHub Nametag v4
-- Детекция через чат: отправляем маркер, другие ловят и показывают бейдж
-- Запуск: loadstring(game:HttpGet("https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/refs/heads/main/EliteHub_Nametag.lua"))()

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local player = Players.LocalPlayer

local MARKER = "[EHACTIVE]"
local detectedUsers = {}

warn("[EliteHub Nametag] Loaded! Player: " .. player.Name)

-- Функция показа бейджа
local function showTag(p)
    local char = p.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if hrp:FindFirstChild("EliteHubTag") then return end

    warn("[EliteHub Nametag] Tag created for: " .. p.Name)

    local bb = Instance.new("BillboardGui")
    bb.Name = "EliteHubTag"
    bb.AlwaysOnTop = true
    bb.ExtentsOffset = Vector3.new(0, 3, 0)
    bb.Size = UDim2.new(0, 120, 0, 20)
    bb.Adornee = hrp
    bb.Parent = hrp

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
    bg.BackgroundTransparency = 0.1
    bg.BorderSizePixel = 0
    bg.Parent = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "ELITE HUB"
    lbl.TextColor3 = Color3.fromRGB(220, 180, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.Parent = bg
end

-- Слушаем входящие чат-сообщения
pcall(function()
    TextChatService.MessageReceived:Connect(function(message)
        pcall(function()
            local text = message.Text or ""
            if text:find(MARKER) then
                local sender = message.TextSource
                if sender then
                    local senderPlayer = Players:GetPlayerByUserId(sender.UserId)
                    if senderPlayer and senderPlayer ~= player then
                        if not detectedUsers[senderPlayer.Name] then
                            detectedUsers[senderPlayer.Name] = true
                            warn("[EliteHub Nametag] Detected via chat: " .. senderPlayer.Name)
                            showTag(senderPlayer)
                        end
                    end
                end
            end
        end)
    end)
end)

-- Также слушаем через LegacyChat (некоторые игры)
pcall(function()
    local chat = game:GetService("Chat")
    chat.Chatted:Connect(function(message)
        if message:find(MARKER) then
            -- Chatted не даёт имя отправителя напрямую, пропускаем
        end
    end)
end)

-- Отправляем маркер каждые 5 секунд
task.spawn(function()
    while task.wait(5) do
        pcall(function()
            TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral"):SendAsync(MARKER)
        end)
    end
end)

-- Также показываем бейдж тем кого засекли
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            for name, _ in pairs(detectedUsers) do
                local p = Players:FindFirstChild(name)
                if p then
                    showTag(p)
                end
            end
        end)
    end
end)

warn("[EliteHub Nametag] Chat detection active! Sending marker every 5s.")
