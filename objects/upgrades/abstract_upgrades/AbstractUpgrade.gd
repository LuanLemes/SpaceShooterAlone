extends Upgrade

var attack_bonus: int = 10

func _ready():
	_up_name = "Missle Launcher"
	_up_effect = "Your ship now have gain a missle launcher"
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
	hero.hero_weapon.is_back_fire = true

	


func on_signal_received(value = 0):
	pass


func _execute_bonus_1() -> void:
	pass


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func update_labels() -> void:
	pass
	
	
#func update_attack_variation() -> int:
#	var nerf: int = UpgradeCounter.counter_attack_up *2
#	attack_variation = max(2, 7 - round(nerf))
#	return attack_variation
