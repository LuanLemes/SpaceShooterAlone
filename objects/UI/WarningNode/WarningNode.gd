extends Node2D
class_name BossWarning
signal warning_ended


onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("click"):
		appear()


func appear() -> void:
	animation_player.play("Appear")


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("warning_ended")
