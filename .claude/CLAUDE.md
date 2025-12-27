# 🍉 Tutti Fruttini - Technical Reference

**Engine:** Godot 4.2+ | **Package:** `com.bonsaidotdot.tuttifruitini` | **Version:** 1.0.0 (Pre-Release)
**Status:** Milestones 1-6 Complete | **Next:** Release Preparation

---

## Project Overview

Physics-based fruit-merging puzzle game. Drop fruits, merge identical ones, shake to jostle pile. Player-friendly monetization (rewarded ads only for shake refills).

**Core Mechanics:**
- 11 fruit tiers (0-10): Cherry → Watermelon
- Spawn pool: Levels 0-4 only (weighted random)
- Merge on collision (identical level + low velocity)
- Shake system: 50 uses, refill via rewarded ad
- Game over: 2-second grace period when fruit stays in danger zone

---

## Technical Specifications

### Physics Configuration
```gdscript
# Project Settings
default_gravity = 980.0
physics_ticks_per_second = 60

# Fruit PhysicsMaterial (CURRENT - optimized)
friction = 0.5
bounce = 0.09

# Merge Conditions
velocity_threshold = 300  # px/s average
merge_cooldown = 0.05     # seconds
spawn_cooldown = 0.5      # seconds
```

### Fruit Data (Scale: 0.85x)
| Level | Name | Radius | Score | Spawn % |
|-------|------|--------|-------|---------|
| 0 | Cherry | 36px | 1 | 35% |
| 1 | Strawberry | 42px | 3 | 30% |
| 2 | Grape | 50px | 6 | 20% |
| 3 | Orange | 67px | 10 | 10% |
| 4 | Lemon | 84px | 15 | 5% |
| 5-10 | Apple→Watermelon | 101-208px | 21-100 | 0% (merge only) |

### Collision Layers
- **1 (Walls):** StaticBody2D container
- **2 (Fruits):** RigidBody2D fruits
- **4 (MergeDetection):** Area2D merge zones
- **8 (GameOverZone):** Area2D top boundary

### Performance Targets
- **FPS:** 60 (achieved ✅)
- **Max Fruits:** 75 active (enforced by pool ✅)
- **RAM Usage:** <150MB (currently ~120MB ✅)

---

## Architecture

### Autoload Singletons
1. **GameManager** - Fruit data, game state
2. **ScoreManager** - Score, combo (1.0-3.0x), high score
3. **AudioManager** - Music + 15 pooled SFX channels
4. **SaveManager** - JSON persistence (`user://save_data.json`)
5. **AdManager** - AdMob integration + 30s fallback timer

### Object Pools
- **FruitPool:** 30 initial, 100 max, 75 active limit (auto-culls oldest)
- **ParticlePool:** 15 pre-warmed systems

### Scene Hierarchy
```
Main.tscn
├── Camera2D (shake effect)
├── Container (walls/floor)
├── GameplayArea
│   ├── SpawnPoint, FruitContainer, GameOverDetector
│   └── NextFruitPreview (mouse-following)
├── Managers (Spawner, ShakeManager)
├── UI (Score, Combo, Shake Counter, Refill Button)
├── FruitPool
└── ParticlePool
```

---

## Key Systems

### Shake Mechanic
- **Count:** 50 max (persists via SaveManager)
- **Cooldown:** 0.8s between uses
- **Impulse:** Random vector (150 strength, mostly horizontal)
- **Feedback:** Camera shake, haptic (100ms), particles, sound
- **Refill:** Rewarded ad OR free after 30s timer

### Scoring System
```gdscript
# Combo system
combo_multiplier += 0.1  # per merge within 3s
max_combo = 3.0x
combo_timeout = 3.0      # resets to 1.0x
```

### Game Over Detection
- **Area2D at top** with 2-second grace period
- **Velocity check:** Ignore fast-moving fruits (>200 px/s)
- **Visual warning:** Red overlay + pulsing

### Save Data Structure
```json
{
  "version": "1.0.0",
  "high_score": 0,
  "shake_count": 50,
  "settings": {
    "music_volume": 0.8,
    "sfx_volume": 1.0,
    "music_enabled": true,
    "sfx_enabled": true,
    "vibration_enabled": true
  },
  "stats": {
    "games_played": 0,
    "total_merges": 0,
    "highest_fruit_reached": 0
  }
}
```

---

## File Structure

```
/tutti-fruitini
├── /scenes
│   ├── Main.tscn, Fruit.tscn, MainMenu.tscn, GameOver.tscn
├── /scripts
│   ├── /autoload (GameManager, ScoreManager, AudioManager, SaveManager, AdManager)
│   ├── Main.gd, Fruit.gd, Spawner.gd, ShakeManager.gd, GameOverDetector.gd
│   ├── FruitPool.gd, ParticlePool.gd, Utils.gd
├── /data
│   └── fruit_data.json (11 fruit definitions)
├── /assets/sounds
│   ├── /sfx (merge_01-05.wav, drop, shake, game_over, click, refill)
│   └── /music (bgm_main.ogg)
├── project.godot
└── default_bus_layout.tres (Music: -6dB, SFX: 0dB)
```

