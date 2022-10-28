extends TouchScreenButton

signal use_move_vector
var toutching: bool = false
var vector_radius = Vector2(shape.radius, shape.radius)
var input_index

func _ready():
	var x = OS.get_name()
	connect("use_move_vector", SignalManager, "_use_move_vector")


func _input(event):

	if  event is InputEventScreenTouch and toutching != true:
		if !is_same_index(event.index):
			return
		print("click_touched")
		toutching = true
		global_position = event.position - Vector2(shape.radius, shape.radius)
		input_index = event.index


	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if !is_same_index(event.index):
			return
		if is_pressed():
#			print(calculate_move_vector(event.position))
			emit_signal("use_move_vector", calculate_move_vector(event.position))


func calculate_move_vector(event_position):
	var texture_center = position + vector_radius
	return (event_position - texture_center).normalized()



func _on_TouchScreenButton_released():
	print("sig release")
	emit_signal("use_move_vector", Vector2.ZERO)
	global_position = Vector2(540, 1622) - vector_radius
	toutching = false


func _on_TouchScreenButton_pressed():
	print("sig pressed")
	toutching = true

func is_same_index(this_index) -> bool:
#	return this_index == input_index
	
	return this_index == 0

