-- EliteHub Nametag Test Script
-- Показывает "ELITE HUB" над игроками которые запустили этот же скрипт
-- Запуск: loadstring(game:HttpGet("https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/refs/heads/main/EliteHub_Nametag.lua"))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Ставим тег на себя
pcall(function()
    player:SetAttribute("EliteHubUser", true)
    if player.Character then
        player.Character:SetAttribute("EliteHubUser", true)
    end
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 5)
        pcall(function() char:SetAttribute("EliteHubUser", true) end)
    end)
end)

warn("[EliteHub Nametag] Script loaded! Tag set on: " .. player.Name)

-- Цикл проверки
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    local char = p.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local existing = hrp:FindFirstChild("EliteHubTag")
                            local isUser = p:GetAttribute("EliteHubUser") or char:GetAttribute("EliteHubUser")

                            if isUser then
                                if not existing then
                                    warn("[EliteHub Nametag] Found user: " .. p.Name)

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
                            else
                                if existing then existing:Destroy() end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
