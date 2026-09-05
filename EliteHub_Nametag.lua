-- EliteHub Nametag - Multi Method Test
-- Тестирует 6 способов кросс-клиент детекции
-- Запуск: loadstring(game:HttpGet("https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/refs/heads/main/EliteHub_Nametag.lua"))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")

local METHODS = {}

-- ═══════════════════════════════════════════════════════════════
-- METHOD 1: SetAttribute on Player
-- ═══════════════════════════════════════════════════════════════
METHODS[1] = function()
    local ok, err = pcall(function()
        player:SetAttribute("EliteHubTest1", true)
    end)
    if ok then
        local val = player:GetAttribute("EliteHubTest1")
        return val == true, "SetAttribute on Player works (value=" .. tostring(val) .. ")"
    else
        return false, "SetAttribute on Player FAILED: " .. tostring(err)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- METHOD 2: SetAttribute on Character
-- ═══════════════════════════════════════════════════════════════
METHODS[2] = function()
    local ok, err = pcall(function()
        local char = player.Character
        if char then char:SetAttribute("EliteHubTest2", true) end
    end)
    if ok then
        local char = player.Character
        local val = char and char:GetAttribute("EliteHubTest2")
        return val == true, "SetAttribute on Character works (value=" .. tostring(val) .. ")"
    else
        return false, "SetAttribute on Character FAILED: " .. tostring(err)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- METHOD 3: CollectionService tag on Player
-- ═══════════════════════════════════════════════════════════════
METHODS[3] = function()
    local ok, err = pcall(function()
        CS:AddTag(player, "EliteHubTest3")
    end)
    if ok then
        local has = CS:HasTag(player, "EliteHubTest3")
        return has, "CollectionService tag on Player works (has=" .. tostring(has) .. ")"
    else
        return false, "CollectionService tag on Player FAILED: " .. tostring(err)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- METHOD 4: StringValue in ReplicatedStorage
-- ═══════════════════════════════════════════════════════════════
METHODS[4] = function()
    local ok, err = pcall(function()
        local sv = Instance.new("StringValue")
        sv.Name = "EliteHubTest4_" .. player.Name
        sv.Value = player.Name
        sv.Parent = RS
    end)
    if ok then
        local exists = RS:FindFirstChild("EliteHubTest4_" .. player.Name)
        return exists ~= nil, "ReplicatedStorage StringValue works (exists=" .. tostring(exists ~= nil) .. ")"
    else
        return false, "ReplicatedStorage StringValue FAILED: " .. tostring(err)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- METHOD 5: StringValue in Workspace
-- ═══════════════════════════════════════════════════════════════
METHODS[5] = function()
    local ok, err = pcall(function()
        local sv = Instance.new("StringValue")
        sv.Name = "EliteHubTest5_" .. player.Name
        sv.Value = player.Name
        sv.Parent = workspace
    end)
    if ok then
        local exists = workspace:FindFirstChild("EliteHubTest5_" .. player.Name)
        return exists ~= nil, "Workspace StringValue works (exists=" .. tostring(exists ~= nil) .. ")"
    else
        return false, "Workspace StringValue FAILED: " .. tostring(err)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- METHOD 6: BoolValue in Folder in ReplicatedStorage
-- ═══════════════════════════════════════════════════════════════
METHODS[6] = function()
    local ok, err = pcall(function()
        local folder = RS:FindFirstChild("EliteHubTest6")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "EliteHubTest6"
            folder.Parent = RS
        end
        local bv = Instance.new("BoolValue")
        bv.Name = player.Name
        bv.Value = true
        bv.Parent = folder
    end)
    if ok then
        local folder = RS:FindFirstChild("EliteHubTest6")
        local exists = folder and folder:FindFirstChild(player.Name)
        return exists ~= nil, "RS Folder BoolValue works (exists=" .. tostring(exists ~= nil) .. ")"
    else
        return false, "RS Folder BoolValue FAILED: " .. tostring(err)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- RUN ALL TESTS
-- ═══════════════════════════════════════════════════════════════
warn("========================================")
warn("[ELITE HUB] METHOD TEST START - Player: " .. player.Name)
warn("========================================")

for i, testFn in ipairs(METHODS) do
    local success, result = pcall(testFn)
    if success then
        local works, msg = result
        if works then
            warn("[METHOD " .. i .. "] ✅ WORKS: " .. msg)
        else
            warn("[METHOD " .. i .. "] ❌ BROKEN: " .. msg)
        end
    else
        warn("[METHOD " .. i .. "] 💥 CRASHED: " .. tostring(result))
    end
end

warn("========================================")
warn("[ELITE HUB] TEST COMPLETE")
warn("========================================")

-- Ждём 5 секунд и проверяем какие объекты видим от других игроков
task.wait(5)
warn("[ELITE HUB] Checking what OTHER players created...")

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then
        -- Проверяем все методы на других игроках
        local m1 = p:GetAttribute("EliteHubTest1")
        local m2 = p.Character and p.Character:GetAttribute("EliteHubTest2")
        local m3 = CS:HasTag(p, "EliteHubTest3")
        local m4 = RS:FindFirstChild("EliteHubTest4_" .. p.Name)
        local m5 = workspace:FindFirstChild("EliteHubTest5_" .. p.Name)
        local m6 = RS:FindFirstChild("EliteHubTest6") and RS:FindFirstChild("EliteHubTest6"):FindFirstChild(p.Name)

        warn("[OTHER PLAYER: " .. p.Name .. "]")
        warn("  Method 1 (Attr Player): " .. tostring(m1))
        warn("  Method 2 (Attr Char):   " .. tostring(m2))
        warn("  Method 3 (CS Tag):      " .. tostring(m3))
        warn("  Method 4 (RS String):   " .. tostring(m4))
        warn("  Method 5 (WS String):   " .. tostring(m5))
        warn("  Method 6 (RS Folder):   " .. tostring(m6))
    end
end
