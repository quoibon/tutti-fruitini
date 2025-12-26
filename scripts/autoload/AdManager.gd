extends Node

## AdManager - Handles AdMob integration for rewarded ads

signal ad_loaded
signal ad_failed_to_load
signal ad_displayed
signal ad_closed
signal reward_earned
signal free_refill_ready

# Test IDs (replace with real IDs for production)
const ANDROID_APP_ID = "ca-app-pub-3940256099942544~3347511713"  # Test App ID
const ANDROID_REWARDED_AD_ID = "ca-app-pub-3940256099942544/5224354917"  # Test Rewarded Ad
const IOS_APP_ID = "ca-app-pub-3940256099942544~1458002511"  # Test App ID
const IOS_REWARDED_AD_ID = "ca-app-pub-3940256099942544/1712485313"  # Test Rewarded Ad

var admob: Object = null
var rewarded_ad: Object = null
var is_ad_loaded: bool = false
var is_plugin_available: bool = false
var retry_timer: Timer
var free_refill_timer: Timer
var is_loading: bool = false

const AD_RETRY_DELAY: float = 5.0
const FREE_REFILL_DELAY: float = 30.0

func _ready() -> void:
	# Check if AdMob plugin is available
	check_plugin_availability()

	# Setup retry timer
	retry_timer = Timer.new()
	retry_timer.one_shot = true
	retry_timer.wait_time = AD_RETRY_DELAY
	retry_timer.timeout.connect(_on_retry_timeout)
	add_child(retry_timer)

	# Setup free refill timer (fallback)
	free_refill_timer = Timer.new()
	free_refill_timer.one_shot = true
	free_refill_timer.wait_time = FREE_REFILL_DELAY
	free_refill_timer.timeout.connect(_on_free_refill_timeout)
	add_child(free_refill_timer)

	# Initialize AdMob if available
	if is_plugin_available:
		initialize_admob()
		load_rewarded_ad()

func check_plugin_availability() -> void:
	# Check if AdMob singleton exists
	if Engine.has_singleton("AdMob"):
		admob = Engine.get_singleton("AdMob")
		is_plugin_available = true
		print("AdMob plugin detected")
	else:
		is_plugin_available = false
		print("AdMob plugin not detected - using fallback mode")

func initialize_admob() -> void:
	if not is_plugin_available:
		return

	# Initialize AdMob with appropriate App ID
	var app_id = ANDROID_APP_ID if OS.get_name() == "Android" else IOS_APP_ID

	# Configuration for initialization
	var config = {
		"max_ad_content_rating": "G",  # General audience
		"is_real": false,  # Set to true for production
		"is_for_child_directed_treatment": false
	}

	admob.initialize(app_id, config)
	print("AdMob initialized with App ID: ", app_id)

func load_rewarded_ad() -> void:
	if not is_plugin_available:
		print("Cannot load ad - AdMob plugin not available")
		return

	if is_loading:
		print("Ad already loading...")
		return

	if is_ad_loaded:
		print("Ad already loaded")
		return

	is_loading = true

	# Get appropriate ad unit ID
	var ad_unit_id = ANDROID_REWARDED_AD_ID if OS.get_name() == "Android" else IOS_REWARDED_AD_ID

	# Load rewarded ad
	print("Loading rewarded ad...")
	admob.load_rewarded_ad(ad_unit_id)

	# Connect signals if not already connected
	if not admob.rewarded_ad_loaded.is_connected(_on_rewarded_ad_loaded):
		admob.rewarded_ad_loaded.connect(_on_rewarded_ad_loaded)
	if not admob.rewarded_ad_failed_to_load.is_connected(_on_rewarded_ad_failed):
		admob.rewarded_ad_failed_to_load.connect(_on_rewarded_ad_failed)
	if not admob.rewarded_ad_opened.is_connected(_on_rewarded_ad_opened):
		admob.rewarded_ad_opened.connect(_on_rewarded_ad_opened)
	if not admob.rewarded_ad_closed.is_connected(_on_rewarded_ad_closed):
		admob.rewarded_ad_closed.connect(_on_rewarded_ad_closed)
	if not admob.user_earned_reward.is_connected(_on_user_earned_reward):
		admob.user_earned_reward.connect(_on_user_earned_reward)

func show_rewarded_ad() -> void:
	if not is_plugin_available:
		print("AdMob plugin not available - starting free refill timer")
		show_free_refill_option()
		return

	if not is_ad_loaded:
		print("Rewarded ad not loaded yet - attempting to load")
		load_rewarded_ad()
		show_free_refill_option()  # Offer fallback while loading
		return

	print("Showing rewarded ad...")
	admob.show_rewarded_ad()

func show_free_refill_option() -> void:
	print("Free refill available in ", FREE_REFILL_DELAY, " seconds")
	free_refill_timer.start()

func grant_free_refill() -> void:
	print("Granting free shake refill")
	emit_signal("reward_earned")

# AdMob Callbacks

func _on_rewarded_ad_loaded() -> void:
	is_ad_loaded = true
	is_loading = false
	print("✅ Rewarded ad loaded successfully")
	emit_signal("ad_loaded")

func _on_rewarded_ad_failed(error_code: int) -> void:
	is_ad_loaded = false
	is_loading = false
	print("❌ Rewarded ad failed to load. Error code: ", error_code)
	emit_signal("ad_failed_to_load")

	# Retry after delay
	print("Retrying ad load in ", AD_RETRY_DELAY, " seconds...")
	retry_timer.start()

	# Offer free refill as backup
	show_free_refill_option()

func _on_rewarded_ad_opened() -> void:
	print("📱 Rewarded ad displayed")
	emit_signal("ad_displayed")

func _on_rewarded_ad_closed() -> void:
	print("🚪 Rewarded ad closed")
	is_ad_loaded = false
	emit_signal("ad_closed")

	# Load next ad
	load_rewarded_ad()

func _on_user_earned_reward(reward_type: String, reward_amount: int) -> void:
	print("🎁 User earned reward: ", reward_amount, " ", reward_type)
	emit_signal("reward_earned")

	# Cancel free refill timer if active
	if free_refill_timer.time_left > 0:
		free_refill_timer.stop()

# Timer Callbacks

func _on_retry_timeout() -> void:
	print("Retrying ad load...")
	load_rewarded_ad()

func _on_free_refill_timeout() -> void:
	print("✅ Free refill now available!")
	emit_signal("free_refill_ready")

# Public API

func is_ad_ready() -> bool:
	return is_plugin_available and is_ad_loaded

func get_free_refill_time_remaining() -> float:
	return free_refill_timer.time_left

func is_free_refill_ready() -> bool:
	return free_refill_timer.is_stopped() and free_refill_timer.time_left <= 0
