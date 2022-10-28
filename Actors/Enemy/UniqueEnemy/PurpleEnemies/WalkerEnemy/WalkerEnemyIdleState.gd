extends State


func _ready():
	pass




func physics_process(delta):
	pass

func enter(msg: Dictionary = {}) -> void:
	start_timer()


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_to("Walk")
