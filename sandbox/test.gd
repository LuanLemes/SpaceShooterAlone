extends RayCast2D

onready var label : Label  = $Label

func _physics_process(delta):

	if is_colliding():
		var collider = get_collider()
		if get_collider() is Enemy:
			label.text = "enemy"
		else:
			label.text = "not enemy"
		add_exception(collider)
		collider.set_modulate(154)


func _input(event):
	if event.is_action_pressed("click"):
		look_at(get_global_mouse_position())
		rotation_degrees -= 90
