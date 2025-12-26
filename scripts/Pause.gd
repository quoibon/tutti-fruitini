extends CanvasLayer

## Pause - Pause menu overlay

@onready var resume_button = $Panel/VBoxContainer/ResumeButton
@onready var restart_button = $Panel/VBoxContainer/RestartButton
@onready var settings_button = $Panel/VBoxContainer/SettingsButton
@onready var menu_button = $Panel/VBoxContainer/MenuButton

var settings_scene: PackedScene

func _ready() -> void:
	settings_scene = preload("res://scenes/Settings.tscn")

	# Connect buttons
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

	# Pause the game
	get_tree().paused = true

func _on_resume_pressed() -> void:
	AudioManager.play_click_sound()
	resume_game()

func _on_restart_pressed() -> void:
	AudioManager.play_click_sound()
	resume_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_settings_pressed() -> void:
	AudioManager.play_click_sound()

	# Open settings
	var settings = settings_scene.instantiate()
	add_child(settings)

func _on_menu_pressed() -> void:
	AudioManager.play_click_sound()
	resume_game()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func resume_game() -> void:
	get_tree().paused = false
	queue_free()
