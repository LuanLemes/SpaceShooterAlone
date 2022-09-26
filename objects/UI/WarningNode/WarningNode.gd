extends Node2D

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("click"):
		appear()


func appear() -> void:
	animation_player.play("Appear")


