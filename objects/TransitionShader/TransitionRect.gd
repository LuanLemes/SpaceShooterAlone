extends ColorRect
class_name TransitionRect

signal transition_ended

onready var animation_player : AnimationPlayer = $AnimationPlayer

func transition_in() -> void:
	animation_player.play("transition_in")

func transition_out() -> void:
	animation_player.play("transition_out")



func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("transition_ended")
