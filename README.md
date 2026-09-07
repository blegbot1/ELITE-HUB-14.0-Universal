# ELITE HUB 14.0 — Universal Roblox Script

HASKER EDITION — Универсальный хаб для Roblox.

## Структура репозитория

```
ELITE_HUB_14.0.lua          — Основной скрипт (monolith, для загрузки)
modules/                     — Разбитые модули (для разработки)
├── init.lua                 — Загрузчик: окно, вкладки, shared env, запуск модулей
├── ui_library.lua           — UI библиотека (EliteHubUI)
├── main.lua                 — Основные функции (WallHop, Fly, Noclip, Spin)
├── aimbot.lua               — Аимбот 3D FOV
├── esp.lua                  — ESP (Box, Name, HP, Skeleton, Tracers, Max Distance)
├── chams.lua                — Чамсы (Player, Rainbow, Weapon)
├── visual.lua               — Визуал (Particles, Neon, Hit Effects, Fire Trail)
├── visual_plus.lua          — Визуал+ (VFX: Vignette, Pulse Ring, HP Bar)
├── combat_plus.lua          — Комбат+ (Hitbox, Auto Parry, Reach, Spin Bot)
├── movement.lua             — Движение (Jump Boost, Speed, Jump Power)
├── camera.lua               — Камера (Click TP, NoClip TP, Waypoint)
├── environment.lua          — Окружение (Night Mode, Sky, World Tint, Fog)
├── nametag.lua              — Наметка
├── nametag_standalone.lua   — Наметка (standalone, для отдельной загрузки)
├── overlay.lua              — Оверлей (Status bar, Drawing primitives)
├── teleport.lua             — Телепорт к игрокам (Auto-TP)
├── kill_all.lua             — Kill All + EXTRA SCRIPTS кнопки
├── item_finder.lua          — Поиск предметов
├── range.lua                — Range (Эффекты, Spin Bot, Speed Boost)
├── music.lua                — Музыка (плейлист, shuffle, repeat, скорость)
├── utilities.lua            — Утилиты (FPS/Ping overlay, Anti-AFK, Server Hop)
├── hubs.lua                 — Universal Hubs загрузчик
├── fe_scripts.lua           — FE скрипты
├── game_scripts.lua         — Игровые скрипты (Rivals, MM2, Blox Fruits...)
├── settings.lua             — Настройки (язык, конфиг)
├── anti_fling.lua           — Anti-Fling система
├── watchdog.lua             — Watchdog (восстановление фич)
save/                        — Бэкапы
```

Модули регенерированы из актуального монолита и могут запускаться через
`modules/init.lua` (для экзекуторов с `readfile`).

## Загрузка

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/refs/heads/main/ELITE_HUB_14.0.lua"))()
```

## Функции

- **ESP**: Box, Name, Health, Distance, Tracers, Skeleton, 3D Box, Arrows, Head Dots, Max Distance
- **Aimbot**: 3D FOV, Prediction, Auto-Shoot, Anti-Aim Detect, Target Indicator
- **Chams**: Player Chams, Rainbow Chams, Weapon Chams
- **Visual**: Particles (35 типов), Neon Body, Night Mode, X-Ray, Vignette, Pulse Ring
- **Combat**: Hitbox Expander, Auto Parry, Reach, Spin Bot
- **Movement**: Jump Boost, Speed, Infinite Jump, Fly
- **Camera**: Click TP, NoClip TP, Waypoint
- **Teleport**: TP к игрокам, Auto-TP
- **Utilities**: FPS/Ping overlay, Anti-AFK, Chat Spammer, Server Hop, Auto Rejoin
- **Music**: плейлист, выбор трека, скорость, shuffle, repeat
- **FE Scripts**: 40+ FE скриптов
- **Game Scripts**: Rivals, MM2, Blox Fruits, Blade Ball, Arsenal, Jailbreak, и др.

## Тестировщик

gerkylesichakes
