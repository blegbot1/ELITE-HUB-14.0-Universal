-- source: ELITE_HUB_14.0.lua Chams (lines 7951-12443)
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
local ESPConfig = _g().ELITE_HUB_ESPConfig
local IsTeammate = _g().ELITE_HUB_IsTeammate

task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local chamHighlights = {}
    local origMats = {}

    local function SaveOriginals(plr)
        local ch = plr.Character
        if not ch then return end
        if origMats[plr] and origMats[plr]._ch == ch then return end
        origMats[plr] = { _ch = ch }
        for _, part in ipairs(ch:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local data = {Material = part.Material, Color = part.Color, Transparency = part.Transparency, CastShadow = part.CastShadow}
                if part:IsA("MeshPart") then
                    pcall(function() data.TextureID = part.TextureID end)
                end
                origMats[plr][part] = data
            end
            if part:IsA("Accessory") then
                pcall(function()
                    local handle = part:FindFirstChild("Handle")
                    if handle then
                        origMats[plr][handle] = {Material = handle.Material, Color = handle.Color, Transparency = handle.Transparency, CastShadow = handle.CastShadow}
                    end
                end)
            end
            if part:IsA("SpecialMesh") then
                pcall(function()
                    origMats[plr][part] = {VertexColor = part.VertexColor, TextureId = part.TextureId}
                end)
            end
            if part:IsA("SurfaceAppearance") then
                origMats[plr][part] = {Enabled = part.Enabled}
            end
            if part:IsA("Texture") then
                origMats[plr][part] = {Transparency = part.Transparency}
            end
            if part:IsA("Decal") then
                origMats[plr][part] = {Transparency = part.Transparency}
            end
        end
    end

    local function RestoreOriginals(plr)
        if origMats[plr] then
            for part, data in pairs(origMats[plr]) do
                if part ~= "_ch" and part and part.Parent then
                    pcall(function()
                        if part:IsA("BasePart") then
                            part.Material = data.Material
                            part.Color = data.Color
                            part.Transparency = data.Transparency
                            if data.CastShadow ~= nil then part.CastShadow = data.CastShadow end
                            if data.TextureID ~= nil and part:IsA("MeshPart") then
                                part.TextureID = data.TextureID
                            end
                        elseif part:IsA("SpecialMesh") then
                            if data.VertexColor then part.VertexColor = data.VertexColor end
                            if data.TextureId then part.TextureId = data.TextureId end
                        elseif part:IsA("SurfaceAppearance") then
                            part.Enabled = data.Enabled
                        elseif part:IsA("Texture") then
                            part.Transparency = data.Transparency
                        elseif part:IsA("Decal") then
                            part.Transparency = data.Transparency
                        end
                    end)
                end
            end
            origMats[plr] = nil
        end
    end

    getgenv().ELITE_HUB_ChamHighlights = chamHighlights
    getgenv().ELITE_HUB_OrigMats = origMats
    getgenv().ELITE_HUB_SaveChamOriginals = SaveOriginals
    getgenv().ELITE_HUB_RestoreChamOriginals = RestoreOriginals

    local function ApplyCham(plr)
        local ch = plr.Character
        if not ch then return end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local show = false
        if ESPConfig.ChamsEnabled then
            if plr == player then
                show = ESPConfig.ChamsSelf
            else
                local isTeam = IsTeammate(plr)
                if ESPConfig.ChamsTeamCheck and isTeam then
                    show = false
                elseif isTeam then
                    show = ESPConfig.ChamsTeammates
                else
                    show = true
                end
            end
        end

        if not show then
            if chamHighlights[plr] then
                chamHighlights[plr]:Destroy()
                chamHighlights[plr] = nil
            end
            RestoreOriginals(plr)
            return
        end

        if not origMats[plr] then
            SaveOriginals(plr)
        end

        local hl = chamHighlights[plr]
        if not hl or not hl.Parent then
            hl = Instance.new("Highlight")
            hl.Name = "EliteChamHighlight"
            hl.Adornee = ch
            hl.Parent = ch
            chamHighlights[plr] = hl
        end
        hl.FillColor = ESPConfig.ChamsFillColor
        hl.FillTransparency = ESPConfig.ChamsFillTransparency
        hl.OutlineColor = ESPConfig.ChamsOutlineColor
        hl.OutlineTransparency = ESPConfig.ChamsOutlineTransparency
        hl.Enabled = true
        hl.Adornee = ch

        local mat = ESPConfig.ChamsMaterial
        local col = ESPConfig.ChamsFillColor
        if mat then
            for _, part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    pcall(function()
                        part.Material = mat
                        part.Color = col
                        part.CastShadow = false
                        if part:IsA("MeshPart") then
                            pcall(function() part.TextureID = "" end)
                        end
                    end)
                end
                if part:IsA("Accessory") then
                    pcall(function()
                        local handle = part:FindFirstChild("Handle")
                        if handle then
                            handle.Material = mat
                            handle.Color = col
                            handle.CastShadow = false
                        end
                    end)
                end
                if part:IsA("SpecialMesh") then
                    pcall(function()
                        part.TextureId = ""
                        part.VertexColor = Vector3.new(col.R, col.G, col.B)
                    end)
                end
                if part:IsA("SurfaceAppearance") then pcall(function() part.Enabled = false end) end
                if part:IsA("Texture") then pcall(function() part.Transparency = 1 end) end
                if part:IsA("Decal") then pcall(function() part.Transparency = 1 end) end
            end
        end
    end

    Players.PlayerRemoving:Connect(function(plr)
        if chamHighlights[plr] then
            chamHighlights[plr]:Destroy()
            chamHighlights[plr] = nil
        end
        RestoreOriginals(plr)
    end)

    local function SetupPlayer(plr)
        plr.CharacterAdded:Connect(function()
            origMats[plr] = nil
            task.spawn(function()
                for _ = 1, 20 do
                    task.wait(0.5)
                    if not ESPConfig.ChamsEnabled then return end
                    local c = plr.Character
                    if c and c:FindFirstChildOfClass("Humanoid") then
                        pcall(ApplyCham, plr)
                        return
                    end
                end
            end)
        end)
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        SetupPlayer(plr)
    end

    Players.PlayerAdded:Connect(SetupPlayer)

    RunService.RenderStepped:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            pcall(ApplyCham, plr)
        end
    end)
    getgenv().ELITE_HUB_ChamHighlights = chamHighlights
    getgenv().ELITE_HUB_RestoreOriginals = RestoreOriginals
    getgenv().ELITE_HUB_ChamOrigMats = origMats
