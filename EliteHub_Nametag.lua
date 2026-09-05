-- EliteHub Nametag v6 - HTTP через НЕ HttpService
-- Тест: какие функции HTTP доступны в executor'е

local BUCKET = "CnWTikAq6kahaCkrUahVM4"
local TESTKEY = "httptest" .. tostring(math.random(10000, 99999))
local TESTURL = "https://kvdb.io/" .. BUCKET .. "/" .. TESTKEY

warn("=== HTTP ACCESS TEST ===")

-- 1. game:HttpGet
pcall(function()
    local ok, res = pcall(game.HttpGet, game, TESTURL)
    if ok then
        warn("[1] game:HttpGet ✅ WORKS: " .. res)
    else
        warn("[1] game:HttpGet ❌ BLOCKED: " .. tostring(res))
    end
end)

-- 2. game:HttpPost
pcall(function()
    local ok, res = pcall(game.HttpPost, game, TESTURL, "12345")
    if ok then
        warn("[2] game:HttpPost ✅ WORKS")
    else
        warn("[2] game:HttpPost ❌ BLOCKED: " .. tostring(res))
    end
end)

-- 3. syn.request
pcall(function()
    local synRequest = syn and syn.request
    if synRequest then
        local ok, res = pcall(synRequest, { Url = TESTURL, Method = "GET" })
        if ok and res then
            warn("[3] syn.request ✅ WORKS: " .. (res.Body or "empty"))
        else
            warn("[3] syn.request ❌ FAILED: " .. tostring(res))
        end
    else
        warn("[3] syn.request ❌ NOT FOUND")
    end
end)

-- 4. request
pcall(function()
    local req = nil
    if getgenv then
        req = getgenv().request
    elseif _G then
        req = _G.request
    end
    if req then
        local ok, res = pcall(req, { Url = TESTURL, Method = "GET" })
        if ok and res then
            warn("[4] request ✅ WORKS: " .. (res.Body or "empty"))
        else
            warn("[4] request ❌ FAILED: " .. tostring(res))
        end
    else
        warn("[4] request ❌ NOT FOUND")
    end
end)

-- 5. http_request
pcall(function()
    local req = http_request or http and http.request
    if req then
        local ok, res = pcall(req, { Url = TESTURL, Method = "GET" })
        if ok and res then
            warn("[5] http_request ✅ WORKS: " .. (res.Body or "empty"))
        else
            warn("[5] http_request ❌ FAILED: " .. tostring(res))
        end
    else
        warn("[5] http_request ❌ NOT FOUND")
    end
end)

warn("=== TEST SLOT= " .. TESTKEY .. " ===")