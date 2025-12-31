extends Node

## SaveManager - Handles all game data persistence

const SAVE_PATH = "user://save_data.json"
var current_data: Dictionary

func _ready() -> void:
	load_data()

func load_data() -> void:
	print("Loading save data from: ", SAVE_PATH)

	if not FileAccess.file_exists(SAVE_PATH):
		print("Save file does not exist, creating default data")
		current_data = get_default_data()
		save_data()
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		var json = JSON.new()
		var parse_result = json.parse(json_string)

		if parse_result == OK:
			current_data = json.data
			print("Save data loaded successfully")
			print("High score loaded: ", current_data.get("high_score", 0))
		else:
			print("Error parsing save file: ", json.get_error_message())
			current_data = get_default_data()
	else:
		push_error("Failed to open save file for reading: " + str(FileAccess.get_open_error()))
		current_data = get_default_data()

func save_data() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(current_data, "\t")
		file.store_string(json_string)
		file.flush()  # Explicitly flush to disk
		file.close()
		print("Save data written successfully to: ", SAVE_PATH)
		print("High score in save: ", current_data.get("high_score", 0))
	else:
		push_error("Failed to open save file for writing: " + str(FileAccess.get_open_error()))

func get_default_data() -> Dictionary:
	return {
		"version": "1.0.0",
		"high_score": 0,
		"shake_count": 50,
		"tutorial_seen": false,
		"settings": {
			"music_volume": 0.4,
			"sfx_volume": 1.0,
			"music_enabled": true,
			"sfx_enabled": true,
			"vibration_enabled": true,
			"announce_all_drops": false
		},
		"stats": {
			"games_played": 0,
			"total_merges": 0,
			"highest_fruit_reached": 0
		}
	}

func save_high_score(score: int) -> void:
	current_data["high_score"] = score
	save_data()

func get_high_score() -> int:
	return current_data.get("high_score", 0)

func save_shake_count(count: int) -> void:
	current_data["shake_count"] = count
	save_data()

func get_shake_count() -> int:
	return current_data.get("shake_count", 50)

func save_audio_settings(music_vol: float, sfx_vol: float, music_on: bool, sfx_on: bool) -> void:
	if not current_data.has("settings"):
		current_data["settings"] = {}

	current_data["settings"]["music_volume"] = music_vol
	current_data["settings"]["sfx_volume"] = sfx_vol
	current_data["settings"]["music_enabled"] = music_on
	current_data["settings"]["sfx_enabled"] = sfx_on
	save_data()

func get_audio_settings() -> Dictionary:
	if current_data.has("settings"):
		return current_data["settings"]
	return get_default_data()["settings"]

func save_vibration_setting(enabled: bool) -> void:
	if not current_data.has("settings"):
		current_data["settings"] = {}

	current_data["settings"]["vibration_enabled"] = enabled
	save_data()

func get_vibration_enabled() -> bool:
	if current_data.has("settings"):
		return current_data["settings"].get("vibration_enabled", true)
	return true

func save_announce_all_drops(enabled: bool) -> void:
	if not current_data.has("settings"):
		current_data["settings"] = {}

	current_data["settings"]["announce_all_drops"] = enabled
	save_data()

func get_announce_all_drops() -> bool:
	if current_data.has("settings"):
		return current_data["settings"].get("announce_all_drops", false)
	return false

func increment_games_played() -> void:
	if not current_data.has("stats"):
		current_data["stats"] = {}

	current_data["stats"]["games_played"] = current_data["stats"].get("games_played", 0) + 1
	save_data()

func increment_total_merges() -> void:
	if not current_data.has("stats"):
		current_data["stats"] = {}

	current_data["stats"]["total_merges"] = current_data["stats"].get("total_merges", 0) + 1
	save_data()

func update_highest_fruit(level: int) -> void:
	if not current_data.has("stats"):
		current_data["stats"] = {}

	var current_highest = current_data["stats"].get("highest_fruit_reached", 0)
	if level > current_highest:
		current_data["stats"]["highest_fruit_reached"] = level
		save_data()

func get_stats() -> Dictionary:
	if current_data.has("stats"):
		return current_data["stats"]
	return get_default_data()["stats"]

func mark_tutorial_seen() -> void:
	current_data["tutorial_seen"] = true
	save_data()

func has_seen_tutorial() -> bool:
	return current_data.get("tutorial_seen", false)
