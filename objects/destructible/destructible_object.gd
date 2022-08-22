extends Node2D

signal destroyed

func destroy() -> void:
	emit_signal("destroyed")
	queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		destroy()
