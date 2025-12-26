extends Node

## FruitPool - Object pool for Fruit instances to reduce allocation overhead

class_name FruitPool

var pooled_fruits: Array[Fruit] = []
var active_fruits: Array[Fruit] = []
const INITIAL_POOL_SIZE = 30
const MAX_POOL_SIZE = 100
const MAX_ACTIVE_FRUITS = 75

var fruit_scene: PackedScene

func _ready() -> void:
	fruit_scene = preload("res://scenes/Fruit.tscn")
	prewarm_pool()

func prewarm_pool() -> void:
	print("Prewarming fruit pool with ", INITIAL_POOL_SIZE, " fruits...")
	for i in INITIAL_POOL_SIZE:
		var fruit = create_new_fruit()
		fruit.visible = false
		fruit.freeze = true
		pooled_fruits.append(fruit)
	print("Fruit pool ready")

func create_new_fruit() -> Fruit:
	var fruit = fruit_scene.instantiate() as Fruit
	add_child(fruit)
	return fruit

func get_fruit() -> Fruit:
	var fruit: Fruit = null

	# Check if we have a pooled fruit available
	if pooled_fruits.size() > 0:
		fruit = pooled_fruits.pop_back()
	else:
		# Pool exhausted, create new fruit if under limit
		if get_total_fruit_count() < MAX_POOL_SIZE:
			print("Pool empty, creating new fruit")
			fruit = create_new_fruit()
		else:
			# At maximum capacity, remove oldest active fruit
			print("Maximum fruit capacity reached, removing oldest fruit")
			if active_fruits.size() > 0:
				var oldest = active_fruits[0]
				return_fruit(oldest)
				fruit = get_fruit()  # Recursive call to get the fruit we just returned
			else:
				# Fallback: create anyway
				fruit = create_new_fruit()

	# Reset fruit state
	if fruit:
		fruit.visible = true
		fruit.freeze = false
		fruit.is_merging = false
		fruit.can_merge = false
		fruit.linear_velocity = Vector2.ZERO
		fruit.angular_velocity = 0.0
		active_fruits.append(fruit)

	return fruit

func return_fruit(fruit: Fruit) -> void:
	if not is_instance_valid(fruit):
		return

	# Remove from active list
	if active_fruits.has(fruit):
		active_fruits.erase(fruit)

	# Reset fruit state
	fruit.visible = false
	fruit.freeze = true
	fruit.global_position = Vector2(-10000, -10000)  # Move off-screen
	fruit.linear_velocity = Vector2.ZERO
	fruit.angular_velocity = 0.0
	fruit.is_merging = false
	fruit.can_merge = false

	# Add back to pool if not at max size
	if pooled_fruits.size() < MAX_POOL_SIZE:
		pooled_fruits.append(fruit)
	else:
		# Pool is full, destroy the fruit
		fruit.queue_free()

func get_total_fruit_count() -> int:
	return pooled_fruits.size() + active_fruits.size()

func get_active_fruit_count() -> int:
	return active_fruits.size()

func get_pooled_fruit_count() -> int:
	return pooled_fruits.size()

func cleanup_all() -> void:
	# Return all active fruits to pool
	for fruit in active_fruits.duplicate():
		return_fruit(fruit)

	print("Fruit pool cleaned up. Active: ", active_fruits.size(), ", Pooled: ", pooled_fruits.size())

func enforce_fruit_limit() -> void:
	# Remove oldest fruits if over limit
	while active_fruits.size() > MAX_ACTIVE_FRUITS:
		var oldest = active_fruits[0]
		print("Enforcing fruit limit, removing oldest fruit")
		return_fruit(oldest)
