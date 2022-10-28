extends CanvasLayer

onready var touch_button = $TouchScreenButton
signal use_move_vector
var first_tutch

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if touch_button.is_pressed():
			print(event.position)
			emit_signal("use_move_vector", calculate_move_vector(event.position))

func calculate_move_vector(event_position):
	var texture_center = touch_button.position + Vector2(70,70) 
	return (event_position - texture_center).normalized()
	

func position_to_point(touched_at: Vector2) -> void:
