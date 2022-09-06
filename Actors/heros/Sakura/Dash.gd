extends State
signal hero_started_dashing
signal hero_stopped_dashing

onready var timer: = $Timer
export var dash_duration: float = 0.2
export var sprite_trail: PackedScene
var initial_position: Vector2
var _bonus_rotation_speed = 77
func _ready():
	timer.connect("timeout", self, "_on_dash_timeout")


func unhandled_input(event):
	return


func physics_process(delta):
	_spawn_trail()
	character.hero_movement_handler.dash()
	character.hero_movement_handler.rotate_to_movement(delta)


func enter(msg: Dictionary = {}) -> void:
	character._dash_timer.start()
#	character._dash_particles.emitting = true
	character.hero_movement_handler._rotation_speed += _bonus_rotation_speed
	character.hero_movement_handler.update_direction_inputs = false
	character.hero_movement_handler
	emit_signal("hero_started_dashing")
	initial_position = character.global_position
	timer.start(dash_duration)


func _on_dash_timeout() -> void:
	_state_machine.transition_without_delay("Move")


func exit() -> void:
#	character._dash_particles.emitting = false
	character.hero_movement_handler.update_direction_inputs = true
	character.hero_movement_handler._rotation_speed -= _bonus_rotation_speed
	emit_signal("hero_stopped_dashing")


func _on_timer_timeout() -> void:
	exit()


func _spawn_trail() -> void:
	var new_sprite_trail: Node2D = sprite_trail.instance()
	character.add_child(new_sprite_trail)
	new_sprite_trail.global_position = character.global_position
	new_sprite_trail.global_rotation = character.global_rotation
















