extends RayCast2D
class_name AntecipationRayCast2D

signal color_changed

var line_activated: bool = false setget set_line_activated
onready var _line_2d: Line2D = $Line2D
onready var _red_line_2d: Line2D = $RedLine2D
onready var _tween: Tween = $Tween
export var width_of_the_line: int = 3
export var duration_of_the_animation:float = 1


func _ready():
	set_process(false)
	_reset_lines()
	_line_2d.set_as_toplevel(true)
	set_line_activated(true)


func set_line_activated(value) -> void:
	line_activated = value
	set_process(line_activated)
	if !line_activated:
		_reset_lines()
	else:
		_reset_lines()
		_tween_first_line()


func _reset_lines() -> void:
	_line_2d.clear_points()
	_line_2d.width = 0
	_line_2d.default_color = Color(0.30,0.30,0.30,0.40)


func _draw_line()	-> void:
	_line_2d.clear_points()
	var destiny_position = (get_collision_point())
	_line_2d.add_point(self.global_position)
	_line_2d.add_point(destiny_position)


#func _input(event):
#	if event.is_action_pressed("click"):
#		self.line_activated = !line_activated


func _tween_first_line() -> void:
	_tween.stop_all()
	_tween.interpolate_property(_line_2d, "width", 0, width_of_the_line, duration_of_the_animation, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()


func _process(delta):
	_draw_line()


func _change_color() -> void:
	$AnimationPlayer.play("change_color_to_red")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "change_color_to_red":
		emit_signal("color_changed")
