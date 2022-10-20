extends KinematicBody2D
class_name GuidedMissle

onready var hit_box: HitBoxArea2D = $HitBoxArea2D2
onready var sprite: Sprite = $Sprite
onready var front_particle: Particles2D = $Particles2D
onready var explosion_particle: Particles2D = $Particles2D2


var velocity: Vector2
var speed: float = 1340
var direction: Vector2
var rotation_speed = 10
var target: Enemy setget set_target
var aim: bool = false

func _ready():
	find_target() 

func set_target(new_target) -> void:
	target = new_target
#	target.connect("death_started", self, "find_target")
#	set_physics_process(true)


func aim_handler(delta) -> void:
	if !aim:
		return
	if target == null or !is_instance_valid(target):
		find_target()
		return
	var angle_delta = rotation_speed * delta

	var v = target.global_position - global_position
#		var v = character.target.global_position - character.global_position
	var angle = v.angle()
	var r = global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	global_rotation = angle


func _physics_process(delta):
	aim_handler(delta)
	move_and_slide(Vector2.RIGHT.rotated(global_rotation)* speed)


func _on_time_before_start_timeout():
	aim = true


func destroy() -> void:
	set_physics_process(false)
	front_particle.emitting = true
	explosion_particle.emitting = true
	sprite.visible = false
	yield(get_tree().create_timer(front_particle.lifetime+0.1), "timeout")
	queue_free()


func _on_HitBoxArea2D2_hit_applied():
	destroy()


func find_target() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() <= 0:
		destroy()
		return
	self.target = enemies[Rng.rng.randf_range(0, enemies.size())]
	


