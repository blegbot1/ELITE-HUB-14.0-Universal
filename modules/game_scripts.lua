-- source: ELITE_HUB_14.0.lua GameScripts (lines 3127-4439)
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
local GameScriptsTab = _g().ELITE_HUB_GameScriptsTab

--[[
    ==============================
    Р’РљР›РђР”РљРђ РЎРљР РРџРўРћР’ Р”Р›РЇ РР“Р 
    ==============================
]]--

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџ› пёЏ VISUALS & TOOLS (TOP PICKS)
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("👁 VISUALS & TOOLS")

GameScriptsTab:CreateButton({
    Name = " Sp3arParvus v4.2.9 (ESP+Aimbot+Explorer)",
    Callback = function()
        LoadScript(" Sp3arParvus v4.2.9", "https://raw.githubusercontent.com/JakeHukari/Sp3arParvus/refs/heads/main/Sp3arParvus.lua")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЊџ UNIVERSAL HUBS (30+ РёРіСЂ РєР°Р¶РґС‹Р№)
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection(" UNIVERSAL HUBS")

GameScriptsTab:CreateButton({
    Name = " Infinite Yield (400+ cmds)",
    Callback = function()
        LoadScript(" Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
    end
})
GameScriptsTab:CreateButton({
    Name = " CanHub V2 (150+ games, KEYLESS)",
    Callback = function()
        LoadScript(" CanHub V2", "https://canhub.dev")
    end
})
GameScriptsTab:CreateButton({
    Name = " Forge Hub (40+ games)",
    Callback = function()
        LoadScript(" Forge Hub", "https://rawscripts.net/raw/Universal-Script-Forge-Hub-41461")
    end
})
GameScriptsTab:CreateButton({
    Name = " Ronix Hub (154+ games)",
    Callback = function()
        LoadScript(" Ronix Hub", "https://api.luarmor.net/files/v3/loaders/b581d07bfd134ff4ea612d671361be77.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Ghost Hub (MM2, Blox Fruits, etc)",
    Callback = function()
        LoadScript(" Ghost Hub", "https://ghost-hub-scripts.github.io/ghost/")
    end
})
GameScriptsTab:CreateButton({
    Name = " Snowy Hub (40+ games)",
    Callback = function()
        LoadScript(" Snowy Hub", "https://api.luarmor.net/files/v3/loaders/snowyhub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Lunar Hub (10+ games)",
    Callback = function()
        LoadScript(" Lunar Hub", "https://api.luarmor.net/files/v3/loaders/lunarhub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " PreciseWare Hub (Universal)",
    Callback = function()
        LoadScript(" PreciseWare", "https://api.luarmor.net/files/v3/loaders/preciseware.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Velocity Hub (All Games ESP)",
    Callback = function()
        LoadScript(" Velocity Hub", "https://raw.githubusercontent.com/Actyrn/Scripts/main/AzureModded")
    end
})
GameScriptsTab:CreateButton({
    Name = " Lumin Hub (GAG2, etc)",
    Callback = function()
        LoadScript(" Lumin Hub", "https://api.luarmor.net/files/v3/loaders/luminhub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Flow Hub (23 games)",
    Callback = function()
        LoadScript(" Flow Hub", "https://api.luarmor.net/files/v3/loaders/flowhub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " King's Hub (7+ games)",
    Callback = function()
        LoadScript(" King's Hub", "https://api.luarmor.net/files/v3/loaders/kingshub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Kak Hub (Universal)",
    Callback = function()
        LoadScript(" Kak Hub", "https://api.luarmor.net/files/v3/loaders/kakhub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Raptor Hub (Universal)",
    Callback = function()
        LoadScript(" Raptor Hub", "https://api.luarmor.net/files/v3/loaders/raptorhub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Awesome Hub (FPS games)",
    Callback = function()
        LoadScript(" Awesome Hub", "https://api.luarmor.net/files/v3/loaders/awesomehub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " RiftHub (Arsenal, FPS)",
    Callback = function()
        LoadScript(" RiftHub", "https://api.luarmor.net/files/v3/loaders/rifthub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Atherhub (25+ games)",
    Callback = function()
        LoadScript(" Atherhub", "https://api.luarmor.net/files/v3/loaders/atherhub.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Project Kobran (Universal)",
    Callback = function()
        LoadScript(" Project Kobran", "https://api.luarmor.net/files/v3/loaders/projectkobran.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Lunax Hub (Universal)",
    Callback = function()
        LoadScript(" Lunax Hub", "https://raw.githubusercontent.com/Alexisisback/Lunax/refs/heads/main/Loader.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Skibidi Hub (240+ games)",
    Callback = function()
        LoadScript(" Skibidi Hub", "https://api.luarmor.net/files/v3/loaders/skibidihub.lua")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- вљ”пёЏ RIVALS (FPS)
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("⚔ RIVALS")

GameScriptsTab:CreateButton({
    Name = " Rivals Auto Farm",
    Callback = function()
        LoadScript(" Rivals Auto Farm", "https://api.luarmor.net/files/v3/loaders/212c1198a1beacf31150a8cf339ba288.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " KiciaHook Rivals",
    Callback = function()
        LoadScript(" KiciaHook Rivals", "https://raw.githubusercontent.com/kiciahook/kiciahook/refs/heads/main/loader.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Xera Script Rivals",
    Callback = function()
        LoadScript(" Xera Script Rivals", "https://raw.githubusercontent.com/luascriptsROBLOX/Xerar/refs/heads/main/RivalsxeraPBF")
    end
})
GameScriptsTab:CreateButton({
    Name = " Minimal Hub Rivals",
    Callback = function()
        LoadScript(" Minimal Hub Rivals", "https://raw.githubusercontent.com/MinimalScriptingService/MinimalRivals/main/rivals.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " RIVALS ByNami",
    Callback = function()
        LoadScript(" RIVALS ByNami", "https://raw.githubusercontent.com/ByNami/RIVALS/main/RIVALS.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Soluna Script Rivals",
    Callback = function()
        LoadScript(" Soluna Script Rivals", "https://soluna-script.vercel.app/main.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Ember Hub Rivals",
    Callback = function()
        LoadScript(" Ember Hub Rivals", "https://raw.githubusercontent.com/scripter66/EmberHub/refs/heads/main/Rivals.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Zypherion Rivals",
    Callback = function()
        LoadScript(" Zypherion Rivals", "https://raw.githubusercontent.com/blackowl1231/ZYPHERION/refs/heads/main/main.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Kona3366 Rivals",
    Callback = function()
        LoadScript(" Kona3366 Rivals", "https://raw.githubusercontent.com/kona3366/rivals-script/main/main.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Venoxware Rivals",
    Callback = function()
        LoadScript(" Venoxware Rivals", "https://raw.githubusercontent.com/venoxcc/universalscripts/refs/heads/main/rivals/venoxware")
    end
})
GameScriptsTab:CreateButton({
    Name = " Nivex Loader Rivals",
    Callback = function()
        LoadScript(" Nivex Loader Rivals", "https://raw.githubusercontent.com/Nivex123456/main/refs/heads/main/Loader.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Solix Hub Rivals",
    Callback = function()
        LoadScript(" Solix Hub Rivals", "https://raw.githubusercontent.com/debunked69/Solixreworkkeysystem/refs/heads/main/solix%20new%20keyui.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Ventures Rivals",
    Callback = function()
        LoadScript(" Ventures Rivals", "https://raw.githubusercontent.com/laeraz/ventures/refs/heads/main/rivals.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Winter Rivals",
    Callback = function()
        LoadScript(" Winter Rivals", "https://raw.githubusercontent.com/SkibidiCen/MainMenu/main/Code")
    end
})
GameScriptsTab:CreateButton({
    Name = " Tbao Hub Rivals",
    Callback = function()
        LoadScript(" Tbao Hub Rivals", "https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubRivals")
    end
})
GameScriptsTab:CreateButton({
    Name = " 8Bits Hub Rivals",
    Callback = function()
        LoadScript(" 8Bits Hub Rivals", "https://raw.githubusercontent.com/8bits4ya/rivals-v3/refs/heads/main/main.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Ronix Hub Rivals",
    Callback = function()
        LoadScript(" Ronix Hub Rivals", "https://api.luarmor.net/files/v3/loaders/b581d07bfd134ff4ea612d671361be77.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Pinguin Rivals",
    Callback = function()
        LoadScript(" Pinguin Rivals", "https://raw.githubusercontent.com/PUSCRIPTS/PINGUIN/refs/heads/main/RivalsV1")
    end
})
GameScriptsTab:CreateButton({
    Name = " Sheeshablee Rivals",
    Callback = function()
        LoadScript(" Sheeshablee Rivals", "https://raw.githubusercontent.com/Sheeshablee73/Scriptss/main/Rivals%20Latest.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Pi Hub Rivals",
    Callback = function()
        LoadScript(" Pi Hub Rivals", "https://pi-hub.pages.dev/protected/loader.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " RIVALS Auto Farm v2",
    Callback = function()
        LoadScript(" RIVALS Auto Farm v2", "https://api.luarmor.net/files/v3/loaders/e945f55997c4240abc865c0bcc2136c5.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " RIVALS Aimbot+ESP",
    Callback = function()
        LoadScript(" RIVALS Aimbot+ESP", "https://api.luarmor.net/files/v3/loaders/2136f3786fd368193dd152c435d7ebfb.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " RIVALS Ronix",
    Callback = function()
        LoadScript(" RIVALS Ronix", "https://api.luarmor.net/files/v3/loaders/b581d07bfd134ff4ea612d671361be77.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " RIVALS Pi Hub",
    Callback = function()
        LoadScript(" RIVALS Pi Hub", "https://raw.githubusercontent.com/pihub/rivals/main/main.lua")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџ”Є MURDER MYSTERY 2
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("🔪 MURDER MYSTERY 2")

GameScriptsTab:CreateButton({
    Name = " MM2 Auto Farm+ESP+Kill All",
    Callback = function()
        LoadScript(" MM2 Auto Farm+ESP+Kill All", "https://script.roscripts.io/mm2-script-auto-farm-esp-kill-all-more-9aa3")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Freeze Trades",
    Callback = function()
        LoadScript(" MM2 Freeze Trades", "https://script.roscripts.io/mm2-freeze-trades")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 OP Summer Update",
    Callback = function()
        LoadScript(" MM2 OP Summer Update", "https://script.roscripts.io/mm2-script-op-summer-upd-keyless-op-undete")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Overdrive Hub",
    Callback = function()
        LoadScript(" MM2 Overdrive Hub", "https://script.roscripts.io/op-mm2-overdrive-h-script")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 DUPE SCRIPT",
    Callback = function()
        LoadScript(" MM2 DUPE SCRIPT", "https://script.roscripts.io/mm2-dupe-script")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Best Script",
    Callback = function()
        LoadScript(" MM2 Best Script", "https://script.roscripts.io/mm2-best-script-a-lot-of-features")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 AutoFarm+AutoKill",
    Callback = function()
        LoadScript(" MM2 AutoFarm+AutoKill", "https://script.roscripts.io/mm2-autofarm-autokill-1325")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Spawner Keyless",
    Callback = function()
        LoadScript(" MM2 Spawner Keyless", "https://script.roscripts.io/mm2-spawner-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Godly Upgrader",
    Callback = function()
        LoadScript(" MM2 Godly Upgrader", "https://script.roscripts.io/working-mm2-godly-upgrader-chroma-9cdd")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Thunder",
    Callback = function()
        LoadScript(" MM2 Thunder", "https://script.roscripts.io/mm2-thunder")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Stealer Items",
    Callback = function()
        LoadScript(" MM2 Stealer Items", "https://script.roscripts.io/mm2-stealer-items")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Foxname GUI",
    Callback = function()
        LoadScript(" MM2 Foxname GUI", "https://script.roscripts.io/foxname-mm2-gui-keyless-auto-farm-and-more")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Kiyori Hub",
    Callback = function()
        LoadScript(" MM2 Kiyori Hub", "https://script.roscripts.io/kiyori-mm2-auto-farm-esp-op")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Yuni Hub",
    Callback = function()
        LoadScript(" MM2 Yuni Hub", "https://script.roscripts.io/mm2-keyless-yuni-hub")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Luno Hub",
    Callback = function()
        LoadScript(" MM2 Luno Hub", "https://script.roscripts.io/luno-mm2-hub-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Summer Autofarm",
    Callback = function()
        LoadScript(" MM2 Summer Autofarm", "https://script.roscripts.io/summer-mm2-autofarm-easy-wins-6dcd")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Auto Trade",
    Callback = function()
        LoadScript(" MM2 Auto Trade", "https://script.roscripts.io/mm2-auto-trade-keyless-69e2")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Trade Freeze 2026",
    Callback = function()
        LoadScript(" MM2 Trade Freeze 2026", "https://script.roscripts.io/mm2-trade-freeze-6127")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Aimbot 2026",
    Callback = function()
        LoadScript(" MM2 Aimbot 2026", "https://script.roscripts.io/aimbot-mm2-2026")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Gun/Knife Spawner",
    Callback = function()
        LoadScript(" MM2 Gun/Knife Spawner", "https://script.roscripts.io/mm2-gun-knife-spawner-duper-24ba")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Weapon Spawner",
    Callback = function()
        LoadScript(" MM2 Weapon Spawner", "https://script.roscripts.io/mm2-weapon-spawner")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Stealer",
    Callback = function()
        LoadScript(" MM2 Stealer", "https://script.roscripts.io/mm2-stealer")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Freeze Trade OP",
    Callback = function()
        LoadScript(" MM2 Freeze Trade OP", "https://script.roscripts.io/mm2-freeze-trade-new-op-version")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 DUPE multiply",
    Callback = function()
        LoadScript(" MM2 DUPE multiply", "https://script.roscripts.io/mm2-dupe-script-multiply-your-items-c7c4")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Auto Farm Interface",
    Callback = function()
        LoadScript(" MM2 Auto Farm Interface", "https://script.roscripts.io/mm2-auto-farm")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 THUNDER POWER",
    Callback = function()
        LoadScript(" MM2 THUNDER POWER", "https://script.roscripts.io/mm2-thunder")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 OP Script",
    Callback = function()
        LoadScript(" MM2 OP Script", "https://script.roscripts.io/mm2-op-script-kill-all-auto-farm-bring")
    end
})
GameScriptsTab:CreateButton({
    Name = " MM2 Auto Farm+ESP",
    Callback = function()
        LoadScript(" MM2 Auto Farm+ESP", "https://script.roscripts.io/mm2-script-auto-farm-esp-kill-all-more-e6fd")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- вљ”пёЏ BLOX FRUITS
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("🍎 BLOX FRUITS")

GameScriptsTab:CreateButton({
    Name = " Blox Fruits Fruit Dupe",
    Callback = function()
        LoadScript(" Blox Fruits Fruit Dupe", "https://script.roscripts.io/blox-fruits-fruit-dupe-autofarm")
    end
})
GameScriptsTab:CreateButton({
    Name = " Blox Fruits Ultimate Farm",
    Callback = function()
        LoadScript(" Blox Fruits Ultimate Farm", "https://script.roscripts.io/blox-fruits-ultimate-auto-farm")
    end
})
GameScriptsTab:CreateButton({
    Name = " VaultX Blox Fruits",
    Callback = function()
        LoadScript(" VaultX Blox Fruits", "https://script.roscripts.io/vaultx-blox-fruits")
    end
})
GameScriptsTab:CreateButton({
    Name = " Specter Core BF",
    Callback = function()
        LoadScript(" Specter Core BF", "https://script.roscripts.io/specter-core-keyless-fruit-dupe")
    end
})
GameScriptsTab:CreateButton({
    Name = " Abyss X BF",
    Callback = function()
        LoadScript(" Abyss X BF", "https://script.roscripts.io/abyss-x-keyless-godmode-fruit-dupe")
    end
})
GameScriptsTab:CreateButton({
    Name = " Leviathan X BF",
    Callback = function()
        LoadScript(" Leviathan X BF", "https://script.roscripts.io/leviathan-x-godmode-fruit-dupe")
    end
})
GameScriptsTab:CreateButton({
    Name = " Banana Cat Hub BF",
    Callback = function()
        LoadScript(" Banana Cat Hub BF", "https://script.roscripts.io/banana-cat-hub-cracked")
    end
})
GameScriptsTab:CreateButton({
    Name = " Nova Hub BF",
    Callback = function()
        LoadScript(" Nova Hub BF", "https://script.roscripts.io/nova-hub")
    end
})
GameScriptsTab:CreateButton({
    Name = " Akizz Empire BF",
    Callback = function()
        LoadScript(" Akizz Empire BF", "https://script.roscripts.io/akizz-empire-bloxs-fruit-script")
    end
})
GameScriptsTab:CreateButton({
    Name = " Bloxfruits Hub",
    Callback = function()
        LoadScript(" Bloxfruits Hub", "https://script.roscripts.io/bloxfruits")
    end
})
GameScriptsTab:CreateButton({
    Name = " Islands (OwlHub)",
    Callback = function()
        LoadScript(" Islands", "https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџ›ЎпёЏ BLADE BALL
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("⚔ BLADE BALL")

GameScriptsTab:CreateButton({
    Name = " Blade Ball Vanish Hub",
    Callback = function()
        LoadScript(" Blade Ball Vanish Hub", "https://script.roscripts.io/blade-ball-vanish-hub-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " Blade Ball Vegas Hub",
    Callback = function()
        LoadScript(" Blade Ball Vegas Hub", "https://script.roscripts.io/blade-ball-vegas-hub-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " Blade Ball Keyless Script",
    Callback = function()
        LoadScript(" Blade Ball Keyless Script", "https://script.roscripts.io/blade-ball-script-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " Blade Ball OP Script",
    Callback = function()
        LoadScript(" Blade Ball OP Script", "https://script.roscripts.io/keyless-op-blade-ball-script")
    end
})
GameScriptsTab:CreateButton({
    Name = " Rise Blade Ball",
    Callback = function()
        LoadScript(" Rise Blade Ball", "https://script.roscripts.io/rise-blade-ball-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " Luno BladeBall",
    Callback = function()
        LoadScript(" Luno BladeBall", "https://script.roscripts.io/luno-bladeball-script-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " Blade Ball Fake Trade",
    Callback = function()
        LoadScript(" Blade Ball Fake Trade", "https://script.roscripts.io/blade-ball-script-fake-trade-auto-dodge")
    end
})
GameScriptsTab:CreateButton({
    Name = " Blade Ball Auto Kill",
    Callback = function()
        LoadScript(" Blade Ball Auto Kill", "https://script.roscripts.io/bladeball-scropt")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЏ‹пёЏ ARSENAL
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("💣 ARSENAL")

GameScriptsTab:CreateButton({
    Name = " Arsenal KEYLESS OP",
    Callback = function()
        LoadScript(" Arsenal KEYLESS OP", "https://script.roscripts.io/keyless-op-arsenal-script")
    end
})
GameScriptsTab:CreateButton({
    Name = " PreciseWare Arsenal",
    Callback = function()
        LoadScript(" PreciseWare Arsenal", "https://script.roscripts.io/preciseware-arsenal-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " Cryziie Arsenal 2.0",
    Callback = function()
        LoadScript(" Cryziie Arsenal 2.0", "https://script.roscripts.io/cryziie-s-arsenal-script-2-0")
    end
})
GameScriptsTab:CreateButton({
    Name = " Valor Hub Arsenal",
    Callback = function()
        LoadScript(" Valor Hub Arsenal", "https://script.roscripts.io/valor-hub-arsenal-open-source")
    end
})
GameScriptsTab:CreateButton({
    Name = " Crazy AIMBOT Arsenal",
    Callback = function()
        LoadScript(" Crazy AIMBOT Arsenal", "https://script.roscripts.io/arsenal-script")
    end
})
GameScriptsTab:CreateButton({
    Name = " Arsenal trace",
    Callback = function()
        LoadScript(" Arsenal trace", "https://script.roscripts.io/trace")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЏ« JAILBREAK
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("🚔 JAILBREAK")

GameScriptsTab:CreateButton({
    Name = " Jailbreak Money Farm",
    Callback = function()
        LoadScript(" Jailbreak Money Farm", "https://script.roscripts.io/jailbreak-money-auto-farm")
    end
})
GameScriptsTab:CreateButton({
    Name = " Jailbreak (Vynixius)",
    Callback = function()
        LoadScript(" Jailbreak (Vynixius)", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Jailbreak/Script.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " High Bounty Finder",
    Callback = function()
        LoadScript(" High Bounty Finder", "https://script.roscripts.io/high-bounty-finder-script-auto-arrest")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЊ± GROW A GARDEN 2
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("🌿 GROW A GARDEN 2")

GameScriptsTab:CreateButton({
    Name = " GAG2 Script",
    Callback = function()
        LoadScript(" GAG2 Script", "https://script.roscripts.io/grow-a-garden-2-script")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Dupe Keyless",
    Callback = function()
        LoadScript(" GAG2 Dupe Keyless", "https://script.roscripts.io/grow-a-garden-2-gag-2-dupe-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Auto Harvest",
    Callback = function()
        LoadScript(" GAG2 Auto Harvest", "https://script.roscripts.io/grow-a-garden-2-auto-harvest-auto")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 No Key Script",
    Callback = function()
        LoadScript(" GAG2 No Key Script", "https://script.roscripts.io/grow-a-garden-2-script-with-no-key-auto-fa")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Dupe Pets+Seeds",
    Callback = function()
        LoadScript(" GAG2 Dupe Pets+Seeds", "https://script.roscripts.io/gag-2-dupe-pets-seeds-keyless")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Auto Steal+Dupe",
    Callback = function()
        LoadScript(" GAG2 Auto Steal+Dupe", "https://script.roscripts.io/grow-a-garden-2-auto-steal-dupe-seed")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Duper+Spawner",
    Callback = function()
        LoadScript(" GAG2 Duper+Spawner", "https://script.roscripts.io/grow-a-garden-2-duper-spawner-more")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Auto Sell+Farm",
    Callback = function()
        LoadScript(" GAG2 Auto Sell+Farm", "https://script.roscripts.io/grow-a-garden-2-auto-sell-farm-script")
    end
})
GameScriptsTab:CreateButton({
    Name = " Hoshi Hub GAG2",
    Callback = function()
        LoadScript(" Hoshi Hub GAG2", "https://script.roscripts.io/hoshi-hub-loader-hoshiontop-grow-a-garden")
    end
})
GameScriptsTab:CreateButton({
    Name = " Ouroboros Hub GAG2",
    Callback = function()
        LoadScript(" Ouroboros Hub GAG2", "https://script.roscripts.io/ouroboros-hub-keyless-no-conditions")
    end
})
GameScriptsTab:CreateButton({
    Name = " Garden King GAG2",
    Callback = function()
        LoadScript(" Garden King GAG2", "https://script.roscripts.io/garden-king")
    end
})
GameScriptsTab:CreateButton({
    Name = " Lumin Hub GAG2",
    Callback = function()
        LoadScript(" Lumin Hub GAG2", "https://script.roscripts.io/lumin-hub")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 AUTOFARM",
    Callback = function()
        LoadScript(" GAG2 AUTOFARM", "https://script.roscripts.io/gag2-autofarm-auto-steal-and-more")
    end
})
GameScriptsTab:CreateButton({
    Name = " TTJY Hub GAG2",
    Callback = function()
        LoadScript(" TTJY Hub GAG2", "https://script.roscripts.io/ttjy-hub-gag2-undetected-2-language-ttj")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 MintVault v2",
    Callback = function()
        LoadScript(" GAG2 MintVault v2", "https://script.roscripts.io/gag2-mintvault-v2-auto-farm-dupe-b1f0")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 OP Hub 40+",
    Callback = function()
        LoadScript(" GAG2 OP Hub 40+", "https://script.roscripts.io/gag2-scripts-op-hub-40-features")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Dupe Script",
    Callback = function()
        LoadScript(" GAG2 Dupe Script", "https://script.roscripts.io/gag2-dupe-script-keyless-a459")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Dupe xwao",
    Callback = function()
        LoadScript(" GAG2 Dupe xwao", "https://script.roscripts.io/dupe-script-xwao")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Spawner/Dupe v3",
    Callback = function()
        LoadScript(" GAG2 Spawner/Dupe v3", "https://script.roscripts.io/gag-2-new-spawner-dupe-autofarm-v3")
    end
})
GameScriptsTab:CreateButton({
    Name = " GAG2 Auto Farm Pet",
    Callback = function()
        LoadScript(" GAG2 Auto Farm Pet", "https://script.roscripts.io/grow-a-garden-2-auto-farm-seed-pet-script")
    end
})
GameScriptsTab:CreateButton({
    Name = " Gardenia PRO GAG2",
    Callback = function()
        LoadScript(" Gardenia PRO GAG2", "https://script.roscripts.io/gardenia-pro-auto-farm-more")
    end
})
GameScriptsTab:CreateButton({
    Name = " Devil GAG2",
    Callback = function()
        LoadScript(" Devil GAG2", "https://script.roscripts.io/devil-grow-a-garden")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЏ™пёЏ SOUTH BRONX
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("🏖 SOUTH BRONX")

GameScriptsTab:CreateButton({
    Name = " South Bronx Saytus Hub",
    Callback = function()
        LoadScript(" South Bronx Saytus Hub", "https://raw.githubusercontent.com/Turtle1891/South-Bronx-Script---Saytus/refs/heads/main/Saytus%20Cheat")
    end
})
GameScriptsTab:CreateButton({
    Name = " South Bronx Lunax",
    Callback = function()
        LoadScript(" South Bronx Lunax", "https://raw.githubusercontent.com/Alexisisback/Lunax/refs/heads/main/Loader.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " South Bronx Prodactors",
    Callback = function()
        LoadScript(" South Bronx Prodactors", "https://raw.githubusercontent.com/Prodactors/Script/refs/heads/main/scriptt")
    end
})
GameScriptsTab:CreateButton({
    Name = " South Bronx Neptune",
    Callback = function()
        LoadScript(" South Bronx Neptune", "https://raw.githubusercontent.com/new-gugus/scouth-broux-neptune/refs/heads/main/main.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " South Bronx Dodgebros",
    Callback = function()
        LoadScript(" South Bronx Dodgebros", "https://raw.githubusercontent.com/Dodgebros/South-Bronx/refs/heads/main/SouthBronx")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЋЄ SIMULATORS
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("📊 SIMULATORS")

GameScriptsTab:CreateButton({
    Name = " Muscle Legends",
    Callback = function()
        LoadScript(" Muscle Legends", "https://raw.githubusercontent.com/harisiskandar178/Roblox-Script/main/Muscle%20Legend")
    end
})
GameScriptsTab:CreateButton({
    Name = " Pet Simulator X",
    Callback = function()
        LoadScript(" Pet Simulator X", "https://raw.githubusercontent.com/Muhammad6196/Project-WD/main/Main.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Bee Swarm Simulator",
    Callback = function()
        LoadScript(" Bee Swarm Simulator", "https://raw.githubusercontent.com/Historia00012/HISTORIAHUB/main/BSS%20FREE")
    end
})
GameScriptsTab:CreateButton({
    Name = " Ninja Legends",
    Callback = function()
        LoadScript(" Ninja Legends", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Ninja%20Legends/Script.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Legends Of Speed",
    Callback = function()
        LoadScript(" Legends Of Speed", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Legends%20Of%20Speed/Script.lua")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџ‘» HORROR GAMES
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("👻 HORROR GAMES")

GameScriptsTab:CreateButton({
    Name = " Doors (Vynixius)",
    Callback = function()
        LoadScript(" Doors", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Doors/Script.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Piggy (Vynixius)",
    Callback = function()
        LoadScript(" Piggy", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Piggy/Script.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Piggy (Vynixius)",
    Callback = function()
        LoadScript(" Piggy", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Piggy/Script.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Survive the Killer",
    Callback = function()
        LoadScript(" Survive the Killer", "https://script.roscripts.io/survive-the-killer")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЏ—пёЏ BUILDING & TYCOON
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("🏗 BUILDING & TYCOON")

GameScriptsTab:CreateButton({
    Name = " Build A Boat (Vynixius)",
    Callback = function()
        LoadScript(" Build A Boat", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Build%20A%20Boat%20For%20Treasure/Script.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " YouTube Life (Vynixius)",
    Callback = function()
        LoadScript(" YouTube Life", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/YouTube%20Life/Script.lua")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЏ° OBBY & PARKOUR
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("🧗 OBBY & PARKOUR")

GameScriptsTab:CreateButton({
    Name = " Tower of Hell (Vynixius)",
    Callback = function()
        LoadScript(" Tower of Hell", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Tower%20of%20Hell/Script.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Tower of Hell Hub",
    Callback = function()
        LoadScript(" Tower of Hell Hub", "https://script.roscripts.io/tower-of-hell")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- вљЎ ANIME GAMES
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("👗 ANIME GAMES")

GameScriptsTab:CreateButton({
    Name = " Anime Vanguards",
    Callback = function()
        LoadScript(" Anime Vanguards", "https://script.roscripts.io/anime-vanguards")
    end
})
GameScriptsTab:CreateButton({
    Name = " Blox Fruits (Universal)",
    Callback = function()
        LoadScript(" Blox Fruits (Universal)", "https://script.roscripts.io/blox-fruits-ultimate-auto-farm")
    end
})
GameScriptsTab:CreateButton({
    Name = " One Piece Game",
    Callback = function()
        LoadScript(" One Piece Game", "https://script.roscripts.io/one-piece-game")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЋ® FUNKY FRIDAY & RHYTHM
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("🎵 RHYTHM GAMES")

GameScriptsTab:CreateButton({
    Name = " Funky Friday",
    Callback = function()
        LoadScript(" Funky Friday", "https://raw.githubusercontent.com/ShowerHead-FluxTeam/scripts/main/funky-friday-autoplay")
    end
})

-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
-- рџЋ­ EXTRA & MISC GAMES
-- в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
GameScriptsTab:CreateSection("❓ EXTRA GAMES")

GameScriptsTab:CreateButton({
    Name = " Prison Life (Vynixius)",
    Callback = function()
        LoadScript(" Prison Life", "https://raw.githubusercontent.com/RegularVynixu/Vynixius/main/Prison%20Life/Script.lua")
    end
})
GameScriptsTab:CreateButton({
    Name = " Phantom Forces",
    Callback = function()
        LoadScript(" Phantom Forces", "https://script.roscripts.io/phantom-forces")
    end
})
GameScriptsTab:CreateButton({
    Name = " Dungeon Quest",
    Callback = function()
        LoadScript(" Dungeon Quest", "https://script.roscripts.io/dungeon-quest-reborn")
    end
})
GameScriptsTab:CreateButton({
    Name = " Squid Game X",
    Callback = function()
        LoadScript(" Squid Game X", "https://script.roscripts.io/squid-game-x")
    end
})
GameScriptsTab:CreateButton({
    Name = " The Strongest BG",
    Callback = function()
        LoadScript(" The Strongest BG", "https://script.roscripts.io/the-strongest-battlegrounds")
    end
})
GameScriptsTab:CreateButton({
    Name = " BloxStrike",
    Callback = function()
        LoadScript(" BloxStrike", "https://script.roscripts.io/bloxstrike")
    end
})
GameScriptsTab:CreateButton({
    Name = " Counter Blox",
    Callback = function()
        LoadScript(" Counter Blox", "https://script.roscripts.io/counter-blox")
    end
})
GameScriptsTab:CreateButton({
    Name = " Slap Battles",
    Callback = function()
        LoadScript(" Slap Battles", "https://script.roscripts.io/slap-battles")
    end
})
GameScriptsTab:CreateButton({
    Name = " Brookhaven",
    Callback = function()
        LoadScript(" Brookhaven", "https://script.roscripts.io/brookhaven")
    end
})
GameScriptsTab:CreateButton({
    Name = " Work at a Pizza Place",
    Callback = function()
        LoadScript(" Work at a Pizza Place", "https://script.roscripts.io/work-at-a-pizza-place")
    end
})
GameScriptsTab:CreateButton({
    Name = " Muscles Legends",
    Callback = function()
        LoadScript(" Muscles Legends", "https://script.roscripts.io/muscle-legends")
    end
})
GameScriptsTab:CreateButton({
    Name = " Blox Fruits Survival Hub",
    Callback = function()
        LoadScript(" Blox Fruits Survival Hub", "https://rawscripts.net/raw/Blox-Fruits-Survive-Hub-12264")
    end
})
GameScriptsTab:CreateButton({
    Name = " Survive the Killer",
    Callback = function()
        LoadScript(" Survive the Killer", "https://script.roscripts.io/survive-the-killer")
    end
})
GameScriptsTab:CreateButton({
    Name = " Obby But You're On a Bike",
    Callback = function()
        LoadScript(" Obby But You're On a Bike", "https://script.roscripts.io/obby-but-youre-on-a-bike")
    end
})
GameScriptsTab:CreateButton({
    Name = " A Dusty Trip",
    Callback = function()
        LoadScript(" A Dusty Trip", "https://script.roscripts.io/a-dusty-trip")
    end
})
GameScriptsTab:CreateButton({
    Name = " Baseplate",
    Callback = function()
        LoadScript(" Baseplate", "https://script.roscripts.io/baseplate")
    end
})
GameScriptsTab:CreateButton({
    Name = " Zombie Attack",
    Callback = function()
        LoadScript(" Zombie Attack", "https://script.roscripts.io/zombie-attack")
    end
})
GameScriptsTab:CreateButton({
    Name = " 3008",
    Callback = function()
        LoadScript(" 3008", "https://script.roscripts.io/3008")
    end
})
GameScriptsTab:CreateButton({
    Name = " Westbound",
    Callback = function()
        LoadScript(" Westbound", "https://script.roscripts.io/westbound")
    end
})
GameScriptsTab:CreateButton({
    Name = " Word Bomb",
    Callback = function()
        LoadScript(" Word Bomb", "https://script.roscripts.io/word-bomb")
    end
})
GameScriptsTab:CreateButton({
    Name = " Hypershot",
    Callback = function()
        LoadScript(" Hypershot", "https://script.roscripts.io/hypershot")
    end
})
GameScriptsTab:CreateButton({
    Name = " Welcome to Bloxburg",
    Callback = function()
        LoadScript(" Welcome to Bloxburg", "https://script.roscripts.io/welcome-to-bloxburg")
    end
})
GameScriptsTab:CreateButton({
    Name = " Your Bizarre Adventure",
    Callback = function()
        LoadScript(" Your Bizarre Adventure", "https://script.roscripts.io/your-bizarre-adventure")
    end
})
GameScriptsTab:CreateButton({
    Name = " Total Roblox Drama",
    Callback = function()
        LoadScript(" Total Roblox Drama", "https://script.roscripts.io/total-roblox-drama")
    end
})
GameScriptsTab:CreateButton({
    Name = " Trident Survival",
    Callback = function()
        LoadScript(" Trident Survival", "https://script.roscripts.io/trident-survival")
    end
})
GameScriptsTab:CreateButton({
    Name = " The Dropper 130+",
    Callback = function()
        LoadScript(" The Dropper 130+", "https://script.roscripts.io/the-dropper-130-levels")
    end
})
GameScriptsTab:CreateButton({
    Name = " Speed Draw",
    Callback = function()
        LoadScript(" Speed Draw", "https://script.roscripts.io/speed-draw")
    end
})
GameScriptsTab:CreateButton({
    Name = " Valley Prison",
    Callback = function()
        LoadScript(" Valley Prison", "https://script.roscripts.io/valley-prison")
    end
})
GameScriptsTab:CreateButton({
    Name = " Survive Zombie Arena",
    Callback = function()
        LoadScript(" Survive Zombie Arena", "https://script.roscripts.io/survive-zombie-arena")
    end
})
GameScriptsTab:CreateButton({
    Name = " T-Titans Battlegrounds",
    Callback = function()
        LoadScript(" T-Titans Battlegrounds", "https://script.roscripts.io/t-titans-battlegrounds")
    end
})
GameScriptsTab:CreateButton({
    Name = " Spelling Bee",
    Callback = function()
        LoadScript(" Spelling Bee", "https://script.roscripts.io/spelling-bee")
    end
})
GameScriptsTab:CreateButton({
    Name = " Apocalypse Rising 2",
    Callback = function()
        LoadScript(" Apocalypse Rising 2", "https://script.roscripts.io/apocalypse-rising-2")
    end
})
GameScriptsTab:CreateButton({
    Name = " Zombie Tower",
    Callback = function()
        LoadScript(" Zombie Tower", "https://script.roscripts.io/zombie-tower")
    end
})
GameScriptsTab:CreateButton({
    Name = " Granny",
    Callback = function()
        LoadScript(" Granny", "https://script.roscripts.io/granny")
    end
})
GameScriptsTab:CreateButton({
    Name = " Hide or Die",
    Callback = function()
        LoadScript(" Hide or Die", "https://script.roscripts.io/hide-or-die")
    end
})
GameScriptsTab:CreateButton({
    Name = " Forsaken",
    Callback = function()
        LoadScript(" Forsaken", "https://script.roscripts.io/forsaken")
    end
})
GameScriptsTab:CreateButton({
    Name = " Specter Legacy",
    Callback = function()
        LoadScript(" Specter Legacy", "https://script.roscripts.io/specter-legacy")
    end
})
GameScriptsTab:CreateButton({
    Name = " Dingus",
    Callback = function()
        LoadScript(" Dingus", "https://script.roscripts.io/dingus")
    end
})
GameScriptsTab:CreateButton({
    Name = " AniPhobia",
    Callback = function()
        LoadScript(" AniPhobia", "https://script.roscripts.io/aniphobia")
    end
})
GameScriptsTab:CreateButton({
    Name = " Undergraduate War 2.0",
    Callback = function()
        LoadScript(" Undergraduate War 2.0", "https://script.roscripts.io/underground-war-2")
    end
})
GameScriptsTab:CreateButton({
    Name = " Steal an Egg",
    Callback = function()
        LoadScript(" Steal an Egg", "https://script.roscripts.io/steal-an-egg")
    end
})
GameScriptsTab:CreateButton({
    Name = " +1 Speed Monkey Escape",
    Callback = function()
        LoadScript(" +1 Speed Monkey Escape", "https://script.roscripts.io/speed-monkey-escape")
    end
})
GameScriptsTab:CreateButton({
    Name = " Murder Duels",
    Callback = function()
        LoadScript(" Murder Duels", "https://script.roscripts.io/murder-duels")
    end
})
GameScriptsTab:CreateButton({
    Name = " Jump To Steal Soccer",
    Callback = function()
        LoadScript(" Jump To Steal Soccer", "https://script.roscripts.io/jump-to-steal-soccer")
    end
})
GameScriptsTab:CreateButton({
    Name = " Deagle Arena",
    Callback = function()
        LoadScript(" Deagle Arena", "https://script.roscripts.io/deagle-arena")
    end
})
GameScriptsTab:CreateButton({
    Name = " Clean All The Leaves",
    Callback = function()
        LoadScript(" Clean All The Leaves", "https://script.roscripts.io/clean-all-the-leaves")
    end
})
GameScriptsTab:CreateButton({
    Name = " Vacuum For Brainrots",
    Callback = function()
        LoadScript(" Vacuum For Brainrots", "https://script.roscripts.io/vacuum-for-brainrots")
    end
})
GameScriptsTab:CreateButton({
    Name = " Math Obby",
    Callback = function()
        LoadScript(" Math Obby", "https://script.roscripts.io/math-obby")
    end
})
GameScriptsTab:CreateButton({
    Name = " Roblox Party",
    Callback = function()
        LoadScript(" Roblox Party", "https://script.roscripts.io/roblox-party")
    end
})
GameScriptsTab:CreateButton({
    Name = " Deadeye",
    Callback = function()
        LoadScript(" Deadeye", "https://script.roscripts.io/deadeye")
    end
})
GameScriptsTab:CreateButton({
    Name = " Mafia",
    Callback = function()
        LoadScript(" Mafia", "https://script.roscripts.io/mafia")
    end
})
GameScriptsTab:CreateButton({
    Name = " Untamed Animals",
    Callback = function()
        LoadScript(" Untamed Animals", "https://script.roscripts.io/untamed-animals")
    end
})
GameScriptsTab:CreateButton({
    Name = " The Roblox Learn",
    Callback = function()
        LoadScript(" The Roblox Learn", "https://script.roscripts.io/the-roblox-learn-experience")
    end
})
GameScriptsTab:CreateButton({
    Name = " Bicep Simulator",
    Callback = function()
        LoadScript(" Bicep Simulator", "https://script.roscripts.io/bicep-simulator")
    end
})
GameScriptsTab:CreateButton({
    Name = " Endangered World",
    Callback = function()
        LoadScript(" Endangered World", "https://script.roscripts.io/endangered-world")
    end
})
GameScriptsTab:CreateButton({
    Name = " Spot the Differences",
    Callback = function()
        LoadScript(" Spot the Differences", "https://script.roscripts.io/spot-the-differences")
    end
})