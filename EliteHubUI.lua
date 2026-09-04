-- EliteHubUI.lua — Custom UI library in mini-menu style
-- Dark purple theme with tabs, buttons, toggles, sliders, inputs, dropdowns, color pickers

local EliteHubUI = {}
EliteHubUI.__index = EliteHubUI

local TweenService = game:GetService("TweenService")

-- Colors (same as mini menu)
local C = {
    BG = Color3.fromRGB(16, 11, 30),
    BG2 = Color3.fromRGB(25, 18, 45),
    BG3 = Color3.fromRGB(60, 46, 94),
    Stroke = Color3.fromRGB(140, 60, 255),
    Title = Color3.fromRGB(205, 150, 255),
    Text = Color3.fromRGB(175, 175, 185),
    TextBright = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(150, 70, 255),
    AccentLight = Color3.fromRGB(190, 120, 255),
    Green = Color3.fromRGB(90, 215, 110),
    Red = Color3.fromRGB(255, 70, 80),
    Off = Color3.fromRGB(82, 82, 92),
    TabActive = Color3.fromRGB(58, 42, 95),
    TabInactive = Color3.fromRGB(28, 20, 48),
    ScrollBar = Color3.fromRGB(95, 60, 165),
    Field = Color3.fromRGB(46, 34, 76),
}

local function newCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
    return c
end

local function newStroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or C.Stroke
    s.Thickness = thickness or 1.5
    s.Transparency = trans or 0.35
    s.Parent = parent
    return s
end

local function newPadding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, t or 8)
    p.PaddingBottom = UDim.new(0, b or 8)
    p.PaddingLeft = UDim.new(0, l or 8)
    p.PaddingRight = UDim.new(0, r or 8)
    p.Parent = parent
    return p
end

