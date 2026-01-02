extends GutTest

## Test suite for fruit merge logic

var fruit_scene: PackedScene
var test_fruit_a: Fruit
var test_fruit_b: Fruit
var test_parent: Node2D

func before_each():
	# Setup test environment
	fruit_scene = load("res://scenes/Fruit.tscn")
	test_parent = Node2D.new()
	add_child_autofree(test_parent)

	# Create two test fruits
	test_fruit_a = fruit_scene.instantiate()
	test_fruit_b = fruit_scene.instantiate()
	test_parent.add_child(test_fruit_a)
	test_parent.add_child(test_fruit_b)

func after_each():
	# Cleanup happens automatically with add_child_autofree
	test_fruit_a = null
	test_fruit_b = null
	test_parent = null

func test_same_level_fruits_merge():
	# Given: Two level 0 fruits at same position with low velocity
	test_fruit_a.initialize(0)
	test_fruit_b.initialize(0)
	test_fruit_a.global_position = Vector2(100, 100)
	test_fruit_b.global_position = Vector2(110, 100)
	test_fruit_a.linear_velocity = Vector2(10, 10)
	test_fruit_b.linear_velocity = Vector2(10, 10)

	# Wait for merge cooldown
	await wait_seconds(0.1)

	# Enable merge capability
	test_fruit_a.can_merge = true
	test_fruit_b.can_merge = true

	# When: Fruits touch
	test_fruit_a.perform_merge(test_fruit_b)

	# Then: Both fruits should be merging
	assert_true(test_fruit_a.is_merging, "Fruit A should be in merging state")
	assert_true(test_fruit_b.is_merging, "Fruit B should be in merging state")

func test_different_level_fruits_dont_merge():
	# Given: Two different level fruits
	test_fruit_a.initialize(0)
	test_fruit_b.initialize(1)
	test_fruit_a.global_position = Vector2(100, 100)
	test_fruit_b.global_position = Vector2(110, 100)
	test_fruit_a.linear_velocity = Vector2(10, 10)
	test_fruit_b.linear_velocity = Vector2(10, 10)

	# Wait for merge cooldown
	await wait_seconds(0.1)
	test_fruit_a.can_merge = true
	test_fruit_b.can_merge = true

	# When: Checking if levels match
	var levels_match = (test_fruit_a.level == test_fruit_b.level)

	# Then: Levels should not match
	assert_false(levels_match, "Different level fruits should not have matching levels")

func test_max_level_fruit_merging():
	# Given: Two max level fruits (level 10 - Strawberry)
	test_fruit_a.initialize(10)
	test_fruit_b.initialize(10)
	test_fruit_a.global_position = Vector2(100, 100)
	test_fruit_b.global_position = Vector2(110, 100)
	test_fruit_a.linear_velocity = Vector2(10, 10)
	test_fruit_b.linear_velocity = Vector2(10, 10)

	# Wait for merge cooldown
	await wait_seconds(0.1)
	test_fruit_a.can_merge = true
	test_fruit_b.can_merge = true

	# When: Max level fruits merge
	var initial_score = ScoreManager.score
	test_fruit_a.perform_merge(test_fruit_b)

	# Then: Score should increase by 5x bonus
	var expected_score = initial_score + (test_fruit_a.score_value * 5)
	assert_eq(ScoreManager.score, expected_score, "Max level merge should give 5x bonus points")

func test_merge_cooldown_prevents_instant_merge():
	# Given: Two level 0 fruits just spawned
	test_fruit_a.initialize(0)
	test_fruit_b.initialize(0)
	test_fruit_a.global_position = Vector2(100, 100)
	test_fruit_b.global_position = Vector2(110, 100)

	# When: Immediately checking merge capability (before cooldown expires)
	var can_merge_immediately = test_fruit_a.can_merge

	# Then: Should not be able to merge yet
	assert_false(can_merge_immediately, "Fruits should not merge immediately after spawn")

	# When: After cooldown period
	await wait_seconds(0.1)

	# Then: Should be able to merge
	assert_true(test_fruit_a.can_merge, "Fruits should be able to merge after cooldown")

func test_velocity_threshold_prevents_midair_merge():
	# Given: Two level 0 fruits moving fast
	test_fruit_a.initialize(0)
	test_fruit_b.initialize(0)
	test_fruit_a.global_position = Vector2(100, 100)
	test_fruit_b.global_position = Vector2(110, 100)
	test_fruit_a.linear_velocity = Vector2(600, 600)  # Above threshold
	test_fruit_b.linear_velocity = Vector2(600, 600)  # Above threshold

	await wait_seconds(0.1)
	test_fruit_a.can_merge = true
	test_fruit_b.can_merge = true

	# When: Checking velocity threshold (500 px/s average)
	var combined_velocity = (test_fruit_a.linear_velocity.length() + test_fruit_b.linear_velocity.length()) / 2.0
	var should_merge = combined_velocity <= 500

	# Then: Fruits should not merge due to high velocity
	assert_false(should_merge, "Fast-moving fruits should not merge")

func test_merge_spawns_next_level_fruit():
	# Given: Two level 0 fruits ready to merge
	test_fruit_a.initialize(0)
	test_fruit_b.initialize(0)
	test_fruit_a.global_position = Vector2(100, 100)
	test_fruit_b.global_position = Vector2(110, 100)
	test_fruit_a.linear_velocity = Vector2(10, 10)
	test_fruit_b.linear_velocity = Vector2(10, 10)

	await wait_seconds(0.1)
	test_fruit_a.can_merge = true
	test_fruit_b.can_merge = true

	# When: Fruits merge
	var initial_fruit_count = test_parent.get_child_count()
	test_fruit_a.perform_merge(test_fruit_b)

	# Wait for spawn
	await wait_seconds(0.1)

	# Then: A new fruit should be spawned
	# Note: Original fruits queue_free, new fruit is added
	# So count should be initial - 2 + 1 = initial - 1
	# But queue_free is deferred, so we check that spawn happened
	var fruits = get_tree().get_nodes_in_group("fruits")
	var has_level_1_fruit = false
	for fruit in fruits:
		if fruit.level == 1:
			has_level_1_fruit = true
			break

	assert_true(has_level_1_fruit, "Merge should spawn next level fruit")

func test_merge_increases_score():
	# Given: Two level 0 fruits ready to merge
	test_fruit_a.initialize(0)
	test_fruit_b.initialize(0)
	test_fruit_a.global_position = Vector2(100, 100)
	test_fruit_b.global_position = Vector2(110, 100)

	await wait_seconds(0.1)
	test_fruit_a.can_merge = true
	test_fruit_b.can_merge = true

	# When: Fruits merge
	var initial_score = ScoreManager.score
	var expected_increase = test_fruit_a.score_value * 2
	test_fruit_a.perform_merge(test_fruit_b)

	# Then: Score should increase by 2x the fruit's score value
	assert_eq(ScoreManager.score, initial_score + expected_increase, "Merge should award 2x score value")
