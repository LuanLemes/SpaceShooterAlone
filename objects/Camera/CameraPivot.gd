extends KinematicBody2D

export var path_of_node: NodePath
export var speed: int = 700
var direction = Vector2.ZERO
var node_to_follow
var velocity = Vector2.ZERO
export var distance_threshold: = 34

func _ready():
	set_physics_process(false)
	node_to_follow = get_node(path_of_node)
	set_physics_process(true)


func _physics_process(delta):
	if self.position.distance_to(node_to_follow.position) < distance_threshold:
		return
	direction =  (node_to_follow.position - self.position).normalized()
	velocity = speed * direction
	move_and_slide(velocity)
