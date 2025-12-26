# Performance Optimization Guide

This document outlines performance optimizations implemented in Tutti Fruitini and recommendations for maintaining performance.

## Implemented Optimizations

### 1. Object Pooling

#### Fruit Pooling (`FruitPool.gd`)
- **Pool Size**: 30 initial, 100 maximum
- **Active Limit**: 75 fruits
- **Benefits**:
  - Eliminates allocation/deallocation overhead
  - Reduces garbage collection pauses
  - Predictable memory usage
  - Automatic fruit limit enforcement

**Usage**:
```gdscript
var fruit = fruit_pool.get_fruit()  # Get from pool
fruit_pool.return_fruit(fruit)      # Return to pool
fruit_pool.enforce_fruit_limit()     # Remove oldest fruits if over limit
```

#### Particle Pooling (`ParticlePool.gd`)
- **Pool Size**: 15 particle systems
- **Benefits**:
  - No runtime particle system creation
  - Smooth merge effects without stuttering
  - Reduced CPU spikes

**Usage**:
```gdscript
particle_pool.emit_merge_effect(position, color, radius)
# Automatically returns to pool after effect completes
```

### 2. Physics Optimizations

#### Current Settings (`project.godot`)
```ini
[physics/2d]
physics_ticks_per_second=60
default_gravity=980.0
default_linear_damp=0.1
default_angular_damp=1.0
sleep_threshold_linear=2.0
sleep_threshold_angular=0.139626
```

#### Fruit Physics Material
- **Friction**: 0.5 (prevents excessive sliding)
- **Bounce**: 0.09 (soft, minimal bouncing)
- **Contact Monitoring**: Enabled (max 8 contacts)
- **Sleep Enabled**: Yes (reduces CPU when settled)

#### Collision Layers
- Layer 1: Walls (Static)
- Layer 2: Fruits (Dynamic)
- Layer 4: Merge Detection (Areas)
- Layer 8: Game Over Zone (Area)

**Benefits**:
- Minimal unnecessary collision checks
- Broadphase optimization
- Sleeping bodies don't process

### 3. Audio Pooling

#### SFX Player Pool
- **Pool Size**: 8 concurrent players
- **Benefits**:
  - Multiple sounds play without cutting off
  - No audio player creation at runtime
  - Predictable audio performance

**Implementation**: `AudioManager.gd`
```gdscript
var sfx_players: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE = 8
```

### 4. Render Optimizations

#### Mobile Rendering Settings
```ini
[rendering]
renderer/rendering_method="mobile"
textures/vram_compression/import_etc2_astc=true
anti_aliasing/quality/msaa_2d=2
```

#### Sprite Optimization
- Simple colored circles (procedurally generated)
- No complex textures or shaders
- Minimal draw calls

### 5. Memory Management

#### Save System
- **Format**: JSON (human-readable, small file size)
- **Save Frequency**: Only on data change, not every frame
- **Data Size**: <1KB typical save file

#### Resource Loading
- **Preloading**: All scenes preloaded in `_ready()`
- **No Runtime Loading**: Assets loaded at startup
- **Singleton Pattern**: Autoloads for managers

## Performance Targets

| Metric | Target | Critical | Notes |
|--------|--------|----------|-------|
| **FPS** | 60 | 45 | Locked to 60 on mobile |
| **Frame Time** | <16.67ms | <22ms | For 60 FPS |
| **Load Time** | <2s | <3s | Cold start |
| **RAM Usage** | <150MB | <200MB | Total game memory |
| **Max Fruits** | 75 | 100 | Before culling |
| **Physics Time** | <8ms | <12ms | Per frame |
| **Draw Calls** | <100 | <150 | Per frame |

## Performance Profiling

### Using Godot Profiler

1. Run game in debug mode
2. Open Debugger → Profiler
3. Monitor key metrics:
   - **Frame Time**: Should be <16.67ms for 60 FPS
   - **Physics Time**: Should be <50% of frame time
   - **Idle Time**: Remaining time after physics/render
   - **Node Count**: Track node growth over time
   - **Memory**: Monitor for leaks

### Bottleneck Identification

#### CPU-Bound (Physics)
**Symptoms**:
- FPS drops with many fruits
- Physics time >50% of frame budget
- Gameplay slows down

**Solutions**:
- Reduce max active fruits (already limited to 75)
- Increase sleep threshold (allow more fruits to sleep)
- Simplify collision shapes

