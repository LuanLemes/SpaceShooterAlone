extends State







func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	start_timer()


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_without_delay("Rotate")





