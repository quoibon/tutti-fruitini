extends GutTest

## Test suite for physics and shake mechanics

var fruit_scene: PackedScene
var test_fruit: Fruit
var test_parent: Node2D
var shake_manager: Node

func before_each():
	# Setup test environment
	fruit_scene = load("res://scenes/Fruit.tscn")
	test_parent = Node2D.new()
	add_child_autofree(test_parent)

	# Create test fruit
	test_fruit = fruit_scene.instantiate()
	test_parent.add_child(test_fruit)
	test_fruit.initialize(0)

	# Get ShakeManager autoload
	shake_manager = get_node_or_null("/root/ShakeManager")

func after_each():
	test_fruit = null
	test_parent = null

func test_fruit_has_correct_physics_properties():
	# Given: A fruit is initialized
	# Already done in before_each

	# Then: Fruit should have correct physics material
	var physics_mat = test_fruit.physics_material_override
	assert_not_null(physics_mat, "Fruit should have physics material")
	assert_almost_eq(physics_mat.friction, 0.5, 0.01, "Friction should be 0.5")
	assert_almost_eq(physics_mat.bounce, 0.117, 0.01, "Bounce should be 0.117")

func test_fruit_has_correct_collision_layers():
	# Given: A fruit is initialized
	# Already done in before_each

	# Then: Fruit should be on layer 2 and collide with layers 1 and 2
	assert_eq(test_fruit.collision_layer, 2, "Fruit should be on collision layer 2")
	assert_eq(test_fruit.collision_mask, 3, "Fruit should collide with layers 1 and 2 (mask=3)")

func test_shake_applies_impulse():
	# Given: A fruit in the scene and shake manager with shakes available
	if not shake_manager:
		fail_test("ShakeManager not found")
		return

	# Ensure shake count is available
	if shake_manager.shake_count <= 0:
		shake_manager.shake_count = 10

	# Add fruit to "fruits" group
	test_fruit.add_to_group("fruits")
	test_fruit.global_position = Vector2(300, 300)
	test_fruit.linear_velocity = Vector2.ZERO

	# Wait for physics to stabilize
	await wait_seconds(0.1)

	# When: Shake is performed
	var initial_velocity = test_fruit.linear_velocity.length()
	shake_manager.perform_shake()

	# Wait for physics update
	await wait_seconds(0.05)

	# Then: Fruit should have velocity applied
	var final_velocity = test_fruit.linear_velocity.length()
	assert_gt(final_velocity, initial_velocity, "Shake should apply impulse to fruit")

func test_shake_count_decreases():
	# Given: ShakeManager with shakes available
	if not shake_manager:
		fail_test("ShakeManager not found")
		return

	# Set known shake count
	shake_manager.shake_count = 10
	var initial_count = shake_manager.shake_count

	# When: Shake is performed
	shake_manager.perform_shake()

	# Then: Shake count should decrease by 1
	assert_eq(shake_manager.shake_count, initial_count - 1, "Shake count should decrease by 1")

func test_shake_cooldown_prevents_rapid_shaking():
	# Given: ShakeManager with shakes available
	if not shake_manager:
		fail_test("ShakeManager not found")
		return

	shake_manager.shake_count = 10
	var initial_count = shake_manager.shake_count

	# When: Two shakes performed rapidly
	shake_manager.perform_shake()
	shake_manager.perform_shake()  # Should be blocked by cooldown

	# Then: Only one shake should have occurred
	assert_eq(shake_manager.shake_count, initial_count - 1, "Cooldown should prevent second shake")

	# When: Waiting for cooldown
	await wait_seconds(0.2)

	# Then: Should be able to shake again
	shake_manager.perform_shake()
	assert_eq(shake_manager.shake_count, initial_count - 2, "Should shake again after cooldown")

func test_shake_respects_max_count():
	# Given: ShakeManager
	if not shake_manager:
		fail_test("ShakeManager not found")
		return

	# When: Refilling shakes
	shake_manager.refill_shakes()

	# Then: Shake count should be MAX_SHAKES (50)
	assert_eq(shake_manager.shake_count, 50, "Refill should set count to 50")

func test_cannot_shake_when_depleted():
	# Given: ShakeManager with no shakes
	if not shake_manager:
		fail_test("ShakeManager not found")
		return

	shake_manager.shake_count = 0

	# When: Attempting to shake
	var can_shake = shake_manager.can_shake()

	# Then: Should not be able to shake
	assert_false(can_shake, "Should not be able to shake when count is 0")

func test_fruit_settles_after_drop():
	# Given: A fruit with downward velocity
	test_fruit.global_position = Vector2(300, 100)
	test_fruit.linear_velocity = Vector2(0, 500)

	# When: Waiting for physics to settle
	await wait_seconds(2.0)

	# Then: Fruit velocity should be near zero (settled)
	var velocity_magnitude = test_fruit.linear_velocity.length()
	assert_lt(velocity_magnitude, 100, "Fruit should settle after drop")

func test_fruit_collision_shape_exists():
	# Given: An initialized fruit
	# Already done in before_each

	# Then: Collision shape should be set
	var collision_shape = test_fruit.get_node_or_null("CollisionShape2D")
	assert_not_null(collision_shape, "Fruit should have CollisionShape2D")
	assert_not_null(collision_shape.shape, "CollisionShape2D should have a shape")

func test_merge_area_exists():
	# Given: An initialized fruit
	# Already done in before_each

	# Then: Merge area should exist
	var merge_area = test_fruit.get_node_or_null("MergeArea")
	assert_not_null(merge_area, "Fruit should have MergeArea")

	var merge_shape = merge_area.get_node_or_null("CollisionShape2D")
	assert_not_null(merge_shape, "MergeArea should have CollisionShape2D")
	assert_not_null(merge_shape.shape, "MergeArea shape should be set")

func test_fruit_has_contact_monitoring():
	# Given: An initialized fruit
	# Already done in before_each

	# Then: Contact monitoring should be enabled
	assert_true(test_fruit.contact_monitor, "Contact monitor should be enabled")
	assert_eq(test_fruit.max_contacts_reported, 8, "Should report up to 8 contacts")
