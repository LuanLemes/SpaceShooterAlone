extends KinematicBody2D
class_name EnemyNova


export var damage: = 10
onready var hitbox_2d = $HitBoxArea2D


func explode() -> void:
	





func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_AnimatedSprite2_animation_finished():
		queue_free()
