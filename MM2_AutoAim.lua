-- MM2 Pulse Script
-- Murder Mystery 2 (They're Infinite)
-- PlaceId: 142823291

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local CFG = {
    SilentAim = false,
    AutoShot = false,
    HitboxExpander = false,
    HitboxSize = 20,
    GunDropGrab = false,
    Noclip = false,
    Speed = false,
    SpeedVal = 32,
    MaxDist = 400,
    FireDelay = 0.5,
}

local Connections = {}
local LastFire = 0
local HitboxCache = {}
local MenuOpen = true

-- ========== FIND REMOTES ==========

local function findGunRemote()
    local char = LP.Character
    if not char then return nil end

    local gun = char:FindFirstChild("Gun")
    if not gun then
        gun = LP.Backpack:FindFirstChild("Gun")
    end
    if not gun then return nil end

    -- Find ShootGun remote anywhere in the tool
    for _, desc in ipairs(gun:GetDescendants()) do
        if desc.Name == "ShootGun" then
            return desc
        end
    end

    -- Find any RemoteEvent in KnifeServer
    local ks = gun:FindFirstChild("KnifeServer")
    if ks then
        for _, v in ipairs(ks:GetChildren()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                return v
            end
        end
    end

    -- Last: any remote in the tool
    for _, desc in ipairs(gun:GetDescendants()) do
        if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
            return desc
        end
    end

    return nil
end

-- ========== ROLE DETECTION ==========

local function getRole(plr)
    local c = plr.Character
    if (c and c:FindFirstChild("Knife")) or plr.Backpack:FindFirstChild("Knife") then
        return "Murderer"
    elseif (c and c:FindFirstChild("Gun")) or plr.Backpack:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and getRole(p) == "Murderer" then
            local c = p.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    return p
                end
            end
        end
    end
    return nil
end

local function getDist(target)
    local c = LP.Character
    if not c then return math.huge end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return math.huge end
    local tc = target.Character
    if not tc then return math.huge end
    local thrp = tc:FindFirstChild("HumanoidRootPart")
    if not thrp then return math.huge end
    return (hrp.Position - thrp.Position).Magnitude
end

local function hasGun()
    local c = LP.Character
    return (c and c:FindFirstChild("Gun")) or LP.Backpack:FindFirstChild("Gun")
end

local function equipGun()
    local gun = LP.Backpack:FindFirstChild("Gun")
    if gun and LP.Character then
        gun.Parent = LP.Character
    end
end

-- ========== SILENT AIM ==========

local function fireAtTarget()
    local now = tick()
    if now - LastFire < CFG.FireDelay then return end

    local murderer = getMurderer()
    if not murderer then return end
    local tc = murderer.Character
    if not tc then return end
    local thrp = tc:FindFirstChild("HumanoidRootPart")
    if not thrp then return end

    local remote = findGunRemote()
    if not remote then return end

    local shootPos = thrp.Position
    pcall(function()
        if remote:IsA("RemoteFunction") then
            remote:InvokeServer(1, shootPos, "AH")
        else
            remote:FireServer(shootPos)
        end
    end)
    LastFire = now
end

-- ========== HITBOX EXPANDER ==========

local function expandHitboxes()
    if not CFG.HitboxExpander then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and getRole(p) == "Murderer" then
            local c = p.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not HitboxCache[p.Name] then
                        HitboxCache[p.Name] = hrp.Size
                    end
                    hrp.Size = Vector3.new(CFG.HitboxSize, CFG.HitboxSize, CFG.HitboxSize)
                    hrp.Transparency = 0.6
                    hrp.CanCollide = false
                    hrp.Massless = true
                end
            end
        end
    end
end

local function resetHitboxes()
    for name, size in pairs(HitboxCache) do
        local p = Players:FindFirstChild(name)
        if p and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = size
                hrp.Transparency = 1
            end
        end
    end
    HitboxCache = {}
end

-- ========== GUN DROP ==========

local function watchGunDrop()
    table.insert(Connections, workspace.ChildAdded:Connect(function(child)
        if child.Name == "GunDrop" and CFG.GunDropGrab then
            task.wait(0.05)
            local c = LP.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = child.CFrame + Vector3.new(0, 2, 0)
                end
            end
        end
    end))
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

    -- Toggle button (always visible)
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
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Color3.fromRGB(255, 100, 120)
    toggleStroke.Thickness = 2
    toggleStroke.Parent = toggleBtn

    -- Main panel
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "Panel"
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 200, 0, 310)
    MainFrame.Position = UDim2.new(0, 70, 0.5, -155)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 50, 70)
    mainStroke.Thickness = 1.5
    mainStroke.Parent = MainFrame

    -- Title bar
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
    targetLabel.Text = "Target: Nobody"
    targetLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    targetLabel.TextSize = 10
    targetLabel.Font = Enum.Font.GothamMedium
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggles
    local toggles = {
        {name = "Silent Aim", key = "SilentAim", color = Color3.fromRGB(255, 50, 70)},
        {name = "Auto Shot", key = "AutoShot", color = Color3.fromRGB(255, 150, 50)},
        {name = "Hitbox Expander", key = "HitboxExpander", color = Color3.fromRGB(50, 200, 255)},
        {name = "Gun Drop Grab", key = "GunDropGrab", color = Color3.fromRGB(100, 255, 100)},
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
            if key == "HitboxExpander" and not CFG.HitboxExpander then
                resetHitboxes()
            end
        end)

        yPos = yPos + 34
    end

    -- Toggle menu button
    toggleBtn.MouseButton1Click:Connect(function()
        MenuOpen = not MenuOpen
        MainFrame.Visible = MenuOpen
    end)

    return ScreenGui, status, targetLabel
end

-- ========== MAIN ==========

local gui, statusLabel, targetLabel = createUI()
watchGunDrop()

-- Main loop
table.insert(Connections, RunService.RenderStepped:Connect(function()
    local myChar = LP.Character
    if myChar then
        statusLabel.Text = "Role: " .. getRole(LP)
    end

    local murderer = getMurderer()
    if murderer then
        local dist = getDist(murderer)
        targetLabel.Text = "Target: " .. murderer.Name .. " (" .. math.floor(dist) .. "m)"

        -- Silent Aim + Auto Shot
        if CFG.SilentAim and hasGun() and dist <= CFG.MaxDist then
            equipGun()
            if CFG.AutoShot then
                fireAtTarget()
            end
        end

        -- Hitbox Expander (every frame to override server)
        if CFG.HitboxExpander then
            expandHitboxes()
        end
    else
        targetLabel.Text = "Target: Nobody"
    end
end))

-- Cleanup on leave
table.insert(Connections, Players.PlayerRemoving:Connect(function(plr)
    if plr == LP then
        resetHitboxes()
        for _, c in ipairs(Connections) do
            pcall(function() c:Disconnect() end)
        end
        if ScreenGui then ScreenGui:Destroy() end
    end
end))

-- Delete to unload
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
