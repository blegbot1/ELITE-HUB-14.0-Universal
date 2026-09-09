-- source: ELITE_HUB_14.0.lua ИГРОКИ (players tab)
local _g = getgenv
local Rayfield = _g().ELITE_HUB_Rayfield
local Players = _g().ELITE_HUB_Players
local player = _g().ELITE_HUB_Player
local PlayersTab = _g().ELITE_HUB_PlayersTab
local AimbotConfig = _g().ELITE_HUB_AimbotConfig
local ESPConfig = _g().ELITE_HUB_ESPConfig
local SafeNotify = _g().ELITE_HUB_SafeNotify
local UpdateESP = _g().ELITE_HUB_UpdateESP or function() end
local GetPlayerRelation = _g().ELITE_HUB_GetPlayerRelation or function() return "none" end

local FRIENDS = getgenv().ELITE_HUB_FRIENDS
local ENEMIES = getgenv().ELITE_HUB_ENEMIES
local FRIEND_TEAMS = getgenv().ELITE_HUB_FRIEND_TEAMS
local ENEMY_TEAMS = getgenv().ELITE_HUB_ENEMY_TEAMS

local function HasName(list, name)
    local lname = tostring(name or ""):lower()
    for _, n in ipairs(list) do
        if tostring(n):lower() == lname then return true end
    end
    return false
end

local function AddName(list, name)
    name = tostring(name or "")
    if name == "" then return end
    if HasName(list, name) then return end
    table.insert(list, name)
end

local function RemoveName(list, name)
    name = tostring(name or "")
    for i = #list, 1, -1 do
        if tostring(list[i]):lower() == name:lower() then
            table.remove(list, i)
        end
    end
end

local function JoinNames(list)
    local parts = {}
    for _, n in ipairs(list) do table.insert(parts, tostring(n)) end
    table.sort(parts)
    return table.concat(parts, ", ")
end

local function RefreshESPColors()
    pcall(UpdateESP)
end

local function TeamOf(p)
    if not p then return "—" end
    local tn = GetTeamName(p)
    return tn or "—"
end

local function HpOf(p)
    local ch = p and p.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if hum then return math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) end
    return "—"
end

local function RelText(p)
    if not p then return "—" end
    local r = GetPlayerRelation(p)
    if r == "friend" then return "Друг 💙"
    elseif r == "enemy" then return "Враг ❤️"
    elseif r == "my" then return "Ты"
    else return "Нейтрал" end
end

local playersTabScroll = PlayersTab._scroll

PlayersTab:CreateSection("🔍 ИГРОК")

local pickDD = nil
local teamDD = nil
local selectedPlr = nil
local selName = ""

local thumbCard = nil
local thumbInner = nil
local function MakeThumbCard()
    if thumbCard then pcall(function() thumbCard:Destroy() end) end
    thumbCard = Instance.new("Frame")
    thumbCard.Size = UDim2.new(0, 64, 0, 64)
    thumbCard.BorderSizePixel = 0
    thumbCard.BackgroundColor3 = Color3.fromRGB(25, 18, 45)
    thumbCard.LayoutOrder = PlayersTab._order
    PlayersTab._order = PlayersTab._order + 1
    thumbCard.Parent = playersTabScroll
    Instance.new("UICorner", thumbCard).CornerRadius = UDim.new(0, 10)
    thumbInner = Instance.new("ImageLabel")
    thumbInner.Name = "Thumb"
    thumbInner.Size = UDim2.new(1, -4, 1, -4)
    thumbInner.Position = UDim2.new(0, 2, 0, 2)
    thumbInner.BackgroundColor3 = Color3.fromRGB(46, 34, 76)
    thumbInner.BackgroundTransparency = 0.4
    thumbInner.ScaleType = Enum.ScaleType.Fit
    thumbInner.BorderSizePixel = 0
    thumbInner.Image = ""
    thumbInner.Parent = thumbCard
    Instance.new("UICorner", thumbInner).CornerRadius = UDim.new(0, 8)
end
MakeThumbCard()

