-- source: ELITE_HUB_14.0.lua KillAll (lines 9389-9590)
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
local KillAllTab = _g().ELITE_HUB_KillAllTab
local MainTab = _g().ELITE_HUB_MainTab

--[[
    ==============================
    Р РђР—Р”Р•Р› РЈР‘РРўР¬ Р’РЎР•РҐ (РћР‘РќРћР’Р›Р•РќРќР«Р™)
    ==============================
]]--
local KillAllSection = KillAllTab:CreateSection("☠ KILL ALL ENEMIES")
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
   Name = " Enable Safe Zone",
   CurrentValue = isActive,
   Callback = function(Value)
      isActive = Value
   end
})

KillAllTab:CreateToggle({
   Name = " Kill All mode",
   CurrentValue = killAllEnabled,
   Callback = function(Value)
      killAllEnabled = Value
   end
})

KillAllTab:CreateToggle({
   Name = " Ignore team",
   CurrentValue = ignoreTeam,
   Callback = function(Value)
      ignoreTeam = Value
   end
})

KillAllTab:CreateSlider({
   Name = " Safe zone radius",
   Range = {5, 100},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = safeZoneRadius,
   Callback = function(Value)
      safeZoneRadius = Value
   end
})

task.spawn(function()
    Log("KILLALL", " Kill All ")
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

--[[
    ==============================
    РћР‘РќРћР’Р›Р•РќРќР«Р• Р”РћРџРћР›РќРРўР•Р›Р¬РќР«Р• РЎРљР РРџРўР«
    ==============================
]]--
local ScriptsSection = MainTab:CreateSection("➕ EXTRA SCRIPTS")

local function LoadImprovedFlight()
    local UserInputService = game:GetService("UserInputService")
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    if isMobile then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/MobileFly.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/396abc/Script/refs/heads/main/FlyR15.lua"))()
    end
end

local function LoadRakeAnimation()
    local animationId = "rbxassetid://252557606"
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    local animation = Instance.new("Animation")
    animation.AnimationId = animationId

    local animationTrack = humanoid:LoadAnimation(animation)
    local defaultWalkSpeed = 50
    humanoid.WalkSpeed = defaultWalkSpeed

    local function onWalking(speed)
        if speed > 0 then
            humanoid.WalkSpeed = 50
            animationTrack:Play()
        else
            humanoid.WalkSpeed = defaultWalkSpeed
            animationTrack:Stop()
        end
    end

    humanoid.Running:Connect(onWalking)

    local backpack = player:WaitForChild("Backpack")
    
    local tool1 = Instance.new("Tool")
    tool1.Name = "double slash"
    tool1.RequiresHandle = false
    tool1.CanBeDropped = false

    local animation1 = Instance.new("Animation")
    animation1.AnimationId = "rbxassetid://105211514"

    tool1.Activated:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animTrack = humanoid:LoadAnimation(animation1)
            animTrack:Play()
        end
    end)
    tool1.Parent = backpack

    local tool2 = Instance.new("Tool")
    tool2.Name = "enrage"
    tool2.RequiresHandle = false
    tool2.CanBeDropped = false

    local animation2 = Instance.new("Animation")
    animation2.AnimationId = "rbxassetid://93648331"

    tool2.Activated:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animTrack = humanoid:LoadAnimation(animation2)
            animTrack:Play()
        end
    end)
    tool2.Parent = backpack
end

local newScripts = {
    {
        Name = " FE Seraphic Blade",
        Url = "https://pastefy.app/59mJGQGe/raw"
    },
    {
        Name = " FE Animations",
        Url = "https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"
    },
    {
        Name = " Enhanced Flight",
        Callback = LoadImprovedFlight
    },
    {
        Name = " The Rake Animation",
        Callback = LoadRakeAnimation
    },
    {
        Name = " Touch Fling",
        Url = "https://rawscripts.net/raw/Universal-Script-TOUCH-FLING-30401"
    }
}

for i, scriptInfo in ipairs(newScripts) do
    MainTab:CreateButton({
        Name = scriptInfo.Name,
        Callback = function()
            Rayfield:Notify({
                Title = "⏳ Loading...",
                Content = "Loading: "..scriptInfo.Name,
                Duration = 3
            })

            local success, err = pcall(function()
                if scriptInfo.Callback then
                    scriptInfo.Callback()
                else
                    loadstring(game:HttpGet(scriptInfo.Url, true))()
                end
            end)

            if success then
                Rayfield:Notify({
                    Title = "✅ Done!",
                    Content = scriptInfo.Name.." loaded",
                    Duration = 4
                })
            else
                Rayfield:Notify({
                    Title = "❌ Error",
                    Content = "Error loading "..scriptInfo.Name..":\n"..tostring(err),
                    Duration = 6
                })
            end
        end
    })
end

local scriptUrls = {
    "https://pastefy.app/YsJgITXR/raw",
    "https://pastebin.com/raw/3Rnd9rHf",
    "https://pastefy.app/JOWniO6o/raw",
    "https://pastebin.com/raw/LgZwZ7ZB",
    "https://pastefy.app/w7KnPY70/raw",
    "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Gale%20Fighter",
    "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Neptunian%20V"
}
local scriptNames = {
    " SCP-096 Mode",
    " Invisibility PRO",
    " Zombie Hacks",
    " Fling+",
    " Simple Zombie Companion",
    " FE GALE FIGHTER",
    " FE Neptunian V"
}

for i = 1, #scriptNames do
    MainTab:CreateButton({
        Name = scriptNames[i],
        Callback = function()
            Rayfield:Notify({
                Title = "⏳ Loading...",
                Content = "Loading: "..scriptNames[i],
                Duration = 3
            })

            local success, err = pcall(function()
                loadstring(game:HttpGet(scriptUrls[i], true))()
            end)

            if not success then
                Rayfield:Notify({
                    Title = "❌ Error",
                    Content = "Error:\n"..tostring(err),
                    Duration = 6
                })
            end
        end
    })
end