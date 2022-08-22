extends State


func unhandled_input(event):
	return


func physics_process(delta):
	if ! is_instance_valid(character.target) or ! character.target:
		_state_machine.transition_to("Idle")
	if character.hero_movement_handler.rotate_to_target(delta):
		character.hero_weapon.shoot()
	if character.hero_movement_handler.direction != Vector2.ZERO:
		_state_machine.transition_to("Move")


func enter(msg: Dictionary = {}) -> void:
	character.emit_signal("started_shooting")


func exit() -> void:
	character.emit_signal("stopped_shooting")


func _on_timer_timeout() -> void:
	return
