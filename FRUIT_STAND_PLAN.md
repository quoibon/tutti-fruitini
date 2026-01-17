# Fruit Stand Implementation Plan

**Feature:** In-game store for unlocking and activating alternate fruit skins, backgrounds, and champion crown
**Status:** Planning
**Last Updated:** January 2025

---

## Table of Contents

1. [Overview](#overview)
2. [Save Data Structure](#save-data-structure)
3. [Pricing Structure](#pricing-structure)
4. [UI/UX Design](#uiux-design)
5. [Implementation Tasks](#implementation-tasks)
6. [File Changes](#file-changes)
7. [Asset Requirements](#asset-requirements)
8. [Technical Details](#technical-details)
9. [Testing Checklist](#testing-checklist)

---

## Overview

### Feature Summary

The **Fruit Stand** is a combined shop and customization screen where players can:

- **Spend accumulated points** to unlock alternate fruit skins
- **Switch between original and alternate skins** per fruit (mix and match)
- **Unlock and activate alternate backgrounds**
- **Unlock and activate a Champion Crown** (requires reaching max level)

### Key Decisions

| Decision | Choice |
|----------|--------|
| Screen name | Fruit Stand |
| Currency | Cumulative points (spent like cash) |
| Fruit skins | Mix and match (per-fruit selection) |
| Crown unlock | Reach max level (Strawberry merge) |
| Pricing | Incremental (10k base, +10k per fruit) |

---

## Save Data Structure

### New Fields for SaveManager.gd

```gdscript
# Add to default_data dictionary
var default_data = {
    "version": "1.1.0",  # Bump version for migration
    "high_score": 0,
    "shake_count": 50,

    # NEW: Fruit Stand currency
    "currency": 0,  # Spendable points (accumulated - spent)

    # NEW: Alt fruit unlocks (array of 11 booleans)
    "alt_fruits_unlocked": [false, false, false, false, false, false, false, false, false, false, false],

    # NEW: Alt fruit active state (array of 11 booleans)
    # true = use alt skin, false = use original
    "alt_fruits_active": [false, false, false, false, false, false, false, false, false, false, false],

    # NEW: Background unlocks
    "backgrounds_unlocked": [true, false, false, false],  # First background free (default)
    "active_background": 0,  # Index of currently active background

    # NEW: Champion crown
    "crown_unlocked": false,  # Auto-unlocks when highest_fruit_reached == 10
    "crown_active": false,    # Player toggle

    "settings": { ... },
    "stats": {
        "games_played": 0,
        "total_merges": 0,
        "highest_fruit_reached": 0  # Already exists - used for crown unlock
    }
}
```

### Data Migration

When loading old save data (version < 1.1.0):
- Add missing fields with default values
- Preserve existing high_score, shake_count, settings, stats

---

## Pricing Structure

### Alternate Fruits

| Fruit # | Name | Unlock Cost | Cumulative Total |
|---------|------|-------------|------------------|
| 1 | Blueberry | 10,000 | 10,000 |
| 2 | Apple | 20,000 | 30,000 |
| 3 | Lemon | 30,000 | 60,000 |
| 4 | Coconut | 40,000 | 100,000 |
| 5 | Banana | 50,000 | 150,000 |
| 6 | Dragon Fruit | 60,000 | 210,000 |
| 7 | Orange | 70,000 | 280,000 |
| 8 | Grapes | 80,000 | 360,000 |
| 9 | Pineapple | 90,000 | 450,000 |
| 10 | Watermelon | 100,000 | 550,000 |
| 11 | Strawberry | 110,000 | 660,000 |

**Total to unlock all alternate fruits: 660,000 points**

### Backgrounds

| Background # | Name | Unlock Cost |
|--------------|------|-------------|
| 0 | Beach (Default) | Free |
| 1 | TBD | 30,000 |
| 2 | TBD | 30,000 |
| 3 | TBD | 30,000 |

**Total to unlock all backgrounds: 90,000 points**

### Champion Crown

| Item | Unlock Condition |
|------|------------------|
| Crown | Reach max level (merge two Strawberries) |

**Note:** Crown is unlocked by achievement, not purchased with points.

---

## UI/UX Design

### Navigation

```
MainMenu
    ├── Play → Main (game)
    ├── Fruit Stand → FruitStand (NEW)
    ├── Settings
    ├── How to Play
    └── Quit
```

### Fruit Stand Layout

```
┌─────────────────────────────────────────────────────────────┐
│  ← Back                    FRUIT STAND                      │
│                         Points: 127,450                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [ FRUITS ]  [ BACKGROUNDS ]  [ SPECIAL ]    ← Tab buttons  │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   FRUITS TAB                         │   │
│  │                   (Scrollable)                       │   │
│  │                                                      │   │
│  │  BLUEBERRY                                          │   │
│  │  ┌────────────┐    ┌────────────┐                   │   │
│  │  │  Original  │    │    Alt     │                   │   │
│  │  │   [img]    │    │   [img]    │                   │   │
│  │  │  ✓ Active  │    │  🔒 10,000 │                   │   │
│  │  └────────────┘    └────────────┘                   │   │
│  │                                                      │   │
│  │  APPLE                                              │   │
│  │  ┌────────────┐    ┌────────────┐                   │   │
│  │  │  Original  │    │    Alt     │                   │   │
│  │  │   [img]    │    │   [img]    │                   │   │
│  │  │   Owned    │    │  🔒 20,000 │                   │   │
│  │  └────────────┘    └────────────┘                   │   │
│  │                                                      │   │
│  │  ... (continues for all 11 fruits)                  │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Item States

| State | Visual | Tap Action |
|-------|--------|------------|
| **Locked** | Grayscale/dimmed + price | Purchase (if enough points) |
| **Owned** | Full color, no indicator | Activate |
| **Active** | Full color + checkmark | None (already active) |

### Tab Content

**FRUITS Tab:**
- 11 fruit rows, each with Original + Alt side by side
- Scrollable container

**BACKGROUNDS Tab:**
- Grid of background thumbnails
- Shows locked/owned/active state

**SPECIAL Tab:**
- Champion Crown item
- Shows "Reach Max Level to Unlock!" if locked
- Toggle on/off if unlocked

---

## Implementation Tasks

### Phase 1: Save System Updates

- [ ] Update SaveManager.gd with new fields
- [ ] Add data migration for old saves
- [ ] Add getter/setter methods:
  - `get_currency()` / `add_currency(amount)` / `spend_currency(amount)`
  - `is_alt_fruit_unlocked(level)` / `unlock_alt_fruit(level)`
  - `is_alt_fruit_active(level)` / `set_alt_fruit_active(level, active)`
  - `is_background_unlocked(index)` / `unlock_background(index)`
  - `get_active_background()` / `set_active_background(index)`
  - `is_crown_unlocked()` / `unlock_crown()`
  - `is_crown_active()` / `set_crown_active(active)`
- [ ] Update `add_score()` to also add to currency

### Phase 2: Fruit Stand Scene

- [ ] Create FruitStand.tscn
  - Back button
  - Points display (top)
  - Tab buttons (Fruits / Backgrounds / Special)
  - ScrollContainer for content
  - Fruit item template (Original + Alt pair)
  - Background item template
  - Crown item display
- [ ] Create FruitStand.gd
  - Tab switching logic
  - Populate fruit/background items dynamically
  - Purchase flow with confirmation
  - Activation toggle logic
  - Connect to SaveManager

### Phase 3: Main Menu Integration

- [ ] Add "Fruit Stand" button to MainMenu.tscn
- [ ] Update MainMenu.gd with navigation
- [ ] Style button to match existing design

### Phase 4: Fruit Skin Switching

- [ ] Update Fruit.gd `try_load_sprite_image()`:
  - Check `SaveManager.is_alt_fruit_active(level)`
  - Load from alt sprite path if active
- [ ] Update Fruit.gd `try_generate_collision_from_sprite()`:
  - Use same alt sprite for collision generation
- [ ] Create alt sprite path mapping

### Phase 5: Sound Switching

- [ ] Update AudioManager.gd:
  - Add alt sound file paths
  - Check active skin when playing fruit sounds
  - `play_fruit_sound(level)` checks alt active state

### Phase 6: Background Switching

- [ ] Update Main.gd:
  - Load background based on `SaveManager.get_active_background()`
- [ ] Update MainMenu.gd (if different menu background):
  - Same background switching logic

### Phase 7: Champion Crown

- [ ] Create crown sprite asset
- [ ] Update Fruit.gd:
  - Add crown overlay if `SaveManager.is_crown_active()`
  - Position crown at top of fruit
  - Scale with fruit size
- [ ] Update max merge logic in Fruit.gd:
  - Call `SaveManager.unlock_crown()` when two Strawberries merge
  - Show unlock notification

### Phase 8: Polish

- [ ] Add purchase confirmation dialog
- [ ] Add unlock animations/effects
- [ ] Add "Not enough points" feedback
- [ ] Add crown unlock celebration
- [ ] Test save/load persistence
- [ ] Test data migration from old saves

---

## File Changes

### New Files

| File | Purpose |
|------|---------|
| `scenes/FruitStand.tscn` | Fruit Stand UI scene |
| `scripts/FruitStand.gd` | Fruit Stand logic |

### Modified Files

| File | Changes |
|------|---------|
| `scripts/autoload/SaveManager.gd` | New fields, getters/setters, migration |
| `scripts/autoload/AudioManager.gd` | Alt sound support |
| `scripts/Fruit.gd` | Alt sprite loading, crown overlay |
| `scripts/Main.gd` | Background switching |
| `scripts/MainMenu.gd` | Fruit Stand button |
| `scenes/MainMenu.tscn` | Fruit Stand button |

---

## Asset Requirements

### Alternate Fruit Sprites

Location: `res://assets/sprites/fruits/alt/`

| File | Size | Notes |
|------|------|-------|
| `1.AltBlueberry.png` | 1024x1024 | Alt skin for fruit 1 |
| `2.AltApple.png` | 1024x1024 | Alt skin for fruit 2 |
| `3.AltLemon.png` | 1024x1024 | Alt skin for fruit 3 |
| `4.AltCoconut.png` | 1024x1024 | Alt skin for fruit 4 |
| `5.AltBanana.png` | 1024x1024 | Alt skin for fruit 5 |
| `6.AltDragonFruit.png` | 1024x1024 | Alt skin for fruit 6 |
| `7.AltOrange.png` | 1024x1024 | Alt skin for fruit 7 |
| `8.AltGrapes.png` | 1024x1024 | Alt skin for fruit 8 |
| `9.AltPineapple.png` | 1024x1024 | Alt skin for fruit 9 |
| `10.AltWatermelon.png` | 1024x1024 | Alt skin for fruit 10 |
| `11.AltStrawberry.png` | 1024x1024 | Alt skin for fruit 11 |

**Sprite Guidelines:**
- Same 1024x1024 dimensions as originals
- Similar silhouette/proportions for consistent collision
- Transparent background (PNG with alpha)

### Alternate Sound Effects

Location: `res://assets/sounds/sfx/alt/`

| File | Format | Notes |
|------|--------|-------|
| `01.AltBlueberry.mp3` | MP3/OGG | Alt sound for fruit 1 |
| `02.AltApple.mp3` | MP3/OGG | Alt sound for fruit 2 |
| ... | ... | ... |
| `11.AltStrawberry.mp3` | MP3/OGG | Alt sound for fruit 11 |

### Alternate Backgrounds

Location: `res://assets/sprites/backgrounds/`

| File | Size | Notes |
|------|------|-------|
| `beach.png` | 1080x1920 | Default (already exists) |
| `background_2.png` | 1080x1920 | Alt background 1 |
| `background_3.png` | 1080x1920 | Alt background 2 |
| `background_4.png` | 1080x1920 | Alt background 3 |

### Crown Sprite

Location: `res://assets/sprites/ui/`

| File | Size | Notes |
|------|------|-------|
| `crown.png` | 256x256 | Champion crown overlay |

**Crown Guidelines:**
- Transparent background
- Golden/metallic appearance
- Will be scaled dynamically based on fruit size

---

## Technical Details

### Currency Flow

```
Player earns points (ScoreManager)
    ↓
Points added to currency (SaveManager.add_currency)
    ↓
Currency displayed in Fruit Stand
    ↓
Player purchases item
    ↓
Currency deducted (SaveManager.spend_currency)
    ↓
Item unlocked (SaveManager.unlock_xxx)
```

### Fruit Sprite Loading Logic

```gdscript
# In Fruit.gd try_load_sprite_image()

func get_sprite_path(level: int) -> String:
    var use_alt = SaveManager.is_alt_fruit_active(level)

    if use_alt:
        return "res://assets/sprites/fruits/alt/" + alt_sprite_files[level + 1] + ".png"
    else:
        return "res://assets/sprites/fruits/" + sprite_files[level + 1] + ".png"
```

### Crown Positioning

```gdscript
# In Fruit.gd, after setup_visuals()

func setup_crown() -> void:
    if not SaveManager.is_crown_active():
        return

    var crown_sprite = Sprite2D.new()
    crown_sprite.texture = preload("res://assets/sprites/ui/crown.png")
    crown_sprite.name = "Crown"

    # Position at top of fruit
    var radius = fruit_info.get("radius", 16) * get_size_scale_for_level(level)
    crown_sprite.position = Vector2(0, -radius * 0.85)

    # Scale crown relative to fruit size
    var crown_scale = radius / 100.0  # Adjust divisor for desired size
    crown_sprite.scale = Vector2(crown_scale, crown_scale)

    add_child(crown_sprite)
```

### Tab Switching

```gdscript
# In FruitStand.gd

enum Tab { FRUITS, BACKGROUNDS, SPECIAL }
var current_tab: Tab = Tab.FRUITS

func _on_fruits_tab_pressed() -> void:
    current_tab = Tab.FRUITS
    fruits_content.visible = true
    backgrounds_content.visible = false
    special_content.visible = false
    update_tab_buttons()

func _on_backgrounds_tab_pressed() -> void:
    current_tab = Tab.BACKGROUNDS
    fruits_content.visible = false
    backgrounds_content.visible = true
    special_content.visible = false
    update_tab_buttons()

func _on_special_tab_pressed() -> void:
    current_tab = Tab.SPECIAL
    fruits_content.visible = false
    backgrounds_content.visible = false
    special_content.visible = true
    update_tab_buttons()
```

---

## Testing Checklist

### Save System

- [ ] New save creates correct default values
- [ ] Old save migrates correctly (no data loss)
- [ ] Currency persists across app restart
- [ ] Unlocks persist across app restart
- [ ] Active selections persist across app restart

### Fruit Stand UI

- [ ] Points display updates correctly
- [ ] Tab switching works
- [ ] Scrolling works on all tabs
- [ ] Locked items show price
- [ ] Owned items are tappable
- [ ] Active items show checkmark
- [ ] Back button returns to MainMenu

### Purchasing

- [ ] Cannot purchase with insufficient points
- [ ] Points deducted correctly on purchase
- [ ] Item unlocks immediately after purchase
- [ ] Purchase feedback shown (animation/sound)

### Fruit Skins

- [ ] Original skin loads when alt not active
- [ ] Alt skin loads when active
- [ ] Collision shape matches active skin
- [ ] Mix and match works (different fruits, different skins)

### Sounds

- [ ] Original sound plays when alt not active
- [ ] Alt sound plays when active

### Backgrounds

- [ ] Default background shows initially
- [ ] Unlocked backgrounds can be activated
- [ ] Active background persists to gameplay

### Champion Crown

- [ ] Crown locked until max level reached
- [ ] Crown unlocks when two Strawberries merge
- [ ] Unlock notification shown
- [ ] Crown toggle works in Fruit Stand
- [ ] Crown appears on all fruits when active
- [ ] Crown scales correctly per fruit size
- [ ] Crown follows fruit physics (rotation)

---

## Future Considerations

- **Additional skin sets:** Could add more than one alt per fruit
- **Seasonal themes:** Holiday-specific skins/backgrounds
- **Achievement unlocks:** More items tied to achievements
- **Daily rewards:** Free currency or items
- **Watch ad for currency:** Alternative to grinding

---

## Changelog

| Date | Changes |
|------|---------|
| Jan 2025 | Initial plan created |
| | |

---

*This document will be updated as assets are prepared and implementation progresses.*
