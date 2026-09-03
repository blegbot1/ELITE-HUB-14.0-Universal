-- MM2 Auto-Aim (Client-Side)
-- Murder Mystery 2 (They're Infinite)
-- PlaceId: 142823291

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Enabled = false,
    AutoFire = true,
    TeleportBehind = true,
    BehindDistance = 8,
    FireDelay = 0.55,
    SmoothAim = true,
    SmoothSpeed = 0.3,
    MaxDistance = 300,
    AimPart = "HumanoidRootPart",
}

local Connections = {}
local LastFire = 0
local Target = nil

-- ========== HELPERS ==========

local function getRole(plr)
    local char = plr.Character
    if (char and char:FindFirstChild("Knife")) or plr.Backpack:FindFirstChild("Knife") then
        return "Murderer"
    elseif (char and char:FindFirstChild("Gun")) or plr.Backpack:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

local function getMurderer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and getRole(plr) == "Murderer" then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                return plr
            end
        end
    end
    return nil
end

local function hasGun()
    local char = LocalPlayer.Character
    return (char and char:FindFirstChild("Gun") ~= nil) or
           (LocalPlayer.Backpack:FindFirstChild("Gun") ~= nil)
end

local function equipGun()
    local char = LocalPlayer.Character
    if not char then return false end
    local gun = LocalPlayer.Backpack:FindFirstChild("Gun")
    if gun then
        gun.Parent = char
        return true
    end
    return char:FindFirstChild("Gun") ~= nil
end

local function getGunRemote()
    local char = LocalPlayer.Character
    if not char then return nil end
    local gun = char:FindFirstChild("Gun")
    if not gun then return nil end
    local knifeServer = gun:FindFirstChild("KnifeServer")
    if not knifeServer then return nil end
    return knifeServer:FindFirstChild("ShootGun")
end

local function getDistanceTo(target)
    local myChar = LocalPlayer.Character
    if not myChar then return math.huge end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return math.huge end
    local targetChar = target.Character
    if not targetChar then return math.huge end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return math.huge end
    return (myHRP.Position - targetHRP.Position).Magnitude
end

local function aimAt(target)
    local char = LocalPlayer.Character
    if not char then return end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local targetChar = target.Character
    if not targetChar then return end
    local targetPart = targetChar:FindFirstChild(Config.AimPart)
    if not targetPart then return end

    local targetPos = targetPart.Position
    if Config.TeleportBehind then
        local lookDir = (myHRP.Position - targetPos).Unit
        targetPos = targetPos + lookDir * Config.BehindDistance
    end

    if Config.SmoothAim then
        local currentCF = myHRP.CFrame
        local lookAt = CFrame.lookAt(currentCF.Position, targetPart.Position)
        myHRP.CFrame = currentCF:Lerp(lookAt, Config.SmoothSpeed)
    else
        myHRP.CFrame = CFrame.lookAt(myHRP.Position, targetPart.Position)
    end
end

local function fireGun()
    local now = tick()
    if now - LastFire < Config.FireDelay then return end

    local murderer = getMurderer()
    if not murderer then return end
    local targetChar = murderer.Character
    if not targetChar then return end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    local remote = getGunRemote()
    if not remote then return end

    local shootPos = targetHRP.Position
    if Config.TeleportBehind then
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHRP then
            local lookDir = (myHRP.Position - targetHRP.Position).Unit
            shootPos = targetHRP.Position + lookDir * Config.BehindDistance
        end
    end

    pcall(function()
        remote:InvokeServer(1, shootPos, "AH")
    end)
    LastFire = now
end

-- ========== UI ==========

local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MM2AutoAim"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 1000
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local btn = Instance.new("TextButton")
    btn.Name = "Toggle"
    btn.Parent = gui
    btn.Size = UDim2.new(0, 140, 0, 36)
    btn.Position = UDim2.new(0.5, -70, 0, 10)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "  🎯 Auto-Aim: OFF"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 80, 80)
    stroke.Thickness = 1
    stroke.Parent = btn

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Parent = gui
    status.Size = UDim2.new(0, 200, 0, 24)
    status.Position = UDim2.new(0.5, -100, 0, 52)
    status.BackgroundTransparency = 1
    status.Text = "Murderer: ???"
    status.TextColor3 = Color3.fromRGB(200, 80, 80)
    status.TextSize = 12
    status.Font = Enum.Font.GothamMedium

    btn.MouseButton1Click:Connect(function()
        Config.Enabled = not Config.Enabled
        if Config.Enabled then
            btn.Text = "  🎯 Auto-Aim: ON"
            btn.BackgroundColor3 = Color3.fromRGB(180, 40, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            stroke.Color = Color3.fromRGB(255, 80, 80)
        else
            btn.Text = "  🎯 Auto-Aim: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            stroke.Color = Color3.fromRGB(80, 80, 80)
        end
    end)

    -- Draggable
    local dragging, dragStart, startPos
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            status.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 0, 52)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return gui, status
end

-- ========== MAIN LOOP ==========

local gui, statusLabel = createUI()

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if not Config.Enabled then
        statusLabel.Text = "Murderer: ???"
        statusLabel.TextColor3 = Color3.fromRGB(200, 80, 80)
        return
    end

    local murderer = getMurderer()
    if murderer then
        local dist = getDistanceTo(murderer)
        statusLabel.Text = "Murderer: " .. murderer.Name .. " (" .. math.floor(dist) .. "m)"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)

        if hasGun() and dist <= Config.MaxDistance then
            equipGun()
            aimAt(murderer)
            if Config.AutoFire then
                fireGun()
            end
        else
            statusLabel.Text = statusLabel.Text .. " [NO GUN]"
        end
    else
        statusLabel.Text = "Murderer: Nobody"
        statusLabel.TextColor3 = Color3.fromRGB(80, 200, 80)
    end
end))

table.insert(Connections, Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then
        for _, conn in ipairs(Connections) do
            pcall(function() conn:Disconnect() end)
        end
        if gui then gui:Destroy() end
    end
end))

-- ========== CLEANUP ON KEYBIND ==========

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Delete then
        Config.Enabled = false
        for _, conn in ipairs(Connections) do
            pcall(function() conn:Disconnect() end)
        end
        if gui then gui:Destroy() end
    end
end)

print("[MM2 Auto-Aim] Loaded | Press Delete to unload")
