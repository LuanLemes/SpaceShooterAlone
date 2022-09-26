extends Path2D
class_name HazardPath

var moving_foward: bool setget set_moving_foward
onready var path_follow: PathFollow2D = $PathFollow
onready var _path_2d: Path2D = $Path2D
onready var _point_a: Position2D = $PointA
onready var _point_b: Position2D = $PointB
export  var hazard_speed: float = 100
onready var center_line: Line2D = $CenterLine
onready var second_line: Line2D = $SecondLine
onready var third_line: Line2D = $ThirdLine
onready var hazard: HazardFollow = $PathFollow.get_child(0)
onready var ref_sprite1: Sprite = $PointB/icon
onready var ref_sprite2: Sprite = $PointA/icon2



func _ready(): 
	ref_sprite1.visible = false
	ref_sprite2.visible = false
	print(hazard)
	var point_a_true_global_position = _point_a.global_position - self.global_position
	var point_b_true_global_position = _point_b.global_position - self.global_position
	curve = Curve2D.new()
	curve.clear_points()
	center_line.add_point(point_a_true_global_position)
	second_line.add_point(point_a_true_global_position)
	third_line.add_point(point_a_true_global_position)
	center_line.add_point(point_b_true_global_position)
	second_line.add_point(point_b_true_global_position)
	third_line.add_point(point_b_true_global_position)
	curve.add_point(point_a_true_global_position)
	curve.add_point(point_b_true_global_position)


func _physics_process(delta):
	move_hazard(delta)
#	path_follow.offset += hazard_speed 

func move_hazard(delta) -> void:
	if moving_foward:
		if path_follow.unit_offset == 1:
			self.moving_foward = false
			return
		path_follow.offset += hazard_speed * delta
	else:
		if path_follow.unit_offset == 0:
			self.moving_foward = true
			return
		path_follow.offset -= hazard_speed * delta


func set_moving_foward(value) -> void:
	moving_foward = value
#	if moving_foward == true:
#		hazard.is_foward = true
#	else: 
#		hazard.is_foward = false
