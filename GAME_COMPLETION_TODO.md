# Game Completion TODO

This document outlines all remaining tasks to complete Tutti Fruitini to a production-ready state.

**Current Status**: Core systems complete (Milestones 1-6 ✅)
**Goal**: Polished, release-ready game

---

## 🎨 Graphics & Art Assets

### Critical (Game Cannot Ship Without)

#### Fruit Sprites (11 total)
**Current**: Colored circles (placeholder)
**Needed**: Italian brainrot themed fruit sprites

- [ ] **Cherry** (Level 0) - 36px radius
  - Style: Small, cute, Italian aesthetic
  - Colors: Red (#E60012)

- [ ] **Strawberry** (Level 1) - 42px radius
  - Style: Slightly larger than cherry
  - Colors: Red/pink (#FF1744)

- [ ] **Grape** (Level 2) - 50px radius
  - Style: Cluster of grapes
  - Colors: Purple (#9C27B0)

- [ ] **Orange** (Level 3) - 67px radius
  - Style: Round citrus fruit
  - Colors: Orange (#FF9800)

- [ ] **Lemon** (Level 4) - 84px radius
  - Style: Oval citrus fruit
  - Colors: Yellow (#FFEB3B)

- [ ] **Apple** (Level 5) - 101px radius
  - Style: Classic apple shape
  - Colors: Red (#F44336)

- [ ] **Pear** (Level 6) - 118px radius
  - Style: Pear-shaped
  - Colors: Green (#8BC34A)

- [ ] **Peach** (Level 7) - 134px radius
  - Style: Round with leaf
  - Colors: Peach/pink (#FFB6C1)

- [ ] **Pineapple** (Level 8) - 151px radius
  - Style: Tropical with crown
  - Colors: Yellow/gold (#FFD700)

- [ ] **Melon** (Level 9) - 168px radius
  - Style: Round cantaloupe
  - Colors: Green/orange (#4CAF50)

- [ ] **Watermelon** (Level 10) - 208px radius (largest!)
  - Style: Large, iconic watermelon
  - Colors: Green/red stripes (#C8E6C9)

**Sprite Requirements**:
- Format: PNG with transparency
- Resolution: 2x radius (e.g., Cherry = 72x72px minimum)
- Style: Cute, cartoony, consistent art style
- Export at 2x for retina/high-DPI
-Optionally create sprite atlas for performance

#### UI Graphics

- [ ] **Button sprites**
  - Shake button (custom design)
  - Refill button
  - Play button
  - Restart button
  - Settings button
  - Pause button

- [ ] **Panel backgrounds**
  - Game over panel
  - Pause menu panel
  - Settings panel

- [ ] **Icons**
  - Shake icon (🔔 current emoji, needs sprite)
  - Sound on/off icons
  - Music on/off icons
  - Back/close icons

### Nice-to-Have (Polish)

- [ ] **Background art**
  - Container background texture
  - Game area background (currently solid color)
  - Menu background

- [ ] **Container visuals**
  - Wall textures (currently colored rectangles)
  - Floor texture
  - Container outline/border

- [ ] **Particle improvements**
  - Custom particle sprites (stars, sparkles)
  - Different effects for different fruit levels
  - Screen-shake visual distortion

- [ ] **App icon**
  - 1024x1024 source
  - Adaptive icon for Android
  - Multiple sizes generated

---

## 🔊 Audio Assets

### Critical (Currently Silently Failing)

#### Sound Effects (`.wav` format, 44.1kHz, 16-bit)

- [ ] **Merge sounds** (5 variants for variety)
  - `merge_01.wav` - Short, satisfying "pop"
  - `merge_02.wav` - Slightly different pitch
  - `merge_03.wav` - Different tone
  - `merge_04.wav` - Variation
  - `merge_05.wav` - Variation
  - Duration: 0.2-0.5 seconds each
  - Style: Playful, bubbly, satisfying

- [ ] **drop.wav**
  - Soft "plop" or "thud" when fruit drops
  - Duration: 0.1-0.3 seconds
  - Style: Gentle, not harsh

- [ ] **shake.wav**
  - Rumble/rattle sound
  - Duration: 0.3-0.5 seconds
  - Style: Energetic, impactful

- [ ] **game_over.wav**
  - Descending tone or "aww" sound
  - Duration: 1.0-2.0 seconds
  - Style: Gentle loss sound, not harsh

- [ ] **click.wav**
  - UI button click/tap
  - Duration: 0.05-0.1 seconds
  - Style: Crisp, clean click

- [ ] **refill.wav**
  - Success chime or "power-up" sound
  - Duration: 0.5-1.0 seconds
  - Style: Positive, rewarding

#### Music (`.ogg` format, looping)

- [ ] **bgm_main.ogg**
  - Main gameplay background music
  - Style: Upbeat, casual, Italian/Mediterranean vibe
  - Tempo: Medium, non-intrusive
  - Duration: 1-2 minutes, seamlessly looping
  - Volume: Mixed for background (not overpowering)

### Nice-to-Have (Polish)

- [ ] Menu music (different from gameplay)
- [ ] Combo sound effects (when multiplier increases)
- [ ] High score celebration sound
- [ ] Danger zone warning sound (when fruits near top)
- [ ] Ambient sounds (subtle background atmosphere)

**Audio Sourcing Options**:
1. Create custom (using tools like BFXR, Audacity)
2. Purchase from asset stores (Itch.io, Unity Asset Store)
3. Free sources (Freesound.org, OpenGameArt.org)
4. Commission from audio designer

---

## 🎮 Polish & Menu Systems

### Settings Menu (Missing!)

- [ ] **Create Settings.tscn scene**
  - Music volume slider (0-100%)
  - SFX volume slider (0-100%)
  - Music on/off toggle
  - SFX on/off toggle
  - Vibration on/off toggle
  - Back button

- [ ] **Settings button in MainMenu**
  - Add settings button to MainMenu.tscn
  - Connect to Settings scene

- [ ] **Settings in pause menu**
  - Access settings from pause menu

### Pause Menu (Missing!)

- [ ] **Create Pause.tscn scene**
  - Resume button
  - Restart button
  - Settings button
  - Quit to menu button
  - Semi-transparent overlay

- [ ] **Pause button in Main scene**
  - Add pause button to HUD
  - Pause game logic (freeze physics)
  - Show pause menu

### Tutorial/How to Play (Recommended)

- [ ] **First-time tutorial**
  - Show on first launch
  - Explain tap to drop fruit
  - Explain merging mechanic
  - Explain shake mechanic
  - "Don't show again" option

- [ ] **How to Play button**
  - Add to main menu
  - Simple instruction screen
  - Visual examples

### Credits Screen (Nice-to-Have)

- [ ] **Credits scene**
  - Developer name
  - Asset credits (art, audio)
  - Plugin credits (AdMob)
  - Framework credit (Godot)

### Visual Polish

- [ ] **UI animations**
  - Button hover/press animations
  - Panel slide-in animations
  - Score pop-up animations
  - Combo multiplier pulse

- [ ] **Screen transitions**
  - Fade between scenes
  - Smooth scene changes

- [ ] **Juice effects**
  - Screen shake improvements
  - More particle variety
  - Fruit squash/stretch on impact
  - Glow effects for high combos

- [ ] **Visual feedback**
  - Danger zone warning (red flash/pulse)
  - Combo multiplier visual indicator
  - Next fruit preview animation
  - Drop indicator improvements

---

## ⚙️ Game Mechanics Fine-Tuning

### Balance Testing

- [ ] **Fruit spawn weights**
  - Current: Cherry 35%, Strawberry 30%, Grape 20%, Orange 10%, Lemon 5%
  - Test if too easy/hard
  - Adjust based on playtesting

- [ ] **Fruit sizes**
  - Current: 0.85x scale
  - Test if too small/large
  - Adjust for optimal gameplay feel

- [ ] **Container dimensions**
  - Width: 540px
  - Height: 960px
  - Test if too cramped/spacious

- [ ] **Gravity & Physics**
  - Gravity: 980.0
  - Bounce: 0.09
  - Friction: 0.5
  - Test feel, adjust if needed

### Scoring Balance

- [ ] **Score values**
  - Test if progression feels rewarding
  - Adjust individual fruit scores
  - Balance combo multiplier (current: +0.1x, max 3.0x)

- [ ] **Combo timing**
  - Current: 3 second timeout
  - Test if too short/long
  - Adjust for optimal flow

### Difficulty Tuning

- [ ] **Spawn cooldown**
  - Current: 0.5 seconds
  - Test if too fast/slow
  - Adjust for difficulty curve

- [ ] **Merge cooldown**
  - Current: 0.05 seconds
  - Test for unintended double-merges
  - Adjust if issues found

- [ ] **Shake count**
  - Current: 50 maximum
  - Test if too generous/stingy
  - Adjust based on average game length

- [ ] **Game over grace period**
  - Current: 2 seconds
  - Test if too forgiving/harsh
  - Adjust for fairness

### Quality of Life

- [ ] **Input improvements**
  - Test touch accuracy
  - Add visual drop indicator line
  - Improve preview fruit feedback

- [ ] **Camera adjustments**
  - Test if viewport shows everything clearly
  - Adjust zoom if needed
  - Ensure UI elements visible on all devices

- [ ] **Performance on low-end devices**
  - Test on Android 7.0 / 2GB RAM device
  - Reduce effects if needed
  - Adjust max fruit count if necessary

---

## 🧪 Playtesting & Iteration

### Internal Testing

- [ ] **10+ test sessions** (varied playstyles)
  - Note average game duration
  - Track average score
  - Identify frustration points
  - Note if game feels too easy/hard

- [ ] **Edge case testing**
  - Fill container with 100+ fruits
  - Rapid tapping spam
  - Game over during shake
  - Ad failure scenarios

- [ ] **Balance spreadsheet**
  - Track score progression
  - Compare spawn rates to merge rates
  - Identify dominant strategies

### External Testing (Friends/Family)

- [ ] **5+ external testers**
  - Record feedback
  - Note confusion points
  - Identify unclear mechanics
  - Ask about difficulty

- [ ] **Tutorial effectiveness**
  - Can new players understand mechanics?
  - Do they know how to shake?
  - Do they understand merging?

### Iteration

- [ ] **Implement feedback**
  - Prioritize critical issues
  - Adjust mechanics based on data
  - Iterate until game feels "right"

---

## 📱 Device-Specific Testing

- [ ] **Android 7.0** (Low-end)
  - Performance acceptable?
  - Input responsive?
  - Crashes?

- [ ] **Android 11** (Mid-range)
  - Smooth gameplay?
  - All features work?

- [ ] **Android 13+** (High-end)
  - Locked 60 FPS?
  - No issues?

- [ ] **Various screen sizes**
  - 16:9, 18:9, 19.5:9, 20:9
  - Notch/cutout handling
  - UI elements positioned correctly

---

## 🚀 Pre-Release Tasks (Milestone 7)

- [ ] Create privacy policy
- [ ] Setup Google Play Console
- [ ] Replace AdMob test IDs
- [ ] Create store listing
- [ ] Screenshots (5+ required)
- [ ] Promotional graphics
- [ ] Generate signed release build
- [ ] Internal testing track
- [ ] Final QA
- [ ] Public release

---

## Priority Breakdown

### CRITICAL (Must Have for 1.0)
1. ✅ All 11 fruit sprites
2. ✅ All 6 sound effects (merge x5, drop, shake, game_over, click, refill)
3. ✅ Background music
4. ✅ Settings menu
5. ✅ Pause menu
6. ✅ Basic balance testing (10+ sessions)

### HIGH (Strongly Recommended)
1. Tutorial/How to Play
2. Visual polish (animations, transitions)
3. External playtesting
4. Device testing
5. Improved UI graphics

### MEDIUM (Nice to Have)
1. Credits screen
2. Additional visual effects
3. Multiple backgrounds
4. Additional audio polish
5. Menu music

### LOW (Post-Launch)
1. Daily challenges
2. Leaderboards
3. Achievements
4. Fruit skins/themes
5. Special events

---

## Estimated Timeline

**With Art/Audio Assets Provided**:
- Polish & Menus: 1-2 weeks
- Fine-tuning & Testing: 1-2 weeks
- Total: 2-4 weeks

**With Asset Creation from Scratch**:
- Art creation: 2-4 weeks
- Audio creation: 1-2 weeks
- Polish & implementation: 1-2 weeks
- Testing & iteration: 1-2 weeks
- Total: 5-10 weeks

---

## Next Steps

1. **Decide on art style** - Sketch concepts for Italian brainrot fruits
2. **Source audio** - Create/purchase/commission sounds
3. **Build Settings menu** - First missing critical feature
4. **Build Pause menu** - Second missing critical feature
5. **Playtest extensively** - Find balance issues
6. **Iterate** - Fix problems, polish rough edges
7. **Prepare for release** - Milestone 7 tasks

---

**Current Completion**: ~60% (core systems done, content & polish pending)
**Target for 1.0 Release**: 100% of CRITICAL + HIGH priority items
