-- source: ELITE_HUB_14.0.lua MUSIC (lines 10698-10963)
local _g = getgenv
local Rayfield = _g().ELITE_HUB_Rayfield
local Window = _g().ELITE_HUB_Window
local ES = _g().EliteHubSettings
local L = _g().ELITE_HUB_L
local Log = _g().ELITE_HUB_Log
local Players = _g().ELITE_HUB_Players
local player = _g().ELITE_HUB_Player
local OverlayGui = _g().ELITE_HUB_OverlayGui
local LoadScript = _g().ELITE_HUB_LoadScript
local SafeNotify = _g().ELITE_HUB_SafeNotify
local DestroyScript = _g().ELITE_HUB_DestroyScript
local MT = Window

local MusicTab = _g().ELITE_HUB_MusicTab

getgenv().ELITE_HUB_MusicPlayer = nil
getgenv().ELITE_HUB_MusicVolume = 0.5
getgenv().ELITE_HUB_MusicPlaying = false
getgenv().ELITE_HUB_MusicPlaylist = {}
getgenv().ELITE_HUB_MusicIndex = 1
getgenv().ELITE_HUB_MusicCache = {}

local function ELITE_HUB_MusicGetId(url)
    if url:sub(1, 13) == "rbxassetid://" then return url end
    local hasReq = (type(request) == "function" or type(http_request) == "function")
    local canWrite = (type(writefile) == "function" and type(isfile) == "function")
    if not (hasReq and canWrite and type(getcustomasset) == "function") then
        return nil, "executor lacks request/getcustomasset"
    end
    local fn = url:match("/([^/]+)$") or "track.mp3"
    fn = fn:gsub("[^%w%.%-]", "_")
    local path = "elitehub_" .. fn .. ".mp3"
    if getgenv().ELITE_HUB_MusicCache[path] and isfile(path) then
        return getgenv().ELITE_HUB_MusicCache[path]
    end
    if not isfile(path) then
        local res
        if type(request) == "function" then
            res = request({ Url = url, Method = "GET" })
        else
            res = http_request({ Url = url, Method = "GET" })
        end
        if not res or not res.Success then
            return nil, "download failed for " .. fn
        end
        writefile(path, res.Body)
        task.wait(0.3)
    end
    local ok, asset = pcall(function() return getcustomasset(path) end)
    if not ok or not asset then return nil, "getcustomasset failed for " .. fn end
    getgenv().ELITE_HUB_MusicCache[path] = asset
    return asset
end
getgenv().ELITE_HUB_MusicGetId = ELITE_HUB_MusicGetId

local function ELITE_HUB_MusicStop()
    if getgenv().ELITE_HUB_MusicPlayer then
        pcall(function()
            getgenv().ELITE_HUB_MusicPlayer:Stop()
            getgenv().ELITE_HUB_MusicPlayer:Destroy()
        end)
        getgenv().ELITE_HUB_MusicPlayer = nil
    end
    getgenv().ELITE_HUB_MusicPlaying = false
end
getgenv().ELITE_HUB_MusicStop = ELITE_HUB_MusicStop

local function ELITE_HUB_MusicEnsureSound()
    if not getgenv().ELITE_HUB_MusicPlayer then
        local s = Instance.new("Sound")
        s.Name = "EliteHubMusic"
        s.Volume = getgenv().ELITE_HUB_MusicVolume
        s.Looped = true
        s.PlaybackSpeed = getgenv().ELITE_HUB_MusicPlaybackSpeed or 1
        s.Parent = game:GetService("SoundService")
        getgenv().ELITE_HUB_MusicPlayer = s
    end
    return getgenv().ELITE_HUB_MusicPlayer
end
getgenv().ELITE_HUB_MusicEnsureSound = ELITE_HUB_MusicEnsureSound

