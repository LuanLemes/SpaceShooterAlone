extends State
signal hero_started_dashing
signal hero_stopped_dashing

onready var timer: = $Timer
export var dash_duration: float = 0.15
export var sprite_trail: PackedScene
var initial_position: Vector2
var _bonus_rotation_speed = 77
var _checker: float
var is_inside_wall: bool = false setget set_is_inside_wall
func _ready():
	timer.connect("timeout", self, "_on_dash_timeout")


func unhandled_input(event):
	return


func physics_process(delta):
	self.is_inside_wall = character.check_if_is_in_wall()
	_spawn_trail()
	character.hero_movement_handler.dash()
#	character.hero_movement_handler.fast_rotate_to_movement()


func enter(msg: Dictionary = {}) -> void:
	character.hero_movement_handler.fast_rotate_to_movement()
	_checker = character.check_if_can_wall_dash()
	print(_checker)
	if _checker == -1:
		dash_duration = 0.15
		pass
	else:
		_checker +=1
		dash_duration = (0.2) + (_checker * 0.012)
		character.set_collision_mask_bit(1, 0)

	
	character._hurt_box.set_deferred("monitorable", false)
	character._dash_timer.start()
#	character._dash_particles.emitting = true
#	character.hero_movement_handler._rotation_speed += _bonus_rotation_speed
	character.hero_movement_handler.update_direction_inputs = false
	emit_signal("hero_started_dashing")
	initial_position = character.global_position
#	timer.start(dash_duration)
#	start_timer(dash_duration)
	print("dash_duration_is" , String(dash_duration))
	_state_machine._timer.start(dash_duration)


func _on_dash_timeout() -> void:
	pass


func exit() -> void:
	dash_duration = 0.15
	is_inside_wall = false
	character.set_collision_mask_bit(1, 1)
	print(initial_position.distance_to(character.global_position))
	character._hurt_box.set_deferred("monitorable", true)
	character.hero_movement_handler.update_direction_inputs = true
#	character.hero_movement_handler._rotation_speed -= _bonus_rotation_speed
	emit_signal("hero_stopped_dashing")


func _on_timer_timeout() -> void:
	character.set_collision_mask_bit(1, 0)
	_state_machine.transition_without_delay("Idle")


func _spawn_trail() -> void:
	var new_sprite_trail: Node2D = sprite_trail.instance()
	character.add_child(new_sprite_trail)
	new_sprite_trail.global_position = character.global_position
	new_sprite_trail.global_rotation = character.global_rotation


func set_is_inside_wall(value) -> void:
	if is_inside_wall == true and value == false:
		is_inside_wall = value
		_state_machine.transition_without_delay("Idle")
		_state_machine._timer.stop()
		return
	is_inside_wall = value
