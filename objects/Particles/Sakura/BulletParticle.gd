extends Particles2D
class_name BulletParticles

var this_global_position
onready var timer: Timer = $Timer


func _ready():
	timer.wait_time = lifetime


func destroy_after_time() -> void:
	emitting = false
	timer.start()


func destroy_explosion_after_time() -> void:
	set_as_toplevel(true)
	self.global_position = this_global_position
	emitting = true
	if timer:
		timer.start()
	else: queue_free()


func _on_Timer_timeout():
	queue_free()


