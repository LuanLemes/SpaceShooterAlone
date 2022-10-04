extends Node2D
class_name BossWarning

signal warning_ended


onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	connect("warning_ended", SignalManager, "_on_warning_ended")


func appear() -> void:
	animation_player.play("Appear")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Appear":
		emit_signal("warning_ended")
