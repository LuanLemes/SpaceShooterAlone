extends State

export var death_particle: PackedScene

func unhandled_input(event):
	return


func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	start_timer()
#	print(_state_machine._timer.wait_time)


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_without_delay(_state_machine._next_state)
