-- EliteHub Nametag v3
-- Показывает "ELITE HUB" только над теми кто запустил этот скрипт
-- Запуск: loadstring(game:HttpGet("https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/refs/heads/main/EliteHub_Nametag.lua"))()

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Создаём/находим папку
local folder = RS:FindFirstChild("EliteHubUsers")
if not folder then
    folder = Instance.new("Folder")
    folder.Name = "EliteHubUsers"
    folder.Parent = RS
end

-- Пишем своё имя
local myMarker = Instance.new("StringValue")
myMarker.Name = player.Name
myMarker.Value = player.Name
myMarker.Parent = folder

warn("[EliteHub Nametag] Joined as: " .. player.Name)

-- Убираем при выходе
player.AncestryChanged:Connect(function()
    if not myMarker.Parent then
        myMarker.Parent = folder
    end
end)

game:BindToClose(function()
    myMarker:Destroy()
end)

-- Цикл показа бейджей
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
                            local isUser = folder:FindFirstChild(p.Name)

                            if isUser then
                                if not existing then
                                    warn("[EliteHub Nametag] Found script user: " .. p.Name)

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
