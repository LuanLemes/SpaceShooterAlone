extends Upgrade
var bonus_hp = 100

func _ready():
	_up_name = "HP UP"
	_up_effect = "Raise your max hp by 100"
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
	hero.bonus_hp += bonus_hp


func on_signal_received(value = 0):
	_execute()


func _execute_bonus_1() -> void:
	pass


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass


func update_labels() -> void:
	_atribute_description = "your hp: " + String(hero._total_hp)









