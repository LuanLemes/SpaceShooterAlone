extends State


export var death_particle: PackedScene


func unhandled_input(event):
	return


func physics_process(delta):
	aim_handler(delta)


func enter(msg: Dictionary = {}) -> void:
	start_timer(character.aim_time)


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_without_delay("PathShoot")


func aim_handler(delta) -> void:
	var can_shoot = false
	var angle_delta = _state_machine.character._rotation_speed * delta

	var v = character.down_location.global_position  - _state_machine.character.global_position
#		var v = character.target.global_position - character.global_position
	var angle = v.angle()
	var ideal_angle = angle
	var r = _state_machine.character.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	_state_machine.character.global_rotation = angle
