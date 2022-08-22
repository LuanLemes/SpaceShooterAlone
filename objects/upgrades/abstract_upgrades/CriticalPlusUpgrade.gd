extends Upgrade

var effect_state: bool = false
var upgrade_bonus: = 2.9

func _ready():
	_up_name = "Critical chance Plus"
	_scene_path = "res://objects/status/status.tscn"


func _execute(value = 0):
	pass


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	hero.hero_weapon.bonus_critical_chance += 2.9


func _execute_bonus_1() -> void:
	pass


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func _on_timeout() -> void:
	_unexecute()

func update_labels() -> void:
	_up_effect = "gain " + String(upgrade_bonus) + "% critical chance"
	_atribute_description = "your critical chance is: " + String(hero.hero_weapon.total_critical_chance)

