-- Anime Sky Full Script v2
-- Запусти — сразу поставит аниме небо с настройками

local url = "https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/main/skybox/anime_sky.jpg"
local lighting = game:GetService("Lighting")

-- === НАСТРОЙКИ ===
local BRIGHTNESS = 2        -- яркость (0.5 - 4)
local CLOCK_TIME = 14.5     -- время суток (0-24, 14-16 = день)
local ATMOS_DENSITY = 0.3   -- плотность атмосферы (0-1)
local ATMOS_COLOR = Color3.fromRGB(180, 200, 255) -- цвет атмосферы
local STAR_COUNT = 500      -- количество звёзд (0 = выкл)
local CLOUDS_DENSITY = 0.4  -- плотность облаков (0-1)
-- =================

local function load()
    local hasReq = (type(request) == "function" or type(http_request) == "function")
    local canWrite = (type(writefile) == "function" and type(isfile) == "function")
    if not (hasReq and canWrite and type(getcustomasset) == "function") then
        warn("Executor не поддерживает request/writefile/getcustomasset")
        return
    end

    local path = "elitehub_anime_sky.jpg"
    if not isfile(path) then
        local res
        if type(request) == "function" then
            res = request({ Url = url, Method = "GET" })
        else
            res = http_request({ Url = url, Method = "GET" })
        end
        if not res or not res.Success then
            warn("Не удалось скачать картинку")
            return
        end
        writefile(path, res.Body)
        task.wait(0.3)
    end

    local ok, asset = pcall(function() return getcustomasset(path) end)
    if not ok or not asset then
        warn("getcustomasset не сработал")
        return
    end

    local sky = lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = lighting
    end

    sky.SkyboxBk = asset
    sky.SkyboxDn = asset
    sky.SkyboxFt = asset
    sky.SkyboxLf = asset
    sky.SkyboxRt = asset
    sky.SkyboxUp = asset

    lighting.Brightness = BRIGHTNESS
    lighting.ClockTime = CLOCK_TIME

    local atmo = lighting:FindFirstChildOfClass("Atmosphere")
    if not atmo then
        atmo = Instance.new("Atmosphere")
        atmo.Parent = lighting
    end
    atmo.Density = ATMOS_DENSITY
    atmo.Color = ATMOS_COLOR

    sky.StarCount = STAR_COUNT

    local clouds = workspace:FindFirstChildOfClass("Clouds")
    if CLOUDS_DENSITY > 0 then
        if not clouds then
            clouds = Instance.new("Clouds")
            clouds.Parent = workspace.Terrain
        end
        clouds.Cover = CLOUDS_DENSITY
        clouds.Density = 0.5
    elseif clouds then
        clouds:Destroy()
    end

    print("Anime Sky v2 установлено!")
end

load()
