extends KinematicBody2D
signal point_defined(point)
signal path_ended


var direction: Vector2 = Vector2(1,1)
export var speed = 520
var velocity: Vector2
onready var line2d: Line2D = $Line2D
var bounces: int = 0
var max_bounces: int = 1
var last_point: int = 0


func _ready():
	velocity = direction * speed
	line2d.set_as_toplevel(true)
	line2d.add_point(self.global_position)
	line2d.add_point(self.global_position)
	last_point += 1
	emit_signal("point_defined", global_position)


func _physics_process(delta):
	var collision_info = move_and_collide(velocity)
	line2d.set_point_position(last_point, global_position)
	if collision_info:
		bounce(collision_info)


func bounce(collision_info) -> void:
	if bounces >= max_bounces:
		return
	
	bounces += 1
	
	last_point += 1
	line2d.add_point(self.global_position)
	emit_signal("point_defined", global_position)
	velocity = velocity.bounce(collision_info.normal)
	global_rotation = velocity.angle()
	if bounces == max_bounces:
		emit_signal("path_ended")
		queue_free()
