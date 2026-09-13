local _g = getgenv
local Window = _g().ELITE_HUB_Window
local MT = Window

local OVERLAY_BASE = "https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/main/overlays/"

local OVERLAY_FILES = {
    { name = "Kotik Big",      file = "kotik_big.png",    type = "image" },
    { name = "Smysl Zhizni",   file = "smysl_zhizni.jpg", type = "image" },
    { name = "Vranie",         file = "vranie.jpg",       type = "image" },
    { name = "Sobaka Kot",     file = "sobaka_kot.jpg",   type = "image" },
    { name = "Epstein",        file = "epstein.jpg",      type = "image" },
    { name = "Femboy",         file = "femboy.mp4",       type = "video" },
    { name = "Femboy Love",    file = "femboy_love.mp4",  type = "video" },
}

local overlayGui = nil
local overlayFrame = nil
local overlayVideo = nil
local overlayImage = nil
local overlaySound = nil
local currentFile = nil
local dragging = false
local dragStart, startPos

local function downloadFile(filename)
    pcall(function() makefolder("elitehub") end)
    local path = "elitehub/" .. filename
    if isfile(path) then return path end
    local url = OVERLAY_BASE .. filename
    local body = game:HttpGet(url, true)
    if not body or #body < 100 then return nil end
    writefile(path, body)
    task.wait(0.3)
    return path
end

local function removeOverlay()
    if overlayVideo then
        pcall(function() overlayVideo:Stop() end)
        overlayVideo = nil
    end
    if overlayImage then
        overlayImage = nil
    end
    if overlaySound then
        pcall(function() overlaySound:Stop() end)
        pcall(function() overlaySound:Destroy() end)
        overlaySound = nil
    end
    if overlayFrame then
        overlayFrame:Destroy()
        overlayFrame = nil
    end
    if overlayGui then
        overlayGui:Destroy()
        overlayGui = nil
    end
    currentFile = nil
end

local function createOverlayGui()
    if overlayGui then return end
    overlayGui = Instance.new("ScreenGui")
    overlayGui.Name = "EliteHubOverlay"
    overlayGui.ResetOnSpawn = false
    overlayGui.DisplayOrder = 999
    overlayGui.Parent = _g().ELITE_HUB_Player:WaitForChild("PlayerGui")

    overlayFrame = Instance.new("Frame")
    overlayFrame.Size = UDim2.new(0, 200, 0, 200)
    overlayFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
    overlayFrame.BackgroundTransparency = 1
    overlayFrame.Parent = overlayGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = overlayFrame

    overlayFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = overlayFrame.Position
        end
    end)
    overlayFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    _g().ELITE_HUB_Player:WaitForChild("PlayerGui").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            overlayFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function showOverlay(entry)
    removeOverlay()
    if not entry then return end
    currentFile = entry

    local path = downloadFile(entry.file)
    if not path then return end

    local asset = getcustomasset(path)
    if not asset then return end

    createOverlayGui()

    if entry.type == "video" then
        overlayVideo = Instance.new("VideoFrame")
        overlayVideo.Size = UDim2.new(1, 0, 1, 0)
        overlayVideo.BackgroundTransparency = 1
        overlayVideo.Video = asset
        overlayVideo.Looped = true
        overlayVideo.Parent = overlayFrame
        overlayVideo:Play()

        overlaySound = Instance.new("Sound")
        overlaySound.SoundId = asset
        overlaySound.Looped = true
        overlaySound.Volume = _g().ELITE_HUB_OverlaySoundVol or 0.5
        overlaySound.Parent = game:GetService("SoundService")
        overlaySound:Play()
        _g().ELITE_HUB_OverlaySoundPlaying = true
    else
        overlayImage = Instance.new("ImageLabel")
        overlayImage.Size = UDim2.new(1, 0, 1, 0)
        overlayImage.BackgroundTransparency = 1
        overlayImage.Image = asset
        overlayImage.ScaleType = Enum.ScaleType.Fit
        overlayImage.Parent = overlayFrame
    end
end

_g().ELITE_HUB_OverlaySoundVol = 0.5
_g().ELITE_HUB_OverlaySoundPlaying = false
_g().ELITE_HUB_OverlaySize = 200

local OverlaySection = MT:CreateSection("🎬 OVERLAY")

local overlayDropdown = MT:CreateDropdown({
    Name = " Select Overlay",
    Options = (function() local o = {"None"} for _, v in ipairs(OVERLAY_FILES) do table.insert(o, v.name) end return o end)(),
    CurrentOption = {"None"},
    MultipleOptions = false,
    Callback = function(opt)
        local choice = (typeof(opt) == "table" and opt[1]) or opt or "None"
        if choice == "None" then
            removeOverlay()
            return
        end
        for _, entry in ipairs(OVERLAY_FILES) do
            if entry.name == choice then
                showOverlay(entry)
                return
            end
        end
    end
})

MT:CreateSlider({
    Name = " Overlay Size",
    Range = {50, 600},
    Increment = 10,
    CurrentValue = 200,
    Callback = function(value)
        _g().ELITE_HUB_OverlaySize = value
        if overlayFrame then
            overlayFrame.Size = UDim2.new(0, value, 0, value)
        end
    end
})

MT:CreateToggle({
    Name = " Sound On/Off",
    CurrentValue = false,
    Callback = function(value)
        if overlaySound then
            if value then
                pcall(function() overlaySound:Play() end)
                _g().ELITE_HUB_OverlaySoundPlaying = true
            else
                pcall(function() overlaySound:Stop() end)
                _g().ELITE_HUB_OverlaySoundPlaying = false
            end
        end
    end
})

MT:CreateSlider({
    Name = " Sound Volume",
    Range = {0, 10},
    Increment = 0.5,
    CurrentValue = 0.5,
    Callback = function(value)
        _g().ELITE_HUB_OverlaySoundVol = value
        if overlaySound then
            overlaySound.Volume = value
        end
    end
})
