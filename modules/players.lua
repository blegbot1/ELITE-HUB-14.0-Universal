-- source: ELITE_HUB_14.0.lua ИГРОКИ (players tab)
local _g = getgenv
local Rayfield = _g().ELITE_HUB_Rayfield
local Players = _g().ELITE_HUB_Players
local player = _g().ELITE_HUB_Player
local PlayersTab = _g().ELITE_HUB_PlayersTab
local AimbotConfig = _g().ELITE_HUB_AimbotConfig
local ESPConfig = _g().ELITE_HUB_ESPConfig
local UpdateESP = _g().ELITE_HUB_UpdateESP or function() end
local GetPlayerRelation = _g().ELITE_HUB_GetPlayerRelation or function() return "none" end

local FRIENDS = getgenv().ELITE_HUB_FRIENDS
local ENEMIES = getgenv().ELITE_HUB_ENEMIES
local FRIEND_TEAMS = getgenv().ELITE_HUB_FRIEND_TEAMS
local ENEMY_TEAMS = getgenv().ELITE_HUB_ENEMY_TEAMS

local playersTabScroll = PlayersTab._scroll

local FriendC = Color3.fromRGB(70, 160, 255)
local EnemyC = Color3.fromRGB(255, 70, 70)
local NeutralC = Color3.fromRGB(120, 120, 130)

local UpdatePlayerRows, UpdateTeamRows, RefreshAllDynamic

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

local function RelColor(p)
    local r = GetPlayerRelation(p)
    if r == "friend" then return FriendC
    elseif r == "enemy" then return EnemyC
    else return NeutralC end
end

local function TeamRelText(tn)
    if HasName(FRIEND_TEAMS, tn) then return "Друг 💙" end
    if HasName(ENEMY_TEAMS, tn) then return "Враг ❤️" end
    return "Нейтрал"
end

local function Avatar(uid, size)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(0, size, 0, size)
    holder.BackgroundColor3 = Color3.fromRGB(46, 34, 76)
    holder.BorderSizePixel = 0
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 8)
    local letter = Instance.new("TextLabel")
    letter.Size = UDim2.new(1, -2, 1, -2)
    letter.Position = UDim2.new(0, 1, 0, 1)
    letter.BackgroundTransparency = 1
    letter.TextColor3 = Color3.fromRGB(205, 205, 215)
    letter.Font = Enum.Font.GothamBold
    letter.TextSize = math.max(12, size * 0.4)
    letter.Text = "?"
    letter.Parent = holder
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, -2, 1, -2)
    img.Position = UDim2.new(0, 1, 0, 1)
    img.BackgroundTransparency = 1
    img.ScaleType = Enum.ScaleType.Fit
    img.BorderSizePixel = 0
    img.Image = ""
    img.Parent = holder
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)
    if uid then
        letter.Text = string.sub(tostring(uid), 1, 1):upper()
        img.Image = "rbxthumb://type=AvatarHeadShot&id=" .. uid .. "&w=420&h=420"
    end
    return holder, letter, img
end

PlayersTab:CreateSection("🔍 ИГРОК")

local pickDD = nil
local selectedPlr = nil
local selName = ""

local infoCard, infoLetter, infoImg = Avatar(0, 64)
infoCard.LayoutOrder = PlayersTab._order
PlayersTab._order = PlayersTab._order + 1
infoCard.Parent = playersTabScroll

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
        infoLetter.Text = "?"
        infoImg.Image = ""
        return
    end
    infoName:Set("Имя: " .. p.Name)
    infoTeam:Set("Команда: " .. TeamOf(p))
    infoHp:Set("HP: " .. HpOf(p))
    infoRel:Set("Связь: " .. RelText(p))
    infoLetter.Text = string.sub(p.Name, 1, 1):upper()
    infoImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=420&h=420"
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
        RefreshAllDynamic()
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
        RefreshAllDynamic()
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
        RefreshAllDynamic()
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

PlayersTab:CreateSection("👥 ИГРОКИ")

