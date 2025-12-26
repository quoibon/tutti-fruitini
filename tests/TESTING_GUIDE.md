# Testing Guide for Tutti Fruitini

This guide outlines testing procedures for the game.

## Automated Testing

### Unit Testing Framework

For automated unit tests, install the **GUT (Godot Unit Test)** framework:
- GitHub: https://github.com/bitwes/Gut
- Installation: Via Godot Asset Library

### Test Cases to Implement (Future)

```gdscript
# test_merge_logic.gd
- test_same_level_fruits_merge()
- test_different_level_fruits_dont_merge()
- test_max_level_fruit_merging()
- test_merge_cooldown_prevents_instant_merge()
- test_velocity_threshold_prevents_midair_merge()

# test_physics.gd
- test_fruit_settles_after_drop()
- test_shake_applies_impulse()
- test_fruits_dont_pass_through_walls()
- test_game_over_detector_triggers_correctly()

# test_save_system.gd
- test_high_score_saves_and_loads()
- test_shake_count_persists()
- test_settings_save_correctly()
```

## Manual Testing Checklist

### Core Gameplay

#### Fruit Spawning
- [ ] Fruit spawns when screen is tapped
- [ ] Fruit spawns at correct X position (following mouse)
- [ ] Fruit doesn't spawn when tapping shake button
- [ ] Fruit doesn't spawn when game is over
- [ ] Spawn cooldown (0.5s) works correctly
- [ ] Next fruit preview updates after each spawn
- [ ] Preview follows mouse position smoothly

#### Fruit Merging
- [ ] Two identical fruits merge when touching
- [ ] Different fruits don't merge
- [ ] Merged fruit spawns at midpoint of two fruits
- [ ] Merge doesn't trigger when fruits are moving fast
- [ ] Merge cooldown prevents instant merging
- [ ] Watermelon (level 10) merging works correctly
- [ ] Multiple simultaneous merges work correctly
- [ ] Merge particle effects appear at correct position
- [ ] Merge sound plays (varies between 5 sounds)

#### Scoring
- [ ] Score increases on merge
- [ ] Score multiplier increases with consecutive merges
- [ ] Combo multiplier resets after 3 seconds
- [ ] High score updates when exceeded
- [ ] High score persists after game restart
- [ ] Score displays correctly in UI

#### Game Over
- [ ] Game over triggers when fruit stays in danger zone for 2 seconds
- [ ] Fast-moving fruits don't trigger game over
- [ ] Grace period timer works correctly
- [ ] Game over screen shows final score
- [ ] Game over screen shows high score
- [ ] "New High Score" message displays when appropriate
- [ ] Game over sound plays

### Shake Mechanic

- [ ] Shake button applies impulse to all fruits
- [ ] Shake count decreases by 1 after each shake
- [ ] Shake has 0.8s cooldown
- [ ] Shake counter displays correctly
- [ ] Haptic feedback triggers (on mobile)
- [ ] Camera shake effect activates
- [ ] Shake sound plays
- [ ] Refill button appears when shake count reaches 0
- [ ] Shake button disables when count is 0

### Ad System

#### AdMob Integration (With Plugin)
- [ ] AdMob initializes on app start
- [ ] Rewarded ad loads in background
- [ ] Ad displays when refill button pressed
- [ ] Shake count refills to 50 after watching ad
- [ ] Refill sound plays after ad completion
- [ ] New ad loads after previous ad closes
- [ ] Ad failure shows appropriate message
- [ ] Free refill timer starts on ad failure

#### Fallback Mode (Without Plugin)
- [ ] Game works without AdMob plugin
- [ ] Free refill timer starts when count reaches 0
- [ ] Free refill available after 30 seconds
- [ ] Refill button shows countdown timer
- [ ] Free refill works correctly

### Audio System

#### Sound Effects
- [ ] Drop sound plays when fruit spawns
- [ ] Merge sounds play (cycle through 5 variants)
- [ ] Shake sound plays with haptic feedback
- [ ] Game over sound plays
- [ ] Button click sounds play on all UI buttons
- [ ] Refill sound plays after shake refill
- [ ] Sounds don't cut each other off (8 SFX channels)

