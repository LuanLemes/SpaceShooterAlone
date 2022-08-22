extends Upgrade



func _ready():
	_up_name = "Repairs"
	_up_effect = "Repair 35% of your ship health"
	_scene_path = "res://objects/status/status.tscn"



func _execute(value = 0):
	pass


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	hero.get_heal(hero._total_hp * 35/100)


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func _on_timeout() -> void:
	_unexecute()


func update_labels() -> void:
	_atribute_description = "your hp is: " + String(hero._hp) + " and your total hp is " + String(hero._total_hp)
