extends Upgrade



var effect_state: bool = false


func _ready():
	_up_name = "Hope!"
	_up_effect = "heal 3 hp whenever you deal a critical hit (only works if your hp is bellow 20%)"
	_scene_path = "res://objects/status/status.tscn"
	
	


func _execute(value = 0):
	if hero._hp <= hero._total_hp/100*20:
		hero.get_heal(3)


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("enemy_critical_landed", self, "_execute")


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func _on_timeout() -> void:
	_unexecute()
