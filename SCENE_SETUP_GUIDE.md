# Scene Setup Guide - Settings & Pause Menus

This guide shows how to create the Settings and Pause menu scenes in Godot.

---

## Settings Scene (Settings.tscn)

### Scene Structure

```
Settings (CanvasLayer)
└── Panel (Panel)
    ├── ColorRect (semi-transparent background overlay)
    └── VBoxContainer
        ├── TitleLabel (Label) - "SETTINGS"
        ├── MusicVolumeContainer (HBoxContainer)
        │   ├── MusicVolumeLabel (Label) - "Music Volume"
        │   └── MusicVolumeSlider (HSlider)
        ├── SFXVolumeContainer (HBoxContainer)
        │   ├── SFXVolumeLabel (Label) - "SFX Volume"
        │   └── SFXVolumeSlider (HSlider)
        ├── MusicToggleContainer (HBoxContainer)
        │   ├── MusicToggleLabel (Label) - "Music"
        │   └── MusicToggle (CheckButton)
        ├── SFXToggleContainer (HBoxContainer)
        │   ├── SFXToggleLabel (Label) - "Sound Effects"
        │   └── SFXToggle (CheckButton)
        ├── VibrationToggleContainer (HBoxContainer)
        │   ├── VibrationToggleLabel (Label) - "Vibration"
        │   └── VibrationToggle (CheckButton)
        └── BackButton (Button) - "BACK"
```

### Step-by-Step Creation

1. **Create New Scene**
   - Right-click in FileSystem → New Scene
   - Name: `Settings.tscn`
   - Root node: CanvasLayer

2. **Add Script**
   - Select Settings (CanvasLayer) node
   - Attach script: `res://scripts/Settings.gd`

3. **Add Panel**
   - Add child node: Panel
   - Layout: Anchor preset → Full Rect
   - Self Modulate: Set alpha to ~0.9 for slight transparency

4. **Add Background Overlay** (Optional dark overlay)
   - Add ColorRect as child of Panel
   - Layout: Anchor preset → Full Rect
   - Color: Black with alpha ~0.5
   - Move to top in node tree (render behind VBoxContainer)

5. **Add VBoxContainer**
   - Add child to Panel: VBoxContainer
   - Layout: Center container
   - Size: 600x800 (or adjust to preference)
   - Separation: 20

6. **Add Title**
   - Add Label to VBoxContainer
   - Name: TitleLabel
   - Text: "SETTINGS"
   - Align: Center
   - Font Size: 48

7. **Add Music Volume Controls**
   - Add HBoxContainer to VBoxContainer
   - Name: MusicVolumeContainer
   - Add Label: "Music Volume"
   - Add HSlider:
     - Name: MusicVolumeSlider
     - Min Value: 0
     - Max Value: 100
     - Step: 1
     - Value: 80

8. **Add SFX Volume Controls**
   - Add HBoxContainer to VBoxContainer
   - Name: SFXVolumeContainer
   - Add Label: "SFX Volume"
   - Add HSlider:
     - Name: SFXVolumeSlider
     - Min Value: 0
     - Max Value: 100
     - Step: 1
     - Value: 100

9. **Add Music Toggle**
   - Add HBoxContainer to VBoxContainer
   - Name: MusicToggleContainer
   - Add Label: "Music"
   - Add CheckButton:
     - Name: MusicToggle
     - Button Pressed: true

10. **Add SFX Toggle**
    - Add HBoxContainer to VBoxContainer
    - Name: SFXToggleContainer
    - Add Label: "Sound Effects"
    - Add CheckButton:
      - Name: SFXToggle
      - Button Pressed: true

11. **Add Vibration Toggle**
    - Add HBoxContainer to VBoxContainer
    - Name: VibrationToggleContainer
    - Add Label: "Vibration"
    - Add CheckButton:
      - Name: VibrationToggle
      - Button Pressed: true

12. **Add Back Button**
    - Add Button to VBoxContainer
    - Name: BackButton
    - Text: "BACK"
    - Custom minimum size: 200x60

13. **Save Scene**
    - Save as `res://scenes/Settings.tscn`

---

## Pause Scene (Pause.tscn)

### Scene Structure

```
Pause (CanvasLayer)
└── Panel (Panel)
    ├── ColorRect (semi-transparent background overlay)
    └── VBoxContainer
        ├── TitleLabel (Label) - "PAUSED"
        ├── ResumeButton (Button) - "RESUME"
        ├── RestartButton (Button) - "RESTART"
        ├── SettingsButton (Button) - "SETTINGS"
        └── MenuButton (Button) - "MAIN MENU"
```

### Step-by-Step Creation

1. **Create New Scene**
   - Right-click in FileSystem → New Scene
   - Name: `Pause.tscn`
   - Root node: CanvasLayer

2. **Add Script**
   - Select Pause (CanvasLayer) node
   - Attach script: `res://scripts/Pause.gd`

3. **Add Panel**
   - Add child node: Panel
   - Layout: Anchor preset → Full Rect
   - Self Modulate: Set alpha to ~0.9

