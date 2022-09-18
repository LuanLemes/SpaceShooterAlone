extends Node2D
class_name HeroMovementHandler


signal stopped

var is_pressing_dash: bool = false
var update_direction_inputs: bool = true
var character setget set_character
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var speed_improve_modifier = 140
export var dash_speed = 1500
export var base_speed: float = 300
export var _rotation_speed: = 10

var up: = Vector2.ZERO

var bonus_speed: float = 0 setget set_bonus_speed
var final_speed = 0

var screen_size


func set_character(new_character):
	character = new_character
	screen_size = character.get_viewport_rect().size
	set_physics_process(true)


func _ready():
	set_final_speed()
	set_physics_process(false)


func _physics_process(delta):
	update_direction()
	update_velocity()
	clamp_position()


func set_final_speed() -> void:
	final_speed = base_speed + bonus_speed


func set_bonus_speed(value) -> void:
	bonus_speed = value
	set_final_speed()


func rotate_to_target(delta) -> bool:
	var angle_delta = _rotation_speed * delta
	
	if !is_instance_valid(character.target):
		character.update_target()
		return false

	var v = character.target.global_position - character.global_position
	var angle: float = v.angle()
	var ideal_angle: float = angle
	var r: float = character.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	character.global_rotation = angle
	var x = (character.global_rotation - angle)
#	if x < 0.01:
#		character.global_rotation = ideal_angle
	var character_rotation = character.global_rotation
	
	
#	character.global_rotation = ideal_angle
	var difference = abs(abs(character.global_rotation) - abs(ideal_angle))
#	if is_equal_approx(character.global_rotation,  ideal_angle):
	if difference < 0.0009:
		return true
	return false


func rotate_to_movement(delta) -> void:
	var angle_delta = _rotation_speed * delta
	var angle = velocity.angle()
	angle = lerp_angle(character.global_rotation, angle, 1)
	angle = clamp(angle, character.global_rotation - angle_delta, character.global_rotation + angle_delta)
	character.global_rotation = angle

func fast_rotate_to_movement() -> void:
#	var angle_delta = _rotation_speed * delta
	var angle = velocity.angle()
#	angle = lerp_angle(character.global_rotation, angle, 1)
#	angle = clamp(angle, character.global_rotation - angle_delta, character.global_rotation + angle_delta)
	character.global_rotation = angle


func update_direction() -> void:
	if !update_direction_inputs:
		return
	var old_direction = direction
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()
	if old_direction != Vector2.ZERO and direction == Vector2.ZERO:
		emit_signal("stopped")


func update_velocity() -> void:
	velocity = direction * final_speed


func move() -> void:
	if velocity != Vector2.ZERO:
		character.move_and_slide(velocity, up)


func dash() -> void:
	if velocity != Vector2.ZERO:
		character.move_and_slide(direction * dash_speed, up)


func clamp_position() -> void:
#	character.position.x = clamp(character.position.x, 0, screen_size.x)
#	character.position.y = clamp(character.position.y, -300, screen_size.y)
	pass


func improve_speed() -> void:
	self.base_speed += speed_improve_modifier 
	speed_improve_modifier = speed_improve_modifier - float(speed_improve_modifier)/100 * 28


func _input(event):
	
	is_pressing_dash = event.is_action_pressed("dash") 
