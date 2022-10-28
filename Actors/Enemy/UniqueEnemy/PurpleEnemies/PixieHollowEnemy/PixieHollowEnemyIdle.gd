extends State

func _ready():
	pass





func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	_state_machine.transition_without_delay("Charge")


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	pass

