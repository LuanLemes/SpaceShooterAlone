extends Upgrade

var bonus_critical: float = 7.0

func _ready():
	_up_name = "Weak Point"
	_up_effect = "More 7% chance to deal a critical damage"
	_scene_path = "res://objects/status/status.tscn"



func _execute(value = 0):
	pass


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	hero.hero_weapon.bonus_critical_chance += bonus_critical



func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func _on_timeout() -> void:
	_unexecute()

func update_labels() -> void:
	_atribute_description = "your critical chance is: " + String(hero.hero_weapon.total_critical_chance)
