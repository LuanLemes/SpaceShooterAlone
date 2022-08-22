extends Sprite


var x = 0

func _input(event):
	if event.is_action_pressed("move_up"):
		x += 1
		print(x)
