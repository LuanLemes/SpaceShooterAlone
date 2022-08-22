extends KinematicBody2D
class_name PipeBullet

export var speed: = 10
var velocity: = Vector2.RIGHT * speed
var direction setget set_direction

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		queue_free()

func explode() -> void:
	queue_free()


func set_direction(new_direction) -> void:
	direction = new_direction
	velocity = direction * speed



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
