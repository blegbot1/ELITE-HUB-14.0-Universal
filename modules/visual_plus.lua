-- ELITE HUB 14.0 — Visual+ Module (Item ESP, X-Ray, Wallhack)
-- Extracted from ELITE_HUB_14.0.lua

MT = VisualPlusTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: VISUAL+")
MT:CreateSection("👁️ ESP+")

getgenv().ELITE_HUB_ItemESP = false
MT:CreateToggle({
    Name = "🎒 Item ESP (items)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_ItemESP = value
        getgenv().ELITE_HUB_Log("MODS", "Item ESP: " .. tostring(value))
        if not value then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:GetAttribute("EliteHubItemTag") then
                    v:FindFirstChildOfClass("BillboardGui"):Destroy()
                    v:SetAttribute("EliteHubItemTag", nil)
                end
            end
        end
    end
})
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if not getgenv().ELITE_HUB_ItemESP then return end
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name ~= "Terrain" and not v:GetAttribute("EliteHubItemTag") then
                    local dist = (v.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 200 and v.Size.Magnitude < 15 then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 20)
                        bb.AlwaysOnTop = true
                        bb.Adornee = v
                        bb.Parent = v
                        local tl = Instance.new("TextLabel")
                        tl.BackgroundTransparency = 1
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.Text = v.Name
                        tl.TextColor3 = Color3.fromRGB(255, 200, 50)
                        tl.TextSize = 10
                        tl.Font = Enum.Font.GothamBold
                        tl.TextStrokeTransparency = 0
                        tl.Parent = bb
                        v:SetAttribute("EliteHubItemTag", true)
                    end
                end
            end
        end)
    end
end)

MT = VisualPlusTab
getgenv().ELITE_HUB_Log("UI", "Section loaded: VISUAL+ (2)")
MT:CreateSection("🌈 VISUAL+")

getgenv().ELITE_HUB_XRay = false
MT:CreateToggle({
    Name = "👀 X-Ray (transparent walls)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_XRay = value
        getgenv().ELITE_HUB_Log("MODS", "X-Ray: " .. tostring(value))
        if value then
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "Terrain" then
                    if not part:GetAttribute("EliteHubXRay") then
                        part:SetAttribute("EliteHubXRay", part.Transparency)
                    end
                    if part.Transparency < 0.5 then
                        part.Transparency = 0.8
                    end
                end
            end
        else
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    local orig = part:GetAttribute("EliteHubXRay")
                    if orig then
                        part.Transparency = orig
                        part:SetAttribute("EliteHubXRay", nil)
                    end
                end
            end
        end
    end
})

getgenv().ELITE_HUB_Wallhack = false
MT:CreateToggle({
    Name = "🧱 Wallhack (walls disappear)",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_Wallhack = value
        getgenv().ELITE_HUB_Log("MODS", "Wallhack: " .. tostring(value))
        if value then
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "Terrain" then
                    if not part:GetAttribute("EliteHubWH") then
                        part:SetAttribute("EliteHubWH", part.Transparency)
                    end
                    part.Transparency = 1
                end
            end
        else
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    local orig = part:GetAttribute("EliteHubWH")
                    if orig then
                        part.Transparency = orig
                        part:SetAttribute("EliteHubWH", nil)
                    end
                end
            end
        end
    end
})
