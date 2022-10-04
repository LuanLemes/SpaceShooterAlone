extends State


func unhandled_input(event):
	return


func physics_process(delta):
	pass


func _ready():
	pass


func enter(msg: Dictionary = {}) -> void:
	_state_machine.transition_without_delay("Move")


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_to("Aim")
