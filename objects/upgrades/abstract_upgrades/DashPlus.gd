extends Upgrade


var _damage_cost = 5
var _is_active: bool = false
var _cooldown: float = 2
onready var timer:= $Timer


func _ready():
	_up_name = "Dash Plus"
	_up_effect = "You can dash two times in a row"
	_bonus_1 = ""
	_bonus_2 = ""
	_bonus_3 = ""
	_scene_path = "res://objects/status/status.tscn"
	

func _execute(value = 0):
	hero.reset_dash_cooldown()


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	hero.max_dashs += 1
	hero.dashs_left = hero.max_dashs


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass


func update_labels() -> void:
	_atribute_description = "your damage is: " + String(hero.hero_weapon._base_damage)


func _on_Timer_timeout():
	_unexecute()
