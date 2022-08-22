extends Upgrade

var _heal_amount = 5
var _heal_chance = 5
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	_up_name = "Ofense is the best defense"
	_up_effect = "Every time you crit has a 2% chance to heal 5 hp"
	_scene_path = "res://objects/status/status.tscn"


func _execute(value = 0):
	var random_number_generated = rng.randi_range(0, 100)
	if random_number_generated <= _heal_chance:
		hero.get_heal(self._heal_amount)


func _unexecute():
	pass


func _initialize() -> void:
	pass


func on_buy_effect():
	SignalManager.connect("enemy_critical_landed", self, "_execute")


func _execute_bonus_2() -> void:
	pass


func _execute_bonus_3() -> void:
	pass

func _on_timeout() -> void:
	_unexecute()


func update_labels() -> void:
	_atribute_description = "your hp is: " + String(hero._hp) + " and your total hp is " + String(hero._total_hp)