local ThumbCache = {}
local function SetThumb(plr)
    if thumbInner then thumbInner.Image = "" end
    if not plr then return end
    local uid = plr.UserId
    if ThumbCache[uid] then
        if thumbInner then thumbInner.Image = ThumbCache[uid] end
        return
    end
    task.spawn(function()
        local ok, url = pcall(function()
            return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
        if ok and type(url) == "string" and url ~= "" then
            ThumbCache[uid] = url
            if thumbInner and thumbInner.Parent then thumbInner.Image = url end
        end
    end)
end

local infoName = PlayersTab:CreateLabel("Имя: —")
local infoTeam = PlayersTab:CreateLabel("Команда: —")
local infoHp = PlayersTab:CreateLabel("HP: —")
local infoRel = PlayersTab:CreateLabel("Связь: —")

local function RefreshInfo()
    local p = selectedPlr
    if not p or not p.Parent then
        infoName:Set("Имя: —")
        infoTeam:Set("Команда: —")
        infoHp:Set("HP: —")
        infoRel:Set("Связь: —")
        SetThumb(nil)
        return
    end
    infoName:Set("Имя: " .. p.Name)
    infoTeam:Set("Команда: " .. TeamOf(p))
    infoHp:Set("HP: " .. HpOf(p))
    infoRel:Set("Связь: " .. RelText(p))
    SetThumb(p)
end

pickDD = PlayersTab:CreateDropdown({
    Name = " Выбрать игрока",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        selName = tostring(n or "")
        selectedPlr = (selName ~= "") and Players:FindFirstChild(selName) or nil
        RefreshInfo()
    end
})

PlayersTab:CreateSection("⚡ ДЕЙСТВИЯ")

PlayersTab:CreateButton({
    Name = "🔵 В друзья",
    Callback = function()
        if not selectedPlr then
            Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = "Сначала выбери игрока", Duration = 2 })
            return
        end
        local nm = selectedPlr.Name
        AddName(FRIENDS, nm)
        RemoveName(ENEMIES, nm)
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = nm .. " → друг 💙", Duration = 2 })
        RefreshInfo()
        RefreshESPColors()
    end
})

PlayersTab:CreateButton({
    Name = "🔴 Во враги",
    Callback = function()
        if not selectedPlr then
            Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = "Сначала выбери игрока", Duration = 2 })
            return
        end
        local nm = selectedPlr.Name
        AddName(ENEMIES, nm)
        RemoveName(FRIENDS, nm)
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = nm .. " → враг ❤️", Duration = 2 })
        RefreshInfo()
        RefreshESPColors()
    end
})

PlayersTab:CreateButton({
    Name = "⚪ Сбросить метку",
    Callback = function()
        if not selectedPlr then
            Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = "Сначала выбери игрока", Duration = 2 })
            return
        end
        local nm = selectedPlr.Name
        RemoveName(FRIENDS, nm)
        RemoveName(ENEMIES, nm)
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = nm .. " — нейтрал", Duration = 2 })
        RefreshInfo()
        RefreshESPColors()
    end
})

PlayersTab:CreateButton({
    Name = "🎯 Сделать целью",
    Callback = function()
        if not selectedPlr then
            Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = "Сначала выбери игрока", Duration = 2 })
            return
        end
        getgenv().ELITE_HUB_TARGET_NAME = selectedPlr.Name
        Rayfield:Notify({ Title = "🎯 ИГРОКИ", Content = "Цель: " .. selectedPlr.Name, Duration = 2 })
    end
})

PlayersTab:CreateSection("🏟 КОМАНДЫ")

local selTeam = ""
teamDD = PlayersTab:CreateDropdown({
    Name = " Выбрать команду",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        local n = option
        if typeof(option) == "table" then n = option[1] end
        selTeam = tostring(n or "")
    end
})

PlayersTab:CreateButton({
    Name = "💙 Команду — в друзья",
    Callback = function()
        if selTeam == "" then
            Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = "Выбери команду", Duration = 2 })
            return
        end
        AddName(FRIEND_TEAMS, selTeam)
        RemoveName(ENEMY_TEAMS, selTeam)
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = selTeam .. ": вся команда → друг 💙", Duration = 2 })
        RefreshESPColors()
    end
})

PlayersTab:CreateButton({
    Name = "❤️ Команду — во враги",
    Callback = function()
        if selTeam == "" then
            Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = "Выбери команду", Duration = 2 })
            return
        end
        AddName(ENEMY_TEAMS, selTeam)
        RemoveName(FRIEND_TEAMS, selTeam)
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = selTeam .. ": вся команда → враг ❤️", Duration = 2 })
        RefreshESPColors()
    end
})

