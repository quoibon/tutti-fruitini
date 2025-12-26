extends Control

## MainMenu - Main menu scene with play button

@onready var play_button = $VBoxContainer/PlayButton
@onready var high_score_label = $VBoxContainer/HighScoreLabel

func _ready() -> void:
	# Connect play button
	play_button.pressed.connect(_on_play_pressed)

	# Load and display high score
	ScoreManager.load_high_score()
	high_score_label.text = "High Score: " + str(ScoreManager.high_score)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
