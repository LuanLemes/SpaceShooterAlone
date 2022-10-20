extends Upgrade



var effect_state: bool = false
onready var _timer: Timer = $Timer
var is_effect_active: bool = false
var effect_duration: int = 5


func _ready():
	_timer.wait_time = effect_duration
	_timer.connect("timeout", self, "_unexecute")
	_up_name = "Catastrophic Morale!"
	_up_effect = "After you Kill an enemy add 1 enemy ricochet and 1 wall ricochet for 5 seconds"
	_scene_path = "res://objects/status/status.tscn"


func _execute(value = 0):
	if !is_effect_active:
		is_effect_active = true
		hero.hero_weapon.max_enemies_bounces += 1
		hero.hero_weapon.max_wall_bounces += 2
		_timer.start()


func _unexecute():
	
	if is_effect_active:
		is_effect_active = false
		hero.hero_weapon.max_enemies_bounces -= 1
		hero.hero_weapon.max_wall_bounces -= 2


func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("enemy_death_started", self, "_execute")


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func _on_timeout() -> void:
	_unexecute()