4. **Add Background Overlay**
   - Add ColorRect as child of Panel
   - Layout: Anchor preset → Full Rect
   - Color: Black with alpha ~0.7 (darker for pause)
   - Move to top in node tree

5. **Add VBoxContainer**
   - Add child to Panel: VBoxContainer
   - Layout: Center container
   - Size: 400x600
   - Separation: 20

6. **Add Title**
   - Add Label to VBoxContainer
   - Name: TitleLabel
   - Text: "PAUSED"
   - Align: Center
   - Font Size: 64

7. **Add Resume Button**
   - Add Button to VBoxContainer
   - Name: ResumeButton
   - Text: "RESUME"
   - Custom minimum size: 300x80

8. **Add Restart Button**
   - Add Button to VBoxContainer
   - Name: RestartButton
   - Text: "RESTART"
   - Custom minimum size: 300x80

9. **Add Settings Button**
   - Add Button to VBoxContainer
   - Name: SettingsButton
   - Text: "SETTINGS"
   - Custom minimum size: 300x80

10. **Add Menu Button**
    - Add Button to VBoxContainer
    - Name: MenuButton
    - Text: "MAIN MENU"
    - Custom minimum size: 300x80

11. **Configure Process Mode** (IMPORTANT!)
    - Select Pause (CanvasLayer) root node
    - In Inspector → Node → Process → Mode
    - Set to: **"When Paused"** or **"Always"**
    - This allows the pause menu to function while game is paused

12. **Save Scene**
    - Save as `res://scenes/Pause.tscn`

---

## Integration Steps

### 1. Add Pause Button to Main Scene

Open `scenes/Main.tscn`:

1. **Add Pause Button to UI**
   - Select UI (CanvasLayer) node
   - Add child: Button
   - Name: PauseButton
   - Text: "⏸ PAUSE" or "II"
   - Position: Top-left or top-right corner
   - Size: ~100x50

2. **Update Main.gd**
   - See integration code below

### 2. Add Settings Button to MainMenu

Open `scenes/MainMenu.tscn`:

1. **Add Settings Button**
   - Select VBoxContainer
   - Add Button after PlayButton
   - Name: SettingsButton
   - Text: "SETTINGS"

2. **Update MainMenu.gd**
   - See integration code below

---

## Code Integration

### Main.gd - Add Pause Functionality

```gdscript
# Add at top with other @onready variables
@onready var pause_button = $UI/PauseButton

# Add to _ready()
pause_button.pressed.connect(_on_pause_button_pressed)

# Add new function
func _on_pause_button_pressed() -> void:
	AudioManager.play_click_sound()
	show_pause_menu()

func show_pause_menu() -> void:
	var pause_scene = preload("res://scenes/Pause.tscn")
	var pause_menu = pause_scene.instantiate()
	add_child(pause_menu)
```

### MainMenu.gd - Add Settings Access

```gdscript
# Add at top with other @onready variables
@onready var settings_button = $VBoxContainer/SettingsButton

# Add to _ready()
settings_button.pressed.connect(_on_settings_pressed)

# Add new function
func _on_settings_pressed() -> void:
	AudioManager.play_click_sound()
	var settings_scene = preload("res://scenes/Settings.tscn")
	var settings = settings_scene.instantiate()
	add_child(settings)
```

---

## Testing Checklist

### Settings Menu
- [ ] Opens from main menu
- [ ] Music volume slider works
- [ ] SFX volume slider works
- [ ] Music toggle mutes/unmutes music
- [ ] SFX toggle mutes/unmutes SFX
- [ ] Vibration toggle enables/disables haptics
- [ ] Settings persist after restart
- [ ] Back button closes menu

### Pause Menu
- [ ] Opens from pause button during gameplay
- [ ] Game pauses (fruits stop moving)
- [ ] Resume button unpauses and closes menu
- [ ] Restart button restarts game
- [ ] Settings button opens settings (from pause)
- [ ] Main menu button returns to main menu
- [ ] All buttons work while game is paused

---

## Styling Tips

### Colors
- **Panel Background**: Light yellow/cream (#FFF9E6)
- **Overlay**: Black with 50-70% transparency
- **Title Text**: Dark teal (#1A535C)
- **Button Normal**: Coral red (#FF6B6B)
- **Button Hover**: Darker coral (#FF5252)
- **Button Pressed**: Even darker (#E53935)

### Fonts
- **Title**: 48-64pt, bold
- **Labels**: 24pt, regular
- **Buttons**: 28pt, bold

### Layout
- **Margins**: 40-60px from edges
- **Spacing**: 20px between elements
- **Button Size**: 300x80 minimum for touch targets
- **Slider Width**: 400-500px

---

## Quick Setup (Simplified)

If you want a basic functional version quickly:

1. Create both scenes with just:
   - CanvasLayer → Panel → VBoxContainer → Buttons
2. Attach the scripts
3. Name the buttons correctly (match the @onready variables)
4. Set process mode to "When Paused" for Pause scene
5. Integrate into Main and MainMenu
6. Style later with themes

The scripts are already written and will work as soon as the scene structure matches the @onready references!
