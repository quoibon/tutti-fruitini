extends Node2D

## ParticlePool - Object pool for particle effects to reduce allocation overhead

class_name ParticlePool

var pooled_particles: Array[CPUParticles2D] = []
var active_particles: Array[CPUParticles2D] = []
const POOL_SIZE = 15

func _ready() -> void:
	prewarm_pool()

func prewarm_pool() -> void:
	print("Prewarming particle pool with ", POOL_SIZE, " particle systems...")
	for i in POOL_SIZE:
		var particles = create_particle_system()
		particles.emitting = false
		pooled_particles.append(particles)
		add_child(particles)
	print("Particle pool ready")

func create_particle_system() -> CPUParticles2D:
	var particles = CPUParticles2D.new()

	# Base configuration (will be customized per use)
	particles.one_shot = true
	particles.amount = 20
	particles.lifetime = 0.6
	particles.explosiveness = 0.8

	# Visual properties (defaults)
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	particles.emission_sphere_radius = 20.0

	# Motion
	particles.direction = Vector2.UP
	particles.spread = 180.0
	particles.initial_velocity_min = 100.0
	particles.initial_velocity_max = 200.0
	particles.gravity = Vector2(0, 300)

	# Size
	particles.scale_amount_min = 4.0
	particles.scale_amount_max = 8.0

	return particles

func get_particle_effect() -> CPUParticles2D:
	var particles: CPUParticles2D = null

	# Get from pool or create new
	if pooled_particles.size() > 0:
		particles = pooled_particles.pop_back()
	else:
		# Pool exhausted, reuse oldest active particle
		if active_particles.size() > 0:
			print("Particle pool empty, reusing oldest")
			particles = active_particles[0]
			active_particles.erase(particles)
		else:
			# Create new particle system
			print("Creating new particle system")
			particles = create_particle_system()
			add_child(particles)

	active_particles.append(particles)
	return particles

func return_particle(particles: CPUParticles2D) -> void:
	if not is_instance_valid(particles):
		return

	# Remove from active list
	if active_particles.has(particles):
		active_particles.erase(particles)

	# Reset state
	particles.emitting = false
	particles.global_position = Vector2(-10000, -10000)

	# Return to pool
	if not pooled_particles.has(particles):
		pooled_particles.append(particles)

func emit_merge_effect(position: Vector2, color: Color, radius: float) -> void:
	var particles = get_particle_effect()

	# Configure particle effect
	particles.global_position = position
	particles.color = color
	particles.emission_sphere_radius = radius * 0.5
	particles.emitting = true

	# Auto-return after lifetime
	await get_tree().create_timer(particles.lifetime + 0.1).timeout
	return_particle(particles)

func get_pool_stats() -> Dictionary:
	return {
		"pooled": pooled_particles.size(),
		"active": active_particles.size(),
		"total": pooled_particles.size() + active_particles.size()
	}

func cleanup_all() -> void:
	for particles in active_particles.duplicate():
		return_particle(particles)
	print("Particle pool cleaned up")
