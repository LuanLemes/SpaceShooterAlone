extends Upgrade

var is_effect_active: bool = false
var critical_bonus_chance := 13.5

func _ready():
	_up_name = "After Move Critical"
	_up_effect = "The first shoot after move has 13.5% more critical chance"
	_scene_path = "res://objects/status/status.tscn"


func _execute(value = 0):
	print(name)


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("hero_started_moving", self, "_on_hero_started_moving")
	SignalManager.connect("hero_shooted", self, "_on_hero_shooted")


func on_signal_received(value = 0):
	_execute()


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass


func _on_hero_started_moving() -> void:
	if is_effect_active:
		return
	add_all_bonus()


func _on_hero_shooted() -> void:
	reset_all_bonus()


func reset_all_bonus() -> void:
	if is_effect_active != true:
		return
	is_effect_active = false
	hero.hero_weapon.bonus_critical_chance -= critical_bonus_chance


func add_all_bonus() -> void:
	if is_effect_active != false:
		return
	is_effect_active = true
	hero.hero_weapon.bonus_critical_chance += critical_bonus_chance


func update_labels() -> void:
	_atribute_description = "your critical chance is: " + String(hero.hero_weapon.total_critical_chance)



