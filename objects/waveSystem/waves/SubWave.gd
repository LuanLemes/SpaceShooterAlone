extends Node2D
class_name SubWave
signal number_of_enemies_updated(number_of_enemies)
signal ready_to_start(sub_wave)


var is_wave_initialized: bool = false
var current_number_of_enemies: int
export var last_subwave_counter_to_spawn: int = 0
var next_subwave = null setget set_next_subwave
var last_subwave = null setget set_last_subwave


func _ready(): 
	update_number_of_enemies()
	connect_all_enemies()


func update_number_of_enemies() -> void:
	current_number_of_enemies = get_child_count()
	emit_signal("number_of_enemies_updated", current_number_of_enemies)


func initialize_sub_wave():
#	
	if is_wave_initialized == true:
		return
	is_wave_initialized = true
	last_subwave.disconnect("number_of_enemies_updated", self, "_on_last_wave_current_enemies_updated")
	emit_signal("ready_to_start", self)


func _on_last_wave_current_enemies_updated(last_wave_current_number_of_enemies):
	pass
	if last_wave_current_number_of_enemies <= last_subwave_counter_to_spawn:
		initialize_sub_wave()


func set_last_subwave(value) -> void:
	var old_value = last_subwave
	last_subwave = value
	if old_value == null:
		last_subwave.connect("number_of_enemies_updated", self, "_on_last_wave_current_enemies_updated")


func set_next_subwave(value) -> void:
	last_subwave = value


func connect_all_enemies() -> void:
	for enemy in get_children():
		var this_enemy: Enemy = enemy
		this_enemy.connect("death_started", self, "_on_enemy_death_started")


func _on_enemy_death_started(position_of_enemy) -> void:
	current_number_of_enemies = current_number_of_enemies -1
	if current_number_of_enemies < 0:
		pass
	emit_signal("number_of_enemies_updated", current_number_of_enemies)