#### Music
- [ ] Background music loops correctly
- [ ] Music volume control works
- [ ] SFX volume control works
- [ ] Music toggle works
- [ ] SFX toggle works

### Save System

- [ ] High score saves immediately
- [ ] Shake count persists between sessions
- [ ] Audio settings persist
- [ ] Game stats update correctly
- [ ] Save file creates on first launch
- [ ] Corrupt save file handled gracefully

### UI/UX

- [ ] All buttons respond to touch
- [ ] Score updates in real-time
- [ ] High score displays correctly
- [ ] Combo multiplier shows with correct color
- [ ] Shake counter updates immediately
- [ ] Next fruit preview shows correct fruit
- [ ] Game over screen buttons work
- [ ] Main menu buttons work
- [ ] Refill button text updates correctly

### Performance

- [ ] Game runs at 60 FPS with 50 fruits
- [ ] No frame drops during merges
- [ ] No memory leaks after 10 minutes of play
- [ ] Object pooling reduces allocation overhead
- [ ] Fruit count limiter prevents performance issues
- [ ] Particle pool prevents stuttering

### Physics

- [ ] Fruits have correct bounciness (0.09)
- [ ] Fruits have appropriate friction (0.5)
- [ ] Fruits settle after shaking
- [ ] Fruits don't clip through walls
- [ ] Fruits don't jitter when stacked
- [ ] Container bounds are correct
- [ ] Collision detection is accurate

## Device-Specific Testing

### Android Devices

#### Low-End (Test Device: Android 7.0, 2GB RAM)
- [ ] Game loads in <3 seconds
- [ ] Maintains 45+ FPS
- [ ] No crashes during 15-minute session
- [ ] Touch input responsive
- [ ] Haptic feedback works

#### Mid-Range (Test Device: Android 11, 4GB RAM)
- [ ] Game loads in <2 seconds
- [ ] Maintains 60 FPS
- [ ] No crashes during extended play
- [ ] All features work smoothly

#### High-End (Test Device: Android 13, 8GB+ RAM)
- [ ] Game loads in <2 seconds
- [ ] Locked 60 FPS
- [ ] No performance issues
- [ ] All effects display correctly

### Screen Aspect Ratios

- [ ] 16:9 (Standard)
- [ ] 18:9 (Modern)
- [ ] 19.5:9 (Notch)
- [ ] 20:9 (Tall)
- [ ] Safe area margins work correctly with notches

## Edge Cases

- [ ] 100+ fruits in container
- [ ] Rapid tapping doesn't break spawning
- [ ] Game over during shake
- [ ] Merge during shake
- [ ] Ad closes before completion (no reward)
- [ ] App backgrounded during ad
- [ ] App backgrounded during gameplay
- [ ] Save corruption recovery
- [ ] No internet connection (ad fallback)
- [ ] Extremely long play session (memory)

## Regression Testing

After each major change, verify:
- [ ] Core gameplay still works
- [ ] Save/load still works
- [ ] Audio still works
- [ ] UI interactions still work
- [ ] Performance hasn't degraded

## Bug Reporting Template

```
**Bug Title:** Brief description

**Device:** Android X.X, Device Model, RAM

**Steps to Reproduce:**
1.
2.
3.

**Expected Result:**

**Actual Result:**

**Frequency:** Always / Sometimes / Rare

**Screenshots/Video:**

**Additional Info:**
```

## Performance Profiling

Use Godot's built-in profiler:
1. Run game in debug mode
2. Go to Debugger → Profiler
3. Monitor:
   - Frame time (should be <16.67ms for 60 FPS)
   - Physics time
   - Memory usage
   - Node count

### Performance Targets

| Metric | Target | Critical |
|--------|--------|----------|
| FPS | 60 | 45 |
| Load Time | <2s | <3s |
| RAM Usage | <150MB | <200MB |
| Max Fruits | 75 | 100 |

## Known Issues

Document any known issues here:
- None currently

## Test Results Log

Record test results here:

### Test Date: YYYY-MM-DD
- Tester: Name
- Device: Device Info
- Results: Summary
- Issues Found: List

---

## Automation Opportunities

Future improvements:
1. Implement GUT framework for automated tests
2. CI/CD pipeline with GitHub Actions
3. Automated performance benchmarks
4. Automated screenshot testing for different screen sizes
