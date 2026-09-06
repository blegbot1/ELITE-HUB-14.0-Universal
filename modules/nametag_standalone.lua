-- EliteHub Nametag v7 - HTTP presence sync (HttpService-free)
-- Использует game:HttpGet / game:HttpPost / request — они не забанены
-- Каждый клиент шлёт heartbeat на kvdb.io, другие читают и показывают бейдж ТОЛЬКО им

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Защита от повторного запуска: убиваем предыдущий инстанс
local env = getgenv and getgenv() or _G
if env._EliteHubNametagThreads then
    for _, th in ipairs(env._EliteHubNametagThreads) do
        pcall(coroutine.close, th)
    end
end
env._EliteHubNametagThreads = {}

local BUCKET = "CnWTikAq6kahaCkrUahVM4"
local PING = 8      -- heartbeat каждые 8с
local POLL = 6      -- опрос списка каждые 6с
local STALE = 25    -- считать мёртвым после 25с тишины

local NAME = player.Name
local detected = {}   -- name -> true
local lastHeard = {}  -- name -> os.time()
local httpDel = request or http_request or (http and http.request)

local function base(extra)
    return "https://kvdb.io/" .. BUCKET .. "/" .. (extra or "")
end

local function httpGet(url)
    return game:HttpGet(url, true)
end

local function httpPost(url, data)
    game:HttpPost(url, data, "text/plain")
end

local function httpDelete(url)
    if httpDel then
        httpDel({ Url = url, Method = "DELETE" })
    end
end

local function showTag(hrp)
    if hrp:FindFirstChild("EliteHubTag") then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "EliteHubTag"
    bb.AlwaysOnTop = true
    bb.ExtentsOffset = Vector3.new(0, 3, 0)
    bb.Size = UDim2.new(0, 120, 0, 20)
    bb.Adornee = hrp
    bb.Parent = hrp

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
    bg.BackgroundTransparency = 0.1
    bg.BorderSizePixel = 0
    bg.Parent = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "ELITE HUB"
    lbl.TextColor3 = Color3.fromRGB(220, 180, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.Parent = bg
end

local function tagPlayer(name)
    local p = Players:FindFirstChild(name)
    if p and p.Character then
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            showTag(hrp)
            return true
        end
    end
    return false
end

-- Heartbeat: POST свой ник с текущим временем
local th1 = task.spawn(function()
    local url = base(NAME)
    while task.wait(PING) do
        local ok, err = pcall(function()
            httpPost(url, tostring(os.time()))
        end)
        if not ok then
            warn("[EliteHub Nametag] ❌ HEARTBEAT FAILED: " .. tostring(err))
        end
    end
end)
table.insert(env._EliteHubNametagThreads, th1)

-- Опрос: GET список ников, проверяем кто живой
local th2 = task.spawn(function()
    local listUrl = base()
    local counter = 0
    while task.wait(POLL) do
        local ok, err = pcall(function()
            counter = counter + 1
            local body = httpGet(listUrl)
            local now = os.time()

            for name in (body .. "\n"):gmatch("([^\n]+)\n") do
                if name ~= NAME then
                    if not detected[name] then
                        -- новый ник - проверяем свежесть
                        local ts = tonumber(httpGet(base(name)))
                        if ts and (now - ts) <= STALE then
                            lastHeard[name] = ts
                            if tagPlayer(name) then
                                detected[name] = true
                                warn("[EliteHub Nametag] Detected user: " .. name)
                            end
                        end
                    else
                        -- уже помечен - следим чтобы не уснул
                        if counter % 3 == 0 then
                            local ts = tonumber(httpGet(base(name)))
                            if not ts or (now - ts) > STALE then
                                detected[name] = nil
                                lastHeard[name] = nil
                                httpDelete(base(name))
                                warn("[EliteHub Nametag] User left (stale): " .. name)
                            end
                        end
                    end
                end
            end

            -- если сервер пуст - чистим список детекций
            if not body or body == "" then
                detected = {}
                lastHeard = {}
            end
        end)
        if not ok then
            warn("[EliteHub Nametag] ❌ POLL FAILED: " .. tostring(err))
        end
    end
end)
table.insert(env._EliteHubNametagThreads, th2)

warn("[EliteHub Nametag] HTTP sync active. Player: " .. NAME .. " bucket: " .. BUCKET)