extends Upgrade


var _damage_cost = 3


func _ready():
	_up_name = "Diagonal Shoot"
	_up_effect = "Your Gun Shoots Diagonal Shoots but you lose 3 damage"
	_bonus_1 = ""
	_bonus_2 = ""
	_bonus_3 = ""
#	_signal_connect = "hero_shield_full"
	_scene_path = "res://objects/status/status.tscn"
	

func _execute(value = 0):
	print(name)


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	hero.hero_weapon.add_diagonal_cannons1()
	hero.hero_weapon._bonus_damage -= _damage_cost


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass


func update_labels() -> void:
	_atribute_description = "your damage is: " + String(hero.hero_weapon._base_damage)
