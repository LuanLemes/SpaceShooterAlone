extends Path2D


var start
var end

onready var line_2d = $Line2D
onready var tween :Tween = $Tween
onready var path_follow :PathFollow2D = $PathFollow2D
onready var projectile: Node2D = $PathFollow2D/BulletContainer.get_child(0)


export var time_variant = 10.0
export var gravity = -800.8
var num_of_points = 50.0
var total_time


func _ready():
	calculate_trajectory()


func calculate_trajectory() -> void:
	var points = []
	var DOT = Vector2(1,0).dot((end - start).normalized())
	var angle = 90 - 45 * DOT
	
	var x_dis = end.x - start.x
	var y_dis = -1.0 * (end.y - start.y)
	
	var speed = sqrt(((0.5 * gravity * x_dis * x_dis) / pow(cos(deg2rad(angle)), 2.0)) / (y_dis - (tan(deg2rad(angle)) * x_dis)))
	var x_component = (cos(deg2rad(angle)) *speed)
	var y_component = (sin(deg2rad(angle)) *speed)
	
#	var total_time = x_dis / x_component
	total_time = x_dis / x_component

	var curve2d : = Curve2D.new()
	
	for point in num_of_points:
		var time = total_time * (point / num_of_points)
		var dx = time * x_component
		var dy = -1.0 * (time * y_component + 0.5 * gravity * time * time)
		points.append( Vector2(dx,dy))
#		print(point)
#		line_2d.points = points
		curve2d.add_point( Vector2(dx,dy))
#	line_2d.points = points
	curve = curve2d
	spawn_path()


func spawn_path() -> void:
	tween.interpolate_property(path_follow, "unit_offset", 0.0, 1.0,total_time / time_variant, Tween.TRANS_QUAD, Tween.EASE_IN )
	projectile.set_as_toplevel(false)
	path_follow.unit_offset = 1
	projectile._set_target_sprite(path_follow.global_position)
#	projectile._set_target_sprite(end)
	path_follow.unit_offset = 0
	path_follow.visible = true
#	curve.get_point_count()
	tween.start()


func _on_Tween_tween_all_completed():
	if !is_instance_valid(projectile):
		return
	projectile.explode()
