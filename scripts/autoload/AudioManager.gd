extends Node

## AudioManager - Handles all game audio (music and sound effects)

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE = 15  # Increased to support multiple simultaneous merges

# Audio settings
var music_volume: float = 0.8
var sfx_volume: float = 1.0
var music_enabled: bool = true
var sfx_enabled: bool = true

# Available merge sounds (will cycle through)
var current_merge_sound: int = 1
const MAX_MERGE_SOUNDS = 5

func _ready() -> void:
	# Setup music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

	# Setup SFX pool
	for i in SFX_POOL_SIZE:
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		sfx_players.append(player)

	# Load settings
	load_settings()

	# Apply initial volumes
	set_music_volume(music_volume)
	set_sfx_volume(sfx_volume)

func play_music(track_name: String, loop: bool = true) -> void:
	if not music_enabled:
		return

	var path = "res://assets/sounds/music/" + track_name + ".ogg"
	if not FileAccess.file_exists(path):
		print("Music file not found: ", path)
		return

	var stream = load(path)
	if stream:
		music_player.stream = stream
		if stream is AudioStreamOggVorbis:
			stream.loop = loop
		music_player.play()

func stop_music() -> void:
	music_player.stop()

func play_sfx(sfx_name: String) -> void:
	if not sfx_enabled:
		return

	var path = "res://assets/sounds/sfx/" + sfx_name + ".wav"
	if not FileAccess.file_exists(path):
		# Silently fail for missing audio files (they're placeholders)
		return

	var stream = load(path)
	if not stream:
		return

	# Find available player
	for player in sfx_players:
		if not player.playing:
			player.stream = stream
			player.play()
			return

	# All players busy, use first one
	sfx_players[0].stream = stream
	sfx_players[0].play()

func play_merge_sound() -> void:
	# Cycle through merge sounds for variety
	play_sfx("merge_0" + str(current_merge_sound))
	current_merge_sound += 1
	if current_merge_sound > MAX_MERGE_SOUNDS:
		current_merge_sound = 1

func play_drop_sound() -> void:
	play_sfx("drop")

func play_shake_sound() -> void:
	play_sfx("shake")

func play_game_over_sound() -> void:
	play_sfx("game_over")

func play_click_sound() -> void:
	play_sfx("click")

func play_refill_sound() -> void:
	play_sfx("refill")

func set_music_volume(volume: float) -> void:
	music_volume = clamp(volume, 0.0, 1.0)
	var db = linear_to_db(music_volume) if music_volume > 0 else -80
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)
	save_settings()

func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)
	var db = linear_to_db(sfx_volume) if sfx_volume > 0 else -80
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)
	save_settings()

func toggle_music() -> void:
	music_enabled = not music_enabled
	if music_enabled:
		set_music_volume(music_volume)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
	save_settings()

func toggle_sfx() -> void:
	sfx_enabled = not sfx_enabled
	if sfx_enabled:
		set_sfx_volume(sfx_volume)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)
	save_settings()

func save_settings() -> void:
	SaveManager.save_audio_settings(music_volume, sfx_volume, music_enabled, sfx_enabled)

func load_settings() -> void:
	var settings = SaveManager.get_audio_settings()
	music_volume = settings.get("music_volume", 0.8)
	sfx_volume = settings.get("sfx_volume", 1.0)
	music_enabled = settings.get("music_enabled", true)
	sfx_enabled = settings.get("sfx_enabled", true)
