extends State


func _ready():
	max_wait = 5
	min_wait = 4





func physics_process(delta):
#	character.move_and_slide(Vector2(1,90))
	pass
	


func enter(msg: Dictionary = {}) -> void:
	pass


func exit() -> void:
	return


func _on_timer_timeout() -> void:
	_state_machine.transition_to("ChooseHost")
