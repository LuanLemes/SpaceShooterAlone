extends State

export var death_particle: PackedScene




func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	_state_machine.transition_without_delay(_state_machine._next_state)


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	pass
