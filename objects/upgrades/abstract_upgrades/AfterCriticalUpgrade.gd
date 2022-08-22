extends Upgrade

var is_effect_active: bool = false
var critical_bonus_chance := 13.5
var wait_time:= 5
var is_active: = false

onready var _timer: Timer = $Timer


func _ready():
	_timer.connect("timeout", self, "_on_time_out")
	_up_name = "After Critical"
	_up_effect = "After a crit you have 10% attack plus for 5 secconds"
	_scene_path = "res://objects/status/status.tscn"


func _execute(value = 0):
	if !is_active:
		is_active = true
		hero.hero_weapon._percent_bonus_damage += 10


func _unexecute():
	if is_active:
		hero.hero_weapon._percent_bonus_damage -= 10
		is_active = false

func _initialize() -> void:
	pass


func _on_time_out() -> void:
	_unexecute()


func on_buy_effect():
	SignalManager.connect("enemy_critical_landed", self, "_execute")


func on_signal_received(value = 0):
	_execute()


func _execute_bonus_1() -> void:
	print("enemy died and bonus 10 executed")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass


func update_labels() -> void:
	_atribute_description = "your critical chance is: " + String(hero.hero_weapon.total_critical_chance) + ". Your attack is " + String(hero.hero_weapon._total_damage)