local function newGradient(parent, colorA, colorB, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(colorA, colorB)
    if rotation then g.Rotation = rotation end
    g.Parent = parent
    return g
end

local function addScroll(frame)
    local sg = Instance.new("ScrollingFrame")
    sg.Name = "Scroll"
    sg.Parent = frame
    sg.Size = UDim2.new(1, 0, 1, 0)
    sg.Position = UDim2.new(0, 0, 0, 0)
    sg.BackgroundTransparency = 1
    sg.ScrollBarThickness = 4
    sg.ScrollBarImageColor3 = C.ScrollBar
    sg.BorderSizePixel = 0
    sg.ScrollingDirection = Enum.ScrollingDirection.Y
    sg.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local list = Instance.new("UIListLayout")
    list.Parent = sg
    list.Padding = UDim.new(0, 5)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    newPadding(sg, 8, 8, 10, 10)
    return sg
end

-- ==================== WINDOW ====================
function EliteHubUI:CreateWindow(config)
    local self = setmetatable({}, EliteHubUI)
    self._tabs = {}
    self._tabButtons = {}
    self._tabFrames = {}
    self._tabRegistry = {}
    self._currentTab = nil
    self._popups = {}
    self._translatables = {}

    local player = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "EliteHubUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    gui.Parent = player:WaitForChild("PlayerGui")
    self._gui = gui

    -- Main frame
    local W, H = 640, 480
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Parent = gui
    main.Size = UDim2.new(0, W, 0, H)
    main.Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2)
    main.BackgroundColor3 = C.BG
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.ClipsDescendants = true
    newCorner(main, 14)
    newStroke(main, C.Stroke, 2, 0.25)
    newGradient(main, Color3.fromRGB(22, 15, 42), C.BG, 90)
    self._main = main

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = main
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = C.BG2
    titleBar.BorderSizePixel = 0
    newCorner(titleBar, 14)

    local titleAccent = Instance.new("Frame")
    titleAccent.Parent = titleBar
    titleAccent.Size = UDim2.new(1, 0, 0, 2)
    titleAccent.Position = UDim2.new(0, 0, 1, -2)
    titleAccent.BackgroundColor3 = C.Accent
    titleAccent.BorderSizePixel = 0

    local titleGlow = Instance.new("Frame")
    titleGlow.Parent = titleAccent
    titleGlow.Size = UDim2.new(0, 120, 1, 0)
    titleGlow.Position = UDim2.new(0, 0, 0, 0)
    titleGlow.BackgroundColor3 = C.AccentLight
    titleGlow.BorderSizePixel = 0

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = titleBar
    titleLabel.Size = UDim2.new(1, -90, 1, -6)
    titleLabel.Position = UDim2.new(0, 16, 0, 3)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Name or "ELITE HUB"
    titleLabel.TextColor3 = C.Title
    titleLabel.TextSize = 15
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -32, 0, 8)
    closeBtn.BackgroundColor3 = C.Red
    closeBtn.Text = "X"
    closeBtn.TextColor3 = C.TextBright
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    newCorner(closeBtn, 12)

    -- Minimize button
    local minBtn = Instance.new("TextButton")
    minBtn.Parent = titleBar
    minBtn.Size = UDim2.new(0, 24, 0, 24)
    minBtn.Position = UDim2.new(1, -62, 0, 8)
    minBtn.BackgroundColor3 = Color3.fromRGB(210, 170, 50)
    minBtn.Text = "-"
    minBtn.TextColor3 = C.TextBright
    minBtn.TextSize = 13
    minBtn.Font = Enum.Font.GothamBold
    minBtn.BorderSizePixel = 0
    newCorner(minBtn, 12)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            main:TweenSize(UDim2.new(0, W, 0, 40), "Out", "Quad", 0.15, true)
        else
            main:TweenSize(UDim2.new(0, W, 0, H), "Out", "Quad", 0.15, true)
        end
    end)
    minBtn.MouseEnter:Connect(function()
        minBtn.BackgroundColor3 = Color3.fromRGB(235, 190, 70)
    end)
    minBtn.MouseLeave:Connect(function()
        minBtn.BackgroundColor3 = Color3.fromRGB(210, 170, 50)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 105)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = C.Red
    end)

    -- Tab sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = main
    sidebar.Size = UDim2.new(0, 158, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = C.BG2
    sidebar.BorderSizePixel = 0
    newCorner(sidebar, 0)
    newGradient(sidebar, C.BG2, Color3.fromRGB(20, 14, 38), 180)

    local sideDivider = Instance.new("Frame")
    sideDivider.Parent = sidebar
    sideDivider.Size = UDim2.new(0, 1, 1, 0)
    sideDivider.Position = UDim2.new(1, -1, 0, 0)
    sideDivider.BackgroundColor3 = C.Accent
    sideDivider.BorderSizePixel = 0
    sideDivider.BackgroundTransparency = 0.4

    local sideScroll = Instance.new("ScrollingFrame")
    sideScroll.Parent = sidebar
    sideScroll.Size = UDim2.new(1, 0, 1, 0)
    sideScroll.BackgroundTransparency = 1
    sideScroll.ScrollBarThickness = 3
    sideScroll.ScrollBarImageColor3 = C.ScrollBar
    sideScroll.BorderSizePixel = 0
    sideScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    sideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local sideList = Instance.new("UIListLayout")
    sideList.Parent = sideScroll
    sideList.Padding = UDim.new(0, 4)
    sideList.SortOrder = Enum.SortOrder.LayoutOrder
    newPadding(sideScroll, 6, 6, 6, 6)
    self._sideScroll = sideScroll

    -- Content area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Parent = main
    content.Size = UDim2.new(1, -158, 1, -40)
    content.Position = UDim2.new(0, 158, 0, 40)
    content.BackgroundColor3 = C.BG
    content.BorderSizePixel = 0
    newGradient(content, C.BG, Color3.fromRGB(14, 10, 26), 90)
    self._content = content

    gui.DisplayOrder = 998

    -- Reveal overlay: hides window until the old loading screen is gone, then fades out smoothly
    local reveal = Instance.new("Frame")
    reveal.Name = "Reveal"
    reveal.Parent = gui
    reveal.Size = UDim2.new(1, 0, 1, 0)
    reveal.Position = UDim2.new(0, 0, 0, 0)
    reveal.BackgroundColor3 = C.BG
    reveal.BorderSizePixel = 0
    reveal.ZIndex = 900

    task.spawn(function()
        local pg = player:WaitForChild("PlayerGui")
        local waited = 0
        while not pg:FindFirstChild("EliteHubLoader") and waited < 6 do
            task.wait(0.1)
            waited = waited + 0.1
        end
        while pg:FindFirstChild("EliteHubLoader") do
            task.wait(0.1)
        end
        if reveal and reveal.Parent then
            TweenService:Create(reveal, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
            task.wait(0.6)
            reveal:Destroy()
        end
    end)

    return self
end

-- ==================== TAB ====================
function EliteHubUI:CreateTab(name, icon)
    local tab = {}
    tab._order = 0
    tab._win = self

    -- Tab button in sidebar
    local btn = Instance.new("TextButton")
    btn.Parent = self._sideScroll
    btn.Size = UDim2.new(1, -4, 0, 32)
    btn.BackgroundColor3 = C.TabInactive
    btn.Text = "  " .. name
    btn.TextColor3 = C.Text
    btn.TextSize = 11.5
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.LayoutOrder = #self._tabs
    newCorner(btn, 7)

    local btnBar = Instance.new("Frame")
    btnBar.Name = "Bar"
    btnBar.Parent = btn
    btnBar.Size = UDim2.new(0, 3, 0.7, 0)
    btnBar.Position = UDim2.new(0, 2, 0.15, 0)
    btnBar.BackgroundColor3 = C.Accent
    btnBar.BorderSizePixel = 0
    btnBar.BackgroundTransparency = 1

    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Parent = btn
    indicator.BackgroundColor3 = C.Off
    indicator.Size = UDim2.new(0, 6, 0, 6)
    indicator.Position = UDim2.new(1, -12, 0.5, -3)
    indicator.BorderSizePixel = 0
    indicator.BackgroundTransparency = 0.5
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    -- Tab content frame
    local frame = Instance.new("Frame")
    frame.Name = tostring(name)
    frame.Parent = self._content
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.BorderSizePixel = 0
    local scroll = addScroll(frame)
    tab._scroll = scroll
    tab._frame = frame

    table.insert(self._tabs, tab)
    self._tabButtons[name] = btn
    self._tabFrames[name] = frame

    -- Click handler
    local function activate()
        if self._currentTab == name then return end        for _, f in pairs(self._tabFrames) do
            f.Visible = false
        end
        for _, b in pairs(self._tabButtons) do
            b.BackgroundColor3 = C.TabInactive
            b.Indicator.BackgroundColor3 = C.Off
            b.Indicator.BackgroundTransparency = 0.5
            b.Bar.BackgroundTransparency = 1
            b.TextColor3 = C.Text
        end
        frame.Visible = true
        btn.BackgroundColor3 = C.TabActive
        btn.Indicator.BackgroundColor3 = C.Accent
        btn.Indicator.BackgroundTransparency = 0
        btn.Bar.BackgroundTransparency = 0
        btn.TextColor3 = C.TextBright
        self._currentTab = name
        for _, p in ipairs(self._popups) do
            p.Visible = false
        end
    end

    btn.MouseButton1Click:Connect(activate)
    btn.MouseEnter:Connect(function()
        if self._currentTab ~= name then
            btn.BackgroundColor3 = C.BG3
        end
    end)
    btn.MouseLeave:Connect(function()
        if self._currentTab ~= name then
            btn.BackgroundColor3 = C.TabInactive
        else
            btn.BackgroundColor3 = C.TabActive
        end
    end)

    -- Store tab methods
    tab._self = self

    function tab:CreateSection(name)
        local s = Instance.new("Frame")
        s.Parent = scroll
        s.Size = UDim2.new(1, 0, 0, 28)
        s.BackgroundTransparency = 1
        s.LayoutOrder = tab._order
        tab._order = tab._order + 1

        local line = Instance.new("Frame")
        line.Parent = s
        line.Size = UDim2.new(0, 4, 0, 16)
        line.Position = UDim2.new(0, 0, 0.5, -8)
        line.BackgroundColor3 = C.Accent
        line.BorderSizePixel = 0
        newCorner(line, 2)

        local text = Instance.new("TextLabel")
        text.Parent = s
        text.Size = UDim2.new(1, -16, 1, 0)
        text.Position = UDim2.new(0, 12, 0, 0)
        text.BackgroundTransparency = 1
        text.Text = name
        text.TextColor3 = C.Title
        text.TextSize = 12.5
        text.Font = Enum.Font.GothamBlack
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.TextTruncate = Enum.TextTruncate.AtEnd

        local under = Instance.new("Frame")
        under.Parent = s
        under.Size = UDim2.new(1, 0, 0, 1)
        under.Position = UDim2.new(0, 0, 1, -1)
        under.BackgroundColor3 = C.Accent
        under.BorderSizePixel = 0
        under.BackgroundTransparency = 0.65
        return s
    end

    function tab:CreateButton(config)
        local btn = Instance.new("TextButton")
        btn.Parent = scroll
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.BackgroundColor3 = C.BG3
        btn.Text = "  " .. config.Name
        btn.TextColor3 = C.TextBright
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.LayoutOrder = tab._order
        newCorner(btn, 8)
        newStroke(btn, C.Stroke, 1.2, 0.3)
        tab._order = tab._order + 1

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = C.Accent, Size = UDim2.new(1, -3, 0, 36)}):Play()
            btn.TextColor3 = C.TextBright
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = C.BG3, Size = UDim2.new(1, 0, 0, 34)}):Play()
            btn.TextColor3 = C.TextBright
        end)
        btn.MouseButton1Down:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = C.AccentLight, Size = UDim2.new(1, 2, 0, 33)}):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = C.Accent, Size = UDim2.new(1, -3, 0, 36)}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            if config.Callback then
                config.Callback()
            end
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = C.AccentLight, Size = UDim2.new(1, 2, 0, 33)}):Play()
            task.delay(0.12, function()
                TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = C.BG3, Size = UDim2.new(1, 0, 0, 34)}):Play()
                btn.TextColor3 = C.TextBright
            end)
        end)
        return btn
    end

    function tab:CreateToggle(config)
        local enabled = config.CurrentValue or false

        local frame = Instance.new("Frame")
        frame.Parent = scroll
        frame.Size = UDim2.new(1, 0, 0, 36)
        frame.BackgroundColor3 = C.BG3
        frame.BorderSizePixel = 0
        frame.LayoutOrder = tab._order
        newCorner(frame, 9)
        newStroke(frame, C.Stroke, 1, 0.5)
        tab._order = tab._order + 1

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(1, -58, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = config.Name
        label.TextColor3 = C.Text
        label.TextSize = 12
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true
        label.TextTruncate = Enum.TextTruncate.AtEnd

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Parent = frame
        toggleBtn.Size = UDim2.new(0, 42, 0, 22)
        toggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
        toggleBtn.BackgroundColor3 = enabled and C.Green or C.Off
        toggleBtn.Text = ""
        toggleBtn.BorderSizePixel = 0
        toggleBtn.AutoButtonColor = false
        newCorner(toggleBtn, 11)
        newStroke(toggleBtn, C.TextBright, 1, 0.3)

        local knob = Instance.new("Frame")
        knob.Parent = toggleBtn
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        knob.BackgroundColor3 = C.TextBright
        knob.BorderSizePixel = 0
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function update()
            toggleBtn.BackgroundColor3 = enabled and C.Green or C.Off
            knob:TweenPosition(enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9), "Out", "Quad", 0.12, true)
        end

        toggleBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            update()
            if config.Callback then
                config.Callback(enabled)
            end
        end)

        return {
            Frame = frame,
            Set = function(_, val)
                enabled = val
                update()
            end
        }
    end

    function tab:CreateSlider(config)
        local min = config.Range[1]
        local max = config.Range[2]
        local inc = config.Increment or 1
        local val = config.CurrentValue or min
        local suffix = config.Suffix or ""

        local frame = Instance.new("Frame")
        frame.Parent = scroll
        frame.Size = UDim2.new(1, 0, 0, 48)
        frame.BackgroundColor3 = C.BG3
        frame.BorderSizePixel = 0
        frame.LayoutOrder = tab._order
        newCorner(frame, 9)
        newStroke(frame, C.Stroke, 1, 0.5)
        tab._order = tab._order + 1

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(0.62, 0, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = config.Name
        label.TextColor3 = C.Text
        label.TextSize = 11.5
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left

        local valLabel = Instance.new("TextLabel")
        valLabel.Parent = frame
        valLabel.Size = UDim2.new(0.38, -8, 0, 20)
        valLabel.Position = UDim2.new(0.62, 0, 0, 5)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(val) .. suffix
        valLabel.TextColor3 = C.AccentLight
        valLabel.TextSize = 11.5
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.TextTruncate = Enum.TextTruncate.AtEnd

        local track = Instance.new("Frame")
        track.Parent = frame
        track.Size = UDim2.new(1, -20, 0, 6)
        track.Position = UDim2.new(0, 10, 0, 32)
        track.BackgroundColor3 = C.Field
        track.BorderSizePixel = 0
        newCorner(track, 3)

        local fill = Instance.new("Frame")
        fill.Parent = track
        fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = C.Accent
        fill.BorderSizePixel = 0
        newCorner(fill, 3)
        newGradient(fill, C.AccentLight, C.Accent, 90)

        local knob = Instance.new("TextButton")
        knob.Parent = track
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = UDim2.new((val - min) / (max - min), -8, 0.5, -8)
        knob.BackgroundColor3 = C.TextBright
        knob.Text = ""
        knob.BorderSizePixel = 0
        knob.AutoButtonColor = false
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        newStroke(knob, C.Accent, 1.5, 0.2)

        local dragging = false
        knob.MouseButton1Down:Connect(function()
            dragging = true
        end)
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        game:GetService("RunService").RenderStepped:Connect(function()
            if dragging then
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local relX = (mouse.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                relX = math.clamp(relX, 0, 1)
                local raw = min + relX * (max - min)
                val = math.floor(raw / inc + 0.5) * inc
                val = math.clamp(val, min, max)
                local pct = (val - min) / (max - min)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                knob.Position = UDim2.new(pct, -8, 0.5, -8)
                valLabel.Text = tostring(val) .. suffix
                if config.Callback then
                    config.Callback(val)
                end
            end
        end)

        return {
            Set = function(_, v)
                val = math.clamp(v, min, max)
                local pct = (val - min) / (max - min)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                knob.Position = UDim2.new(pct, -8, 0.5, -8)
                valLabel.Text = tostring(val) .. suffix
            end
        }
    end

    function tab:CreateInput(config)
        local frame = Instance.new("Frame")
        frame.Parent = scroll
        frame.Size = UDim2.new(1, 0, 0, 58)
        frame.BackgroundColor3 = C.BG3
        frame.BorderSizePixel = 0
        frame.LayoutOrder = tab._order
        newCorner(frame, 9)
        newStroke(frame, C.Stroke, 1, 0.5)
        tab._order = tab._order + 1

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = config.Name
        label.TextColor3 = C.Text
        label.TextSize = 11.5
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd

        local box = Instance.new("TextBox")
        box.Parent = frame
        box.Size = UDim2.new(1, -20, 0, 26)
        box.Position = UDim2.new(0, 10, 0, 26)
        box.BackgroundColor3 = C.Field
        box.Text = ""
        box.PlaceholderText = config.PlaceholderText or ""
        box.PlaceholderColor3 = C.Off
        box.TextColor3 = C.TextBright
        box.TextSize = 12
        box.Font = Enum.Font.GothamMedium
        box.ClearTextOnFocus = false
        box.BorderSizePixel = 0
        newCorner(box, 7)
        newStroke(box, C.Stroke, 1, 0.6)
        newPadding(box, 0, 0, 10, 10)

        box.Focused:Connect(function()
            newStroke(box, C.Accent, 1.5, 0)
        end)
        box.FocusLost:Connect(function(enterPressed)
            newStroke(box, C.Stroke, 1, 0.6)
            if config.Callback then
                config.Callback(box.Text)
            end
            if config.RemoveTextAfterFocusLost then
                box.Text = ""
            end
        end)

        return box
    end

    function tab:CreateDropdown(config)
        local options = config.Options or {}
        local current = config.CurrentOption or ""
        if typeof(current) == "table" then current = current[1] or "" end
        local isOpen = false

        local frame = Instance.new("Frame")
        frame.Parent = scroll
        frame.Size = UDim2.new(1, 0, 0, 38)
        frame.BackgroundColor3 = C.BG3
        frame.BorderSizePixel = 0
        frame.LayoutOrder = tab._order
        newCorner(frame, 9)
        newStroke(frame, C.Stroke, 1, 0.5)
        tab._order = tab._order + 1

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(0.5, -6, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = config.Name
        label.TextColor3 = C.Text
        label.TextSize = 11.5
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd

        local dropBtn = Instance.new("TextButton")
        dropBtn.Parent = frame
        dropBtn.Size = UDim2.new(0.5, -10, 0, 26)
        dropBtn.Position = UDim2.new(0.5, 0, 0.5, -13)
        dropBtn.BackgroundColor3 = C.Field
        dropBtn.Text = current ~= "" and ("  " .. current) or "  Выберите..."
        dropBtn.TextColor3 = current ~= "" and C.TextBright or C.Off
        dropBtn.TextSize = 11.5
        dropBtn.Font = Enum.Font.GothamMedium
        dropBtn.TextXAlignment = Enum.TextXAlignment.Left
        dropBtn.TextTruncate = Enum.TextTruncate.AtEnd
        dropBtn.BorderSizePixel = 0
        dropBtn.AutoButtonColor = false
        newCorner(dropBtn, 6)
        newStroke(dropBtn, C.Stroke, 1, 0.6)
        dropBtn.MouseEnter:Connect(function()
            newStroke(dropBtn, C.Accent, 1.5, 0.2)
            dropBtn.BackgroundColor3 = Color3.fromRGB(30, 21, 54)
        end)
        dropBtn.MouseLeave:Connect(function()
            newStroke(dropBtn, C.Stroke, 1, 0.6)
            dropBtn.BackgroundColor3 = C.Field
        end)

        local arrow = Instance.new("TextLabel")
        arrow.Parent = dropBtn
        arrow.Size = UDim2.new(0, 22, 1, 0)
        arrow.Position = UDim2.new(1, -24, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.TextColor3 = C.AccentLight
        arrow.TextSize = 12
        arrow.Font = Enum.Font.GothamBold

        -- Floating list, parented to main window so it is never clipped
        local win = self._win or self
        local listFrame = Instance.new("Frame")
        listFrame.Parent = win._gui
        listFrame.BackgroundColor3 = C.BG3
        listFrame.BorderSizePixel = 0
        listFrame.Visible = false
        listFrame.ZIndex = 40
        newCorner(listFrame, 8)
        newStroke(listFrame, C.Accent, 1.5, 0.2)

        local listScroll = Instance.new("ScrollingFrame")
        listScroll.Parent = listFrame
        listScroll.Size = UDim2.new(1, 0, 1, 0)
        listScroll.BackgroundTransparency = 1
        listScroll.ScrollBarThickness = 3
        listScroll.ScrollBarImageColor3 = C.ScrollBar
        listScroll.ScrollBarImageTransparency = 0.6
        listScroll.BorderSizePixel = 0
        listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local ll = Instance.new("UIListLayout")
        ll.Parent = listScroll
        ll.Padding = UDim.new(0, 2)
        newPadding(listScroll, 5, 5, 5, 5)

        local maxVisible = 6

        local function refresh(opts)
            options = opts
            for _, c in ipairs(listScroll:GetChildren()) do
                if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
                    if c:IsA("TextButton") then c:Destroy() end
                end
            end
            listScroll.CanvasSize = UDim2.new(0, 0, 0, #options * 28 + 8)
            for i, opt in ipairs(options) do
                local item = Instance.new("TextButton")
                item.Parent = listScroll
                item.Size = UDim2.new(1, -6, 0, 26)
                item.BackgroundColor3 = opt == current and C.Accent or C.BG3
                item.Text = "  " .. opt
                item.TextColor3 = opt == current and C.TextBright or C.Text
                item.TextSize = 11.5
                item.Font = Enum.Font.GothamMedium
                item.TextXAlignment = Enum.TextXAlignment.Left
                item.BorderSizePixel = 0
                item.AutoButtonColor = false
                item.ZIndex = 41
                newCorner(item, 5)
                item.MouseEnter:Connect(function()
                    if opt ~= current then
                        item.BackgroundColor3 = C.Accent
                        item.TextColor3 = C.TextBright
                    end
                end)
                item.MouseLeave:Connect(function()
                    if opt ~= current then
                        item.BackgroundColor3 = C.BG3
                        item.TextColor3 = C.Text
                    end
                end)
                item.MouseButton1Click:Connect(function()
                    current = opt
                    dropBtn.Text = "  " .. current
                    dropBtn.TextColor3 = C.TextBright
                    listFrame.Visible = false
                    isOpen = false
                    if config.Callback then
                        config.Callback(current)
                    end
                    refresh(options)
                end)
            end
        end

        refresh(options)

        local function positionList()
            local visible = math.min(#options, maxVisible)
            listFrame.Size = UDim2.new(0, math.max(dropBtn.AbsoluteSize.X, 200), 0, visible * 28 + 12)
            local btnPos = dropBtn.AbsolutePosition
            local btnSize = dropBtn.AbsoluteSize
            local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1000, 600)
            local x = math.clamp(btnPos.X, 4, vp.X - listFrame.AbsoluteSize.X - 4)
            local y = btnPos.Y + btnSize.Y + 2
            if y + listFrame.AbsoluteSize.Y > vp.Y - 4 then
                y = btnPos.Y - listFrame.AbsoluteSize.Y - 2
            end
            y = math.max(4, y)
            listFrame.Position = UDim2.fromOffset(x, y)
        end

        dropBtn.MouseButton1Click:Connect(function()
            if isOpen then
                listFrame.Visible = false
                isOpen = false
                return
            end
            for _, p in ipairs(win._popups) do
                p.Visible = false
            end
            positionList()
            listFrame.Visible = true
            isOpen = true
            table.insert(win._popups, listFrame)
        end)

        return {
            Frame = frame,
            Refresh = function(_, opts)
                refresh(opts)
            end,
            Clear = function(_)
                refresh({})
                current = ""
                dropBtn.Text = "  Выберите..."
                dropBtn.TextColor3 = C.Off
            end,
            Set = function(_, val)
                current = val or ""
                if current == "" then
                    dropBtn.Text = "  Выберите..."
                    dropBtn.TextColor3 = C.Off
                else
                    dropBtn.Text = "  " .. current
                    dropBtn.TextColor3 = C.TextBright
                end
                if config.Callback then
                    config.Callback(current)
                end
            end
        }
    end

    function tab:CreateLabel(text)
        local label = Instance.new("TextLabel")
        label.Parent = scroll
        label.Size = UDim2.new(1, 0, 0, 24)
        label.BackgroundColor3 = C.BG3
        label.BackgroundTransparency = 0.9
        label.Text = "  " .. text
        label.TextColor3 = C.Text
        label.TextSize = 11.5
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.LayoutOrder = tab._order
        newCorner(label, 7)
        newStroke(label, C.Stroke, 1, 0.7)
        tab._order = tab._order + 1

        return {
            Frame = label,
            Set = function(_, newText)
                label.Text = "  " .. newText
            end
        }
    end

    function tab:CreateColorPicker(config)
        local color = config.Color or Color3.fromRGB(255, 255, 255)
        local isOpen = false

        local frame = Instance.new("Frame")
        frame.Parent = scroll
        frame.Size = UDim2.new(1, 0, 0, 38)
        frame.BackgroundColor3 = C.BG3
        frame.BorderSizePixel = 0
        frame.LayoutOrder = tab._order
        newCorner(frame, 9)
        newStroke(frame, C.Stroke, 1, 0.5)
        tab._order = tab._order + 1

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = config.Name
        label.TextColor3 = C.Text
        label.TextSize = 11.5
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd

        local colorBtn = Instance.new("TextButton")
        colorBtn.Parent = frame
        colorBtn.Size = UDim2.new(0, 26, 0, 26)
        colorBtn.Position = UDim2.new(1, -38, 0.5, -13)
        colorBtn.BackgroundColor3 = color
        colorBtn.Text = ""
        colorBtn.BorderSizePixel = 0
        colorBtn.AutoButtonColor = false
        newCorner(colorBtn, 7)
        newStroke(colorBtn, C.TextBright, 1.5, 0.3)

        -- Floating picker, parented to main window
        local win = self._win or self
        local pickerFrame = Instance.new("Frame")
        pickerFrame.Parent = win._gui
        pickerFrame.BackgroundColor3 = C.BG3
        pickerFrame.BorderSizePixel = 0
        pickerFrame.Visible = false
        pickerFrame.ZIndex = 40
        newCorner(pickerFrame, 10)
        newStroke(pickerFrame, C.Accent, 1.5, 0.2)

        local presets = {
            Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 128, 0), Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 128, 255),
            Color3.fromRGB(0, 0, 255), Color3.fromRGB(128, 0, 255), Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(255, 255, 255), Color3.fromRGB(128, 128, 128), Color3.fromRGB(20, 20, 20),
        }
        local pickerW = 190

        for i, c in ipairs(presets) do
            local px = Instance.new("TextButton")
            px.Parent = pickerFrame
            local col = (i - 1) % 6
            local row = math.floor((i - 1) / 6)
            px.Size = UDim2.new(0, 26, 0, 26)
            px.Position = UDim2.new(0, 8 + col * 30, 0, 8 + row * 30)
            px.BackgroundColor3 = c
            px.Text = ""
            px.BorderSizePixel = 0
            px.AutoButtonColor = false
            px.ZIndex = 41
            newCorner(px, 5)
            newStroke(px, C.TextBright, 1, 0.6)
            px.MouseButton1Click:Connect(function()
                color = c
                colorBtn.BackgroundColor3 = c
                if config.Callback then
                    config.Callback(c)
                end
                pickerFrame.Visible = false
                isOpen = false
            end)
        end

        local customLabel = Instance.new("TextLabel")
        customLabel.Parent = pickerFrame
        customLabel.Size = UDim2.new(1, -16, 0, 18)
        customLabel.Position = UDim2.new(0, 8, 0, 70)
        customLabel.BackgroundTransparency = 1
        customLabel.Text = "Custom hex / RGB:"
        customLabel.TextColor3 = C.Text
        customLabel.TextSize = 10.5
        customLabel.Font = Enum.Font.GothamMedium
        customLabel.TextXAlignment = Enum.TextXAlignment.Left
        customLabel.ZIndex = 41

        local hexBox = Instance.new("TextBox")
        hexBox.Parent = pickerFrame
        hexBox.Size = UDim2.new(1, -16, 0, 24)
        hexBox.Position = UDim2.new(0, 8, 0, 88)
        hexBox.BackgroundColor3 = C.Field
        hexBox.PlaceholderText = "#RRGGBB"
        hexBox.PlaceholderColor3 = C.Off
        hexBox.TextColor3 = C.TextBright
        hexBox.TextSize = 11
        hexBox.Font = Enum.Font.GothamMedium
        hexBox.ClearTextOnFocus = false
        hexBox.BorderSizePixel = 0
        hexBox.ZIndex = 41
        newCorner(hexBox, 6)
        newPadding(hexBox, 0, 0, 8, 8)

        hexBox.FocusLost:Connect(function()
            local t = string.gsub(hexBox.Text, "#", ""):upper()
            if string.len(t) == 6 then
                local r = tonumber(string.sub(t, 1, 2), 16)
                local g = tonumber(string.sub(t, 3, 4), 16)
                local b = tonumber(string.sub(t, 5, 6), 16)
                if r and g and b then
                    color = Color3.fromRGB(r, g, b)
                    colorBtn.BackgroundColor3 = color
                    if config.Callback then
                        config.Callback(color)
                    end
                end
            end
        end)

        pickerFrame.Size = UDim2.new(0, pickerW, 0, 122)

        local function positionPicker()
            local btnPos = colorBtn.AbsolutePosition
            local btnSize = colorBtn.AbsoluteSize
            local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1000, 600)
            local x = btnPos.X + btnSize.X + 2
            if x + pickerW > vp.X - 4 then
                x = btnPos.X - pickerW - 2
            end
            x = math.max(4, x)
            local y = btnPos.Y
            if y + pickerFrame.AbsoluteSize.Y > vp.Y - 4 then
                y = btnPos.Y - pickerFrame.AbsoluteSize.Y + btnSize.Y
            end
            y = math.max(4, y)
            pickerFrame.Position = UDim2.fromOffset(x, y)
        end

        colorBtn.MouseButton1Click:Connect(function()
            if isOpen then
                pickerFrame.Visible = false
                isOpen = false
                return
            end
            for _, p in ipairs(win._popups) do
                p.Visible = false
            end
            positionPicker()
            pickerFrame.Visible = true
            isOpen = true
            table.insert(win._popups, pickerFrame)
        end)

        return {
            Set = function(_, c)
                color = c
                colorBtn.BackgroundColor3 = c
            end
        }
    end

    -- Show first tab
    if self._tabs[1] then
        activate()
    end

    return tab
end

-- ==================== NOTIFY ====================
local notifStack = 0

function EliteHubUI:Notify(config)
    local player = game:GetService("Players").LocalPlayer
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return end

    local duration = config.Duration or 3
    local dur = math.max(0.5, duration)

    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "EliteNotif"
    notifGui.ResetOnSpawn = false
    notifGui.IgnoreGuiInset = true
    notifGui.DisplayOrder = 1000
    notifGui.Parent = gui

    local safeArea = Instance.new("Frame")
    safeArea.Parent = notifGui
    safeArea.AnchorPoint = Vector2.new(1, 0)
    safeArea.Position = UDim2.new(1, -14, 0, 14)
    safeArea.Size = UDim2.new(0, 250, 0, 40)
    safeArea.BackgroundTransparency = 1

    local stackGap = 46
    local notif = Instance.new("Frame")
    notif.Parent = safeArea
    notif.Size = UDim2.new(1, 0, 1, 0)
    notif.Position = UDim2.new(1, 0, 0, (notifStack - 1) * stackGap)
    notif.BackgroundColor3 = C.BG2
    notif.BorderSizePixel = 0
    notif.BackgroundTransparency = 0
    notif.ClipsDescendants = true
    newCorner(notif, 8)
    newStroke(notif, C.Accent, 1, 0.15)
    newGradient(notif, Color3.fromRGB(44, 32, 72), Color3.fromRGB(30, 22, 50), 90)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notif
    titleLabel.Size = UDim2.new(1, -18, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = (config.Content or "") == "" and (config.Title or "") or ((config.Title or "") .. "  •  " .. (config.Content or ""))
    titleLabel.TextColor3 = C.TextBright
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.ZIndex = 2

    local progress = Instance.new("Frame")
    progress.Parent = notif
    progress.Size = UDim2.new(1, 0, 0, 3)
    progress.Position = UDim2.new(0, 0, 1, -3)
    progress.BackgroundColor3 = C.Accent
    progress.BorderSizePixel = 0
    newCorner(progress, 2)

    notifStack = notifStack + 1
    local stackIndex = notifStack

    local slideIn = TweenService:Create(notif, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(1, -250, 0, (stackIndex - 1) * stackGap) })
    notif.Position = UDim2.new(1, 40, 0, (stackIndex - 1) * stackGap)
    slideIn:Play()

    local barTween = TweenService:Create(progress, TweenInfo.new(dur, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 3) })
    task.spawn(function()
        task.wait(0.3)
        barTween:Play()
    end)

    task.spawn(function()
        task.wait(dur + 0.4)
        local fade = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(1, 0, 0, (stackIndex - 1) * stackGap), BackgroundTransparency = 1 })
        local fadeTitle = TweenService:Create(titleLabel, TweenInfo.new(0.3), { TextTransparency = 1 })
        fade:Play()
        fadeTitle:Play()
        task.wait(0.35)
        notifGui:Destroy()
        notifStack = math.max(0, notifStack - 1)
    end)
end

-- ==================== DESTROY ====================
function EliteHubUI:Destroy()
    if self._gui then
        self._gui:Destroy()
    end
end

return EliteHubUI