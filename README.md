# ELITE HUB 14.0 — Universal Roblox Script

HASKER EDITION — Универсальный хаб для Roblox.

## Структура репозитория

```
ELITE_HUB_14.0.lua          — Основной скрипт (monolith, для загрузки)
Chinese_Hat.lua              — Standalone китайская шляпа
EliteHub_Nametag.lua         — Standalone наметка
modules/                     — Разбитые модули (для разработки)
├── ui_library.lua           — UI библиотека (EliteHubUI)
├── init.lua                 — Инициализация, язык, загрузка
├── main.lua                 — Основные функции (WallHop, Fly, Noclip)
├── aimbot.lua               — Аимбот 3D FOV
├── esp.lua                  — ESP (Box, Name, HP, Skeleton, Tracers)
├── chams.lua                — Чамсы (Player, Rainbow, Weapon)
├── visual.lua               — Визуал (Particles, Chinese Hat)
├── visual_plus.lua          — Визуал+ (Item ESP, X-Ray, Wallhack)
├── combat_plus.lua          — Комбат+ (Hitbox, Auto Parry, Reach, Spin)
├── movement.lua             — Движение (Jump Boost, Speed, Bunny Hop)
├── camera.lua               — Камера (Free Cam, Teleport, Waypoint)
├── environment.lua          — Окружение (Night Mode, Gravity, FOV)
├── nametag.lua              — Наметка с анимацией
├── overlay.lua              — Оверлей (Status bar, Drawing primitives)
├── teleport.lua             — Телепорт к игрокам
├── kill_all.lua             — Kill All
├── item_finder.lua          — Поиск предметов
├── range.lua                — Range (Эффекты, Spin Bot, Speed Boost)
├── utilities.lua            — Утилиты (Anti-AFK, Fullbright, Server Hop)
├── hubs.lua                 — Universal Hubs загрузчик
├── fe_scripts.lua           — FE скрипты
├── game_scripts.lua         — Игровые скрипты (Rivals, MM2, Blox Fruits...)
├── settings.lua             — Настройки
├── anti_fling.lua           — Anti-Fling система
save/                        — Бэкапы
```

## Загрузка

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/blegbot1/ELITE-HUB-14.0-Universal/refs/heads/main/ELITE_HUB_14.0.lua"))()
```

## Функции

- **ESP**: Box, Name, Health, Distance, Tracers, Skeleton, 3D Box, Arrows, Head Dots
- **Aimbot**: 3D FOV, Prediction, Auto-Shoot, Anti-Aim Detect, Target Indicator
- **Chams**: Player Chams, Rainbow Chams, Weapon Chams
- **Visual**: Particles (35 типов), Chinese Hat, Fullbright, Night Mode, X-Ray
- **Combat**: Hitbox Expander, Auto Parry, Reach, Spin Bot
- **Movement**: Jump Boost, Speed, Infinite Jump, Bunny Hop, Fly
- **Camera**: Free Cam, Click TP, Waypoint, Third Person
- **Teleport**: TP к игрокам, Auto-TP
- **Utilities**: Anti-AFK, Chat Spammer, Server Hop, Auto Respawn
- **FE Scripts**: 40+ FE скриптов
- **Game Scripts**: Rivals, MM2, Blox Fruits, Blade Ball, Arsenal, Jailbreak, и др.

## Тестировщик

gerkylesichakes
