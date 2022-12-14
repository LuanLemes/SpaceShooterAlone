extends State

export var weapon_cannon_path: NodePath
var weapon_cannon
var number_of_shoots = 3


func _ready():
	if DifficultParameters.shoot_more:
		number_of_shoots += 4
	min_wait = 2
	max_wait = 2




func physics_process(delta):
	aim_handler(delta)
	

func enter(msg: Dictionary = {}) -> void:
	start_timer(0.5)


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	for i in number_of_shoots:
		if is_the_state_machine_state():
			yield(get_tree().create_timer(0.3), "timeout")
			_state_machine.character.weapon.shoot()
		else: 
			return
		
	if is_the_state_machine_state():
		_state_machine.transition_to("Walk")
	

func aim_handler(delta) -> void:
	var angle_delta = 5 * delta

	var v = character.wave.hero.global_position - character.weapon.global_position
	var angle = v.angle()
	var r = character.weapon.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	character.weapon.global_rotation = angle


func initialize() -> void:
	weapon_cannon = get_node(weapon_cannon_path)
