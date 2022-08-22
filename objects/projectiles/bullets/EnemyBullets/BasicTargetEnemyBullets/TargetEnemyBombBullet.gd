extends KinematicBody2D
class_name TargetEnemyBullet


export var explosion_particle_scene : PackedScene
onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _target_sprite = $AntecipationTargetAnimation
onready var _hit_box : HitBoxArea2D = $HitBoxArea2D
onready var _collision_shape: = $HitBoxArea2D/CollisionShape2D
onready var _sprite := $Sprite


func explode() -> void:
	_target_sprite.visible = false
	_sprite.visible = false
	SignalManager.camera_shake_requested()
	instance_explosion_particle()
	$HitBoxArea2D/CollisionShape2D.disabled = false
	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()


#func set_direction(new_direction) -> void:
#	direction = new_direction
#	velocity = direction * speed


func _on_VisibilityNotifier2D_screen_exited():
	pass


func _on_HitBoxArea2D_hit_applied():
	pass


func instance_explosion_particle() -> void:
	var particle = explosion_particle_scene.instance()
	particle.this_global_position = self.global_position
	particle.modulate = $Sprite.modulate
	get_parent().add_child(particle)
	particle.destroy_explosion_after_time()


func _on_AnimationPlayer_animation_finished(anim_name):
	pass


func _set_target_sprite(target_location):
	_target_sprite.set_as_toplevel(true)
	_target_sprite.global_position = target_location - Vector2(0,0)
	_target_sprite.visible = true


