local _g = getgenv
local Rayfield = _g().ELITE_HUB_Rayfield
local Window = _g().ELITE_HUB_Window
local ES = _g().EliteHubSettings
local L = _g().ELITE_HUB_L
local Log = _g().ELITE_HUB_Log
local Players = _g().ELITE_HUB_Players
local player = _g().ELITE_HUB_Player
local SafeNotify = _g().ELITE_HUB_SafeNotify
local DestroyScript = _g().ELITE_HUB_DestroyScript
local RunService = game:GetService("RunService")
local MT = Window

do
    local AF_ENABLED = true
    local AF_VELOCITY_THRESHOLD = 100
    local AF_ANGULAR_THRESHOLD = 15
    local AF_DETECT_RADIUS = 50
    local AF_CHECK_INTERVAL = 0.1
    local afConn = nil
    local afAnchorConn = nil
    local afLastPositions = {}
    local afFlingers = {}
    local afAnchorPart = nil

    local function getCharacterParts()
        local ch = player.Character
        if not ch then return nil, nil, nil end
        return ch, ch:FindFirstChild("HumanoidRootPart"), ch:FindFirstChildOfClass("Humanoid")
    end

    local function isFlinging(otherPlayer)
        local otherChar = otherPlayer.Character
        if not otherChar then return false end
        local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
        local otherHum = otherChar:FindFirstChildOfClass("Humanoid")
        if not otherRoot or not otherHum then return false end
        if otherHum.Health <= 0 then return false end

        local vel = otherRoot.Velocity
        local angVel = otherRoot.RotVelocity
        local speed = vel.Magnitude
        local angSpeed = angVel.Magnitude

        if speed > AF_VELOCITY_THRESHOLD then return true end
        if angSpeed > AF_ANGULAR_THRESHOLD then return true end

        local prevPos = afLastPositions[otherPlayer]
        if prevPos then
            local moved = (otherRoot.Position - prevPos).Magnitude
            if moved > 100 then return true end
        end
        afLastPositions[otherPlayer] = otherRoot.Position
        return false
    end

    local function isApproaching(otherPlayer)
        local ch, rootPart, _ = getCharacterParts()
        if not rootPart then return false end
        local otherChar = otherPlayer.Character
        if not otherChar then return false end
        local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
        if not otherRoot then return false end

        local dist = (otherRoot.Position - rootPart.Position).Magnitude
        if dist > AF_DETECT_RADIUS then return false end

        local dir = (rootPart.Position - otherRoot.Position).Unit
        local velDir = otherRoot.Velocity.Unit
        local dot = dir:Dot(velDir)
        return dot > 0.7 and otherRoot.Velocity.Magnitude > 80
    end

    local function createAnchorPart()
        if afAnchorPart and afAnchorPart.Parent then return afAnchorPart end
        local ch, rootPart, _ = getCharacterParts()
        if not rootPart then return nil end

        local anchor = Instance.new("Part")
        anchor.Name = "EliteHubAntiFlingAnchor"
        anchor.Size = Vector3.new(0.1, 0.1, 0.1)
        anchor.Transparency = 1
        anchor.Anchored = true
        anchor.CanCollide = false
        anchor.Position = rootPart.Position
        anchor.Parent = workspace
        afAnchorPart = anchor
        return anchor
    end

    local function removeAnchorPart()
        if afAnchorPart then
            pcall(function() afAnchorPart:Destroy() end)
            afAnchorPart = nil
        end
    end

    local function anchorLocalPlayer()
        local ch, rootPart, hum = getCharacterParts()
        if not rootPart or not hum then return end

        local anchor = createAnchorPart()
        if not anchor then return end

        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.RotVelocity = Vector3.new(0, 0, 0)
        anchor.Position = rootPart.Position
        rootPart.CFrame = anchor.CFrame
    end

    local function unanchorLocalPlayer()
        removeAnchorPart()
    end

    local function handleFlingerDetected(otherPlayer)
        if afFlingers[otherPlayer] then return end
        afFlingers[otherPlayer] = true

        pcall(function()
            SafeNotify("ANTI-FLING", otherPlayer.Name .. " fling detected!", 2, "AntiFling")
        end)

        anchorLocalPlayer()

        task.delay(1.5, function()
            unanchorLocalPlayer()
            afFlingers[otherPlayer] = nil
        end)
    end

    local function checkNearbyFlingers()
        local ch, rootPart, _ = getCharacterParts()
        if not rootPart then return end

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                if isFlinging(otherPlayer) and isApproaching(otherPlayer) then
                    handleFlingerDetected(otherPlayer)
                    return
                end
            end
        end
    end

    local function startAntiFling()
        if afConn then return end

        afConn = RunService.Heartbeat:Connect(function(dt)
            if not AF_ENABLED then return end
            pcall(checkNearbyFlingers)
        end)

        afAnchorConn = RunService.Stepped:Connect(function()
            if not AF_ENABLED then return end
            pcall(function()
                local ch, rootPart, hum = getCharacterParts()
                if not rootPart or not hum then return end
                if hum.Health <= 0 then return end

                if afAnchorPart and afAnchorPart.Parent then
                    rootPart.Velocity = Vector3.new(0, 0, 0)
                    rootPart.RotVelocity = Vector3.new(0, 0, 0)
                    afAnchorPart.Position = rootPart.Position
                end
            end)
        end)
    end

    local function stopAntiFling()
        if afConn then
            afConn:Disconnect()
            afConn = nil
        end
        if afAnchorConn then
            afAnchorConn:Disconnect()
            afAnchorConn = nil
        end
        afLastPositions = {}
        afFlingers = {}
        removeAnchorPart()
    end

    startAntiFling()
    getgenv().ELITE_HUB_AntiFling = true

    player.CharacterAdded:Connect(function()
        task.wait(1)
        if AF_ENABLED then
            afLastPositions = {}
            afFlingers = {}
        end
    end)

    MT:CreateSection("🛡 ANTI-FLING")
    MT:CreateToggle({
        Name = " Anti-Fling (auto ON)",
        CurrentValue = true,
        Callback = function(value)
            AF_ENABLED = value
            getgenv().ELITE_HUB_AntiFling = value
            if value then
                startAntiFling()
                SafeNotify("ANTI-FLING", "ON", 1.5, "AntiFling")
            else
                stopAntiFling()
                SafeNotify("ANTI-FLING", "OFF", 1.5, "AntiFling")
            end
        end
    })
    MT:CreateSlider({
        Name = " Velocity threshold",
        Range = {50, 500},
        Increment = 10,
        CurrentValue = AF_VELOCITY_THRESHOLD,
        Callback = function(value)
            AF_VELOCITY_THRESHOLD = value
        end
    })
    MT:CreateSlider({
        Name = " Detection radius",
        Range = {10, 200},
        Increment = 5,
        CurrentValue = AF_DETECT_RADIUS,
        Callback = function(value)
            AF_DETECT_RADIUS = value
        end
    })
end
