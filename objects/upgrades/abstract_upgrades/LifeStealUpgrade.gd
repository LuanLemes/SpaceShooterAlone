extends Upgrade

func _ready():
	_up_name = "Is this even LifeSteal?"
	_up_effect = "Whenever You Kill An Enemy you have 50% chance to Heal 1 HP"
	_bonus_1 = ""
	_bonus_2 = ""
	_bonus_3 = ""
	_scene_path = "res://objects/status/status.tscn"
	

func _execute():
	if Rng.rng.randi_range(0,1) == 1:
		hero.get_heal(1)


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

func update_labels() -> void:
	_atribute_description = "your hp is: " + String(hero._hp) + " and your total hp is " + String(hero._total_hp)

