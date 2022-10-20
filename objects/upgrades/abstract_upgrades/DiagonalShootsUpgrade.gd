extends Upgrade


var _damage_cost = 5
var _is_active: bool = false
var _cooldown: float = 1
onready var timer:= $Timer


func _ready():
	_up_name = "Diagonal Shoot"
	_up_effect = "After pick code fragment gain Diagonal Shoots for a short time"
	_bonus_1 = ""
	_bonus_2 = ""
	_bonus_3 = ""
	_scene_path = "res://objects/status/status.tscn"
	timer.wait_time = _cooldown
	

func _execute(value = 0):
	if _is_active == true:
		return
	_is_active = true
	hero.hero_weapon.add_diagonal_cannons1()
	timer.start()


func _unexecute():
	if _is_active == false:
		return
	hero.hero_weapon.remove_extra_cannons()
	_is_active = false


func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("collectable_picked", self, "_execute")


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass


func update_labels() -> void:
	_atribute_description = "your damage is: " + String(hero.hero_weapon._base_damage)


func _on_Timer_timeout():
	_unexecute()
