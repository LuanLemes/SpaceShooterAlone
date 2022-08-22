extends Upgrade

var is_effect_active: bool = false
var bullet_bonus_scale = 0.5
var percent_bonus_damage := 10.0

func _ready():
	_up_name = "After Move UPgrade"
	_up_effect = "First Shoot after player move are bigger and stronger"

#	_signal_connect = "hero_shield_full"

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
	is_effect_active = true
	add_all_bonus()


func _on_hero_shooted() -> void:
	reset_all_bonus()


func reset_all_bonus() -> void:
	if is_effect_active != true:
		return
	hero.hero_weapon.bullet_bonus_scale = hero.hero_weapon.bullet_bonus_scale - self.bullet_bonus_scale
	is_effect_active = false
	hero.hero_weapon._percent_bonus_damage -= percent_bonus_damage

func add_all_bonus() -> void:
	hero.hero_weapon.bullet_bonus_scale = hero.hero_weapon.bullet_bonus_scale + self.bullet_bonus_scale
	hero.hero_weapon._percent_bonus_damage += percent_bonus_damage
	


