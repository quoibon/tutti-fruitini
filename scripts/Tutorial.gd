extends CanvasLayer

# Tutorial/How to Play screen

@onready var close_button = $Panel/VBoxContainer/CloseButton
@onready var got_it_button = $Panel/VBoxContainer/GotItButton

func _ready() -> void:
	# Connect buttons
	close_button.pressed.connect(_on_close_pressed)
	got_it_button.pressed.connect(_on_got_it_pressed)

	# Play click sound when buttons pressed
	AudioManager.play_click_sound()

func _on_close_pressed() -> void:
	AudioManager.play_click_sound()
	close_tutorial()

func _on_got_it_pressed() -> void:
	AudioManager.play_click_sound()
	# Mark tutorial as seen in save data
	SaveManager.mark_tutorial_seen()
	close_tutorial()

func close_tutorial() -> void:
	queue_free()

# Optional: Handle back button on Android
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			close_tutorial()
