-- source: ELITE_HUB_14.0.lua FEScripts (lines 2799-3126)
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
local FEScriptsTab = _g().ELITE_HUB_FEScriptsTab

--[[
    ==============================
    РќРћР’РђРЇ Р’РљР›РђР”РљРђ FE РЎРљР РРџРўР«
    ==============================
]]--
local FEBasicSection = FEScriptsTab:CreateSection("🛡 CORE FE SCRIPTS")

FEScriptsTab:CreateButton({
    Name = " Fe Punch (R15/R6)",
    Callback = function()
        LoadScript(" Fe Punch", "https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Neko (R6 only)",
    Callback = function()
        LoadScript(" Fe Neko", "https://raw.githubusercontent.com/Gazer-Ha/Neko-v1/main/Extremely%20Broken")
    end
})
FEScriptsTab:CreateButton({
    Name = " Fe Gale Fighter (R6 only)",
    Callback = function()
        LoadScript(" Fe Gale Fighter", "https://pastebin.com/raw/XPGSMEw9")
    end
})
FEScriptsTab:CreateButton({
    Name = " Fe KJ (R6 only)",
    Callback = function()
        LoadScript(" Fe KJ", "https://pastefy.app/sdAujywd/raw")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Caducus (R6 only)",
    Callback = function()
        LoadScript(" Fe Caducus", "https://pastebin.com/raw/LDL9AyQ4")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Sonic (R6 only)",
    Callback = function()
        LoadScript(" Fe Sonic", "https://pastebin.com/raw/uacVtsWe")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Sad Boy (R6 only)",
    Callback = function()
        LoadScript(" Fe Sad Boy", "https://pastebin.com/raw/hgPJbwF0")
    end
})

FEScriptsTab:CreateButton({
    Name = " The Villain Loader",
    Callback = function()
        LoadScript(" The Villain Loader", "https://raw.githubusercontent.com/Jskfhggjxu/My-Script/refs/heads/main/The-Villain-Loader")
    end
})

local FEUtilitiesSection = FEScriptsTab:CreateSection("🔧 FE UTILITIES")

FEScriptsTab:CreateButton({
    Name = " Fe G-Man (R6 only)",
    Callback = function()
        _G.clientsidedeffect = true
        LoadScript(" Fe G-Man", "https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty18.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Car (R15/R6)",
    Callback = function()
        LoadScript(" Fe Car", "https://raw.githubusercontent.com/AlexCr4sh/FeScripts/main/FeCarScript.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Fighter (R6 only)",
    Callback = function()
        LoadScript(" Fe Fighter", "https://rawscripts.net/raw/Universal-Script-FE-Fighter-inspired-by-Gale-21557")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Hug (All Games)",
    Callback = function()
        LoadScript(" Fe Hug", "https://rawscripts.net/raw/Universal-Script-Hug-Gui-R6-17818")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Honored (R6 only)",
    Callback = function()
        LoadScript(" Fe Honored", "https://raw.githubusercontent.com/Cortzalno666/NectoVerse-Industries-Data/master/Scripts%20Folder/Honored.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Invisible (All Games)",
    Callback = function()
        LoadScript(" Fe Invisible", "https://pastebin.com/raw/3Rnd9rHf")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe NPC Control (R6 only)",
    Callback = function()
        LoadScript(" Fe NPC Control", "https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty13.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Telekinesis V5",
    Callback = function()
        LoadScript(" Fe Telekinesis V5", "https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty11.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Tool Draw",
    Callback = function()
        LoadScript(" Fe Tool Draw", "https://raw.githubusercontent.com/Affexter/Programs/refs/heads/main/scripts/tooldrawFE.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Zombie (R6/R15)",
    Callback = function()
        LoadScript(" Fe Zombie", "https://pastefy.app/w7KnPY70/raw")
    end
})

local FEEffectsSection = FEScriptsTab:CreateSection("✨ FE EFFECTS")

FEScriptsTab:CreateButton({
    Name = " Fe Blackhole",
    Callback = function()
        LoadScript(" Fe Blackhole", "https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BringFlingPlayers")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Radius Blackhole",
    Callback = function()
        LoadScript(" Fe Radius Blackhole", "https://pastebin.com/raw/RkWYLL5t")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Super Ring V4",
    Callback = function()
        LoadScript(" Fe Super Ring V4", "https://rawscripts.net/raw/Natural-Disaster-Survival-Super-ring-V4-24296")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Audio Spam",
    Callback = function()
        LoadScript(" Fe Audio Spam", "https://pastebin.com/raw/kmXCTkBt")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Goner Divine Edge (R6 only)",
    Callback = function()
        LoadScript(" Fe Goner Divine Edge", "https://pastebin.com/raw/sFf9MeBE")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Crystal Dance (R6 only)",
    Callback = function()
        LoadScript(" Fe Crystal Dance", "https://pastebin.com/raw/vT1URaRJ")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Jerk (R15/R6)",
    Callback = function()
        LoadScript(" Fe Jerk", "https://pastefy.app/YZoglOyJ/raw")
    end
})

local GenesisFESection = FEScriptsTab:CreateSection("🔰 GENESIS FE SCRIPTS")

FEScriptsTab:CreateButton({
    Name = " Fe Ban Hammer",
    Callback = function()
        LoadScript(" Fe Ban Hammer", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Ban%20Hammer")
    end
})

FEScriptsTab:CreateButton({
    Name = " FE Neptunian V",
    Callback = function()
        LoadScript(" FE Neptunian V", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Neptunian%20V")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Linked Sword",
    Callback = function()
        LoadScript(" Fe Linked Sword", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Linked%20Sword")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Star Glicher",
    Callback = function()
        LoadScript(" Fe Star Glicher", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Star%20Glitcher")
    end
})

FEScriptsTab:CreateButton({
    Name = " FE AK-47 (Da Hood)",
    Callback = function()
        LoadScript(" FE AK-47", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/AK-47")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Krystal Dance",
    Callback = function()
        LoadScript(" Fe Krystal Dance", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Krystal%20Dance")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Good Cop Bad Cop",
    Callback = function()
        LoadScript(" Fe Good Cop Bad Cop", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Good%20Cop%20Bad%20Cop")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Gale Fighter",
    Callback = function()
        LoadScript(" Fe Gale Fighter", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Gale%20Fighter")
    end
})

FEScriptsTab:CreateButton({
    Name = " FE Dearsister Pistol",
    Callback = function()
        LoadScript(" FE Dearsister Pistol", "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Dearsister")
    end
})

local FEAnimationsSection = FEScriptsTab:CreateSection("💃 FE ANIMATIONS")

FEScriptsTab:CreateButton({
    Name = " Fe Animation Man (R6 only)",
    Callback = function()
        LoadScript(" Fe Animation Man", "https://pastefy.app/ZWgckZdU/raw")
    end
})
FEScriptsTab:CreateButton({
    Name = " Fe Animation Walk (R15)",
    Callback = function()
        LoadScript(" Fe Animation Walk", "https://pastebin.com/raw/T7kdfUmG")
    end
})

FEScriptsTab:CreateButton({
    Name = " Fe Get Sturdy (Baseplate)",
    Callback = function()
        LoadScript(" Fe Get Sturdy", "https://pastebin.com/raw/xAHFn1hh")
    end
})
FEScriptsTab:CreateButton({
    Name = " Fe Emotes (R15 only)",
    Callback = function()
        LoadScript(" Fe Emotes", "https://pastebin.com/raw/eCpipCTH")
    end
})

local AdditionalFESection = FEScriptsTab:CreateSection("➕ EXTRA FE SCRIPTS")
local FEUtilitiesSection2 = FEScriptsTab:CreateSection("💰 POPULAR UTILITIES")

FEScriptsTab:CreateButton({
    Name = " Infinite Yield",
    Callback = function()
        LoadScript(" Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end
})

FEScriptsTab:CreateButton({
    Name = " Dark Dex V3",
    Callback = function()
        LoadScript(" Dark Dex V3", "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = " Remote Spy",
    Callback = function()
        LoadScript(" Remote Spy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = " Unnamed ESP",
    Callback = function()
        LoadScript(" Unnamed ESP", "https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua")
    end
})

FEScriptsTab:CreateButton({
    Name = " CMD-X",
    Callback = function()
        LoadScript(" CMD-X", "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source")
    end
})

FEScriptsTab:CreateButton({
    Name = " Hydroxide",
    Callback = function()
        LoadScript(" Hydroxide", "https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/init.lua")
    end
})
FEScriptsTab:CreateButton({
    Name = " FPS Booster",
    Callback = function()
        LoadScript(" FPS Booster", "https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua")
    end
})