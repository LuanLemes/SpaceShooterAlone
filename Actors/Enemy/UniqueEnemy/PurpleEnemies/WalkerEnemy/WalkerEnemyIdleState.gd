extends State


func _ready():
	pass

func unhandled_input(event):
	return


func physics_process(delta):
	pass

func enter(msg: Dictionary = {}) -> void:
	min_wait = 3
	max_wait = 5
	start_timer()


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_to("Walk")
