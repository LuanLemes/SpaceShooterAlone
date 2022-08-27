extends Upgrade


var effect_state: bool = false


func _ready():
	_up_name = "Agressive Endurance"
	_up_effect = "Take 35% less damage while shooting"
	_scene_path = "res://objects/status/status.tscn"


func _execute(value = 0):
	if effect_state == false:
		hero._hurt_box.damage_reduction += 35
		effect_state = true


func _unexecute():
	if effect_state == true:
		hero._hurt_box.damage_reduction -= 35
		effect_state = false

func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("hero_started_shooting", self, "_execute")
	SignalManager.connect("hero_stopped_shooting", self, "_unexecute")


func _execute_bonus_1() -> void:
	pass


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass


func _on_timeout() -> void:
	_unexecute()

