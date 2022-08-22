extends State


func unhandled_input(event):
	return


func physics_process(delta):
	if character.hero_movement_handler.direction != Vector2.ZERO:
		_state_machine.transition_to("Move")
	if character.target != null and is_instance_valid(character.target):
		_state_machine.transition_to("RotateAndShoot")


func enter(msg: Dictionary = {}) -> void:
	return


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	return
