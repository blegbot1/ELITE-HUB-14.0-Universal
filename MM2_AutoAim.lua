-- MM2 Pulse Script
-- Murder Mystery 2 (They're Infinite)
-- PlaceId: 142823291

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer

local CFG = {
    SilentAim = false,
    HitboxExpand = false,
    HitboxSize = 15,
    Noclip = false,
    Speed = false,
    SpeedVal = 24,
}

local Connections = {}
local Roles = {}
local Murderer = nil
local Sheriff = nil
local Hero = nil
local MenuOpen = true

-- ========== ROLE DETECTION (via ReplicatedStorage events) ==========

local function updateRole(player, role)
    Roles[player] = role
    if role == "Murderer" then
        Murderer = player
    elseif role == "Sheriff" then
        Sheriff = player
    elseif role == "Hero" then
        Hero = player
    end
end

local function onRoundEnd()
    for p, _ in pairs(Roles) do
        Roles[p] = "Unknown"
    end
    Murderer, Sheriff, Hero = nil, nil, nil
end

-- Listen to game events for roles (pcall in case remotes don't exist)
pcall(function()
    table.insert(Connections, ReplicatedStorage.Fade.OnClientEvent:Connect(function(data)
        for _, v in ipairs(Players:GetPlayers()) do
            local info = data[v.Name]
            if info then
                local role = typeof(info) == "table" and info.Role or "Unknown"
                pcall(updateRole, v, role)
            end
        end
    end))
end)

pcall(function()
    table.insert(Connections, ReplicatedStorage.UpdatePlayerData.OnClientEvent:Connect(function(data)
        for _, v in ipairs(Players:GetPlayers()) do
            local info = data[v.Name]
            if info then
                local role = typeof(info) == "table" and info.Role or "Unknown"
                pcall(updateRole, v, role)
            end
        end
    end))
end)

pcall(function()
    table.insert(Connections, ReplicatedStorage.RoleSelect.OnClientEvent:Connect(function(role, ...)
        updateRole(LP, role or "Unknown")
    end))
end)

pcall(function()
    table.insert(Connections, ReplicatedStorage.Remotes.Gameplay.RoundEndFade.OnClientEvent:Connect(onRoundEnd))
end)

-- Fallback: detect roles by checking tools (works on all versions)
local function detectRolesByTools()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local c = p.Character
            if (c and c:FindFirstChild("Knife")) or p.Backpack:FindFirstChild("Knife") then
                updateRole(p, "Murderer")
            elseif (c and c:FindFirstChild("Gun")) or p.Backpack:FindFirstChild("Gun") then
                updateRole(p, "Sheriff")
            end
        end
    end
end

-- ========== SILENT AIM (hookmetamethod) ==========

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }
    if not checkcaller() then
        if typeof(self) == "Instance" then
            if self.Name == "ShootGun" and method == "InvokeServer" then
                if CFG.SilentAim and Murderer then
                    local char = Murderer.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            local vel = root.AssemblyLinearVelocity
                            local predict = vel * Vector3.new(0.1, 0, 0.1)
                            args[2] = root.Position + predict
                        end
                    end
                end
            end
        end
    end
    return __namecall(self, unpack(args))
end)

-- ========== HITBOX EXPANDER (firetouchinterest) ==========

local function expandHitboxes()
    if not CFG.HitboxExpand then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Size = Vector3.new(CFG.HitboxSize, CFG.HitboxSize, CFG.HitboxSize)
                root.Transparency = 0.6
                root.CanCollide = false
                root.Massless = true
            end
        end
    end
end

local function resetHitboxes()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Size = Vector3.new(2, 1, 1)
                root.Transparency = 1
            end
        end
    end
end

-- ========== NOCLIP ==========

