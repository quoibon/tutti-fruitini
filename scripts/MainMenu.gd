extends Control

## MainMenu - Main menu scene with play button

@onready var play_button = $VBoxContainer/PlayButton
@onready var settings_button = $VBoxContainer/SettingsButton
@onready var how_to_play_button = $VBoxContainer/HowToPlayButton  # Will be created in scene
@onready var high_score_label = $VBoxContainer/HighScoreLabel
@onready var left_icon = $VBoxContainer/TitleContainer/LeftIcon
@onready var right_icon = $VBoxContainer/TitleContainer/RightIcon

var settings_scene: PackedScene
var tutorial_scene: PackedScene

func _ready() -> void:
	# Load scenes
	settings_scene = preload("res://scenes/Settings.tscn")
	tutorial_scene = preload("res://scenes/Tutorial.tscn")

	# Set random fruit icons
	randomize_title_icons()

	# Connect buttons
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	how_to_play_button.pressed.connect(_on_how_to_play_pressed)

	# Connect quit button if it exists
	var quit_button = get_node_or_null("VBoxContainer/QuitButton")
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

	# Load and display high score
	high_score_label.text = "High Score: " + str(SaveManager.get_high_score())

	# Play menu music
	AudioManager.play_menu_music()

func randomize_title_icons() -> void:
	# Pick two random fruit levels (0-10)
	var left_fruit = randi() % 11
	var right_fruit = randi() % 11

	# Load and set sprites
	load_fruit_icon(left_icon, left_fruit)
	load_fruit_icon(right_icon, right_fruit)

func load_fruit_icon(sprite: Sprite2D, fruit_level: int) -> void:
	var sprite_files = {
		0: "1.BlueberrinniOctopussini",
		1: "2.SlimoLiAppluni",
		2: "3.PerochelloLemonchello",
		3: "4.PenguinoCocosino",
		4: "5.ChimpanziniBananini",
		5: "6.TorrtuginniDragonfrutinni",
		6: "7.UDinDinDinDinDun",
		7: "8.GraipussiMedussi",
		8: "9.CrocodildoPen",
		9: "10.ZibraZubraZibralini",
		10: "11.StrawberryElephant"
	}

	var sprite_number = fruit_level + 1
	if not sprite_files.has(fruit_level):
		return

	var sprite_path = "res://assets/sprites/fruits/" + sprite_files[fruit_level] + ".png"

	# Use ResourceLoader for exported builds
	var texture = ResourceLoader.load(sprite_path)
	if texture:
		sprite.texture = texture

func _on_play_pressed() -> void:
	AudioManager.play_click_sound()
	# Stop menu music before starting game
	AudioManager.stop_music()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_settings_pressed() -> void:
	AudioManager.play_click_sound()
	var settings = settings_scene.instantiate()
	add_child(settings)

func _on_how_to_play_pressed() -> void:
	AudioManager.play_click_sound()
	show_tutorial()

func show_tutorial() -> void:
	var tutorial = tutorial_scene.instantiate()
	add_child(tutorial)

func _on_quit_pressed() -> void:
	AudioManager.play_click_sound()
	get_tree().quit()
