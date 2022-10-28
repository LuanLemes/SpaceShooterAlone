extends State


func _ready():
	max_wait = 2
	min_wait = 1





func physics_process(delta):
#	character.move_and_slide(Vector2(1,90))
	pass
	


func enter(msg: Dictionary = {}) -> void:
	start_timer()


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_without_delay("ChooseHost")