local playersList = Instance.new("Frame")
playersList.Name = "PlayersList"
playersList.BackgroundTransparency = 1
playersList.BorderSizePixel = 0
playersList.Size = UDim2.new(1, -4, 0, 0)
playersList.AutomaticSize = Enum.AutomaticSize.Y
playersList.LayoutOrder = PlayersTab._order
PlayersTab._order = PlayersTab._order + 1
playersList.Parent = playersTabScroll
local pListLayout = Instance.new("UIListLayout")
pListLayout.Padding = UDim.new(0, 4)
pListLayout.SortOrder = Enum.SortOrder.LayoutOrder
pListLayout.Parent = playersList

local PlayerRows = {}
local PlayerRowMeta = {}
local playerRowSig = ""

local function PlayerRowItem(p)
    local row = Instance.new("TextButton")
    row.Text = ""
    row.TextTransparency = 1
    row.BorderSizePixel = 0
    row.BackgroundColor3 = Color3.fromRGB(20, 14, 38)
    row.Size = UDim2.new(1, 0, 0, 52)
    row.LayoutOrder = #PlayerRows + 1
    row.Parent = playersList
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local holder, letter, img = Avatar(p.UserId, 40)
    holder.Position = UDim2.new(0, 6, 0.5, -20)
    holder.Parent = row

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -170, 0, 18)
    nameLbl.Position = UDim2.new(0, 52, 0, 3)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = p.Name
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = row

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -170, 0, 14)
    sub.Position = UDim2.new(0, 52, 0, 25)
    sub.BackgroundTransparency = 1
    sub.Text = HpOf(p) .. "  |  " .. TeamOf(p)
    sub.TextColor3 = Color3.fromRGB(175, 175, 185)
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 10
    sub.TextTruncate = Enum.TextTruncate.AtEnd
    sub.Parent = row

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(1, -118, 0.5, -5)
    dot.BackgroundColor3 = RelColor(p)
    dot.BorderSizePixel = 0
    dot.Parent = row
    Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 5)

    local btnF = Instance.new("TextButton")
    btnF.Text = "💙"
    btnF.Size = UDim2.new(0, 32, 0, 26)
    btnF.Position = UDim2.new(1, -80, 0.5, -13)
    btnF.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
    btnF.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnF.TextSize = 14
    btnF.BorderSizePixel = 0
    btnF.Parent = row
    Instance.new("UICorner", btnF).CornerRadius = UDim.new(0, 6)
    btnF.MouseButton1Click:Connect(function()
        AddName(FRIENDS, p.Name)
        RemoveName(ENEMIES, p.Name)
        UpdatePlayerRows()
        RefreshESPColors()
    end)

    local btnE = Instance.new("TextButton")
    btnE.Text = "❤️"
    btnE.Size = UDim2.new(0, 32, 0, 26)
    btnE.Position = UDim2.new(1, -42, 0.5, -13)
    btnE.BackgroundColor3 = Color3.fromRGB(120, 30, 40)
    btnE.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnE.TextSize = 14
    btnE.BorderSizePixel = 0
    btnE.Parent = row
    Instance.new("UICorner", btnE).CornerRadius = UDim.new(0, 6)
    btnE.MouseButton1Click:Connect(function()
        AddName(ENEMIES, p.Name)
        RemoveName(FRIENDS, p.Name)
        UpdatePlayerRows()
        RefreshESPColors()
    end)

    row.Activated:Connect(function()
        selectedPlr = p
        selName = p.Name
        RefreshInfo()
    end)

    table.insert(PlayerRows, row)
    PlayerRowMeta[row] = {sub = sub, dot = dot, p = p}
end

UpdatePlayerRows = function()
    for row, meta in pairs(PlayerRowMeta) do
        if not row.Parent then
            PlayerRowMeta[row] = nil
        else
            meta.sub.Text = HpOf(meta.p) .. "  |  " .. TeamOf(meta.p)
            meta.dot.BackgroundColor3 = RelColor(meta.p)
        end
    end
end

