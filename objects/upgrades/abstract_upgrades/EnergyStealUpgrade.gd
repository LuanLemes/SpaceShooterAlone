extends Upgrade

func _ready():
	_up_name = "Shield Steal"
	_up_effect = "When you kill an enemy you recover 10 shield"
	_bonus_1 = ""
	_bonus_2 = ""
	_bonus_3 = ""
	_scene_path = "res://objects/status/status.tscn"
	

func _execute():
	hero.shield_recharge_action.recover_shield(10)


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("enemy_death_started", self, "_execute")


func on_signal_received(value = 0):
	_execute()


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass
