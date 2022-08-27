extends Upgrade

var is_effect_active: bool = false
var bullet_bonus_scale = 0.5
var status_bonus_chance := 15

func _ready():
	_up_name = "After Move Elemental Upgrade"
	_up_effect = "After moving your first shoot have 25% more chance of being and elemental shoot (if possible)"


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
	hero.hero_weapon.bonus_status_chance -= status_bonus_chance
	hero.hero_weapon.is_special_bullet = false


func add_all_bonus() -> void:
	if is_effect_active != false:
		return
	is_effect_active = true
	hero.hero_weapon.bonus_status_chance += status_bonus_chance
	hero.hero_weapon.is_special_bullet = true


func update_labels() -> void:
	_atribute_description = "your elemental chance is: " + String(hero.hero_weapon.status_chance)