local function RebuildPlayerRows()
    local plrs = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= player then table.insert(plrs, pl) end
    end
    table.sort(plrs, function(a, b) return a.Name:lower() < b.Name:lower() end)
    local parts = {}
    for _, pl in ipairs(plrs) do table.insert(parts, pl.Name) end
    local sig = table.concat(parts, ",")
    if sig == playerRowSig then return end
    playerRowSig = sig
    for _, r in ipairs(PlayerRows) do
        pcall(function() r:Destroy() end)
    end
    PlayerRows = {}
    PlayerRowMeta = {}
    for _, pl in ipairs(plrs) do
        PlayerRowItem(pl)
    end
end

PlayersTab:CreateSection("🏅 КОМАНДЫ")

local teamsList = Instance.new("Frame")
teamsList.Name = "TeamsList"
teamsList.BackgroundTransparency = 1
teamsList.BorderSizePixel = 0
teamsList.Size = UDim2.new(1, -4, 0, 0)
teamsList.AutomaticSize = Enum.AutomaticSize.Y
teamsList.LayoutOrder = PlayersTab._order
PlayersTab._order = PlayersTab._order + 1
teamsList.Parent = playersTabScroll
local tListLayout = Instance.new("UIListLayout")
tListLayout.Padding = UDim.new(0, 4)
tListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tListLayout.Parent = teamsList

local TeamRows = {}
local TeamRowMeta = {}
local teamSig = ""

local function TeamInfoList()
    local seen = {}
    local res = {}
    local myTeam = GetTeamName(player)
    local function push(tn)
        if not tn or tn == "" or seen[tn:lower()] then return end
        seen[tn:lower()] = true
        local members = {}
        if myTeam and myTeam:lower() == tn:lower() then table.insert(members, player) end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= player and GetTeamName(pl) and GetTeamName(pl):lower() == tn:lower() then
                table.insert(members, pl)
            end
        end
        table.sort(members, function(a, b) return a.Name:lower() < b.Name:lower() end)
        table.insert(res, {name = tn, members = members})
    end
    push(myTeam)
    for _, pl in ipairs(Players:GetPlayers()) do push(GetTeamName(pl)) end
    table.sort(res, function(a, b) return a.name:lower() < b.name:lower() end)
    return res
end

