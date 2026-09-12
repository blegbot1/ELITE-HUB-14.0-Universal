-- ELITE HUB 14.0 LAUNCHER v6
-- Downloads modules + hub from GitHub, caches locally

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local BASE_URL = "https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/main/"
local HUB_URL = BASE_URL .. "ELITE_HUB_14.0.lua?v=mono7"
local IMAGE_URL = BASE_URL .. "launcher/kotik.jpg"
local IMAGE_FILE = "elitehub_kotik.jpg"

local MODULES = {
    "modules/ui_library.lua",
    "modules/overlay.lua",
    "modules/hubs.lua",
    "modules/fe_scripts.lua",
    "modules/game_scripts.lua",
    "modules/main.lua",
    "modules/aimbot.lua",
    "modules/esp.lua",
    "modules/chams.lua",
    "modules/players.lua",
    "modules/teleport.lua",
    "modules/kill_all.lua",
    "modules/visual.lua",
    "modules/visual_plus.lua",
    "modules/environment.lua",
    "modules/movement.lua",
    "modules/combat_plus.lua",
    "modules/camera.lua",
    "modules/utilities.lua",
    "modules/music.lua",
    "modules/range.lua",
    "modules/item_finder.lua",
    "modules/settings.lua",
    "modules/anti_fling.lua",
    "modules/watchdog.lua",
}

local function ensureFile(path)
    local okRead = pcall(function() return isfile(path) end)
    if okRead and isfile(path) then
        local okTest, testContent = pcall(function() return readfile(path) end)
        if okTest and testContent and #testContent > 100 then return true end
    end
    local ok, raw = pcall(function() return game:HttpGet(BASE_URL .. path, true) end)
    if not ok or not raw then return false end
    local body = raw
    if type(raw) == "table" then
        body = raw.Body or raw.body or ""
    end
    if type(body) ~= "string" or #body < 100 then return false end
    pcall(function() writefile(path, body) end)
    return true
end

local gui = Instance.new("ScreenGui")
gui.Name = "KOLKA_Launcher"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("ImageButton")
btn.Name = "KolkaBtn"
btn.Size = UDim2.new(0, 90, 0, 90)
btn.Position = UDim2.new(0.5, -45, 0.5, -45)
btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundTransparency = 0
btn.BorderSizePixel = 0
btn.AutoButtonColor = false
btn.ScaleType = Enum.ScaleType.Stretch
btn.Image = ""
btn.Parent = gui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200, 50, 200)
stroke.Thickness = 2
stroke.Transparency = 0.2
stroke.Parent = btn

local function loadImage()
    if getgenv().ELITE_HUB_KotikAsset then
        btn.Image = getgenv().ELITE_HUB_KotikAsset
        return true
    end

    local ok1, f1 = pcall(function() return type(isfile) == "function" end)
    local ok2, f2 = pcall(function() return type(writefile) == "function" end)
    local ok3, f3 = pcall(function() return type(getcustomasset) == "function" end)
    local hasFiles = ok1 and f1 and ok2 and f2 and ok3 and f3

    if hasFiles then
        local okExist, exists = pcall(function() return isfile(IMAGE_FILE) end)
        if okExist and exists then
            local okAsset, asset = pcall(function() return getcustomasset(IMAGE_FILE) end)
            if okAsset and asset then
                btn.Image = asset
                getgenv().ELITE_HUB_KotikAsset = asset
                print("[KOLKA] Image from cache!")
                return true
            end
        end
    end

    local hasReq = false
    pcall(function()
        if type(request) == "function" or type(http_request) == "function" then
            hasReq = true
        end
    end)
    if not hasReq then
        warn("[KOLKA] No HTTP function")
        return false
    end

    print("[KOLKA] Downloading kotik...")
    local ok, data = pcall(function()
        if type(http_request) == "function" then
            return http_request({Url = IMAGE_URL, Method = "GET"})
        else
            return request({Url = IMAGE_URL, Method = "GET"})
        end
    end)

    if ok and data and data.Body and #data.Body > 50 then
        if hasFiles then
            pcall(function() writefile(IMAGE_FILE, data.Body) end)
        end
        local okAsset, asset = pcall(function() return getcustomasset(IMAGE_FILE) end)
        if okAsset and asset then
            btn.Image = asset
            getgenv().ELITE_HUB_KotikAsset = asset
            print("[KOLKA] Image loaded! Size: " .. #data.Body)
            return true
        end
    end

    warn("[KOLKA] Image failed: " .. tostring(data and data.StatusCode or "no data"))
    return false
end

local hasImage = loadImage()

if not hasImage then
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 200)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "KOLKA"
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextSize = 20
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextStrokeTransparency = 0.3
    lbl.Parent = btn
end

local dragging = false
local dragStartPos = nil
local startPosBtn = nil
local hasDragged = false

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        hasDragged = false
        dragStartPos = input.Position
        startPosBtn = btn.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local dx = input.Position.X - dragStartPos.X
        local dy = input.Position.Y - dragStartPos.Y
        if math.abs(dx) > 3 or math.abs(dy) > 3 then
            hasDragged = true
        end
        btn.Position = UDim2.new(
            startPosBtn.X.Scale, startPosBtn.X.Offset + dx,
            startPosBtn.Y.Scale, startPosBtn.Y.Offset + dy
        )
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

btn.MouseEnter:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.15), {
        Size = UDim2.new(0, 96, 0, 96),
        Position = UDim2.new(
            btn.Position.X.Scale, btn.Position.X.Offset - 3,
            btn.Position.Y.Scale, btn.Position.Y.Offset - 3
        )
    }):Play()
    TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0, Thickness = 3}):Play()
end)

btn.MouseLeave:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.15), {
        Size = UDim2.new(0, 90, 0, 90),
        Position = UDim2.new(
            btn.Position.X.Scale, btn.Position.X.Offset + 3,
            btn.Position.Y.Scale, btn.Position.Y.Offset + 3
        )
    }):Play()
    TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.2, Thickness = 2}):Play()
end)

btn.MouseButton1Click:Connect(function()
    if hasDragged then return end

    TweenService:Create(btn, TweenInfo.new(0.06), {
        Size = UDim2.new(0, 78, 0, 78)
    }):Play()
    task.wait(0.06)
    TweenService:Create(btn, TweenInfo.new(0.06), {
        Size = UDim2.new(0, 90, 0, 90)
    }):Play()

    print("[KOLKA] Downloading modules...")
    pcall(function() makefolder("modules") end)
    local failCount = 0
    for _, mod in ipairs(MODULES) do
        if not ensureFile(mod) then
            warn("[KOLKA] FAIL: " .. mod)
            failCount = failCount + 1
        end
    end
    print("[KOLKA] Modules done. Failed: " .. failCount .. "/" .. #MODULES)

    print("[KOLKA] Loading ELITE HUB 14.0...")
    local ok, raw = pcall(function()
        return game:HttpGet(HUB_URL)
    end)
    if ok and raw then
        local src = raw
        if type(raw) == "table" then src = raw.Body or raw.body or "" end
        local fn, err = loadstring(src)
        if fn then
            fn()
            print("[KOLKA] Hub loaded!")
            task.delay(1, function()
                gui:Destroy()
            end)
        else
            warn("[KOLKA] Compile error: " .. tostring(err))
        end
    else
        warn("[KOLKA] Download failed")
    end
end)

task.spawn(function()
    while gui.Parent do
        TweenService:Create(stroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.7
        }):Play()
        task.wait(1)
        TweenService:Create(stroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.1
        }):Play()
        task.wait(1)
    end
end)

print("[KOLKA] Launcher ready!")
