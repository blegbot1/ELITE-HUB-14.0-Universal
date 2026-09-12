-- ELITE HUB 14.0 — Nametag Module
-- Extracted from ELITE_HUB_14.0.lua

local MT = NametagTab

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════
-- AUTOMATIC NAMETAG — показывает "ELITE HUB" только над пользователями
-- скрипта. Детекция через kvdb.io (облако): heartbeat + опрос.
-- HttpService в executor'е забанен — используем game:HttpGet/HttpPost.
-- Настраивается через вкладку Mods → 🏷️ NAMETAG
-- ═══════════════════════════════════════════════════════════════════
local env = getgenv and getgenv() or _G
if env.EliteHubNametagActive then return end
env.EliteHubNametagActive = true
do

-- ═══ LOGGER CHIKH: пишем в консоль на каждое действие наметки ═══
local function NLog(msgEl, ...)
    getgenv().ELITE_HUB_Log("NAMETAG", msgEl, ...)
end

    local NH_BUCKET = "CnWTikAq6kahaCkrUahVM4"
    local NH_PING = 8      -- heartbeat каждые 8с
    local NH_POLL = 6      -- опрос каждые 6с
    local NH_STALE = 25    -- мёртв после 25с

    local nhName = player.Name
    local nhDetected = {}
    local nhDel = request or http_request or (http and http.request)

    env.ELITE_HUB_NametagCfg = env.ELITE_HUB_NametagCfg or {
        Enabled = true,
        Mode = "users",              -- "users" | "all"
        Text = "ELITE HUB",
        TextSize = 11,
        TextColor = Color3.fromRGB(220, 180, 255),
        BgColor = Color3.fromRGB(120, 40, 200),
        BgTransparency = 0.1,
        Corner = 5,
        Width = 120,
        Height = 20,
        Offset = 3,
        AlwaysOnTop = true,
        Stroke = true,
        Rainbow = false,
        ShowNick = false,
        Glow = false,
        Pulse = false,
    }
    local cfg = env.ELITE_HUB_NametagCfg

    local function nhBase(extra)
        return "https://kvdb.io/" .. NH_BUCKET .. "/" .. (extra or "")
    end

    local function nhShowTag(hrp, dispName)
        local old = hrp:FindFirstChild("EliteHubTag")
        if old then old:Destroy() end
        if not cfg.Enabled then return end

        local bb = Instance.new("BillboardGui")
        bb.Name = "EliteHubTag"
        bb.AlwaysOnTop = cfg.AlwaysOnTop
        bb.ExtentsOffset = Vector3.new(0, cfg.Offset, 0)
        bb.Size = UDim2.new(0, cfg.Width, 0, cfg.Height)
        bb.Adornee = hrp
        bb.Parent = hrp

        local bg = Instance.new("Frame")
        bg.Name = "TagFrame"
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = cfg.BgColor
        bg.BackgroundTransparency = cfg.BgTransparency
        bg.BorderSizePixel = 0
        bg.Parent = bb

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, cfg.Corner)
        corner.Parent = bg

        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new(
            Color3.fromRGB(cfg.BgColor.r * 255 * 0.55, cfg.BgColor.g * 255 * 0.55, cfg.BgColor.b * 255 * 0.55),
            cfg.BgColor
        )
        grad.Rotation = 90
        grad.Parent = bg

        if cfg.Glow then
            local st = Instance.new("UIStroke")
            st.Color = Color3.fromRGB(190, 120, 255)
            st.Thickness = 2
            st.Transparency = 0.25
            st.Parent = bg
        end

        local lbl = Instance.new("TextLabel")
        lbl.Name = "TagText"
        lbl.BackgroundTransparency = 1
        lbl.Text = cfg.Text
        lbl.TextColor3 = cfg.TextColor
        lbl.TextSize = cfg.TextSize
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextStrokeTransparency = cfg.Stroke and 0 or 1
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        if cfg.ShowNick and dispName and dispName ~= "" then
            lbl.Size = UDim2.new(1, 0, 0.58, 0)
            lbl.Position = UDim2.new(0, 0, 0, 0)
            lbl.Parent = bg

            local nick = Instance.new("TextLabel")
            nick.Name = "TagNick"
            nick.Size = UDim2.new(1, 0, 0.42, 0)
            nick.Position = UDim2.new(0, 0, 0.58, 0)
            nick.BackgroundTransparency = 1
            nick.Text = dispName
            nick.TextColor3 = Color3.fromRGB(255, 255, 255)
            nick.TextSize = cfg.TextSize - 2
            nick.Font = Enum.Font.GothamBold
            nick.TextStrokeTransparency = 0
            nick.TextStrokeColor3 = Color3.new(0, 0, 0)
            nick.TextTruncate = Enum.TextTruncate.AtEnd
            nick.Parent = bg
        else
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.Parent = bg
        end
    end

    local function nhTagPlayer(name)
        local p = Players:FindFirstChild(name)
        if not p then return false end
        local char = p.Character
        if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        nhShowTag(hrp, p.DisplayName or p.Name)
        return true
    end

    local function nhGetTargets()
        local targets = {}
        if cfg.Mode == "all" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    targets[p.Name] = true
                end
            end
        else
            for name in pairs(nhDetected) do
                targets[name] = true
            end
        end
        return targets
    end

    local function nhClearTags()
        for _, p in ipairs(Players:GetPlayers()) do
            local char = p.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local t = hrp:FindFirstChild("EliteHubTag")
                    if t then t:Destroy() end
                end
            end
        end
    end

    local function nhRefreshAll()
        nhClearTags()
        for name in pairs(nhGetTargets()) do
            nhTagPlayer(name)
        end
    end

    -- ре-применение при респавне
    local function nhBindChar(p)
        if p == player then return end
        p.CharacterAdded:Connect(function()
            task.wait(1.5)
            pcall(function()
                if cfg.Enabled and nhGetTargets()[p.Name] then
                    nhTagPlayer(p.Name)
                end
            end)
        end)
    end
    for _, p in ipairs(Players:GetPlayers()) do nhBindChar(p) end
    Players.PlayerAdded:Connect(nhBindChar)

    -- Heartbeat
    task.spawn(function()
        local url = nhBase(nhName)
        local count = 0
        while task.wait(NH_PING) do
            count = count + 1
            local ok = pcall(function()
                game:HttpPost(url, tostring(os.time()), "text/plain")
            end)
            NLog("Heartbeat #" .. tostring(count) .. " → " .. nhName .. " | ok=" .. tostring(ok))
        end
    end)

    -- Опрос (users-режим: обновляем набор детектированных)
    task.spawn(function()
        local listUrl = nhBase()
        local counter = 0
        while task.wait(NH_POLL) do
            pcall(function()
                counter = counter + 1
                local body = game:HttpGet(listUrl, true)
                local now = os.time()

                local listStr = (body or ""):gsub("\n", " ") or ""
                NLog("Poll #" .. tostring(counter) .. " | bucket: " .. tostring(listStr))

                for name in (body .. "\n"):gmatch("([^\n]+)\n") do
                    if name ~= nhName then
                        if not nhDetected[name] then
                            local ts = tonumber(game:HttpGet(nhBase(name), true))
                            if ts and (now - ts) <= NH_STALE then
                                nhDetected[name] = true
                                NLog("DETECTED user: " .. tostring(name))
                            end
                        else
                            if counter % 3 == 0 then
                                local ts = tonumber(game:HttpGet(nhBase(name), true))
                                if not ts or (now - ts) > NH_STALE then
                                    nhDetected[name] = nil
                                    NLog("STALE user: " .. tostring(name) .. " → removed")
                                    if nhDel then
                                        pcall(nhDel, { Url = nhBase(name), Method = "DELETE" })
                                    end
                                end
                            end
                        end
                    end
                end

                if not body or body == "" then
                    nhDetected = {}
                    NLog("Bucket empty → reset detected set")
                end
            end)
        end
    end)

    -- Применение + анимации (радуга/пульс) каждые 2с
    task.spawn(function()
        local hue = 0
        while task.wait(2) do
            pcall(function()
                if not cfg.Enabled then
                    nhClearTags()
                    return
                end
                hue = (hue + 0.04) % 1
                local t = os.clock()
                for name in pairs(nhGetTargets()) do
                    nhTagPlayer(name)
                end
                -- live-анимация существующих тегов
                for _, p in ipairs(Players:GetPlayers()) do
                    local char = p.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local tag = hrp:FindFirstChild("EliteHubTag")
                            if tag then
                                if cfg.Pulse then
                                    local s = 1 + math.sin(t * 3) * 0.03
                                    tag.Size = UDim2.new(0, cfg.Width * s, 0, cfg.Height * s)
                                else
                                    tag.Size = UDim2.new(0, cfg.Width, 0, cfg.Height)
                                end
                                local bg = tag:FindFirstChild("TagFrame")
                                if bg then
                                    local lbl = bg:FindFirstChild("TagText")
                                    if lbl and cfg.Rainbow then
                                        lbl.TextColor3 = Color3.fromHSV(hue, 0.85, 1)
                                    elseif lbl and not cfg.Rainbow then
                                        lbl.TextColor3 = cfg.TextColor
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)

    -- ═══ НАСТРОЙКИ ═══
    MT:CreateSection("🏷️ NAMETAG")
    MT:CreateToggle({
        Name = "✅ Nametag enabled",
        CurrentValue = cfg.Enabled,
        Callback = function(v)
            cfg.Enabled = v
            if v then nhRefreshAll() else nhClearTags() end
            NLog("Setting: Nametag enabled = " .. tostring(v))
        end
    })
    MT:CreateDropdown({
        Name = "🎯 Show for",
        Options = { "Only script users", "All players" },
        CurrentOption = cfg.Mode == "all" and "All players" or "Only script users",
        Callback = function(opt)
            cfg.Mode = opt == "All players" and "all" or "users"
            nhRefreshAll()
            NLog("Setting: Show for = " .. tostring(opt))
        end
    })
    local nhNameInput = MT:CreateInput({
        Name = "✏️ Tag text",
        PlaceholderText = "ELITE HUB",
        Callback = function(v)
            if v and v ~= "" then
                cfg.Text = v
                nhRefreshAll()
                NLog("Setting: Tag text = " .. tostring(v))
            end
        end
    })
    nhNameInput.Text = cfg.Text
    MT:CreateSlider({
        Name = "🔠 Text size",
        Range = { 8, 20 },
        Increment = 1,
        CurrentValue = cfg.TextSize,
        Callback = function(v)
            cfg.TextSize = v
            nhRefreshAll()
            NLog("Setting: Text size = " .. tostring(v))
        end
    })
    MT:CreateSlider({
        Name = "↔️ Tag width",
        Range = { 80, 220 },
        Increment = 5,
        CurrentValue = cfg.Width,
        Callback = function(v)
            cfg.Width = v
            nhRefreshAll()
            NLog("Setting: Tag width = " .. tostring(v))
        end
    })
    MT:CreateSlider({
        Name = "↕️ Tag height",
        Range = { 16, 40 },
        Increment = 2,
        CurrentValue = cfg.Height,
        Callback = function(v)
            cfg.Height = v
            nhRefreshAll()
            NLog("Setting: Tag height = " .. tostring(v))
        end
    })
    MT:CreateSlider({
        Name = "⬆️ Offset Y",
        Range = { 0, 6 },
        Increment = 1,
        CurrentValue = cfg.Offset,
        Callback = function(v)
            cfg.Offset = v
            nhRefreshAll()
            NLog("Setting: Offset = " .. tostring(v))
        end
    })
    MT:CreateSlider({
        Name = "🔳 BG transparency",
        Range = { 0, 90 },
        Increment = 5,
        CurrentValue = math.floor(cfg.BgTransparency * 100),
        Callback = function(v)
            cfg.BgTransparency = v / 100
            nhRefreshAll()
            NLog("Setting: BG transparency = " .. tostring(v))
        end
    })
    MT:CreateSlider({
        Name = "🔘 Corner radius",
        Range = { 0, 12 },
        Increment = 1,
        CurrentValue = cfg.Corner,
        Callback = function(v)
            cfg.Corner = v
            nhRefreshAll()
            NLog("Setting: Corner = " .. tostring(v))
        end
    })
    MT:CreateColorPicker({
        Name = "🎨 Text color",
        Color = cfg.TextColor,
        Callback = function(c)
            cfg.TextColor = c
            nhRefreshAll()
            NLog("Setting: Text color = " .. tostring(c))
        end
    })
    MT:CreateColorPicker({
        Name = "🟣 Background color",
        Color = cfg.BgColor,
        Callback = function(c)
            cfg.BgColor = c
            nhRefreshAll()
            NLog("Setting: Bg color = " .. tostring(c))
        end
    })
    MT:CreateToggle({
        Name = "🌈 Rainbow text",
        CurrentValue = cfg.Rainbow,
        Callback = function(v)
            cfg.Rainbow = v
            nhRefreshAll()
            NLog("Setting: Rainbow = " .. tostring(v))
        end
    })
    MT:CreateToggle({
        Name = "📛 Show nickname",
        CurrentValue = cfg.ShowNick,
        Callback = function(v)
            cfg.ShowNick = v
            nhRefreshAll()
            NLog("Setting: Show nickname = " .. tostring(v))
        end
    })
    MT:CreateToggle({
        Name = "✨ Glow border",
        CurrentValue = cfg.Glow,
        Callback = function(v)
            cfg.Glow = v
            nhRefreshAll()
            NLog("Setting: Glow = " .. tostring(v))
        end
    })
    MT:CreateToggle({
        Name = "⬛ Text stroke",
        CurrentValue = cfg.Stroke,
        Callback = function(v)
            cfg.Stroke = v
            nhRefreshAll()
            NLog("Setting: Text stroke = " .. tostring(v))
        end
    })
    MT:CreateToggle({
        Name = "💗 Pulse animation",
        CurrentValue = cfg.Pulse,
        Callback = function(v)
            cfg.Pulse = v
            NLog("Setting: Pulse = " .. tostring(v))
        end
    })
    MT:CreateToggle({
        Name = "🔝 Always on top",
        CurrentValue = cfg.AlwaysOnTop,
        Callback = function(v)
            cfg.AlwaysOnTop = v
            nhRefreshAll()
NLog("Setting: Always on top = " .. tostring(v))
        end
    })
end
