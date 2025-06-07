# 🎮 Game Design Document: Tap Tap Chef

## Overview

**Tap Tap Chef** is a casual clicker game where players tap to cook meals, earn cash, automate kitchen functions, and ultimately scale a single food stall into a cosmic food empire.

### Design Goals:
- Keep gameplay loop simple but deeply upgradeable
- Create a sense of exponential growth (local → global → galactic)
- Blend humor and existential scale in a satirical, engaging tone
- Easy monetization through rewarded ads and cosmetic/IAP systems

---

## 🧠 Core Loop

1. **Tap to Cook**
2. **Earn Cash**
3. **Upgrade Kitchen / Hire Staff**
4. **Unlock New Kitchen / Restaurant**
5. **Prestige for Multipliers**
6. **Repeat with Higher Tiers**

---

## 🍔 Core Systems

### 1. **Tapping & Income System**
- Every tap = 1 meal served
- Base cash per tap scales with dish tier
- **Combo Meter:** rapid tapping builds a meter that multiplies earnings.
- **Frenzy Mode:** maxing the meter triggers a short burst with screen shake,
  flashy particles, and a large earnings boost.

### 2. **Kitchen Upgrades**
| Upgrade        | Effect                        | Cost Type |
|----------------|-------------------------------|-----------|
| Frying Speed   | Reduce time per tap           | Cash      |
| Meal Quality   | Increase $ per tap            | Cash      |
| Max Inventory  | Boost earnings per idle tick  | Cash      |

### 3. **Automation (Staff Hiring)**
- Staff automate taps at fixed intervals
- Upgradable staff speed & effectiveness
- Unlock new roles (Cook, Server, Manager, Robot Chef)

### 4. **Idle Progression**
- Background income accumulates at slower rate
- Capped based on kitchen inventory or staff efficiency

### 5. **Prestige System (Catering Contracts)**
- Reset progress in exchange for Prestige Points (PP)
- PP can be spent on permanent multipliers, global upgrades, or unlocks
- Unlock new food tiers (cosmic recipes, quantum ingredients)

---

## 🚀 Progression Milestones

| Phase        | Unlock Mechanic                     | Sample Foods              |
|--------------|-------------------------------------|---------------------------|
| Street Food  | Base tapper + 3 upgrades            | Tacos, Hot Dogs, Falafel  |
| Local Diner  | Hire staff, new backgrounds         | Burgers, Pancakes         |
| Chain Store  | Idle income boosts + ad system      | Noodles, Pizza            |
| Global Brand | Prestige system, new tech upgrades  | Sushi, Curry, Banh Mi     |
| Space Empire | Intergalactic cuisine, absurd boosts| Moon cheese, Alien eggs   |
| Endgame      | Black hole catering, existential AI | “Conceptual hunger”       |
| Time Warp Kitchen | Temporal upgrades, time-loop menus | Chrono-chili |
| Multiverse Franchise | Reality-hopping logistics | Schrödinger's soufflé |

---

## 🔓 Upgrade Trees

| Category     | Examples                                  |
|--------------|-------------------------------------------|
| Tap Power    | Multi-tap, Swipe cooking, Double dish     |
| Staff Tech   | Instant serve, Mood booster, Dual chefs   |
| Restaurant   | Increase customer cap, Decor bonus        |
| Prestige     | % earnings bonus, tap cooldowns, unlocks  |
| Dimensional  | Time loops, multiverse delivery           |

*Upgrade math will use exponential cost scaling + diminishing returns curves.*

---

## 💸 Monetization Plan

### Free-to-Play (MVP Post-Launch)
- Rewarded ads for:
  - Instant cash
  - Temporary 2x income
  - Rush orders

### IAPs
- Coin packs
- Permanent boosts (e.g., auto-cookers)
- Cosmetic upgrades (skins, UI themes)

---

## 📈 Data Tracking (Analytics Hooks)

- Daily retention
- Time to first upgrade
- Ad engagement rate
- Tap rate / session length
- Prestige loop frequency

---

## 🧩 MVP Feature List

| Feature                         | Included |
|--------------------------------|----------|
| Tap-to-cook interaction        | ✅        |
| Kitchen upgrades               | ✅        |
| Staff automation               | ✅        |
| Save/load game state           | ✅        |
| Prestige reset system          | ✅        |
| 3–4 progression tiers          | ✅        |
| Monetization (rewarded ads)   | ❌        |
| IAP / cosmetics                | ❌        |
| Sound/Music                    | ❌        |
| Dialogue/Narration system     | ❌        |

---

## 🎨 Visual & UI Notes

- Art style: Egg Inc–inspired soft 3D / 2D hybrid
- Clean, bouncey UI with warm color tones
- Clear upgrade icons + income animations
- Optional food particle effects on tap (e.g. sizzle, steam)

---

## 🤖 Tech Stack Recommendation

- **Framework**: Flutter
- **State Management**: Riverpod or Provider
- **Local Storage**: Hive or Shared Preferences
- **Animation/Physics**: Custom Flutter widgets or Flame (optional)
- **Cross-Platform**: Android + iOS optimized

---

## 🛠 Team Roles (suggested)

| Role              | Tasks                                   |
|-------------------|------------------------------------------|
| Game Designer     | Systems balance, upgrade math, pacing    |
| Flutter Dev       | Core app structure, game logic, UI       |
| Artist            | Characters, food assets, UI elements     |
| Sound Designer    | Optional phase (cooking/tap SFX)         |
| Writer/Narrative  | Prestige & endgame satire (phase 2)      |
| PM / Producer     | Timeline, tasks, asset tracking          |

---

## 📍 Next Steps

1. Finalize MVP UI wireframes  
2. Build tap mechanic + base upgrades  
3. Implement staff automation  
4. Add simple save/load system  
5. Structure prestige system
6. Internal test build
7. Prototype time-warp and multiverse tiers

---
