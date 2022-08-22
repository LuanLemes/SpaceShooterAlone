extends State


onready var _antecipation_ray_cast: AntecipationRayCast2D
onready var _laser_beam
var _is_rotating: bool = true
export var time_before_shoot:float = 0.3


func _ready():
	max_wait = 1
	min_wait = 1
	

func unhandled_input(event):
	return


func physics_process(delta):
	aim(delta)
#	_antecipation_ray_cast.global_rotation = character.weapon.global_rotation
#	_antecipation_ray_cast.rotation_degrees -= 90
#	_antecipation_ray_cast.global_position = character.hero_detector.global_position


func enter(msg: Dictionary = {}) -> void:
	_is_rotating = true
	_antecipation_ray_cast.line_activated = true
	start_timer()


func exit() -> void:
	_antecipation_ray_cast.line_activated = false
	_is_rotating = false
	

func _on_timer_timeout() -> void:
	_is_rotating = false
	_state_machine.call_next_action(time_before_shoot)



func aim(delta) -> void:
	if !_is_rotating:
		return
	var angle_delta = character._rotation_speed * delta

	var v = character.wave.hero.global_position - character.weapon.global_position
	var angle = v.angle() 
	var r = character.weapon.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	character.weapon.global_rotation = angle


func initialize() -> void:
	_laser_beam = character._laser_beam
	_antecipation_ray_cast = character._antecipation_ray_cast
	

func next_action() -> void:
	_laser_beam.is_casting = true
	_state_machine.transition_to("Shoot")
