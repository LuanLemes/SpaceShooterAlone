extends CameraShaker

onready var left_checker: RayCast2D = $raycasts_container/Left
onready var top_checker: RayCast2D = $raycasts_container/Up
onready var bottom_checker: RayCast2D = $raycasts_container/Down
onready var right_checker: RayCast2D = $raycasts_container/Right
onready var raycasts_container: Node2D = $raycasts_container
onready var remote_transform: RemoteTransform2D = $RemoteTransform2D
export var camera_threshold: int = 300
export var ray_distance: int = 30000
export var minimum_distance: int = 450
export var lerp_speed: float = 0.01

var collision_left
var collision_right
var collision_top
var collision_bottom

onready var ideal_limit_left: int = limit_left
onready var ideal_limit_right: int = limit_right
onready var ideal_limit_top: int = limit_top
onready var ideal_limit_bottom: int = limit_bottom

onready var screen_size = get_viewport().size * zoom *0.7 + Vector2(camera_threshold, camera_threshold)

func _ready():
	set_physics_process(true)
	initialize_threhsolds()


func initialize_threhsolds() -> void:
	left_checker.cast_to = Vector2(-ray_distance, 0)
	right_checker.cast_to = Vector2(ray_distance, 0)
	top_checker.cast_to = Vector2(0, -ray_distance)
	bottom_checker.cast_to = Vector2(0, ray_distance)
	raycasts_container.set_as_toplevel(true)



func _physics_process(delta):
	define_threshold_positions()
	threshold_positions()




func threshold_positions() -> void:
	limit_left = lerp(limit_left, ideal_limit_left, lerp_speed)
	limit_right = lerp(limit_right, ideal_limit_right, lerp_speed)
#	limit_top = lerp(limit_top, ideal_limit_top, lerp_speed)
#	limit_bottom = lerp(limit_bottom, ideal_limit_bottom, lerp_speed)




func define_threshold_positions() -> void:
#	bottom_checker.force_raycast_update()
#	top_checker.force_raycast_update()
#	left_checker.force_raycast_update()
#	right_checker.force_raycast_update()
	collision_bottom = bottom_checker.get_collision_point().y
	collision_top = top_checker.get_collision_point().y 
	collision_left = left_checker.get_collision_point().x
	collision_right = right_checker.get_collision_point().x


	if collision_right - collision_left < minimum_distance:
		reset_horizontal_checkers()
	else:
		if left_checker.is_colliding():
			ideal_limit_left = clamp(collision_left - camera_threshold,  global_position.x - screen_size.x, global_position.x + screen_size.x )
			
			
		if right_checker.is_colliding():
			ideal_limit_right =  clamp(collision_right + camera_threshold,  global_position.x - screen_size.x, global_position.x + screen_size.x )


	if collision_bottom - collision_top < minimum_distance:
		reset_vertical_checkers()
	else:
		if top_checker.is_colliding():
			ideal_limit_top = collision_top - camera_threshold

		if bottom_checker.is_colliding():
			ideal_limit_bottom =  collision_bottom + camera_threshold



func reset_horizontal_checkers():
	ideal_limit_left = -10000000
	ideal_limit_right = 10000000

func reset_vertical_checkers():
	ideal_limit_top = -10000000
	ideal_limit_bottom = 10000000

