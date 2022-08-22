extends State

export var max_shoots: = 4
var shoot_count := 0
export var shoot_cooldown: = 0.35

func unhandled_input(event):
	return


func physics_process(delta):
	if aim_handler(delta) and _state_machine._timer.is_stopped():
		character.weapon.shoot()
		shoot_count += 1
		start_timer(shoot_cooldown)
	if shoot_count >= max_shoots:
		_state_machine.transition_without_delay("Walk")
		shoot_count = 0


func enter(msg: Dictionary = {}) -> void:
	pass


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_to("Shoot")


func aim_handler(delta) -> bool:
	var can_shoot = false
	var angle_delta = _state_machine.character._rotation_speed * delta

	var v = _state_machine.character.wave.hero.global_position - _state_machine.character.global_position
#		var v = character.target.global_position - character.global_position
	var angle = v.angle()
	var ideal_angle = angle
	var r = _state_machine.character.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	_state_machine.character.global_rotation = angle
	
	var difference = abs(abs(character.global_rotation) - abs(ideal_angle))
	if difference <= 0.0009:
		can_shoot = true
	
	return can_shoot

#
#
##	character.global_rotation = ideal_angle
#	var difference = abs(abs(character.global_rotation) - abs(ideal_angle))
##	if is_equal_approx(character.global_rotation,  ideal_angle):
#	if difference < 0.0009:
#		return true
#	return false
#
