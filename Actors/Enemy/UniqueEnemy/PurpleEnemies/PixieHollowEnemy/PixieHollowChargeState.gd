extends State


func _ready():
	pass


func unhandled_input(event):
	return


func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	character.animation_player1.play("Charge")


func exit() -> void:
	character.animation_player1.stop()


func _on_timer_timeout() -> void:
	character.animation_player1.stop()


func on_charge_animation_finished(animation_name) -> void:
	if _state_machine.state != self:
		return
	if animation_name == "Charge":
		_state_machine.transition_without_delay("InstanceEnemy")


func initialize() -> void:
	character.animation_player1.connect("animation_finished", self, "on_charge_animation_finished")