---

## Audio System

**Buses:** Master → Music (-6dB) / SFX (0dB)

**SFX Files (all gracefully handle missing):**
- `merge_01.wav` - `merge_05.wav` (randomized)
- `drop.wav`, `shake.wav`, `game_over.wav`, `click.wav`, `refill.wav`

**Music:** `bgm_main.ogg` (looping)

**Implementation:** 15-channel pooled AudioStreamPlayer (prevents cutoff)

---

## AdMob Integration

**Plugin:** [Poing Studios Godot AdMob Plugin](https://github.com/Poing-Studios/godot-admob-plugin)

**Test IDs (used by default):**
```gdscript
ANDROID_REWARDED_AD_ID = "ca-app-pub-3940256099942544/5224354917"
IOS_REWARDED_AD_ID = "ca-app-pub-3940256099942544/1712485313"
```

**Fallback:** If ad fails/unavailable, free refill after 30s countdown timer

**For Production:**
1. Replace test IDs with real AdMob IDs
2. Update AndroidManifest.xml with real App ID
3. Test rewarded ad flow on release build

---

## Android Build Configuration

**Package:** `com.bonsaidotdot.tuttifruitini`
**Min SDK:** 24 (Android 7.0) | **Target SDK:** 34 (Android 14)
**Orientation:** Portrait only
**Permissions:** INTERNET, ACCESS_NETWORK_STATE, VIBRATE

**Signing:**
```bash
keytool -genkey -v -keystore tuttifruitini.keystore \
  -alias tuttifruitini -keyalg RSA -keysize 2048 -validity 10000
```

**Build:**
```bash
godot --headless --export-release "Android" bin/tuttifruitini-release.aab
```

---

## UI/UX Reference

**Colors:**
- Primary: `#FF6B6B`, Secondary: `#4ECDC4`, Background: `#FFE66D`
- Text: `#1A535C`, Danger: `#FF006E`

**Touch Targets:** Min 44x44 dp
**Shake Button:** 80x80 dp circular
**Aspect Ratios:** 16:9 to 20:9 (portrait)

**Animations:**
- Fruit drop: Scale 0.8→1.0 (0.2s bounce)
- Merge: Scale fruits to 0.0 (0.15s), spawn new at 1.3→1.0 (0.2s)
- Camera shake: 5px amplitude, 0.3s duration

---

## Development Notes

### Current Status (December 2024)
✅ **Complete:** Core gameplay, shake system, ads, UI, audio, save system, object pooling
⏳ **Pending:** Audio files (placeholders exist), custom fruit sprites, release prep

### Known Issues
1. Audio files are placeholders (game handles gracefully)
2. AdMob plugin must be installed separately (has fallback)
3. Using colored circles instead of custom sprites
4. No in-game settings menu yet

### Performance Optimization
- Fruit pooling: Auto-returns on merge/removal
- Particle pooling: Auto-returns after effect
- Limit enforcement: Culls oldest when >75 fruits
- Use Godot Profiler: Target <16.67ms frame time

---

## Release Checklist (Milestone 7 - TODO)

**Pre-Release:**
- [ ] Create privacy policy page (host at bonsaidotdot.com)
- [ ] Setup Google Play Console account
- [ ] Replace test AdMob IDs with production IDs
- [ ] Update AndroidManifest.xml with real App ID
- [ ] Create app icon and screenshots
- [ ] Write store listing description
- [ ] Generate signed release build (.aab)
- [ ] Test ad flow on release build
- [ ] Verify save/load persistence
- [ ] Test on multiple devices (low/mid/high-end)

**Store Listing:**
- App Name: Italian Brainrot Tutti Fruttini Combinasion
- Category: Puzzle | Rating: Everyone
- Pricing: Free with ads (rewarded only)

---

## Quick Reference: Critical Files

| File | Purpose |
|------|---------|
| `AdManager.gd` | AdMob integration, test IDs, 30s fallback timer |
| `FruitPool.gd` | Object pooling (30→100 max, 75 active limit) |
| `ParticlePool.gd` | Particle system pooling (15 pre-warmed) |
| `SaveManager.gd` | JSON persistence, auto-save |
| `AudioManager.gd` | 15-channel SFX pool, music control |
| `Fruit.gd` | Merge logic, velocity checks, animations |
| `Spawner.gd` | Input handling, mouse preview, spawn cooldown |
| `ShakeManager.gd` | Impulse system, camera shake, persistence |
| `GameOverDetector.gd` | Danger zone, grace period (2s), velocity filter |

---

## Privacy & Compliance

**COPPA:** Mark as "Not primarily for children" (ages 10+)
**GDPR:** Use AdMob consent SDK for EEA users

**Privacy Policy Requirements:**
- Disclose AdMob data collection (Ad ID, IP, device info)
- State no personal data collected by game
- Provide opt-out instructions (device settings)
- Link: https://bonsaidotdot.com/legal/privacy.html

---

**Last Updated:** December 2024
**Contact:** bonsai@bonsaidotdot.com

*This is a living document. Update as development progresses.*
