extends State


var path_ended: bool = false
var just_turned: bool = false

export var death_particle: PackedScene


func unhandled_input(event):
	return


func physics_process(delta):
	aim_handler(delta)


func enter(msg: Dictionary = {}) -> void:
	character.number_of_charges_left = 4
	character.number_of_shoots = 0
	character.aim_time = 0.7
	start_timer(1)
	


func exit() -> void:
	pass


func _on_timer_timeout() -> void:
	_state_machine.transition_without_delay("Idle")


func aim_handler(delta) -> void:
	var angle_delta = _state_machine.character._rotation_speed * delta

	var v = _state_machine.character.wave.hero.global_position - _state_machine.character.global_position
#		var v = character.target.global_position - character.global_position
	var angle = v.angle()
	var r = _state_machine.character.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	_state_machine.character.global_rotation = angle
