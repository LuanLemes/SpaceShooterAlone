extends State





func physics_process(delta):
	pass


func _ready():
	pass


func enter(msg: Dictionary = {}) -> void:
	_state_machine.transition_without_delay("Aim")


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_to("Aim")