local function TeamRowItem(t)
    local row = Instance.new("Frame")
    row.BorderSizePixel = 0
    row.BackgroundColor3 = Color3.fromRGB(20, 14, 38)
    row.Size = UDim2.new(1, 0, 0, 58)
    row.LayoutOrder = #TeamRows + 1
    row.Parent = teamsList
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local shown = math.min(#t.members, 4)
    local stripW = shown * 32 + 4
    local strip = Instance.new("Frame")
    strip.BackgroundTransparency = 1
    strip.BorderSizePixel = 0
    strip.Size = UDim2.new(0, stripW, 0, 34)
    strip.Position = UDim2.new(0, 6, 0.5, -17)
    strip.Parent = row
    local sLayout = Instance.new("UIListLayout")
    sLayout.Padding = UDim.new(0, 2)
    sLayout.FillDirection = Enum.FillDirection.Horizontal
    sLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    sLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sLayout.Parent = strip
    for i = 1, shown do
        local h, l, im = Avatar(t.members[i].UserId, 30)
        h.LayoutOrder = i
        h.Parent = strip
    end
    if #t.members > shown then
        local more = Instance.new("TextLabel")
        more.Size = UDim2.new(0, 20, 0, 18)
        more.Position = UDim2.new(0, shown * 32 + 6, 0.5, -9)
        more.BackgroundTransparency = 1
        more.Text = "+" .. (#t.members - shown)
        more.TextColor3 = Color3.fromRGB(175, 175, 185)
        more.Font = Enum.Font.GothamBold
        more.TextSize = 11
        more.Parent = strip
    end

    local xOff = stripW + 12
    local tname = Instance.new("TextLabel")
    tname.Size = UDim2.new(1, -(xOff + 110), 0, 16)
    tname.Position = UDim2.new(0, xOff, 0, 5)
    tname.BackgroundTransparency = 1
    tname.Text = t.name
    tname.TextColor3 = Color3.fromRGB(255, 255, 255)
    tname.TextXAlignment = Enum.TextXAlignment.Left
    tname.Font = Enum.Font.GothamBold
    tname.TextSize = 13
    tname.TextTruncate = Enum.TextTruncate.AtEnd
    tname.Parent = row

    local rel = Instance.new("TextLabel")
    rel.Size = UDim2.new(1, -(xOff + 110), 0, 14)
    rel.Position = UDim2.new(0, xOff, 0, 26)
    rel.BackgroundTransparency = 1
    rel.Text = TeamRelText(t.name)
    rel.TextColor3 = Color3.fromRGB(175, 175, 185)
    rel.TextXAlignment = Enum.TextXAlignment.Left
    rel.Font = Enum.Font.GothamMedium
    rel.TextSize = 10
    rel.TextTruncate = Enum.TextTruncate.AtEnd
    rel.Parent = row

    local btnF = Instance.new("TextButton")
    btnF.Text = "💙"
    btnF.Size = UDim2.new(0, 32, 0, 26)
    btnF.Position = UDim2.new(1, -80, 0.5, -13)
    btnF.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
    btnF.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnF.TextSize = 14
    btnF.BorderSizePixel = 0
    btnF.Parent = row
    Instance.new("UICorner", btnF).CornerRadius = UDim.new(0, 6)
    btnF.MouseButton1Click:Connect(function()
        AddName(FRIEND_TEAMS, t.name)
        RemoveName(ENEMY_TEAMS, t.name)
        UpdateTeamRows()
        RefreshESPColors()
    end)

    local btnE = Instance.new("TextButton")
    btnE.Text = "❤️"
    btnE.Size = UDim2.new(0, 32, 0, 26)
    btnE.Position = UDim2.new(1, -42, 0.5, -13)
    btnE.BackgroundColor3 = Color3.fromRGB(120, 30, 40)
    btnE.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnE.TextSize = 14
    btnE.BorderSizePixel = 0
    btnE.Parent = row
    Instance.new("UICorner", btnE).CornerRadius = UDim.new(0, 6)
    btnE.MouseButton1Click:Connect(function()
        AddName(ENEMY_TEAMS, t.name)
        RemoveName(FRIEND_TEAMS, t.name)
        UpdateTeamRows()
        RefreshESPColors()
    end)

    table.insert(TeamRows, row)
    TeamRowMeta[row] = {rel = rel, name = t.name}
end

UpdateTeamRows = function()
    for row, meta in pairs(TeamRowMeta) do
        if not row.Parent then
            TeamRowMeta[row] = nil
        else
            meta.rel.Text = TeamRelText(meta.name)
        end
    end
end

local function RebuildTeamRows()
    local info = TeamInfoList()
    local parts = {}
    for _, t in ipairs(info) do table.insert(parts, t.name) end
    local sig = table.concat(parts, ",")
    if sig == teamSig then return end
    teamSig = sig
    for _, r in ipairs(TeamRows) do
        pcall(function() r:Destroy() end)
    end
    TeamRows = {}
    TeamRowMeta = {}
    for _, t in ipairs(info) do
        TeamRowItem(t)
    end
end

RefreshAllDynamic = function()
    RebuildPlayerRows()
    RebuildTeamRows()
    UpdatePlayerRows()
    UpdateTeamRows()
    RefreshESPColors()
end

PlayersTab:CreateSection("📋 СПИСКИ")

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
        for i = #FRIENDS, 1, -1 do table.remove(FRIENDS, i) end
        for i = #ENEMIES, 1, -1 do table.remove(ENEMIES, i) end
        for i = #FRIEND_TEAMS, 1, -1 do table.remove(FRIEND_TEAMS, i) end
        for i = #ENEMY_TEAMS, 1, -1 do table.remove(ENEMY_TEAMS, i) end
        Rayfield:Notify({ Title = "👥 ИГРОКИ", Content = "Все списки очищены", Duration = 2 })
        RefreshAllDynamic()
    end
})

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
task.delay(1, RefreshAllDynamic)

local function RefreshDDs()
    if pickDD then
        local opts = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then table.insert(opts, p.Name) end
        end
        table.sort(opts)
        pcall(function() pickDD:Refresh(opts) end)
    end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        RefreshInfo()
        UpdatePlayerRows()
        UpdateTeamRows()
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        RefreshDDs()
        RebuildPlayerRows()
        RebuildTeamRows()
    end
end)