extends Control

## MainMenu - Main menu scene with play button

@onready var play_button = $VBoxContainer/PlayButton
@onready var settings_button = $VBoxContainer/SettingsButton  # Will be created in scene
@onready var high_score_label = $VBoxContainer/HighScoreLabel

var settings_scene: PackedScene

func _ready() -> void:
	# Load settings scene
	settings_scene = preload("res://scenes/Settings.tscn")

	# Connect buttons
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)

	# Load and display high score
	high_score_label.text = "High Score: " + str(SaveManager.get_high_score())

func _on_play_pressed() -> void:
	AudioManager.play_click_sound()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_settings_pressed() -> void:
	AudioManager.play_click_sound()
	var settings = settings_scene.instantiate()
	add_child(settings)
