# Asset Sourcing Guide - Tutti Fruttini

This guide provides options for creating or sourcing the remaining game assets needed for version 1.0 release.

---

## Overview of Needed Assets

### Critical Assets
1. **11 Fruit Sprites** (PNG, 256x256px each, transparent background)
2. **7 Audio Files** (WAV or OGG format)
3. **App Icon** (1024x1024px PNG) - **DONE** (placeholder created)

### Optional Assets
4. UI graphics (buttons, backgrounds)
5. Particle effects

---

## Option 1: Free Asset Libraries (Recommended for Quick Launch)

### Fruit Sprites

**OpenGameArt.org**
- URL: https://opengameart.org
- Search: "fruit sprites", "vegetable sprites", "food icons"
- License: Check each asset (prefer CC0, CC-BY, OGA-BY)
- Quality: Varies, but many high-quality options

**Kenney Assets**
- URL: https://kenney.nl/assets
- Search: Look in "Food Pack" or generic sprite packs
- License: CC0 (public domain) - use freely!
- Quality: Consistent, professional style
- Cost: Free (donations appreciated)

**itch.io**
- URL: https://itch.io/game-assets/free/tag-sprites
- Search: "fruit sprites", "food sprites"
- Filter: Free, with commercial use allowed
- License: Varies per asset (check each)
- Quality: Varies widely