PlayersTab:CreateButton({
    Name = "⚪ Сбросить команду",
    Callback = function()
        if selTeam == "" then
            Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = "Выбери команду", Duration = 2 })
            return
        end
        RemoveName(FRIEND_TEAMS, selTeam)
        RemoveName(ENEMY_TEAMS, selTeam)
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = selTeam .. ": команда нейтральна", Duration = 2 })
        RefreshESPColors()
    end
})

PlayersTab:CreateSection("👥 СПИСКИ")

PlayersTab:CreateButton({
    Name = "💙 Показать друзей",
    Callback = function()
        local s = JoinNames(FRIENDS)
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = (s == "" and "Друзей нет" or "Друзья: " .. s), Duration = 5 })
    end
})

PlayersTab:CreateButton({
    Name = "❤️ Показать врагов",
    Callback = function()
        local s = JoinNames(ENEMIES)
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = (s == "" and "Врагов нет" or "Враги: " .. s), Duration = 5 })
    end
})

PlayersTab:CreateButton({
    Name = "🧹 Очистить списки",
    Callback = function()
        FRIENDS = {}
        ENEMIES = {}
        FRIEND_TEAMS = {}
        ENEMY_TEAMS = {}
        getgenv().ELITE_HUB_FRIENDS = FRIENDS
        getgenv().ELITE_HUB_ENEMIES = ENEMIES
        getgenv().ELITE_HUB_FRIEND_TEAMS = FRIEND_TEAMS
        getgenv().ELITE_HUB_ENEMY_TEAMS = ENEMY_TEAMS
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = "Все списки очищены", Duration = 2 })
        RefreshESPColors()
    end
})

PlayersTab:CreateSection("🗺 СПИСОК ИГРОКОВ")

local RowFrames = {}
local RowMeta = {}
local rowSig = ""

local function RowInfo(p)
    return HpOf(p) .. " | " .. TeamOf(p) .. " | " .. RelText(p)
end

local function SetRowThumb(plr, img)
    local uid = plr.UserId
    if ThumbCache[uid] then
        img.Image = ThumbCache[uid]
        return
    end
    task.spawn(function()
        local ok, url = pcall(function()
            return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
        if ok and type(url) == "string" and url ~= "" then
            ThumbCache[uid] = url
            if img and img.Parent then img.Image = url end
        end
    end)
end

local function BuildRow(p, order)
    local row = Instance.new("TextButton")
    row.Text = ""
    row.TextTransparency = 1
    row.BorderSizePixel = 0
    row.BackgroundColor3 = Color3.fromRGB(20, 14, 38)
    row.LayoutOrder = order
    row.Parent = playersTabScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, 34, 0, 34)
    img.Position = UDim2.new(0, 5, 0.5, -17)
    img.BackgroundColor3 = Color3.fromRGB(46, 34, 76)
    img.BackgroundTransparency = 0.4
    img.ScaleType = Enum.ScaleType.Fit
    img.BorderSizePixel = 0
    img.Image = ""
    img.Parent = row
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0, 150, 0, 16)
    nameLbl.Position = UDim2.new(0, 45, 0, 3)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = p.Name
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextSize = 12
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = row

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0, 190, 0, 14)
    sub.Position = UDim2.new(0, 45, 0, 21)
    sub.BackgroundTransparency = 1
    sub.Text = RowInfo(p)
    sub.TextColor3 = Color3.fromRGB(175, 175, 185)
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 10
    sub.TextTruncate = Enum.TextTruncate.AtEnd
    sub.Parent = row

    local btnF = Instance.new("TextButton")
    btnF.Text = "💙"
    btnF.Size = UDim2.new(0, 34, 0, 26)
    btnF.Position = UDim2.new(1, -76, 0.5, -13)
    btnF.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
    btnF.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnF.TextSize = 14
    btnF.BorderSizePixel = 0
    btnF.Parent = row
    Instance.new("UICorner", btnF).CornerRadius = UDim.new(0, 6)
    btnF.MouseButton1Click:Connect(function()
        AddName(FRIENDS, p.Name)
        RemoveName(ENEMIES, p.Name)
        sub.Text = RowInfo(p)
        RefreshESPColors()
    end)

    local btnE = Instance.new("TextButton")
    btnE.Text = "❤️"
    btnE.Size = UDim2.new(0, 34, 0, 26)
    btnE.Position = UDim2.new(1, -39, 0.5, -13)
    btnE.BackgroundColor3 = Color3.fromRGB(120, 30, 40)
    btnE.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnE.TextSize = 14
    btnE.BorderSizePixel = 0
    btnE.Parent = row
    Instance.new("UICorner", btnE).CornerRadius = UDim.new(0, 6)
    btnE.MouseButton1Click:Connect(function()
        AddName(ENEMIES, p.Name)
        RemoveName(FRIENDS, p.Name)
        sub.Text = RowInfo(p)
        RefreshESPColors()
    end)

    row.Activated:Connect(function()
        selectedPlr = p
        selName = p.Name
        RefreshInfo()
    end)

    SetRowThumb(p, img)
    RowMeta[row] = {sub = sub, img = img, p = p}
    return row
