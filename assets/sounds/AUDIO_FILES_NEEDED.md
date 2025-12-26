# Audio Files Required for Tutti Fruitini

This document lists all audio files needed for the game. Currently these are placeholders - actual audio files need to be created and added to the appropriate folders.

## Directory Structure

```
assets/sounds/
├── sfx/          # Sound effects (.wav format)
└── music/        # Background music (.ogg format)
```

## Sound Effects (SFX)

All SFX files should be in `.wav` format for quick loading.

### Required SFX Files:

1. **merge_01.wav** through **merge_05.wav**
   - Location: `assets/sounds/sfx/`
   - Description: Merge sounds that cycle for variety
   - Suggested: Short, satisfying "pop" or "bloop" sounds
   - Duration: 0.2-0.5 seconds
   - Volume: Medium

2. **drop.wav**
   - Location: `assets/sounds/sfx/`
   - Description: Played when fruit is dropped
   - Suggested: Soft "plop" or "thud" sound
   - Duration: 0.1-0.3 seconds
   - Volume: Low-Medium

3. **shake.wav**
   - Location: `assets/sounds/sfx/`
   - Description: Played when shake button is pressed
   - Suggested: Rumble or rattle sound
   - Duration: 0.3-0.5 seconds
   - Volume: Medium-High

4. **game_over.wav**
   - Location: `assets/sounds/sfx/`
   - Description: Played when game over is triggered
   - Suggested: Descending tone or "aww" sound
   - Duration: 1.0-2.0 seconds
   - Volume: Medium

5. **click.wav**
   - Location: `assets/sounds/sfx/`
   - Description: Played for all UI button clicks
   - Suggested: Short, crisp click or tap sound
   - Duration: 0.05-0.1 seconds
   - Volume: Low-Medium

6. **refill.wav**
   - Location: `assets/sounds/sfx/`
   - Description: Played when shake counter is refilled
   - Suggested: Success chime or "power-up" sound
   - Duration: 0.5-1.0 seconds
   - Volume: Medium

## Background Music

Music files should be in `.ogg` format (Ogg Vorbis) for better compression and looping support.

### Required Music Files:

1. **bgm_main.ogg**
   - Location: `assets/sounds/music/`
   - Description: Main gameplay background music
   - Suggested: Upbeat, casual, fun theme matching Italian/fruit aesthetic
   - Duration: 1-2 minutes (seamlessly looping)
   - Volume: Background level (will be set to -6dB in mixer)

## Audio Guidelines

### General Requirements:
- **Sample Rate**: 44.1kHz or 48kHz
- **Bit Depth**: 16-bit minimum
- **Channels**: Mono for SFX, Stereo for music
- **Normalization**: Peak at -3dB to prevent clipping

### Style Guidelines:
- Keep sounds light and fun, matching the game's casual aesthetic
- Avoid harsh or jarring sounds
- Ensure all sounds blend well together
- Test sounds at various volume levels

## Implementation Status

✅ AudioManager system implemented
✅ Audio bus configuration complete (Music: -6dB, SFX: 0dB)
✅ All audio hooks integrated into gameplay code
⏳ Actual audio files pending (will gracefully fail if missing)

## Temporary Behavior

Until actual audio files are added, the game will:
- Continue to function normally
- Silently skip missing audio files (no errors shown to player)
- Print debug messages when attempting to play missing sounds

## Next Steps

1. Create or source audio files matching the specifications above
2. Place files in appropriate directories
3. Test each sound in-game
4. Adjust volumes and timing as needed
5. Update this document with any changes to audio specifications
