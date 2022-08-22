extends State


onready var _antecipation_ray_cast: AntecipationRayCast2D = $AntecipationRayCast2D
var _is_rotating: bool = true
export var time_before_shoot:float = 0.1


func _ready():
	_antecipation_ray_cast.connect("color_changed", self, "_on_AntecipationRayCast2D_color_changed")
	max_wait = 1
	min_wait = 1
	

func unhandled_input(event):
	return


func physics_process(delta):
	aim(delta)
	_antecipation_ray_cast.global_rotation = character.global_rotation
	_antecipation_ray_cast.rotation_degrees -= 90
	_antecipation_ray_cast.global_position = character.hero_detector.global_position


func enter(msg: Dictionary = {}) -> void:
	_is_rotating = true
	_antecipation_ray_cast.line_activated = true
	start_timer()


func exit() -> void:
	_antecipation_ray_cast.line_activated = false	


func _on_timer_timeout() -> void:
	_is_rotating = false
	_antecipation_ray_cast._change_color()


#func _on_animation_player_animation_finished(anim_name):
#	_state_machine.transition_to("Idle")


func aim(delta) -> void:
	if !_is_rotating:
		return
	var angle_delta = _state_machine.character._rotation_speed * delta

	var v = _state_machine.character.wave.hero.global_position - _state_machine.character.global_position
#		var v = character.target.global_position - character.global_position
	var angle = v.angle()
	var r = _state_machine.character.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	_state_machine.character.global_rotation = angle


func _on_AntecipationRayCast2D_color_changed():
	yield(get_tree().create_timer(time_before_shoot), "timeout")
	_state_machine.transition_to("Shoot")
