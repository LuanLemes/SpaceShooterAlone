extends Node2D


signal _hero_heal
signal _hero_hurt
signal enemy_died
signal object_destroyed
signal _hero_shield_full
signal _hero_shield_depleted
signal _enemy_critical_landed
signal _level_started


onready var _hero = $HeroContainer.get_child(0)
onready var _upgrade_handler = $CanvasLayer/Ui/UpgradeHandler
onready var _wave_spawner = $WaveSpawner
onready var _health_bar :ProgressBar = $CanvasLayer/Ui/HealthBar
onready var _health_label : Label = $CanvasLayer/Ui/HealthBar/HealthLabel
onready var _shield_bar :ProgressBar = $CanvasLayer/Ui/ShieldBar
onready var _shield_label :Label = $CanvasLayer/Ui/ShieldBar/ShieldLabel
onready var _transition_rect: TransitionRect = $CanvasLayer/Ui/TransitionRect
onready var _reward_handler: = $RewardHandler
onready var _camera := $Camera2D
onready var _restart_button = $CanvasLayer/RestartButton
onready var _timer: Timer = $Timer
onready var _level_label := $CanvasLayer/Ui/LevelLabel
export var _reward_levels: int = 3
var _min_wait_time_between_levels: int = 3.5


func _ready():
	_upgrade_handler.hero = self._hero
	
	SignalManager.connect("wave_ended", self, "_on_wave_spawner_wave_ended")
	SignalManager.connect("all_waves_ended", self, "_on_wave_spawner_all_waves_ended")
	SignalManager.connect("object_destroyed", self, "_on_Spawner_object_destroyed")
	SignalManager.connect("on_hero_left", self, "_on_Spawner_hero_left")
	SignalManager.connect("upgrade_animation_finished", self, "_on_upgrade_handler_upgrade_finished")
	connect("_level_started", SignalManager, "_on_level_entered")
	_restart_button.connect("restart_button_pressed", self, "_on_restart_button_pressed")
	_reward_handler.connect("reward_activated", self, "_on_reward_handler_activated")
	start_level()
#	_wave_spawner.open_wave_front_door()


func count_timer() -> void:
	var elapsed_time = (_timer.wait_time - _timer.time_left)
	print(String(_wave_spawner.all_waves[_wave_spawner.wave_to_spawn - 1]), " took ", elapsed_time   )
	_timer.start()


func _show_upgrade_ui() -> void:
	_upgrade_handler.visible = true


func _hide_upgrade_ui() -> void:
	_upgrade_handler.visible = false


func _show_upgrade() -> void:
	_show_upgrade_ui()
	upgrade_pause()


func _on_upgrade_handler_upgrade_finished():
	_hide_upgrade_ui()
	upgrade_pause()


func _on_wave_spawner_wave_ended():
	print(_wave_spawner.wave_to_spawn)
	if (_wave_spawner.wave_to_spawn) % 3 == 0:
		_reward_handler.spawn_reward("BuyReward", _hero.global_position)
	_wave_spawner.open_wave_front_door()



func _on_wave_spawner_all_waves_ended():
	pass


func _on_Spawner_object_destroyed():
	emit_signal("object_destroyed")


func _on_hero_shield_full():
	emit_signal("_hero_shield_full")


func toggle_shield_ui_visibility() -> void:
	_shield_bar.visible = ! _shield_bar.visible


func upgrade_pause() -> void:
	get_tree().paused = !get_tree().paused


func _on_reward_handler_activated(reward_name: String) -> void:
	match reward_name:
		"BuyReward":
			_upgrade_handler.chosse_upgrades_to_buy()
			_show_upgrade()


func reset_hero_position() -> void:
	_hero.global_position = _wave_spawner.spawned_wave._player_start_position.global_position


func _on_Spawner_hero_left() -> void:
	call_next_level()


func call_next_level() -> void:
	count_timer()
	_hero.is_active = false
	_transition_rect.transition_out()
	yield(_transition_rect, "transition_ended")
	_wave_spawner.call_next_wave()
	_update_level_label()
	reset_hero_position()
	yield(get_tree().create_timer(_min_wait_time_between_levels), "timeout")
	_transition_rect.transition_in()
	_level_label.visible = false
#	yield(get_tree().create_timer(_min_wait_time_between_levels), "timeout")
	_hero.is_active = true
	emit_signal("_level_started")


func start_level() -> void:
	_hero.is_active = false
	_wave_spawner.call_next_wave()
#	yield(_transition_rect, "transition_ended")
	reset_hero_position()
	_update_level_label()
	yield(get_tree().create_timer(_min_wait_time_between_levels), "timeout")
	_transition_rect.transition_in()
	_level_label.visible = false
#	yield(get_tree().create_timer(_min_wait_time_between_levels), "timeout")
	_hero.is_active = true
	_reward_handler.spawn_reward("BuyReward", _hero.global_position)
	emit_signal("_level_started")


func _input(event):
	if event.is_action_pressed("test_input_3"):
		_on_reward_handler_activated("BuyReward")


func screen_shake() -> void:
	_camera.shake = true


func _on_restart_button_pressed() -> void:
	SignalManager.disconnect_all_signals()
	UpgradeCounter._reset_all_counters()
	get_tree().reload_current_scene()


func _update_level_label() -> void:
	_level_label.visible = true
	_level_label.text = "Level " + String(_wave_spawner.folder_number) + " - " + String(_wave_spawner.wave_to_spawn)

