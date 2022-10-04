extends State


var path_ended: bool = false
var curve2d: Curve2D = Curve2D.new()
export var death_particle: PackedScene


func unhandled_input(event):
	return


func physics_process(delta):
	if path_ended == true:
		return
	if character.path_follow.unit_offset == 1:
			yield(get_tree().create_timer(10),"timeout")
			_state_machine.transition_without_delay("RotateToDirection")
			return
	character.path_follow.offset += character.path_follow_speed
	character.global_position = character.path_follow.global_position
	character.global_rotation = character.path_follow.global_rotation


func enter(msg: Dictionary = {}) -> void:
	yield(SignalManager, "warning_ended")
	character.can_be_damaged = false
	curve2d.add_point(character.global_position)
	curve2d.add_point(Vector2(540,500))
	character.path.curve = curve2d.duplicate()
	character.path_follow.unit_offset = 0


func exit() -> void:
	curve2d.clear_points()
	character.path_follow.unit_offset = 0
	character.can_be_damaged = true


func _on_timer_timeout() -> void:
	pass


func initialize() -> void:
#	SignalManager.connect("warning_ended", self, "_on_warning_ended")
	pass
	

func _on_warning_ended() -> void:
	pass