local function ELITE_HUB_MusicPlayTrack(track)
    if not track then return end
    task.spawn(function()
        local id, err = ELITE_HUB_MusicGetId(track.url)
        if not id then
            getgenv().ELITE_HUB_Log("MUSIC", "Load error: " .. tostring(err))
            Rayfield:Notify({ Title = "🎵 Error", Content = "Failed: " .. tostring(err), Duration = 3 })
            return
        end
        local snd = ELITE_HUB_MusicEnsureSound()
        snd.Looped = false
        snd.SoundId = id
        snd.PlaybackSpeed = getgenv().ELITE_HUB_MusicPlaybackSpeed or 1
        snd:Play()
        getgenv().ELITE_HUB_MusicPlaying = true
        getgenv().ELITE_HUB_Log("MUSIC", "Playing: " .. track.name)
        if not getgenv().ELITE_HUB_MusicEndConn and type(snd.Ended) == "userdata" then
            getgenv().ELITE_HUB_MusicEndConn = snd.Ended:Connect(function()
                local pl = getgenv().ELITE_HUB_MusicPlaylist
                if not getgenv().ELITE_HUB_MusicPlaying or #pl == 0 then return end
                if getgenv().ELITE_HUB_MusicRepeatOne then
                    ELITE_HUB_MusicPlayTrack(pl[getgenv().ELITE_HUB_MusicIndex])
                    return
                end
                if getgenv().ELITE_HUB_MusicShuffle and #pl > 1 then
                    getgenv().ELITE_HUB_MusicIndex = math.random(1, #pl)
                else
                    getgenv().ELITE_HUB_MusicIndex = (getgenv().ELITE_HUB_MusicIndex % #pl) + 1
                end
                ELITE_HUB_MusicPlayTrack(pl[getgenv().ELITE_HUB_MusicIndex])
            end)
        end
    end)
end
getgenv().ELITE_HUB_MusicPlayTrack = ELITE_HUB_MusicPlayTrack

getgenv().ELITE_HUB_MusicShuffle = false
getgenv().ELITE_HUB_MusicRepeatOne = false
getgenv().ELITE_HUB_MusicPlaybackSpeed = 1

MusicTab:CreateSection("🎵 MUSIC PLAYER")
MusicTab:CreateButton({
    Name = " Load Playlist",
    Callback = function()
        task.spawn(function()
            pcall(function()
                local url = "https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/main/music/playlist.json"
                local json = game:HttpGet(url)
                local HttpService = game:GetService("HttpService")
                getgenv().ELITE_HUB_MusicPlaylist = HttpService:JSONDecode(json)
                local names = {}
                for _, track in ipairs(getgenv().ELITE_HUB_MusicPlaylist) do
                    table.insert(names, track.name)
                end
                musicDropdown:Refresh(names)
                getgenv().ELITE_HUB_Log("MUSIC", "Loaded " .. #getgenv().ELITE_HUB_MusicPlaylist .. " tracks")
                Rayfield:Notify({
                    Title = "🎵 Playlist Loaded",
                    Content = #getgenv().ELITE_HUB_MusicPlaylist .. " tracks available",
                    Duration = 3
                })
            end)
        end)
    end
})

local musicDropdown = MusicTab:CreateDropdown({
    Name = " Select Track",
    Options = {"Load playlist first"},
    CurrentOption = {"Load playlist first"},
    Callback = function(opt)
        for i, track in ipairs(getgenv().ELITE_HUB_MusicPlaylist) do
            if track.name == opt then
                getgenv().ELITE_HUB_MusicIndex = i
                break
            end
        end
    end
})

MusicTab:CreateToggle({
    Name = " Play / Pause",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_Log("MUSIC", "Play: " .. tostring(value))
        if value then
            if not getgenv().ELITE_HUB_MusicPlayer then
                getgenv().ELITE_HUB_MusicPlayer = Instance.new("Sound")
                getgenv().ELITE_HUB_MusicPlayer.Name = "EliteHubMusic"
                getgenv().ELITE_HUB_MusicPlayer.Volume = getgenv().ELITE_HUB_MusicVolume
                getgenv().ELITE_HUB_MusicPlayer.Looped = true
                getgenv().ELITE_HUB_MusicPlayer.Parent = game:GetService("SoundService")
            end
            local playlist = getgenv().ELITE_HUB_MusicPlaylist
            local idx = getgenv().ELITE_HUB_MusicIndex
            if #playlist > 0 and playlist[idx] then
                ELITE_HUB_MusicPlayTrack(playlist[idx])
            end
        else
            ELITE_HUB_MusicStop()
        end
    end
})

MusicTab:CreateButton({
    Name = " Next Track",
    Callback = function()
        local playlist = getgenv().ELITE_HUB_MusicPlaylist
        if #playlist == 0 then return end
        if getgenv().ELITE_HUB_MusicShuffle and #playlist > 1 then
            getgenv().ELITE_HUB_MusicIndex = math.random(1, #playlist)
        else
            getgenv().ELITE_HUB_MusicIndex = (getgenv().ELITE_HUB_MusicIndex % #playlist) + 1
        end
        local track = playlist[getgenv().ELITE_HUB_MusicIndex]
        if ELITE_HUB_MusicPlaying or ELITE_HUB_MusicPlayer then
            ELITE_HUB_MusicPlayTrack(track)
        end
        getgenv().ELITE_HUB_Log("MUSIC", "Next: " .. track.name)
    end
})

MusicTab:CreateButton({
    Name = " Prev Track",
    Callback = function()
        local playlist = getgenv().ELITE_HUB_MusicPlaylist
        if #playlist == 0 then return end
        getgenv().ELITE_HUB_MusicIndex = getgenv().ELITE_HUB_MusicIndex - 1
        if getgenv().ELITE_HUB_MusicIndex < 1 then getgenv().ELITE_HUB_MusicIndex = #playlist end
        local track = playlist[getgenv().ELITE_HUB_MusicIndex]
        if ELITE_HUB_MusicPlaying or ELITE_HUB_MusicPlayer then
            ELITE_HUB_MusicPlayTrack(track)
        end
        getgenv().ELITE_HUB_Log("MUSIC", "Prev: " .. track.name)
    end
})

MusicTab:CreateSlider({
    Name = " Volume",
    Range = {0, 10},
    Increment = 0.5,
    CurrentValue = 0.5,
    Callback = function(value)
        getgenv().ELITE_HUB_MusicVolume = value
        if getgenv().ELITE_HUB_MusicPlayer then
            getgenv().ELITE_HUB_MusicPlayer.Volume = value
        end
    end
})

MusicTab:CreateSlider({
    Name = " Speed",
    Range = {0.5, 2},
    Increment = 0.05,
    CurrentValue = 1,
    Callback = function(value)
        getgenv().ELITE_HUB_MusicPlaybackSpeed = value
        if getgenv().ELITE_HUB_MusicPlayer then
            getgenv().ELITE_HUB_MusicPlayer.PlaybackSpeed = value
        end
        getgenv().ELITE_HUB_Log("MUSIC", "Speed: " .. value)
    end
})

MusicTab:CreateToggle({
    Name = " Shuffle",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_MusicShuffle = value
        getgenv().ELITE_HUB_Log("MUSIC", "Shuffle: " .. tostring(value))
    end
})

MusicTab:CreateToggle({
    Name = " Repeat One",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ELITE_HUB_MusicRepeatOne = value
        getgenv().ELITE_HUB_Log("MUSIC", "Repeat One: " .. tostring(value))
    end
})

MusicTab:CreateButton({
    Name = " Refresh Playlist",
    Callback = function()
        task.spawn(function()
            pcall(function()
                local url = "https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/main/music/playlist.json"
                local json = game:HttpGet(url)
                local HttpService = game:GetService("HttpService")
                getgenv().ELITE_HUB_MusicPlaylist = HttpService:JSONDecode(json)
                local names = {}
                for _, track in ipairs(getgenv().ELITE_HUB_MusicPlaylist) do
                    table.insert(names, track.name)
                end
                musicDropdown:Refresh(names)
                if getgenv().ELITE_HUB_MusicIndex > #getgenv().ELITE_HUB_MusicPlaylist then
                    getgenv().ELITE_HUB_MusicIndex = 1
                end
                getgenv().ELITE_HUB_Log("MUSIC", "Refreshed: " .. #getgenv().ELITE_HUB_MusicPlaylist .. " tracks")
            end)
        end)
    end
})
