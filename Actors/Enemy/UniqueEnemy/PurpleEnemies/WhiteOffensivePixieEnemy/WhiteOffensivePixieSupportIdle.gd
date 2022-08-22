extends State
export var shoot_cooldown: float = 1
export var max_shoots: float = 2
var shoot_count = 0
var round_count = 0
func _ready():
	max_wait = 5
	min_wait = 4


func unhandled_input(event):
	return


func physics_process(delta):
	pass
#	aim_handler(delta)
#	shoot()
	


func enter(msg: Dictionary = {}) -> void:
	round_count = 0
	shoot()


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	shoot()
#	shoot_count = 0


func shoot() -> void:
	if round_count >= 10:
		for n in 9:
			character.weapon.shoot()
			round_count = 0
			start_timer(shoot_cooldown)
		return
	character.weapon.shoot()
	start_timer(shoot_cooldown)
	round_count += 1


func aim_handler(delta) -> void:
	var target_node = character.weapon
	var angle_delta = _state_machine.character._rotation_speed * delta

	var v = _state_machine.character.wave.hero.global_position - target_node.global_position
#		var v = character.target.global_position - character.global_position
	var angle = v.angle()
	var r = target_node.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	target_node.global_rotation = angle
