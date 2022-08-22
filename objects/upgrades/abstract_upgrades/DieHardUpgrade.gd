extends Upgrade

var effect_state: bool = false setget set_effect_state
var hp_percentage_threshold: float = 40
var damage_reduction: float = 20


func _ready():
	_up_name = "DieHard"
	_up_effect = "If your hp is bellow 40% you take 20% less damage"
	_scene_path = "res://objects/status/status.tscn"



func _execute(value = 0):
	pass


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("hero_hp_changed", self, "_on_hero_hp_changed")


func _on_hero_hp_changed() -> void:
	if hero._hp < hero._total_hp * hp_percentage_threshold / 100:
		self.effect_state = true
	else:
		self.effect_state = false


func set_effect_state(new_state) -> void:
	if effect_state == new_state:
		return
	if new_state == true:
		hero._hurt_box.damage_reduction += 20
	if new_state == false:
		hero._hurt_box.damage_reduction -= 20
	print(hero._hurt_box.damage_reduction)
	effect_state = new_state


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func _on_timeout() -> void:
	_unexecute()
