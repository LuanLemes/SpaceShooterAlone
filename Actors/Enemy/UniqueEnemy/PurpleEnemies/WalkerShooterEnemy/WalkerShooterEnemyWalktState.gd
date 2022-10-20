extends State

var path = []
export var minimum_distance: float = 16.0
export var stinger_sprite_path: NodePath
var stinger_sprite: AnimatedSprite
var stored_target_position: Vector2
export var threshold: int =1
var target_location: Vector2
onready var line2d: Line2D = $Line2D


func _ready():
	set_process(false)


func unhandled_input(event):
	return


func physics_process(delta):
	move_along_path()
	rotate(delta)


func enter(msg: Dictionary = {}) -> void:
	max_wait = 2
	min_wait = 2
	set_new_random_path()


func exit() -> void:
#	stinger_sprite.visible = false
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_without_delay("RotateAndShoot")


func move_along_path() -> void:
	if !path.size() > 0:
		set_new_random_path()
		return
		
	if character.global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		character.direction = character.global_position.direction_to(path[0])
		character.velocity = character.direction * character.speed
		character.velocity = character.move_and_slide(character.velocity)


func set_path() -> void:
	var value : PoolVector2Array
	value = character.wave.navigation_2d.get_simple_path(character.position,
	character.wave.get_random_walkable_cell_location(), false)
	if value.size() == 0:
		return
	path = PoolVector2Array()
	path = value
	path.remove(0)
	if path:
		set_process(true)
	start_timer()
	line2d.points = path


func set_new_random_path() -> void:
	var value : PoolVector2Array
	target_location = character.wave.get_random_walkable_cell_location()
	value = character.wave.navigation_2d.get_simple_path(character.position,
	target_location, false)
	if value.size() == 0:
		return
	path = PoolVector2Array()
	path = value
	path.remove(0)
	if path:
		set_process(true)
	start_timer()
	line2d.points = path


func rotate(delta) -> void:
	var angle_delta = character._rotation_speed * delta

#		var v = character.target.global_position - character.global_position
	var angle = character.direction.angle()
	var r = character.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	character.global_rotation = angle

#func initialize() -> void:
#	stinger_sprite = get_node(stinger_sprite_path)

#extends State
#
#
#func unhandled_input(event):
#	return
#
#
#func physics_process(delta):
#	aim_handler(delta)
#
#
#func enter(msg: Dictionary = {}) -> void:
#	start_timer()
#
#
#func exit() -> void:
#	return
#
#
#func _on_timer_timeout() -> void:
#	_state_machine.transition_to("Walk")
#
#
#func aim_handler(delta) -> void:
#	var angle_delta = _state_machine.character._rotation_speed * delta
#
#	var v = _state_machine.character.wave.hero.global_position - _state_machine.character.global_position
##		var v = character.target.global_position - character.global_position
#	var angle = v.angle()
#	var r = _state_machine.character.global_rotation
#	angle = lerp_angle(r, angle, 1)
#	angle = clamp(angle, r - angle_delta, r + angle_delta)
#	_state_machine.character.global_rotation = angle
