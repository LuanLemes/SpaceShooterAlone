extends Sprite

onready var line_2d: Line2D = $RayCast2D/Line2D
#var step = 


#func _physics_process(delta):
#	look_at(get_global_mouse_position())
#	rotation_degrees += 90


func _draw_line()	-> void:
	
	line_2d.add_point(get_global_mouse_position())
#	while line_2d.

func _input(event):
	if event.is_action_pressed("click"):
		_draw_line()