end)
getgenv().ELITE_HUB_ChamsTab:CreateSection("🎨 PLAYER CHAMS")

task.spawn(function()
local chamHighlights = getgenv().ELITE_HUB_ChamHighlights or {}
local RestoreOriginals = getgenv().ELITE_HUB_RestoreOriginals or function() end
getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = " Enable Chams",
    CurrentValue = ESPConfig.ChamsEnabled,
    Callback = function(value)
        ESPConfig.ChamsEnabled = value
        getgenv().ELITE_HUB_Log("CHAMS", "Chams: " .. tostring(value))
        if not value then
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                pcall(function()
                    if chamHighlights[plr] then
                        chamHighlights[plr]:Destroy()
                        chamHighlights[plr] = nil
                    end
                    RestoreOriginals(plr)
                end)
            end
        end
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateColorPicker({
    Name = " Fill color",
    Color = ESPConfig.ChamsFillColor,
    Callback = function(value)
        ESPConfig.ChamsFillColor = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = " Fill transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.ChamsFillTransparency,
    Callback = function(value)
        ESPConfig.ChamsFillTransparency = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateColorPicker({
    Name = " Outline color",
    Color = ESPConfig.ChamsOutlineColor,
    Callback = function(value)
        ESPConfig.ChamsOutlineColor = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = " Outline transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = ESPConfig.ChamsOutlineTransparency,
    Callback = function(value)
        ESPConfig.ChamsOutlineTransparency = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateDropdown({
    Name = " Chams material",
    Options = {"ForceField", "Neon", "Glass", "SmoothPlastic", "Plastic", "Wood", "DiamondPlate", "Foil", "Ice", "Brick", "Cobblestone", "CorrodedMetal", "Grass", "Sand", "Slate", "Marble", "Granite", "Limestone"},
    CurrentOption = "ForceField",
    Callback = function(value)
        local v = (typeof(value) == "table") and value[1] or value
        ESPConfig.ChamsMaterial = Enum.Material[v] or Enum.Material.ForceField
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = " Team check",
    CurrentValue = ESPConfig.ChamsTeamCheck,
    Callback = function(value)
        ESPConfig.ChamsTeamCheck = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = " Show on self",
    CurrentValue = ESPConfig.ChamsSelf,
    Callback = function(value)
        ESPConfig.ChamsSelf = value
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = " Show on teammates",
    CurrentValue = ESPConfig.ChamsTeammates,
    Callback = function(value)
        ESPConfig.ChamsTeammates = value
    end
})
end)

getgenv().ELITE_HUB_ChamsTab:CreateSection("🌈 RAINBOW CHAMS")

getgenv().ELITE_HUB_RainbowChams = false
getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = " Rainbow Chams",
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
getgenv().ELITE_HUB_ChamsTab:CreateSection("🗡 WEAPON CHAMS")

getgenv().ELITE_HUB_RangeWeaponChams = false
getgenv().ELITE_HUB_RangeWeaponColor = Color3.fromRGB(150, 70, 255)
getgenv().ELITE_HUB_RangeWeaponMat = Enum.Material.Neon

getgenv().ELITE_HUB_ChamsTab:CreateToggle({
    Name = " Weapon Chams",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_RangeWeaponChams = value
        getgenv().ELITE_HUB_Log("CHAMS", "Weapon Chams: " .. tostring(value))
        if not value then
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:GetAttribute("EliteHubWC") then
                    pcall(function()
                        local origMat = part:GetAttribute("EliteHubWCOrigMat")
                        local origCol = part:GetAttribute("EliteHubWCOrigCol")
                        local origTrans = part:GetAttribute("EliteHubWCOrigTrans")
                        if origMat then
                            local m = Enum.Material[origMat]
                            if m then part.Material = m end
                        end
                        if origCol then part.Color = origCol end
                        if origTrans then part.Transparency = origTrans end
                        part:SetAttribute("EliteHubWC", nil)
                        part:SetAttribute("EliteHubWCOrigMat", nil)
                        part:SetAttribute("EliteHubWCOrigCol", nil)
                        part:SetAttribute("EliteHubWCOrigTrans", nil)
                    end)
                end
            end
        end
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = " Weapon R",
    Range = {0, 255},
    Increment = 5,
    CurrentValue = 150,
    Callback = function(value)
        local c = getgenv().ELITE_HUB_RangeWeaponColor
        getgenv().ELITE_HUB_RangeWeaponColor = Color3.new(value / 255, c.G, c.B)
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = " Weapon G",
    Range = {0, 255},
    Increment = 5,
    CurrentValue = 70,
    Callback = function(value)
        local c = getgenv().ELITE_HUB_RangeWeaponColor
        getgenv().ELITE_HUB_RangeWeaponColor = Color3.new(c.R, value / 255, c.B)
    end
})

getgenv().ELITE_HUB_ChamsTab:CreateSlider({
    Name = " Weapon B",
    Range = {0, 255},
    Increment = 5,
    CurrentValue = 255,
    Callback = function(value)
        local c = getgenv().ELITE_HUB_RangeWeaponColor
        getgenv().ELITE_HUB_RangeWeaponColor = Color3.new(c.R, c.G, value / 255)
    end
})

local matNames = {"Neon", "ForceField", "Glass", "SmoothPlastic", "DiamondPlate", "Foil"}
getgenv().ELITE_HUB_ChamsTab:CreateDropdown({
    Name = " Material",
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
    while task.wait(0.1) do
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
                        if not part:GetAttribute("EliteHubWC") then
                            part:SetAttribute("EliteHubWC", true)
                            part:SetAttribute("EliteHubWCOrigMat", tostring(part.Material.Name))
                            part:SetAttribute("EliteHubWCOrigCol", part.Color)
                            part:SetAttribute("EliteHubWCOrigTrans", part.Transparency)
                        end
                        part.Material = mat
                        part.Color = col
                        part.CastShadow = false
                        part.Transparency = 0
                        if part:IsA("MeshPart") then
                            pcall(function() part.TextureID = "" end)
                        end
                    end
                    if part:IsA("SurfaceAppearance") then pcall(function() part.Enabled = false end) end
                    if part:IsA("Texture") then pcall(function() part.Transparency = 1 end) end
                    if part:IsA("Decal") then pcall(function() part.Transparency = 1 end) end
                    if part:IsA("SpecialMesh") then
                        pcall(function() part.TextureId = "" end)
                        pcall(function() part.VertexColor = Vector3.new(col.R, col.G, col.B) end)
                    end
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