#### GPU-Bound (Rendering)
**Symptoms**:
- FPS drops but physics time is low
- Many draw calls
- Complex visual effects

**Solutions**:
- Reduce particle count
- Use sprite atlasing
- Reduce anti-aliasing quality

#### Memory-Bound
**Symptoms**:
- Gradual FPS degradation
- Memory usage increases over time
- Garbage collection spikes

**Solutions**:
- Check object pools are working
- Verify `queue_free()` called correctly
- Use profiler to find leaks

## Optimization Checklist

### Before Release

- [ ] Run profiler for 15-minute session
- [ ] Check memory doesn't grow beyond 150MB
- [ ] Verify FPS stays above 45 on low-end device
- [ ] Test with 75+ fruits in container
- [ ] Ensure object pools are being used
- [ ] Check particle effects don't cause stuttering
- [ ] Verify save/load doesn't block main thread
- [ ] Test ad loading doesn't impact gameplay
- [ ] Confirm audio doesn't cause performance issues

### During Development

- [ ] Profile after major changes
- [ ] Use object pools instead of instantiate/free
- [ ] Avoid creating nodes in `_process()`
- [ ] Use signals instead of polling
- [ ] Cache node references in `@onready`
- [ ] Minimize string operations
- [ ] Use typed GDScript (`var x: int`)

## Low-End Device Optimizations

### If Targeting Android 7.0 / 2GB RAM:

1. **Reduce Max Fruits**:
   ```gdscript
   const MAX_ACTIVE_FRUITS = 50  # Down from 75
   ```

2. **Lower Particle Count**:
   ```gdscript
   particles.amount = 15  # Down from 20
   ```

3. **Disable Anti-Aliasing**:
   ```ini
   anti_aliasing/quality/msaa_2d=0
   ```

4. **Reduce Physics Ticks** (last resort):
   ```ini
   physics_ticks_per_second=50  # Down from 60
   ```

## Advanced Optimizations (Future)

### 1. Sprite Atlasing
Combine all fruit sprites into single texture:
- **Benefit**: 1 draw call for all fruits instead of 11
- **Implementation**: TexturePacker or Godot sprite atlas

### 2. Multithreading
Use worker threads for non-critical tasks:
- Save file writing
- Statistics calculation
- Ad loading

### 3. Level of Detail (LOD)
Simplify off-screen fruits:
- Disable merge detection for distant fruits
- Reduce particle detail for distant merges

### 4. Spatial Hashing
Custom collision optimization:
- Only check merges with nearby fruits
- Reduce O(n²) collision checks

## Common Performance Pitfalls

### ❌ Don't Do This:
```gdscript
# Creating objects in _process()
func _process(_delta):
    var particle = CPUParticles2D.new()  # BAD! Creates every frame

# Polling instead of signals
func _process(_delta):
    if check_condition():  # BAD! Checks every frame
        do_something()

# String operations in loops
for i in 1000:
    var text = "Score: " + str(i)  # BAD! String concat is slow
```

### ✅ Do This Instead:
```gdscript
# Use object pools
var particle = particle_pool.get_particle_effect()

# Use signals
signal condition_met
func trigger_condition():
    emit_signal("condition_met")

# Cache strings
var score_text = "Score: "
for i in 1000:
    var text = score_text + str(i)
```

## Monitoring in Production

### Key Metrics to Track

1. **Crash Rate**: <1% of sessions
2. **Average FPS**: >55 (allowing for variance)
3. **Session Duration**: Higher is better
4. **Memory Usage**: Should plateau, not grow
5. **Load Time**: <3 seconds on 90% of devices

### Tools
- Google Play Console: Crash reports, ANR rate
- Firebase Performance Monitoring (optional)
- Custom analytics for FPS tracking

## Conclusion

The game is optimized for:
- **60 FPS** on mid-range Android devices (4GB RAM, Android 11+)
- **45+ FPS** on low-end devices (2GB RAM, Android 7.0+)
- **<150MB** memory usage
- **Smooth gameplay** with 75 active fruits

All major systems use object pooling, physics is optimized for mobile, and rendering is lightweight. The game should perform well on the vast majority of Android devices.

## Performance Updates Log

- **2024-12**: Initial optimizations implemented
  - Fruit pooling (30 initial, 100 max)
  - Particle pooling (15 systems)
  - Audio pooling (8 channels)
  - 75 fruit active limit
