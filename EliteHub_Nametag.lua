-- EliteHub Nametag v5 - HTTP presence sync
-- Каждый клиент шлёт heartbeat на kvdb.io (общий бакет)
-- Другие клиенты читают список живых и показывают бейдж ТОЛЬКО им
-- Запуск: loadstring(game:HttpGet(".../EliteHub_Nametag.lua"))()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local BUCKET = "CnWTikAq6kahaCkrUahVM4"
local PING = 8      -- heartbeat каждые 8с
local POLL = 6      -- опрос списка каждые 6с
local STALE = 25    -- считать мёртвым после 25с тишины

local NAME = player.Name
local detected = {}   -- name -> true
local lastHeard = {}  -- name -> os.time()

warn("[EliteHub Nametag] HTTP sync loaded. Player: " .. NAME)

local function base(extra)
    return "https://kvdb.io/" .. BUCKET .. "/" .. (extra or "")
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
task.spawn(function()
    local url = base(NAME)
    while task.wait(PING) do
        pcall(function()
            HttpService:PostAsync(url, tostring(os.time()))
        end)
    end
end)

-- Опрос: GET список ников, проверяем кто живой
task.spawn(function()
    local listUrl = base()
    local counter = 0
    while task.wait(POLL) do
        pcall(function()
            counter = counter + 1
            local body = HttpService:GetAsync(listUrl)
            local now = os.time()

            for name in (body .. "\n"):gmatch("([^\n]+)\n") do
                if name ~= NAME then
                    if not detected[name] then
                        -- новый ник - проверяем свежесть
                        local ok, tsStr = pcall(HttpService.GetAsync, HttpService, base(name))
                        local ts = ok and tonumber(tsStr) or nil
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
                            local ok, tsStr = pcall(HttpService.GetAsync, HttpService, base(name))
                            local ts = ok and tonumber(tsStr) or nil
                            if ts and (now - ts) > STALE then
                                detected[name] = nil
                                lastHeard[name] = nil
                                pcall(HttpService.RequestAsync, HttpService, { Url = base(name), Method = "DELETE" })
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
    end
end)

warn("[EliteHub Nametag] Presence sync active. Waiting for other users...")