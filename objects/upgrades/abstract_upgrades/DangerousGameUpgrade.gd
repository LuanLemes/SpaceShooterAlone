extends Upgrade


onready var _timer: Timer = $Timer
var wait_time = 40
var heal_amount = 30
var hurt_amount = 15


func _ready():
	_timer.wait_time = wait_time
	_up_name = "Dangerous Game"
	_up_effect = "If you finish a chamber before 35 seconds heal 15 hp, else lose 5 hp"
	_scene_path = "res://objects/status/status.tscn"
	


func _execute(value = 0):
	if _timer.is_stopped():
		hero._hp -= hurt_amount
	else:
		hero.get_heal(heal_amount)


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("on_wave_ended", self, "_execute")
	SignalManager.connect("level_entered", self, "_start_counting")

func _start_counting() -> void:
	_timer.start()

func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass
