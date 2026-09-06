-- ELITE HUB 14.0 LAUNCHER v2
-- Square button with kotik photo, stays where you put it

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local HUB_URL = "https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/main/ELITE_HUB_14.0.lua"
local IMAGE_URL = "https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/main/launcher/kotik.jpg"
local IMAGE_FILE = "elitehub_kotik.jpg"

local gui = Instance.new("ScreenGui")
gui.Name = "KOLKA_Launcher"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- SQUARE button, no corner rounding
local btn = Instance.new("ImageButton")
btn.Name = "KolkaBtn"
btn.Size = UDim2.new(0, 90, 0, 90)
btn.Position = UDim2.new(0.5, -45, 0.5, -45)
btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundTransparency = 0
btn.BorderSizePixel = 0
btn.AutoButtonColor = false
btn.ScaleType = Enum.ScaleType.Fit
btn.Image = ""
btn.Parent = gui

-- SQUARE corners (no rounding)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 0)
corner.Parent = btn

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200, 50, 200)
stroke.Thickness = 2
stroke.Transparency = 0.2
stroke.Parent = btn

-- Load image from GitHub
local function loadImage()
    if getgenv().ELITE_HUB_KotikAsset then
        btn.Image = getgenv().ELITE_HUB_KotikAsset
        return true
    end
    
    local hasFiles = type(isfile) == "function" and type(writefile) == "function" and type(getcustomasset) == "function"
    
    if hasFiles and isfile(IMAGE_FILE) then
        local asset = getcustomasset(IMAGE_FILE)
        btn.Image = asset
        getgenv().ELITE_HUB_KotikAsset = asset
        return true
    end
    
    local hasRequest = type(request) == "function" or type(http_request) == "function"
    if not hasRequest then
        warn("[KOLKA] No request function available")
        return false
    end
    
    print("[KOLKA] Downloading kotik image...")
    local ok, data = pcall(function()
        if http_request then
            return http_request({Url = IMAGE_URL, Method = "GET"})
        else
            return request({Url = IMAGE_URL, Method = "GET"})
        end
    end)
    
    if ok and data and data.Body and #data.Body > 100 then
        if hasFiles then
            writefile(IMAGE_FILE, data.Body)
        end
        local asset = getcustomasset(IMAGE_FILE)
        btn.Image = asset
        getgenv().ELITE_HUB_KotikAsset = asset
        print("[KOLKA] Image loaded!")
        return true
    else
        warn("[KOLKA] Image download failed")
        return false
    end
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

-- DRAGGING (stays where you drop it, no auto-move)
local dragging = false
local dragStart, startPos

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
    end
end)

btn.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

btn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- HOVER
btn.MouseEnter:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.12), {
        Size = UDim2.new(0, 96, 0, 96),
        Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset - 3, btn.Position.Y.Scale, btn.Position.Y.Offset - 3)
    }):Play()
    TweenService:Create(stroke, TweenInfo.new(0.12), {Transparency = 0, Thickness = 3}):Play()
end)

btn.MouseLeave:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.12), {
        Size = UDim2.new(0, 90, 0, 90),
        Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset + 3, btn.Position.Y.Scale, btn.Position.Y.Offset + 3)
    }):Play()
    TweenService:Create(stroke, TweenInfo.new(0.12), {Transparency = 0.2, Thickness = 2}):Play()
end)

-- CLICK -> load hub
btn.MouseButton1Click:Connect(function()
    if dragging then return end
    
    local origSize = btn.Size
    TweenService:Create(btn, TweenInfo.new(0.08), {
        Size = UDim2.new(0, 78, 0, 78)
    }):Play()
    task.wait(0.08)
    TweenService:Create(btn, TweenInfo.new(0.08), {Size = origSize}):Play()

    print("[KOLKA] Loading ELITE HUB 14.0...")
    local ok, src = pcall(function()
        return game:HttpGet(HUB_URL)
    end)
    if ok and src then
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

-- PULSE
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
