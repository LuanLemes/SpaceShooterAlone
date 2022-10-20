extends State


export var death_particle: PackedScene


func unhandled_input(event):
	return


func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	character.set_collision_layer_bit(2, 0)
	character.emit_signal("death_started",character.global_position)
	character.activated = false
	character.support_control.visible = false
	character.enemy_area.set_deferred("monitoring", false)
	character.weapon.set_deferred("monitoring", false)
	character.hurt_box.is_active = false
	var spawned_death_particle = death_particle.instance()
	spawned_death_particle.global_position = character.global_position
	spawned_death_particle.global_rotation = character.global_rotation
	character.animated_sprite.visible = false
	if character.weapon:
		character.weapon.visible = false
	add_child(spawned_death_particle)
	spawned_death_particle.emitting = true
	character.set_is_player_target(false)
	character.remove_from_group("enemies")
	character.emit_signal("camera_shake_requested")
	max_wait = spawned_death_particle.lifetime +1
	min_wait = spawned_death_particle.lifetime +1
	start_timer()
	

func exit() -> void:
	return


func _on_timer_timeout() -> void:
	character.emit_signal("died")
	character.queue_free()