**Recommended Kenney Packs:**
- [Food Pack](https://kenney.nl/assets/food-pack) - Various food sprites
- [Game Icons](https://kenney.nl/assets/game-icons) - Simple, clean icons

### Audio Files

**Freesound.org**
- URL: https://freesound.org
- Search terms:
  - "pop" (for merge sounds)
  - "drop" or "plop" (for fruit drop)
  - "whoosh" or "rumble" (for shake)
  - "game over" or "fail"
  - "click" or "button"
  - "success" or "reward" (for refill)
- License: Filter by CC0 or CC-BY (give attribution)
- Quality: High-quality recordings available
- **Pro tip**: Download 5 different pop sounds for merge variety

**OpenGameArt.org**
- URL: https://opengameart.org/art-search-advanced?keys=&field_art_type_tid%5B%5D=13
- Search: Game sound effects
- License: Check each asset
- Quality: Good selection of game-ready SFX

**Kenney Audio**
- URL: https://kenney.nl/assets?q=audio
- Packs:
  - [Interface Sounds](https://kenney.nl/assets/interface-sounds) - UI clicks
  - [Impact Sounds](https://kenney.nl/assets/impact-sounds) - Drop/merge
- License: CC0 (free to use)
- Quality: Clean, professional

**ZapSplat** (Free with account)
- URL: https://www.zapsplat.com
- Search: Game sound effects
- License: Free with attribution (read terms)
- Quality: Professional sound effects

---

## Option 2: AI-Generated Assets (Fast & Custom)

### Fruit Sprites (AI Image Generation)

**DALL-E 3** (via ChatGPT Plus)
- Cost: $20/month subscription
- Prompt example:
  ```
  "A cute cartoon cherry sprite, flat 2D game asset, transparent background,
  simple shading, vibrant red color, Italian art style, kawaii design"
  ```
- Process: Generate → Download → Remove background (if needed) → Resize to 256x256px

**Midjourney**
- Cost: $10-$30/month
- Quality: Very high
- Prompt example:
  ```
  "2d game sprite, cute cartoon strawberry, flat design, transparent background,
  mobile game asset, vibrant colors --ar 1:1 --style cute"
  ```

**Leonardo.ai** (Free tier available)
- URL: https://leonardo.ai
- Free: 150 credits/day
- Prompt example: Similar to DALL-E
- Advantage: Better control over style consistency

**Stability AI (Stable Diffusion)**
- Free via: https://stablediffusionweb.com
- Quality: Good with right prompts
- Advantage: Completely free, no limits

**AI Image Tips:**
1. Generate all fruits in one session for style consistency
2. Use same prompt structure for each fruit (only change fruit name)
3. Use background removal tool: https://remove.bg (free tier)
4. Batch resize with: https://bulkresizephotos.com

### Audio (AI Sound Generation)

**ElevenLabs Sound Effects** (Beta)
- URL: https://elevenlabs.io/sound-effects
- Free tier available
- Prompt example: "Cartoon pop sound, short, bouncy, game sound effect"
- Quality: Good for short SFX

**Stability AI Audio** (Coming soon)
- Watch for: https://stability.ai

**AIVA** (Music generation)
- URL: https://aiva.ai
- Free tier: 3 downloads/month
- Use for: Background music (if needed)

---

## Option 3: Commission Custom Assets

### Freelance Platforms

**Fiverr**
- URL: https://fiverr.com
- Search: "2D game sprites", "game sound effects"
- Cost: $10-$100+ per gig
- Turnaround: 1-7 days
- **Recommended for:** Custom art matching exact vision

**Upwork**
- URL: https://upwork.com
- Search: "Pixel artist", "2D sprite artist", "Sound designer"
- Cost: Varies by artist ($15-$50/hour)
- Quality: Professional, portfolio-reviewed

**ArtStation**
- URL: https://artstation.com
- Search: Find artists, contact directly
- Cost: Negotiate directly
- Quality: Very high, professional game artists

**Reddit Communities**
- r/gameDevClassifieds
- r/INAT (I Need A Team)
- r/forhire

**Estimated Costs:**
- 11 fruit sprites: $50-$200
- 7 sound effects: $30-$100
- **Total**: $80-$300 for custom assets

---

## Option 4: Create Your Own (Free but Time-Intensive)

### Fruit Sprites (DIY)

**Free Tools:**
1. **GIMP** (https://gimp.org) - Free Photoshop alternative
2. **Krita** (https://krita.org) - Free painting software
3. **Inkscape** (https://inkscape.org) - Free vector graphics

**Process:**
1. Draw fruit outlines (circles/ovals)
2. Add solid color fill
3. Add simple shading (darker color on bottom)
4. Add highlight (white oval on top)
5. Export as 256x256px PNG with transparency

**Time estimate:** 1-2 hours per fruit (if artistic)

**Tutorial Resources:**
- YouTube: "How to draw simple game sprites"
- YouTube: "Flat design fruit icons tutorial"

### Audio (DIY)

**Free Tools:**
1. **Audacity** (https://audacityteam.org) - Audio editor
2. **LMMS** (https://lmms.io) - Music creation
3. **Bfxr** (https://bfxr.net) - 8-bit sound generator (web-based)

**Process:**
1. Use **Bfxr** to generate retro game sounds
2. Download as WAV
3. Import to Audacity for editing (trim, fade, normalize)
4. Export as OGG (smaller file size)

**Time estimate:** 30 minutes - 1 hour for all 7 sounds

**Bfxr Sound Types:**
- Pickup/Coin → Use for merge sound
- Jump → Use for drop sound
- Explosion → Use for shake/game over
- Powerup → Use for refill

---

## Recommended Approach (Fast & Free)

### For Fruit Sprites:
1. **Check Kenney.nl first** (CC0, free, consistent style)
   - Download "Food Pack" or similar
   - Rename files to match your needs (cherry.png, strawberry.png, etc.)

2. **If Kenney doesn't have what you need:**
   - Search OpenGameArt.org
   - Filter by "CC0" or "CC-BY 3.0"
   - Download and attribute if needed

3. **Fallback: Use colored circles** (temporary)
   - Your game already works with colored circles
   - Ship v1.0 with simple graphics
   - Update sprites in v1.1 based on player feedback

### For Audio:
1. **Use Bfxr** (5 minutes to generate all sounds)
   - Generate 5 different "pickup" sounds for merges
   - Generate "explosion" for game over
   - Generate "jump" for drop
   - Generate "powerup" for refill

2. **Polish with Freesound.org**
   - Search for higher-quality versions of each sound
   - Download CC0 licensed sounds (no attribution needed)

### For App Icon:
- **Already done!** Use the placeholder SVG created
- Can improve later based on final fruit sprite style

---

## Asset Integration Steps

### 1. Fruit Sprites

**File naming convention:**
```
assets/sprites/fruits/
├── cherry.png        (Level 0)
├── strawberry.png    (Level 1)
├── grape.png         (Level 2)
├── orange.png        (Level 3)
├── lemon.png         (Level 4)
├── apple.png         (Level 5)
├── pear.png          (Level 6)
├── peach.png         (Level 7)
├── pineapple.png     (Level 8)
├── melon.png         (Level 9)
└── watermelon.png    (Level 10)
```

**Import Settings** (in Godot):
- Filter: Linear Mipmap
- Compress: VRAM Compressed
- Mipmaps: Generate

**Testing:**
1. Add sprites to `assets/sprites/fruits/`
2. Run game - sprites should automatically load
3. Check `fruit_data.json` paths are correct

### 2. Audio Files

**File naming convention:**
```
assets/sounds/sfx/
├── merge_01.ogg
├── merge_02.ogg
├── merge_03.ogg
├── merge_04.ogg
├── merge_05.ogg
├── drop.ogg
├── shake.ogg
├── game_over.ogg
├── click.ogg
└── refill.ogg
```

**Format:**
- **Preferred**: OGG Vorbis (smaller, good quality)
- **Alternative**: WAV (lossless, larger)

**Import Settings** (in Godot):
- Loop: Disabled (for SFX)
- Compress: Enabled (for OGG)

**Testing:**
1. Add audio files to `assets/sounds/sfx/`
2. Test in-game (drop fruit, merge, shake, etc.)
3. Adjust volume in AudioManager if too loud/quiet

### 3. App Icon

**Current:** `icon_placeholder.svg`
**Final:** `icon.png` (1024x1024px)

**Steps:**
1. Export SVG to PNG at 1024x1024
2. Or create custom icon matching final fruit style
3. Save as `icon.png` in project root
4. Godot will auto-generate Android icons

---

## License Compliance

### When Using Free Assets:

**CC0 (Public Domain):**
- ✅ Use freely
- ✅ Modify as needed
- ❌ No attribution required (but appreciated)
- **Sources:** Kenney, some OpenGameArt

**CC-BY 3.0 (Attribution Required):**
- ✅ Use freely
- ✅ Modify as needed
- ✅ **MUST give credit** in game or description
- **Sources:** Some OpenGameArt, Freesound

**Where to credit:**
1. In-game: Settings → Credits button
2. Google Play listing: Description (bottom)
3. Format: "Music by [Artist] - [Link]"

**Example credits.txt:**
```
Tutti Fruttini - Asset Credits

Fruit Sprites:
- Kenney (kenney.nl) - CC0 License

Sound Effects:
- Merge sounds by [Artist Name] (freesound.org) - CC-BY 3.0
- UI sounds by Kenney (kenney.nl) - CC0 License

Font:
- [Font Name] by [Creator] - [License]
```

---

## Quick Start Checklist

**Minimum Viable Assets (1-2 hours):**
- [ ] Download Kenney Food Pack (or use colored circles)
- [ ] Generate 7 sounds with Bfxr
- [ ] Export icon_placeholder.svg to PNG
- [ ] Add all assets to project folders
- [ ] Test in-game
- [ ] Create credits.txt if using CC-BY assets

**Polished Assets (1-2 weeks or $100-300):**
- [ ] Commission custom fruit sprites
- [ ] Source high-quality SFX from Freesound
- [ ] Design custom app icon
- [ ] Add particle effects
- [ ] Add background music

---

## Timeline Estimates

| Approach | Time | Cost | Quality |
|----------|------|------|---------|
| **Bfxr + Colored Circles** | 1 hour | $0 | Functional |
| **Free Asset Libraries** | 2-4 hours | $0 | Good |
| **AI Generation** | 1 day | $0-$20 | Good-Great |
| **Freelance Commission** | 3-7 days | $80-$300 | Professional |
| **DIY Creation** | 1-2 weeks | $0 | Varies |

---

## Recommended Action Plan

### Week 1: Get Game Playable
1. Use colored circles (already done!)
2. Generate sounds with Bfxr (30 min)
3. Test game end-to-end

### Week 2: Polish
1. Search Kenney + OpenGameArt for sprites (2 hours)
2. Replace colored circles with free sprites
3. Replace Bfxr sounds with Freesound SFX

### Week 3: Final Polish (Optional)
1. Commission custom sprites if budget allows
2. Add particle effects
3. Fine-tune audio levels

---

## Useful Links

**Asset Libraries:**
- Kenney: https://kenney.nl/assets
- OpenGameArt: https://opengameart.org
- itch.io: https://itch.io/game-assets/free
- Freesound: https://freesound.org

**Tools:**
- Bfxr (sound generator): https://bfxr.net
- Remove.bg (background removal): https://remove.bg
- Bulk resize: https://bulkresizephotos.com
- GIMP: https://gimp.org
- Audacity: https://audacityteam.org

**AI Tools:**
- Leonardo.ai: https://leonardo.ai
- Stable Diffusion: https://stablediffusionweb.com
- Remove backgrounds: https://cleanup.pictures

**Freelance:**
- Fiverr: https://fiverr.com
- Upwork: https://upwork.com
- ArtStation: https://artstation.com

---

## Questions? Contact

If you need help finding specific assets or have licensing questions, reach out to the communities:
- r/gamedev
- r/godot
- Godot Discord: https://discord.gg/godot

---

**Ready to start?** Begin with Option 1 (Free Asset Libraries) for the fastest path to a complete game!
