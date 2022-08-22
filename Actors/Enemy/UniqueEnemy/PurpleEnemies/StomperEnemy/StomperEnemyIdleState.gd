extends State

var path = []
export var minimum_distance: float = 16.0

var stored_target_position: Vector2
export var threshold: int =1

func _ready():
	max_wait = 1
	min_wait = 1
	set_process(false)


func unhandled_input(event):
	return


func physics_process(delta):
	character.move_and_collide(character.velocity)


func enter(msg: Dictionary = {}) -> void:
	character.direction = Vector2()


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	pass


func rotate(delta) -> void:
	var angle_delta = character._rotation_speed * delta
#		var v = character.target.global_position - character.global_position
	var angle = character.direction.angle()
	var r = character.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	character.global_rotation = angle
