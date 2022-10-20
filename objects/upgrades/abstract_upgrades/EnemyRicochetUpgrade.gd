extends Upgrade

var is_active: bool = false
onready var timer: Timer = $Timer
var cooldown: float = 2

func _ready():
	timer.wait_time = cooldown
	_up_name = "Enemy Ricochet"
	_up_effect = "After pick code fragment Your bullets ricochet from one enemy to another for a short period of time"
	_bonus_1 = ""
	_bonus_2 = ""
	_bonus_3 = ""
#	_signal_connect = "hero_shield_full"
	_scene_path = "res://objects/status/status.tscn"
	

func _execute(value = 0):
	if !is_active:
		is_active = true
		hero.hero_weapon.max_enemies_bounces += 1
		timer.start()


func _unexecute():
	hero.hero_weapon.max_enemies_bounces -= 1
	


func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("collectable_picked", self, "_execute")


func on_signal_received(value = 0):
	_execute()


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass


func _on_Timer_timeout():
	if is_active:
		is_active = false
		_unexecute()
