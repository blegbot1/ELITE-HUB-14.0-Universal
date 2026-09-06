-- ELITE HUB 14.0 — Chams Module (Player Chams, Rainbow Chams, Weapon Chams)
-- Extracted from ELITE_HUB_14.0.lua

getgenv().ELITE_HUB_ChamsTab:CreateSection("💎 PLAYER CHAMS")

task.spawn(function()
getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "💎 Enable Chams",
    CurrentValue = ESPConfig.ChamsEnabled,
    Callback = function(value)
        ESPConfig.ChamsEnabled = value
        getgenv().ELITE_HUB_Log("CHAMS", "Chams: " .. tostring(value))
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateColorPicker({
    Name = "🎨 Fill color",
    Color = ESPConfig.ChamsFillColor,
    Callback = function(value)
        ESPConfig.ChamsFillColor = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = "🔍 Fill transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.ChamsFillTransparency,
    Callback = function(value)
        ESPConfig.ChamsFillTransparency = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateColorPicker({
    Name = "🎨 Outline color",
    Color = ESPConfig.ChamsOutlineColor,
    Callback = function(value)
        ESPConfig.ChamsOutlineColor = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = "🔍 Outline transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.ChamsOutlineTransparency,
    Callback = function(value)
        ESPConfig.ChamsOutlineTransparency = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateDropdown({
    Name = "🧊 Chams material",
    Options = {"ForceField", "Neon", "Glass", "SmoothPlastic", "Plastic", "Wood", "DiamondPlate", "Foil", "Ice", "Brick", "Cobblestone", "CorrodedMetal", "Grass", "Sand", "Slate", "Marble", "Granite", "Limestone"},
    CurrentOption = "ForceField",
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        ESPConfig.ChamsMaterial = Enum.Material[v] or Enum.Material.ForceField
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "👥 Team check",
    CurrentValue = ESPConfig.ChamsTeamCheck,
    Callback = function(value)
        ESPConfig.ChamsTeamCheck = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "👤 Show on self",
    CurrentValue = ESPConfig.ChamsSelf,
    Callback = function(value)
        ESPConfig.ChamsSelf = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "🤝 Show on teammates",
    CurrentValue = ESPConfig.ChamsTeammates,
    Callback = function(value)
        ESPConfig.ChamsTeammates = value
    end
})
end)

getgenv().ELITE_HUB_ChamsTab:CreateSection("🌈 RAINBOW CHAMS")

getgenv().ELITE_HUB_RainbowChams = false
getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "🌈 Rainbow Chams",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RainbowChams = value
        getgenv().ELITE_HUB_Log("CHAMS", "Rainbow Chams: " .. tostring(value))
    end
})
task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        pcall(function()
            if not getgenv().ELITE_HUB_RainbowChams then return end
            if not ESPConfig.ChamsEnabled then return end
            hue = (hue + 0.01) % 1
            ESPConfig.ChamsFillColor = Color3.fromHSV(hue, 1, 1)
            ESPConfig.ChamsOutlineColor = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
        end)
    end
end)

getgenv().ELITE_HUB_ChamsTab:CreateSection("🔫 WEAPON CHAMS")

getgenv().ELITE_HUB_RangeWeaponChams = false
getgenv().ELITE_HUB_RangeWeaponColor = Color3.fromRGB(150, 70, 255)
getgenv().ELITE_HUB_RangeWeaponMat = Enum.Material.Neon

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = "🔫 Weapon Chams",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RangeWeaponChams = value
        getgenv().ELITE_HUB_Log("CHAMS", "Weapon Chams: " .. tostring(value))
        if not value then
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:GetAttribute("EliteHubWC") then
                    pcall(function()
                        part.Material = part:GetAttribute("EliteHubWCOrigMat")
                        part.Color = part:GetAttribute("EliteHubWCOrigCol")
                        part:SetAttribute("EliteHubWC", nil)
                        part:SetAttribute("EliteHubWCOrigMat", nil)
                        part:SetAttribute("EliteHubWCOrigCol", nil)
                    end)
                end
            end
        end
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = "🎨 Weapon R",
    Range = {0, 255},
    Increment = 5,
    CurrentValue = 150,
    Callback = function(value)
        local c = getgenv().ELITE_HUB_RangeWeaponColor
        getgenv().ELITE_HUB_RangeWeaponColor = Color3.fromRGB(value, c.G * 255, c.B * 255)
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = "🎨 Weapon G",
    Range = {0, 255},
    Increment = 5,
    CurrentValue = 70,
    Callback = function(value)
        local c = getgenv().ELITE_HUB_RangeWeaponColor
        getgenv().ELITE_HUB_RangeWeaponColor = Color3.fromRGB(c.R * 255, value, c.B * 255)
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = "🎨 Weapon B",
    Range = {0, 255},
    Increment = 5,
    CurrentValue = 255,
    Callback = function(value)
        local c = getgenv().ELITE_HUB_RangeWeaponColor
        getgenv().ELITE_HUB_RangeWeaponColor = Color3.fromRGB(c.R * 255, c.G * 255, value)
    end
})

local matNames = {"Neon", "ForceField", "Glass", "SmoothPlastic", "DiamondPlate", "Foil"}
getgenv().ELITE_HUB_ChamsTab:CreateDropdown({
    Name = "🎨 Material",
    Options = matNames,
    CurrentOption = {"Neon"},
    Callback = function(opt)
        local matMap = {
            Neon = Enum.Material.Neon,
            ForceField = Enum.Material.ForceField,
            Glass = Enum.Material.Glass,
            SmoothPlastic = Enum.Material.SmoothPlastic,
            DiamondPlate = Enum.Material.DiamondPlate,
            Foil = Enum.Material.Foil,
        }
        getgenv().ELITE_HUB_RangeWeaponMat = matMap[opt] or Enum.Material.Neon
    end
})

task.spawn(function()
    while task.wait(0.016) do
        pcall(function()
            if not getgenv().ELITE_HUB_RangeWeaponChams then return end
            local ch = player.Character
            if not ch then return end
            local mat = getgenv().ELITE_HUB_RangeWeaponMat
            local col = getgenv().ELITE_HUB_RangeWeaponColor
            local function applyChams(tool)
                if not tool or not tool:IsA("Tool") then return end
                for _, part in ipairs(tool:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Material = mat
                        part.Color = col
                        part.CastShadow = false
                    end
                    if part:IsA("SurfaceAppearance") then pcall(function() part:Destroy() end) end
                    if part:IsA("Texture") then pcall(function() part:Destroy() end) end
                    if part:IsA("Decal") then pcall(function() part.Transparency = 1 end) end
                    if part:IsA("SpecialMesh") then pcall(function() part.TextureId = "" end) end
                end
            end
            for _, tool in ipairs(ch:GetChildren()) do
                applyChams(tool)
            end
            for _, tool in ipairs(player.Backpack:GetChildren()) do
                applyChams(tool)
            end
        end)
    end
end)
