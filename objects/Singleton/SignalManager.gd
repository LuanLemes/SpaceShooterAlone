extends Node


signal player_can_enter
signal hero_entered_level
signal transition_ended
signal warning_ended
signal _on_collectable_request(this_position)
signal camera_shake_requested
signal upgrade_activated(upgrade)
signal enemy_died
signal object_destroyed
signal hero_total_shield_changed
signal hero_heal
signal hero_hurt
signal hero_shield_full
signal hero_shield_depleted
signal hero_hp_changed
signal hero_total_hp_changed
signal hero_shield_changed
signal enemy_critical_landed
signal on_hero_left
signal wave_ended
signal all_waves_ended
signal upgrade_animation_started
signal upgrade_animation_finished
signal level_entered
signal level_exited
signal hero_shooted
signal hero_started_moving
signal hero_stopped_moving
signal on_wave_ended
signal on_enemy_hit_landed
signal enemy_death_started(enemy_global_position)
signal hero_started_shooting
signal hero_stopped_shooting
signal upgrade_duplicated(upgrade_duplicated)
signal hero_death_started
signal collectable_picked(collectable_name)
signal current_stacks_changed(value)

#var _hero: Hero setget _set_hero


func camera_shake_requested() -> void:
	emit_signal("camera_shake_requested")


#func _set_hero(new_hero) -> void:
#	_hero = new_hero

	
func _on_hero_hurt(final_damage) -> void:
	emit_signal("hero_hurt", final_damage)


func _on_hero_heal() -> void:
	emit_signal("hero_heal")


func _on_hero_hp_changed() -> void:
	emit_signal("hero_hp_changed")


func _on_hero_total_hp_changed() -> void:
	emit_signal("hero_total_hp_changed")


func _on_hero_shield_changed() -> void:
	emit_signal("hero_shield_changed")


func _on_hero_total_shield_changed() -> void:
	emit_signal("hero_total_shield_changed")


func _on_hero_shield_depleted():
	emit_signal("hero_shield_depleted")


func _on_hero_shield_full() -> void:
	emit_signal("hero_shield_full")


func _on_enemy_critical_landed(critical_value) -> void:
	emit_signal("enemy_critical_landed")


func _on_enemy_died():
	emit_signal("enemy_died")


func _on_object_destroyed():
	emit_signal("object_destroyed")


func _on_wave_spawner_wave_ended(): 
	emit_signal("wave_ended")


func _on_wave_spawner_all_waves_ended():
	emit_signal("all_waves_ended")


func _on_hero_left() -> void:
	emit_signal("on_hero_left")


func upgrade_animation_finished() -> void:
	emit_signal("upgrade_animation_finished")


func upgrade_animation_started() -> void:
	emit_signal("upgrade_animation_started")


func _on_level_entered() -> void:
	emit_signal("level_entered")


func _on_level_exited() -> void:
	emit_signal("level_exited")


func _on_hero_shooted() -> void:
	emit_signal("hero_shooted")


func _on_hero_started_moving() -> void:
	emit_signal("hero_started_moving")


func _on_hero_stopped_moving() -> void:
	emit_signal("hero_stopped_moving")


func _on_wave_ended() -> void:
	emit_signal("on_wave_ended")


func _on_enemy_hit_landed() -> void:
	emit_signal("on_enemy_hit_landed")


func _on_enemy_death_started(enemy_global_position) -> void:
	emit_signal("enemy_death_started", enemy_global_position)


func _on_hero_started_shooting() -> void:
	emit_signal("hero_started_shooting")


func _on_hero_stopped_shooting() -> void:
	emit_signal("hero_stopped_shooting")


func _on_upgrade_duplicated(upgrade_duplicated) -> void:
	emit_signal("upgrade_duplicated", upgrade_duplicated)


func disconnect_all_signals() -> void:
	var signals = get_signal_list()
	for cur_signal in signals:
		var coons = get_signal_connection_list(cur_signal.name);
		for cur_coon in coons:
			print("signal = " , cur_coon.signal)
			print("target = " , cur_coon.target)
			print("method = " , cur_coon.method)
			disconnect(cur_coon.signal, cur_coon.target, cur_coon.method)


func _on_hero_death_started() -> void:
	emit_signal("hero_death_started")


func on_upgrade_activated(upgrade) -> void:
	emit_signal("upgrade_activated", upgrade)


func _on_collectable_picked(collectable_name) -> void:
	emit_signal("collectable_picked", collectable_name)


func _on_collectable_request(this_position) -> void:
	emit_signal("_on_collectable_request", this_position)


func _on_warning_ended() -> void:
	emit_signal("warning_ended")


func _on_transition_ended() -> void:
	emit_signal("transition_ended")


func _on_hero_entered_level(object, key) -> void:
	emit_signal("hero_entered_level")

func player_can_enter() -> void:
	emit_signal("player_can_enter")


func _on_current_stacks_changed(value) -> void:
	emit_signal("current_stacks_changed", value)
