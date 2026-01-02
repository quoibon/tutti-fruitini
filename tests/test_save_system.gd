extends GutTest

## Test suite for save system persistence

var save_manager: Node
var test_save_path = "user://test_save_data.json"

func before_all():
	# Get SaveManager autoload
	save_manager = get_node_or_null("/root/SaveManager")

func before_each():
	# Backup original save file if it exists
	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		var backup_path = SaveManager.SAVE_PATH + ".backup"
		DirAccess.copy_absolute(SaveManager.SAVE_PATH, backup_path)

func after_each():
	# Restore original save file if backup exists
	var backup_path = SaveManager.SAVE_PATH + ".backup"
	if FileAccess.file_exists(backup_path):
		DirAccess.copy_absolute(backup_path, SaveManager.SAVE_PATH)
		DirAccess.remove_absolute(backup_path)

	# Reset save manager data to defaults
	if save_manager:
		save_manager.current_data = save_manager.get_default_data()

func test_save_manager_exists():
	# Given/When: SaveManager autoload
	# Then: Should be accessible
	assert_not_null(save_manager, "SaveManager should be loaded as autoload")

func test_default_data_structure():
	# Given: SaveManager
	# When: Getting default data
	var default_data = save_manager.get_default_data()

	# Then: Should have all required fields
	assert_true(default_data.has("version"), "Should have version")
	assert_true(default_data.has("high_score"), "Should have high_score")
	assert_true(default_data.has("shake_count"), "Should have shake_count")
	assert_true(default_data.has("settings"), "Should have settings")
	assert_true(default_data.has("stats"), "Should have stats")

func test_high_score_saves_and_loads():
	# Given: A new high score
	var test_score = 12345

	# When: Saving high score
	save_manager.save_high_score(test_score)

	# Wait for file I/O
	await wait_seconds(0.2)

	# Then: Reloading should return same score
	save_manager.load_data()
	var loaded_score = save_manager.get_high_score()
	assert_eq(loaded_score, test_score, "Saved high score should match loaded score")

func test_shake_count_persists():
	# Given: A specific shake count
	var test_shake_count = 25

	# When: Saving shake count
	save_manager.save_shake_count(test_shake_count)

	# Wait for file I/O
	await wait_seconds(0.2)

	# Then: Reloading should return same count
	save_manager.load_data()
	var loaded_count = save_manager.get_shake_count()
	assert_eq(loaded_count, test_shake_count, "Saved shake count should match loaded count")

func test_settings_save_correctly():
	# Given: Custom audio settings
	var test_music_vol = 0.7
	var test_sfx_vol = 0.5
	var test_music_on = false
	var test_sfx_on = true

	# When: Saving settings
	save_manager.save_audio_settings(test_music_vol, test_sfx_vol, test_music_on, test_sfx_on)

	# Wait for file I/O
	await wait_seconds(0.2)

	# Then: Reloading should return same settings
	save_manager.load_data()
	var settings = save_manager.get_audio_settings()
	assert_almost_eq(settings["music_volume"], test_music_vol, 0.01, "Music volume should match")
	assert_almost_eq(settings["sfx_volume"], test_sfx_vol, 0.01, "SFX volume should match")
	assert_eq(settings["music_enabled"], test_music_on, "Music enabled should match")
	assert_eq(settings["sfx_enabled"], test_sfx_on, "SFX enabled should match")

func test_vibration_setting_persists():
	# Given: Vibration disabled
	var test_vibration = false

	# When: Saving vibration setting
	save_manager.save_vibration_setting(test_vibration)

	# Wait for file I/O
	await wait_seconds(0.2)

	# Then: Reloading should return same setting
	save_manager.load_data()
	var loaded_vibration = save_manager.get_vibration_enabled()
	assert_eq(loaded_vibration, test_vibration, "Vibration setting should match")

func test_stats_update_correctly():
	# Given: SaveManager
	var initial_games = save_manager.current_data.get("stats", {}).get("games_played", 0)

	# When: Incrementing games played
	save_manager.increment_games_played()

	# Wait for file I/O
	await wait_seconds(0.2)

	# Then: Games played should increase by 1
	save_manager.load_data()
	var stats = save_manager.get_stats()
	assert_eq(stats["games_played"], initial_games + 1, "Games played should increment")

func test_highest_fruit_updates():
	# Given: A new highest fruit level
	var test_fruit_level = 7

	# When: Updating highest fruit
	save_manager.update_highest_fruit(test_fruit_level)

	# Wait for file I/O
	await wait_seconds(0.2)

	# Then: Highest fruit should be saved
	save_manager.load_data()
	var stats = save_manager.get_stats()
	assert_eq(stats["highest_fruit_reached"], test_fruit_level, "Highest fruit should update")

func test_save_file_creates_if_not_exists():
	# Given: No save file exists
	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		DirAccess.remove_absolute(SaveManager.SAVE_PATH)

	# When: Loading data
	save_manager.load_data()

	# Then: Save file should be created
	assert_true(FileAccess.file_exists(SaveManager.SAVE_PATH), "Save file should be created")

func test_corrupt_save_handled_gracefully():
	# Given: A corrupted save file
	var file = FileAccess.open(SaveManager.SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string("{ corrupt json data !!!")
		file.close()

	# When: Loading data
	save_manager.load_data()

	# Then: Should fall back to default data
	var loaded_score = save_manager.get_high_score()
	assert_eq(loaded_score, 0, "Corrupt save should reset to default high score of 0")

func test_save_verify_function_works():
	# Given: A saved high score
	save_manager.save_high_score(999)

	# Wait for file I/O
	await wait_seconds(0.2)

	# When: Verifying save
	save_manager.verify_save()

	# Then: No errors should occur (verification passes silently)
	# If verification failed, it would push_error which we can't easily test
	# But we can verify the file contains correct data
	var file = FileAccess.open(SaveManager.SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		assert_true(content.contains("999"), "Save file should contain the high score")

func test_multiple_saves_persist_latest():
	# Given: Multiple high scores saved in sequence
	save_manager.save_high_score(100)
	await wait_seconds(0.1)
	save_manager.save_high_score(200)
	await wait_seconds(0.1)
	save_manager.save_high_score(300)
	await wait_seconds(0.2)

	# When: Reloading
	save_manager.load_data()

	# Then: Latest score should be persisted
	assert_eq(save_manager.get_high_score(), 300, "Latest save should persist")
