extends Upgrade

var attack_bonus: int = 10

func _ready():
	_up_name = "Attack Plus"
	_up_effect = String("Your guns gain " + String(attack_bonus) + " attack")
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
	hero.hero_weapon._bonus_damage += attack_bonus
	UpgradeCounter.counter_attack_up += 1

	


func on_signal_received(value = 0):
	_execute()


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func update_labels() -> void:
	_atribute_description = "your attack is: " + String(hero.hero_weapon._total_damage)
	_up_effect = String("Your guns gain " + String(attack_bonus) + " attack")
	
	
#func update_attack_variation() -> int:
#	var nerf: int = UpgradeCounter.counter_attack_up *2
#	attack_variation = max(2, 7 - round(nerf))
#	return attack_variation
