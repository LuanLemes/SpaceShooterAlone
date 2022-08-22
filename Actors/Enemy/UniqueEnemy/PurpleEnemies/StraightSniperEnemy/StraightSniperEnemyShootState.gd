extends State

onready var _laser_beam: RayCast2D
onready var _damage_cooldown: Timer = $DamageCooldownTimer
var stored_target_position: Vector2
export var damage: = 5
export var cooldown_damage: = 0.4


func _ready():
	max_wait = 2.5
	min_wait = 3.0
	_damage_cooldown.wait_time = cooldown_damage


func unhandled_input(event):
	return


func physics_process(delta):
	damage_manager()


func enter(msg: Dictionary = {}) -> void:
	start_timer()


func exit() -> void:
	_laser_beam.is_casting = false


func _on_timer_timeout() -> void:
	_laser_beam.is_casting = false
	_state_machine.transition_to("Idle")


func initialize() -> void:
	_laser_beam = character._laser_beam


func damage_manager() -> void:
	if ! _damage_cooldown.is_stopped():
		return
	if ! _laser_beam.is_colliding():
		return
	var collider = _laser_beam.get_collider()
	if collider.is_in_group("heroes"):
		var this_hit: Hit = Hit.new()
		this_hit.constructor(damage, 0, Color.white, collider.global_position)
		collider._hurt_box.get_hurt(this_hit)
		_damage_cooldown.start()

