-- ELITE HUB 14.0 — Kill All Module
-- Extracted from ELITE_HUB_14.0.lua

--[[
    ==============================
    РАЗДЕЛ УБИТЬ ВСЕХ (ОБНОВЛЕННЫЙ)
    ==============================
]]--
local KillAllSection = KillAllTab:CreateSection("⚔️ KILL ALL ENEMIES")
local safeZoneRadius = 20
local isActive = false
local killAllEnabled = true
local ignoreTeam = true
local zonePart = Instance.new("Part")
zonePart.Shape = Enum.PartType.Ball
zonePart.Anchored = true
zonePart.CanCollide = false
zonePart.Transparency = 0.7
zonePart.Color = Color3.fromRGB(0, 255, 0)
zonePart.Material = Enum.Material.Neon
zonePart.Name = "SafeZone"
zonePart.Parent = workspace

KillAllTab:CreateToggle({
   Name = "🛡️ Enable Safe Zone",
   CurrentValue = isActive,
   Callback = function(Value)
      isActive = Value
   end
})

KillAllTab:CreateToggle({
   Name = "⚔️ Kill All mode",
   CurrentValue = killAllEnabled,
   Callback = function(Value)
      killAllEnabled = Value
   end
})

KillAllTab:CreateToggle({
   Name = "👥 Ignore team",
   CurrentValue = ignoreTeam,
   Callback = function(Value)
      ignoreTeam = Value
   end
})

KillAllTab:CreateSlider({
   Name = "📏 Safe zone radius",
   Range = {5, 100},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = safeZoneRadius,
   Callback = function(Value)
      safeZoneRadius = Value
   end
})

task.spawn(function()
    Log("KILLALL", "Цикл Kill All запущен")
    while task.wait(0.1) do
        pcall(function()
            local myChar = player.Character
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

            local root = myChar.HumanoidRootPart
            zonePart.Position = root.Position
            zonePart.Size = Vector3.new(safeZoneRadius * 2, safeZoneRadius * 2, safeZoneRadius * 2)

            if not isActive then
                zonePart.Transparency = 1
                return
            else
                zonePart.Transparency = 0.7
            end

            local tool = myChar:FindFirstChildOfClass("Tool")
            if not tool or not tool:FindFirstChild("Handle") then return end

            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                    if not (ignoreTeam and player.Team and other.Team and player.Team == other.Team) then
                        local oRoot = other.Character.HumanoidRootPart
                        local dist = (oRoot.Position - root.Position).Magnitude

                        local shouldAttack = killAllEnabled or (dist > safeZoneRadius)

                        if shouldAttack and dist <= 10000 then
                            tool:Activate()
                            for _, part in pairs(other.Character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    firetouchinterest(tool.Handle, part, 0)
                                    firetouchinterest(tool.Handle, part, 1)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
