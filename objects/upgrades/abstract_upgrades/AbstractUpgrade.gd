extends Upgrade

var effect_state: bool = false


func _ready():
	_up_name = "AftyerMoveCritical"
	_up_effect = "The first shoot after move has 10% more critical chance"
	_scene_path = "res://objects/status/status.tscn"


func _execute(value = 0):
	pass


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	hero.hero_weapon.bonus_critical_chance += 5


func _execute_bonus_1() -> void:
	pass


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func _on_timeout() -> void:
	_unexecute()