end

local function RebuildRows()
    local plrs = Players:GetPlayers()
    local sigParts = {}
    for _, pl in ipairs(plrs) do table.insert(sigParts, pl.Name) end
    table.sort(sigParts)
    local sig = table.concat(sigParts, ",")
    if sig == rowSig then return end
    rowSig = sig

    for _, f in ipairs(RowFrames) do
        pcall(function() f:Destroy() end)
    end
    RowFrames = {}
    RowMeta = {}
    local order = PlayersTab._order + 5
    for _, pl in ipairs(plrs) do
        if pl ~= player then
            local row = BuildRow(pl, order)
            order = order + 1
            table.insert(RowFrames, row)
        end
    end
end

local function UpdateRows()
    for row, meta in pairs(RowMeta) do
        if not row.Parent then
            RowMeta[row] = nil
        else
            meta.sub.Text = RowInfo(meta.p)
        end
    end
end

local function RefreshDDs()
    if pickDD then
        local opts = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then table.insert(opts, p.Name) end
        end
        table.sort(opts)
        pcall(function() pickDD:Refresh(opts) end)
    end
    if teamDD then
        local seen = {}
        local opts = {}
        local function push(tn)
            if tn and tn ~= "" and not seen[tn:lower()] then
                seen[tn:lower()] = true
                table.insert(opts, tn)
            end
        end
        push(GetTeamName(player))
        for _, p in ipairs(Players:GetPlayers()) do push(GetTeamName(p)) end
        table.sort(opts)
        pcall(function() teamDD:Refresh(opts) end)
    end
end

PlayersTab:CreateSection("⚙ НАСТРОЙКИ")

PlayersTab:CreateToggle({
    Name = " Не целяться в друзей",
    CurrentValue = AimbotConfig.FriendCheck,
    Flag = "AimbotFriendCheck",
    Callback = function(value)
        AimbotConfig.FriendCheck = value
    end
})

PlayersTab:CreateToggle({
    Name = " Приоритет врагов",
    CurrentValue = AimbotConfig.EnemyPriority,
    Flag = "AimbotEnemyPriority",
    Callback = function(value)
        AimbotConfig.EnemyPriority = value
    end
})

PlayersTab:CreateToggle({
    Name = " Скрыть друзей в ESP",
    CurrentValue = ESPConfig.FriendCheck,
    Flag = "ESPFriendCheck",
    Callback = function(value)
        ESPConfig.FriendCheck = value
        RefreshESPColors()
    end
})

PlayersTab:CreateToggle({
    Name = " Уведомления вход/выход",
    CurrentValue = AimbotConfig.NotifyPlayerJoin,
    Callback = function(value)
        AimbotConfig.NotifyPlayerJoin = value
        AimbotConfig.NotifyPlayerLeave = value
    end
})

PlayersTab:CreateColorPicker({
    Name = " Цвет друзей (ESP)",
    Color = ESPConfig.FriendColor,
    Callback = function(value)
        ESPConfig.FriendColor = value
        RefreshESPColors()
    end
})

PlayersTab:CreateColorPicker({
    Name = " Цвет врагов (ESP)",
    Color = ESPConfig.EnemyColor,
    Callback = function(value)
        ESPConfig.EnemyColor = value
        RefreshESPColors()
    end
})

RefreshInfo()
task.delay(1, RefreshDDs)
task.delay(2, RebuildRows)

task.spawn(function()
    while true do
        task.wait(0.5)
        RefreshInfo()
        UpdateRows()
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        RefreshDDs()
        RebuildRows()
    end
end)

task.spawn(function()
    while true do
        task.wait(30)
        ThumbCache = {}
    end
end)