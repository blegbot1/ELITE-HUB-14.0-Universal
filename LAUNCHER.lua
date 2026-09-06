-- ELITE HUB 14.0 LAUNCHER (with kotik image from GitHub)
-- Drag once -> moves to top-left. Click -> loads hub.

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

local btn = Instance.new("ImageButton")
btn.Name = "KolkaBtn"
btn.Size = UDim2.new(0, 90, 0, 90)
btn.Position = UDim2.new(0.5, -45, 0.5, -45)
btn.BackgroundColor3 = Color3.fromRGB(30, 15, 45)
btn.BorderSizePixel = 0
btn.AutoButtonColor = false
btn.ScaleType = Enum.ScaleType.Fit
btn.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = btn

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200, 50, 200)
stroke.Thickness = 2.5
stroke.Transparency = 0.2
stroke.Parent = btn

local glow = Instance.new("ImageLabel")
glow.Name = "Glow"
glow.Size = UDim2.new(1, 30, 1, 30)
glow.Position = UDim2.new(0, -15, 0, -15)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5028857084"
glow.ImageColor3 = Color3.fromRGB(200, 50, 200)
glow.ImageTransparency = 0.6
glow.ScaleType = Enum.ScaleType.Fit
glow.ZIndex = 0
glow.Parent = btn

local function loadImage()
    local asset
    if getgenv().ELITE_HUB_KotikAsset then
        asset = getgenv().ELITE_HUB_KotikAsset
    elseif isfile and isfile(IMAGE_FILE) then
        asset = getcustomasset(IMAGE_FILE)
        getgenv().ELITE_HUB_KotikAsset = asset
    else
        local ok, data = pcall(function()
            if http_request then
                return http_request({Url = IMAGE_URL, Method = "GET"})
            elseif request then
                return request({Url = IMAGE_URL, Method = "GET"})
            end
        end)
        if ok and data and data.Body then
            writefile(IMAGE_FILE, data.Body)
            asset = getcustomasset(IMAGE_FILE)
            getgenv().ELITE_HUB_KotikAsset = asset
        else
            warn("[KOLKA] Image download failed, using placeholder")
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 200)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "KOLKA"
            lbl.TextColor3 = Color3.new(1, 1, 1)
            lbl.TextSize = 18
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextStrokeTransparency = 0.5
            lbl.Parent = btn
            return
        end
    end
    btn.Image = asset
end

loadImage()

local dragging = false
local dragStart, startPos
local movedToCorner = false

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
        if not movedToCorner then
            movedToCorner = true
            TweenService:Create(btn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 12, 0, 12),
                Size = UDim2.new(0, 60, 0, 60)
            }):Play()
        end
    end
end)

btn.MouseEnter:Connect(function()
    local sz = movedToCorner and 65 or 95
    TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, sz, 0, sz)}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0, Thickness = 3.5}):Play()
end)

btn.MouseLeave:Connect(function()
    local sz = movedToCorner and 60 or 90
    TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, sz, 0, sz)}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.2, Thickness = 2.5}):Play()
end)

btn.MouseButton1Click:Connect(function()
    local origSize = btn.Size
    TweenService:Create(btn, TweenInfo.new(0.08), {
        Size = UDim2.new(0, origSize.X.Offset * 0.8, 0, origSize.Y.Offset * 0.8)
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

task.spawn(function()
    while gui.Parent do
        TweenService:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.7
        }):Play()
        task.wait(1.2)
        TweenService:Create(stroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.1
        }):Play()
        task.wait(1.2)
    end
end)

print("[KOLKA] Ready!")
