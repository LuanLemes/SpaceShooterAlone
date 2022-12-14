extends State

signal hero_started_moving
signal hero_stopped_moving

func _ready():
	connect("hero_started_moving", SignalManager, "_on_hero_started_moving")
	connect("hero_stopped_moving", SignalManager, "_on_hero_stopped_moving")





func physics_process(delta):
	character.hero_movement_handler.move()
	character.hero_movement_handler.rotate_to_movement(delta)
	if character.hero_movement_handler.direction == Vector2.ZERO:
		_state_machine.transition_without_delay("Idle")
	if character.hero_movement_handler.is_pressing_dash and character.dashs_left > 0:
		_state_machine.transition_without_delay("Dash")
		

func enter(msg: Dictionary = {}) -> void:
	emit_signal("hero_started_moving")


func exit() -> void:
	emit_signal("hero_stopped_moving")


func _on_timer_timeout() -> void:
	return
