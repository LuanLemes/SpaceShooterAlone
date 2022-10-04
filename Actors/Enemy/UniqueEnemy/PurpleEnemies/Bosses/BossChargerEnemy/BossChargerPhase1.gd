extends State


var path_ended: bool = false

export var death_particle: PackedScene


func unhandled_input(event):
	return


func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	character.number_of_charges_left = 4
	character.aim_time = 0.7
	start_timer(1)
	


func exit() -> void:
	pass


func _on_timer_timeout() -> void:
	_state_machine.transition_without_delay("Idle")

