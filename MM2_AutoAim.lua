-- MM2 Pulse-Style Script
-- Murder Mystery 2 (They're Infinite)
-- PlaceId: 142823291

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local CFG = {
    SilentAim = false,
    AutoShot = false,
    HitboxExpander = false,
    HitboxSize = 15,
    GunDropGrab = false,
    Noclip = false,
    Speed = false,
    SpeedVal = 24,
    MaxDist = 350,
    FireDelay = 0.55,
    AimPart = "HumanoidRootPart",
}

local Connections = {}
local LastFire = 0
local OriginalHitbox = {}

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

-- ========== GUN ==========

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

local function getShootRemote()
    local c = LP.Character
    if not c then return nil, nil end
    local gun = c:FindFirstChild("Gun")
    if not gun then return nil, nil end
    -- Try KnifeServer folder first
    local ks = gun:FindFirstChild("KnifeServer")
    if ks then
        local remote = ks:FindFirstChild("ShootGun")
        if remote then
            return remote, remote:IsA("RemoteFunction") and "RF" or "RE"
        end
        -- Search all children
        for _, v in ipairs(ks:GetChildren()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                return v, v:IsA("RemoteFunction") and "RF" or "RE"
            end
        end
    end
    -- Fallback: search entire gun
    for _, v in ipairs(gun:GetDescendants()) do
        if v.Name == "ShootGun" and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
            return v, v:IsA("RemoteFunction") and "RF" or "RE"
        end
    end
    -- Last resort: any remote in gun
    for _, v in ipairs(gun:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            return v, v:IsA("RemoteFunction") and "RF" or "RE"
        end
    end
    return nil, nil
end

-- ========== SILENT AIM ==========

local function silentAim()
    local murderer = getMurderer()
    if not murderer then return end
    local tc = murderer.Character
    if not tc then return end
    local thrp = tc:FindFirstChild(CFG.AimPart)
    if not thrp then return end

    local c = LP.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Teleport behind murderer
    local dir = (hrp.Position - thrp.Position).Unit
    local behindPos = thrp.Position + dir * 8
    hrp.CFrame = CFrame.lookAt(behindPos, thrp.Position)

    -- Face the murderer
    hrp.CFrame = CFrame.lookAt(hrp.Position, thrp.Position)
end

local function fireAtTarget()
    local now = tick()
    if now - LastFire < CFG.FireDelay then return end

    local murderer = getMurderer()
    if not murderer then return end
    local tc = murderer.Character
    if not tc then return end
    local thrp = tc:FindFirstChild(CFG.AimPart)
    if not thrp then return end

    local remote, rtype = getShootRemote()
    if not remote then return end

    -- Silent aim: always send bullet to target
    local shootPos = thrp.Position
    pcall(function()
        if rtype == "RF" then
            remote:InvokeServer(1, shootPos, "AH")
        else
            remote:FireServer(shootPos)
        end
    end)
    LastFire = now
end

-- ========== HITBOX EXPANDER ==========

local function setHitbox(plr, size)
    local c = plr.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local old = OriginalHitbox[plr.Name]
    if not old then
        OriginalHitbox[plr.Name] = hrp.Size
    end
    hrp.Size = Vector3.new(size, size, size)
    hrp.Transparency = 0.7
    hrp.CanCollide = false
end

local function resetHitbox(plr)
    local c = plr.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local orig = OriginalHitbox[plr.Name]
    if orig then
        hrp.Size = orig
        hrp.Transparency = 1
    end
end

-- ========== GUN DROP GRAB ==========

local function watchGunDrop()
    table.insert(Connections, workspace.ChildAdded:Connect(function(child)
        if child.Name == "GunDrop" and CFG.GunDropGrab then
            task.wait(0.1)
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
                if hum then
                    hum.WalkSpeed = CFG.SpeedVal
                end
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

local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MM2Pulse"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 1000
    gui.Parent = LP:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "Panel"
    main.Parent = gui
    main.Size = UDim2.new(0, 200, 0, 280)
    main.Position = UDim2.new(0, 10, 0.5, -140)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 50, 70)
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.3
    mainStroke.Parent = main

    local title = Instance.new("TextLabel")
    title.Parent = main
    title.Size = UDim2.new(1, 0, 0, 32)
    title.BackgroundColor3 = Color3.fromRGB(255, 50, 70)
    title.Text = "  MM2 PULSE"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BorderSizePixel = 0
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Parent = main
    status.Size = UDim2.new(1, -16, 0, 20)
    status.Position = UDim2.new(0, 8, 0, 36)
    status.BackgroundTransparency = 1
    status.Text = "Role: ..."
    status.TextColor3 = Color3.fromRGB(180, 180, 180)
    status.TextSize = 11
    status.Font = Enum.Font.GothamMedium
    status.TextXAlignment = Enum.TextXAlignment.Left

    local targetLabel = Instance.new("TextLabel")
    targetLabel.Name = "Target"
    targetLabel.Parent = main
    targetLabel.Size = UDim2.new(1, -16, 0, 20)
    targetLabel.Position = UDim2.new(0, 8, 0, 54)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "Target: Nobody"
    targetLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    targetLabel.TextSize = 11
    targetLabel.Font = Enum.Font.GothamMedium
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left

    local toggles = {
        {name = "Silent Aim", key = "SilentAim", color = Color3.fromRGB(255, 50, 70)},
        {name = "Auto Shot", key = "AutoShot", color = Color3.fromRGB(255, 150, 50)},
        {name = "Hitbox Expander", key = "HitboxExpander", color = Color3.fromRGB(50, 200, 255)},
        {name = "Gun Drop Grab", key = "GunDropGrab", color = Color3.fromRGB(100, 255, 100)},
        {name = "Noclip", key = "Noclip", color = Color3.fromRGB(200, 100, 255)},
        {name = "Speed", key = "Speed", color = Color3.fromRGB(255, 255, 100)},
    }

    local yPos = 80
    for i, t in ipairs(toggles) do
        local frame = Instance.new("Frame")
        frame.Parent = main
        frame.Size = UDim2.new(1, -16, 0, 28)
        frame.Position = UDim2.new(0, 8, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(0.65, 0, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = t.name
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 11
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left

        local toggle = Instance.new("TextButton")
        toggle.Parent = frame
        toggle.Size = UDim2.new(0, 40, 0, 18)
        toggle.Position = UDim2.new(1, -48, 0.5, -9)
        toggle.BackgroundColor3 = CFG[t.key] and t.color or Color3.fromRGB(60, 60, 60)
        toggle.Text = CFG[t.key] and "ON" or "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 9
        toggle.Font = Enum.Font.GothamBold
        toggle.BorderSizePixel = 0
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 9)

        local key = t.key
        local col = t.color
        toggle.MouseButton1Click:Connect(function()
            CFG[key] = not CFG[key]
            if CFG[key] then
                toggle.BackgroundColor3 = col
                toggle.Text = "ON"
            else
                toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                toggle.Text = "OFF"
            end
            if key == "Noclip" then toggleNoclip() end
            if key == "Speed" then toggleSpeed() end
        end)

        yPos = yPos + 32
    end

    return gui, status, targetLabel
end

-- ========== MAIN ==========

local gui, statusLabel, targetLabel = createUI()
watchGunDrop()

table.insert(Connections, RunService.RenderStepped:Connect(function()
    local myChar = LP.Character
    local myRole = "..."
    if myChar then
        myRole = getRole(LP)
    end
    statusLabel.Text = "Role: " .. myRole

    local murderer = getMurderer()
    if murderer then
        local dist = getDist(murderer)
        targetLabel.Text = "Target: " .. murderer.Name .. " (" .. math.floor(dist) .. "m)"

        -- Silent Aim
        if CFG.SilentAim and hasGun() and dist <= CFG.MaxDist then
            equipGun()
            silentAim()
            if CFG.AutoShot then
                fireAtTarget()
            end
        end

        -- Hitbox Expander
        if CFG.HitboxExpander then
            setHitbox(murderer, CFG.HitboxSize)
        else
            resetHitbox(murderer)
        end
    else
        targetLabel.Text = "Target: Nobody"
    end
end))

-- Reset hitbox when murderer changes
table.insert(Connections, Players.PlayerRemoving:Connect(function(plr)
    resetHitbox(plr)
    OriginalHitbox[plr.Name] = nil
end))

-- Cleanup
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Delete then
        for _, c in ipairs(Connections) do
            pcall(function() c:Disconnect() end)
        end
        -- Reset all hitboxes
        for _, p in ipairs(Players:GetPlayers()) do
            resetHitbox(p)
        end
        -- Reset speed
        if LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
        if gui then gui:Destroy() end
        print("[MM2 Pulse] Unloaded")
    end
end)

print("[MM2 Pulse] Loaded | Press Delete to unload")