local noclipConn
local function toggleNoclip()
    if CFG.Noclip then
        noclipConn = RunService.Stepped:Connect(function()
            local c = LP.Character
            if c then
                for _, part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        table.insert(Connections, noclipConn)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end
end

-- ========== SPEED ==========

local speedConn
local function toggleSpeed()
    if CFG.Speed then
        speedConn = RunService.Stepped:Connect(function()
            local c = LP.Character
            if c then
                local hum = c:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = CFG.SpeedVal end
            end
        end)
        table.insert(Connections, speedConn)
    else
        if speedConn then
            speedConn:Disconnect()
            speedConn = nil
        end
        local c = LP.Character
        if c then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
end

-- ========== UI ==========

local ScreenGui
local MainFrame

local function createUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MM2Pulse"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 1000
    ScreenGui.Parent = LP:WaitForChild("PlayerGui")

    -- Toggle button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleMenu"
    toggleBtn.Parent = ScreenGui
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 70)
    toggleBtn.Text = "P"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 20
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 100
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 25)
    local ts = Instance.new("UIStroke")
    ts.Color = Color3.fromRGB(255, 100, 120)
    ts.Thickness = 2
    ts.Parent = toggleBtn

    -- Main panel
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "Panel"
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 200, 0, 250)
    MainFrame.Position = UDim2.new(0, 70, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local ms = Instance.new("UIStroke")
    ms.Color = Color3.fromRGB(255, 50, 70)
    ms.Thickness = 1.5
    ms.Parent = MainFrame

    -- Title
    local title = Instance.new("Frame")
    title.Parent = MainFrame
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(255, 50, 70)
    title.BorderSizePixel = 0
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

    local titleText = Instance.new("TextLabel")
    titleText.Parent = title
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "MM2 PULSE"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 14
    titleText.Font = Enum.Font.GothamBlack
    titleText.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = title
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -28, 0, 3)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 40)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 12)
    closeBtn.MouseButton1Click:Connect(function()
        MenuOpen = false
        MainFrame.Visible = false
    end)

    -- Status
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Parent = MainFrame
    status.Size = UDim2.new(1, -16, 0, 16)
    status.Position = UDim2.new(0, 8, 0, 34)
    status.BackgroundTransparency = 1
    status.Text = "Role: ..."
    status.TextColor3 = Color3.fromRGB(180, 180, 180)
    status.TextSize = 10
    status.Font = Enum.Font.GothamMedium
    status.TextXAlignment = Enum.TextXAlignment.Left

    local targetLabel = Instance.new("TextLabel")
    targetLabel.Name = "Target"
    targetLabel.Parent = MainFrame
    targetLabel.Size = UDim2.new(1, -16, 0, 16)
    targetLabel.Position = UDim2.new(0, 8, 0, 50)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "Murderer: Nobody"
    targetLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    targetLabel.TextSize = 10
    targetLabel.Font = Enum.Font.GothamMedium
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggles
    local toggles = {
        {name = "Silent Aim", key = "SilentAim", color = Color3.fromRGB(255, 50, 70)},
        {name = "Hitbox Expander", key = "HitboxExpand", color = Color3.fromRGB(50, 200, 255)},
        {name = "Noclip", key = "Noclip", color = Color3.fromRGB(200, 100, 255)},
        {name = "Speed", key = "Speed", color = Color3.fromRGB(255, 255, 100)},
    }

    local yPos = 72
    for _, t in ipairs(toggles) do
        local frame = Instance.new("Frame")
        frame.Parent = MainFrame
        frame.Size = UDim2.new(1, -16, 0, 30)
        frame.Position = UDim2.new(0, 8, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = t.name
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 11
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left

        local tog = Instance.new("TextButton")
        tog.Parent = frame
        tog.Size = UDim2.new(0, 40, 0, 20)
        tog.Position = UDim2.new(1, -48, 0.5, -10)
        tog.BackgroundColor3 = CFG[t.key] and t.color or Color3.fromRGB(50, 50, 50)
        tog.Text = CFG[t.key] and "ON" or "OFF"
        tog.TextColor3 = Color3.fromRGB(255, 255, 255)
        tog.TextSize = 9
        tog.Font = Enum.Font.GothamBold
        tog.BorderSizePixel = 0
        Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 10)

        local key = t.key
        local col = t.color
        tog.MouseButton1Click:Connect(function()
            CFG[key] = not CFG[key]
            if CFG[key] then
                tog.BackgroundColor3 = col
                tog.Text = "ON"
            else
                tog.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                tog.Text = "OFF"
            end
            if key == "Noclip" then toggleNoclip() end
            if key == "Speed" then toggleSpeed() end
            if key == "HitboxExpand" and not CFG.HitboxExpand then resetHitboxes() end
        end)

        yPos = yPos + 34
    end

    toggleBtn.MouseButton1Click:Connect(function()
        MenuOpen = not MenuOpen
        MainFrame.Visible = MenuOpen
    end)

    return ScreenGui, status, targetLabel
end

-- ========== MAIN ==========

local gui, statusLabel, targetLabel = createUI()

table.insert(Connections, RunService.RenderStepped:Connect(function()
    -- Update status
    local myRole = Roles[LP] or "..."
    statusLabel.Text = "Role: " .. myRole

    -- Fallback role detection
    detectRolesByTools()

    -- Update target
    if Murderer and Murderer.Character then
        local root = Murderer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local myChar = LP.Character
            if myChar then
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local dist = math.floor((myRoot.Position - root.Position).Magnitude)
                    targetLabel.Text = "Murderer: " .. Murderer.Name .. " (" .. dist .. "m)"
                end
            end
        end
    else
        targetLabel.Text = "Murderer: Nobody"
    end

    -- Hitbox expander
    if CFG.HitboxExpand then
        expandHitboxes()
    end
end))

-- Cleanup
table.insert(Connections, Players.PlayerRemoving:Connect(function(plr)
    if plr == LP then
        resetHitboxes()
        for _, c in ipairs(Connections) do
            pcall(function() c:Disconnect() end)
        end
        if ScreenGui then ScreenGui:Destroy() end
    end
end))

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Delete then
        resetHitboxes()
        for _, c in ipairs(Connections) do
            pcall(function() c:Disconnect() end)
        end
        local c = LP.Character
        if c then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
        if ScreenGui then ScreenGui:Destroy() end
        print("[MM2 Pulse] Unloaded")
    end
end)

print("[MM2 Pulse] Loaded | P = toggle menu | Delete = unload")
