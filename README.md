# 🍳 Tap Tap Chef

A clicker-style mobile game where players build a food empire from a humble street cart to feeding alien civilizations across the galaxy.

Inspired by **Egg, Inc.** and **Universal Paperclips**, Tap Tap Chef balances a simple, addictive tap-and-upgrade loop with an absurdly fun scale of growth—from sizzling burgers to quantum cuisine.

---

## 🎮 Core Gameplay

### Basic Loop:
- **Tap to Cook** – Taps = meals served = cash.
- **Build Combos** – Rapid taps raise a combo meter for extra earnings.
- **Frenzy Mode** – Max the meter for a short burst of huge profits.
- **Special Customers** – Occasionally a VIP pops up. Tap them for mini-games or temporary boosts.
- **Upgrade Kitchen** – Faster production, better food.
- **Hire Staff** – Automate income generation.
- **Bulk Buy Options** – Purchase 10, 100, or the max number of upgrades or staff at once.
- **Expand Reach** – From food trucks → restaurants → space diners → multiverse cafeterias.
- **Prestige** – "Universal Catering Contracts" to reset progress and gain permanent multipliers.
- **Milestone Dialogues** – Progression milestones trigger humorous snippets about your growing food empire.

### Long-Term Progression:
- **Research Tree** (Post-MVP): Unlock futuristic cooking tech.
- **Time & Space Upgrades** (Post-MVP): Reach time warp kitchens and multiverse franchises.
- **Narrative Beats** (Post-MVP): Satirical and existential reflections à la Universal Paperclips.
- **Cosmetics + Customization** (Post-MVP): Chef skins, themed kitchens, food particles, etc.

---

## 🧪 MVP Features

✅ Core Tap Mechanic  
✅ Currency System  
✅ Upgrade UI (e.g., Faster Cooking, Better Meals)  
✅ Staff Hire (Simple automation toggle)  
✅ Basic Prestige System  
✅ Save/Load Game State  
✅ Idle Earnings (background income)

🚫 No ad integration in MVP  
🚫 No IAPs (In-App Purchases)  
🚫 No Research Tree or Story Beats yet  
✅ Basic haptic feedback

---

## 🖼 Art Style

- Light 3D or illustrated sprites with soft color palettes
- Minimalist UI with Egg Inc–style bounce and clarity
- Expressive, humorous character animations (chefs, customers, aliens)

---

## 📱 Tech Stack

- **Flutter** for cross-platform mobile development (iOS & Android)
- **Riverpod** for state management
- **Hive** or **Shared Preferences** for local save data
- **Custom widget framework** for upgrade panels, tap animations, and progress bars
- Optional: Flame engine (if visual FX becomes performance-heavy)

---

## 💰 Monetization Strategy

- **Rewarded Video Ads** – watch an ad to double earnings for 5 minutes or gain a lump-sum bonus
- **IAPs for Boosts** (currency packs, chef multipliers)
- **Cosmetics Store** (skins, themed backgrounds, effects)
- **VIP Pass System** (premium prestige tree, bonus automation)

---

## 🔧 Dev Guidelines

- Keep tap interactions tight, responsive, and satisfying
- Use dummy data for upgrades & income curves during MVP
- Prioritize performance on mid-tier mobile devices
- Maintain modular code for scalability (kitchen systems, UI panels, etc.)

---

## 🛠 Sprint Priorities

1. [ ] Tap-to-cook logic  
2. [ ] Upgrade UI & backend model  
3. [ ] Staff automation layer  
4. [ ] Idle earning & save/load  
5. [ ] MVP-ready restaurant progression
6. [ ] First prestige reset loop
7. [ ] Prototype time-warp tiers

---

## 🚀 Development Setup

This repository now includes a minimal Flutter application. To run it locally:

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app on an attached device or emulator:
   ```bash
   flutter run
   ```
   For an optimized build that installs like a production app, use release mode:
   ```bash
   flutter run --release
   ```

The starter app tracks how many meals you've cooked each time you tap the **Cook!** button.
