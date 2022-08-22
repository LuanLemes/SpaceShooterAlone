extends State


var path = []
export var minimum_distance: float = 16.0
var stored_target_position: Vector2
export var threshold: int =1
var location
var course = null
var course_points: Array
export var courses_container_path: NodePath
var all_courses
var next_index = 0
var can_move = true

func _ready():
	max_wait = 0.1
	min_wait = 0.1
	set_process(false)


func unhandled_input(event):
	return


func physics_process(delta):
	move_along_path()
	rotate(delta)


func enter(msg: Dictionary = {}) -> void:
	can_move = true
	course_handler()


func course_handler() -> void:
	if course == null:
		chosse_new_course()
	if next_index >= course_points.size():
		chosse_new_course()
	location = course_points[next_index].global_position
	set_path(location)
	next_index += 1


func chosse_new_course() -> void:
	course = all_courses[_state_machine.rng.randi_range(0, all_courses.size() -1)]
	course_points = course.get_children()
	next_index = 0


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	set_path(location)


func on_location_arrived() -> void:
	can_move = false
	_state_machine.transition_to("RotateAndShoot")


func move_along_path() -> void:
	if !can_move:
		return
	if !path.size() > 0:
		on_location_arrived()
		return
		
	if character.global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	
	if character.global_position.distance_to(path[0]) < 64:
		path.remove(0)
		
	else:
		character.direction = character.global_position.direction_to(path[0])
		character.velocity = character.direction * character.speed
		character.velocity = character.move_and_slide(character.velocity)


func set_path(arrive_location) -> void:
	var value : PoolVector2Array
	value = character.wave.navigation_2d.get_simple_path(character.position,
	arrive_location, false)
	if value.size() == 0:
		return
	path = PoolVector2Array()
	path = value
	path.remove(0)
	if path:
		set_process(true)
#	start_timer()


func rotate(delta) -> void:
	var angle_delta = character._rotation_speed * delta
#		var v = character.target.global_position - character.global_position
	var angle = character.direction.angle()
	var r = character.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	character.global_rotation = angle


func initialize() -> void:
	all_courses = get_node(courses_container_path).get_children()
