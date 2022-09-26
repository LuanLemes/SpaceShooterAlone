extends State



func unhandled_input(event):
	return


func enter(msg: Dictionary = {}) -> void:
	start_timer()


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_to("Shoot")
