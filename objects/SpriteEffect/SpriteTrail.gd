extends Node2D

func _ready():
	set_as_toplevel(true)
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
