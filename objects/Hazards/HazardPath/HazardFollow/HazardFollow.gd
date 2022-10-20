extends Node2D
class_name HazardFollow


var is_foward: bool = true 
onready var container: Node2D = $Container
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var hazard_particles: Particles2D = $HazardParticles
onready var hit_box: HitBoxArea2D = $Container/HitBoxArea2D
var is_colliding: bool = false setget set_is_colliding
onready var timer: Timer = $Timer


func _ready():
	timer.connect("timeout", self, "on_timeout")
	hit_box.disconnect("area_entered", hit_box, "_on_HitBoxArea2D_area_entered")


func set_is_colliding(value) -> void:
	is_colliding = value


func apply_hit() -> void:
	if !timer.is_stopped() or !is_colliding:
		return
	for area in hit_box.get_overlapping_areas():
		hit_box.apply_hit(area)
	timer.start()


func on_timeout() -> void:
	apply_hit()


func _on_HitBoxArea2D_area_entered(area):
	hit_box.apply_hit(area)
	self.is_colliding = true
	hazard_particles.emitting = true
	animation_player.play("Shine")
	timer.start()


func _on_HitBoxArea2D_area_exited(area):
	if hit_box.get_overlapping_areas().size() == 0:
		self.is_colliding = false
		hazard_particles.emitting = false
		timer.start()
		timer.wait_time = timer.wait_time
		animation_player.play("BackToNormal")


