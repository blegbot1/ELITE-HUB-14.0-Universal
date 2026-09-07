-- source: ELITE_HUB_14.0.lua VisualPlus (lines 9105-9244)
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
local ESPTab = _g().ELITE_HUB_ESPTab
local ESPConfig = _g().ELITE_HUB_ESPConfig
local AimbotConfig = _g().ELITE_HUB_AimbotConfig
local NewOverlayCircle = _g().ELITE_HUB_NewOverlayCircle or NewOverlayCircle

ESPTab:CreateToggle({
    Name = " Target HP bar above head",
    CurrentValue = AimbotConfig.TargetHealthBarTop,
    Callback = function(value)
        AimbotConfig.TargetHealthBarTop = value
    end
})

ESPTab:CreateToggle({
    Name = " Pin HP bar to head",
    CurrentValue = AimbotConfig.TargetHealthBarMounted,
    Callback = function(value)
        AimbotConfig.TargetHealthBarMounted = value
    end
})

local VFX = {}
pcall(function()
VFX.VisualGui = Instance.new("ScreenGui")
VFX.VisualGui.Name = "EliteHubVisual"
VFX.VisualGui.ResetOnSpawn = false
VFX.VisualGui.Parent = player:WaitForChild("PlayerGui")


VFX.VignetteFrame = Instance.new("Frame")
VFX.VignetteFrame.Size = UDim2.new(1, 0, 1, 0)
VFX.VignetteFrame.BackgroundColor3 = ESPConfig.LowHPColor
VFX.VignetteFrame.BackgroundTransparency = 1
VFX.VignetteFrame.BorderSizePixel = 0
VFX.VignetteFrame.Visible = false
VFX.VignetteFrame.ZIndex = 5
VFX.VignetteFrame.Parent = VFX.VisualGui
VFX.VignetteGrad = Instance.new("UIGradient")
VFX.VignetteGrad.Rotation = 0
VFX.VignetteGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.55, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(0.8, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
})
VFX.VignetteGrad.Parent = VFX.VignetteFrame

VFX.PulseCircle = NewOverlayCircle()
VFX.PulseCircle.Color = AimbotConfig.PulseColor
VFX.PulseCircle.Thickness = 3
VFX.PulseCircle.Visible = false
VFX.PulseTime = 0

VFX.BarFrame = Instance.new("Frame")
VFX.BarFrame.Size = UDim2.new(0, 200, 0, 14)
VFX.BarFrame.AnchorPoint = Vector2.new(0.5, 1)
VFX.BarBg = Instance.new("Frame")
VFX.BarBg.BackgroundColor3 = Color3.new(0, 0, 0)
VFX.BarBg.BackgroundTransparency = 0.4
VFX.BarBg.Size = UDim2.new(1, 0, 1, 0)
VFX.BarBg.BorderSizePixel = 0
VFX.BarBg.Parent = VFX.BarFrame
VFX.BarFill = Instance.new("Frame")
VFX.BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
VFX.BarFill.BorderSizePixel = 0
VFX.BarFill.AnchorPoint = Vector2.new(0, 0.5)
VFX.BarFill.Position = UDim2.new(0, 0, 0.5, 0)
VFX.BarFill.Size = UDim2.new(1, 0, 1, 0)
VFX.BarFill.Parent = VFX.BarFrame
VFX.BarName = Instance.new("TextLabel")
VFX.BarName.BackgroundTransparency = 1
VFX.BarName.Size = UDim2.new(1, 0, 1, 0)
VFX.BarName.TextColor3 = Color3.new(1, 1, 1)
VFX.BarName.TextStrokeTransparency = 0
VFX.BarName.TextStrokeColor3 = Color3.new(0, 0, 0)
VFX.BarName.Font = Enum.Font.SourceSansBold
VFX.BarName.TextSize = 11
VFX.BarName.Parent = VFX.BarFrame
VFX.BarBillboard = Instance.new("BillboardGui")
VFX.BarBillboard.Size = UDim2.new(0, 220, 0, 40)
VFX.BarBillboard.AlwaysOnTop = true
VFX.BarBillboard.Adornee = nil
VFX.BarBillboard.Parent = VFX.VisualGui
VFX.BarFrame.Parent = VFX.BarBillboard
VFX.BarBillboard.Enabled = false
end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local lowHP = false
            local myChar = player.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if myHum and myHum.Health > 0 and myHum.Health <= ESPConfig.LowHPThreshold then
                lowHP = true
            end
            VFX.VignetteFrame.Visible = ESPConfig.LowHPWarning
            if ESPConfig.LowHPWarning and lowHP then
                local pulse = (math.sin(tick() * 6) + 1) / 2
                VFX.VignetteFrame.BackgroundTransparency = 0.75 - pulse * 0.35
            else
                VFX.VignetteFrame.BackgroundTransparency = 1
            end

            VFX.PulseTime = VFX.PulseTime + 0.05
            local pulseOn = AimbotConfig.PulseTarget and LockedTarget and LockedTargetPlayer
            VFX.PulseCircle.Visible = false
            if pulseOn then
                local base = AimbotConfig.PulseSize
                local pulse = (math.sin(VFX.PulseTime * AimbotConfig.PulseSpeed) + 1) / 2
                VFX.PulseCircle.Radius = base * (1 + pulse * 1.5)
                VFX.PulseCircle.Color = AimbotConfig.PulseColor
                local spp, vis = workspace.CurrentCamera:WorldToViewportPoint(LockedTarget.Position)
                if vis then
                    VFX.PulseCircle.Position = Vector2.new(spp.X, spp.Y)
                    VFX.PulseCircle.Visible = true
                end
            end

            local barOnRaw = AimbotConfig.TargetHealthBarTop and LockedTargetPlayer and LockedTargetPlayer.Character
            local tcRaw = barOnRaw and LockedTargetPlayer.Character
            local thpRaw = tcRaw and tcRaw:FindFirstChild("Head")
            local barOn = barOnRaw and thpRaw
            VFX.BarBillboard.Enabled = barOn and true or false
            if barOn then
                local tc = LockedTargetPlayer.Character
                local th = tc:FindFirstChildOfClass("Humanoid")
                local tr = tc:FindFirstChild("HumanoidRootPart")
                local thp = thpRaw
                if th and tr and thp then
                    VFX.BarBillboard.Adornee = thp
                    VFX.BarBillboard.StudsOffset = Vector3.new(0, 1.2, 0)
                    local mh = th.MaxHealth
                    if mh <= 0 then mh = 100 end
                    local hp = math.max(th.Health, 0)
                    local pct = math.clamp(hp / mh, 0, 1)
                    VFX.BarFill.Visible = pct > 0
                    VFX.BarFill.Size = UDim2.new(pct, 0, 1, 0)
                    VFX.BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    VFX.BarName.Text = LockedTargetPlayer.Name .. " [" .. math.floor(hp) .. "/" .. math.floor(mh) .. "]"
                end
            end
        end)
    end
end)