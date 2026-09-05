-- EliteHub Nametag Test Script v2
-- Показывает "ELITE HUB" над ВСЕМИ игроками кроме себя
-- Запуск: loadstring(game:HttpGet("https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/refs/heads/main/EliteHub_Nametag.lua"))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

warn("[EliteHub Nametag] Loaded! Player: " .. player.Name)
warn("[EliteHub Nametag] Players in server: " .. #Players:GetPlayers())

-- Ждём загрузки
task.wait(3)

-- Просто показываем бейдж над каждым игроком кроме себя
task.spawn(function()
    warn("[EliteHub Nametag] Loop started!")
    while task.wait(2) do
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                local char = p.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local existing = hrp:FindFirstChild("EliteHubTag")
                        if not existing then
                            warn("[EliteHub Nametag] Creating tag for: " .. p.Name)

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
                    end
                end
            end
        end
    end
end)
