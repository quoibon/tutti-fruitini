extends Control

## MainMenu - Main menu scene with play button

@onready var play_button = $VBoxContainer/PlayButton
@onready var settings_button = $VBoxContainer/SettingsButton
@onready var how_to_play_button = $VBoxContainer/HowToPlayButton  # Will be created in scene
@onready var high_score_label = $VBoxContainer/HighScoreLabel

var settings_scene: PackedScene
var tutorial_scene: PackedScene

func _ready() -> void:
	# Load scenes
	settings_scene = preload("res://scenes/Settings.tscn")
	tutorial_scene = preload("res://scenes/Tutorial.tscn")

	# Connect buttons
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	how_to_play_button.pressed.connect(_on_how_to_play_pressed)

	# Load and display high score
	high_score_label.text = "High Score: " + str(SaveManager.get_high_score())

	# Play menu music
	AudioManager.play_menu_music()

	# Show tutorial on first launch
	if not SaveManager.has_seen_tutorial():
		# Delay tutorial slightly so menu is visible first
		await get_tree().create_timer(0.5).timeout
		show_tutorial()

func _on_play_pressed() -> void:
	AudioManager.play_click_sound()
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
