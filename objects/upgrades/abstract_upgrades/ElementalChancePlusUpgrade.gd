extends Upgrade

var effect_state: bool = false


func _ready():
	_up_name = "Elemental Chance Plus"
	_up_effect = "3.5% more elemental chance"
	_scene_path = "res://objects/status/status.tscn"


func _execute(value = 0):
	pass


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	hero.hero_weapon.bonus_status_chance += 3.5


func _execute_bonus_1() -> void:
	pass


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func _on_timeout() -> void:
	_unexecute()


func update_labels() -> void:
	_atribute_description = "your elemental chance is: " + String(hero.hero_weapon.status_chance)

