extends State


var path_ended: bool = false
var curve2d: Curve2D = Curve2D.new()


func unhandled_input(event):
	return


func physics_process(delta):
	if path_ended == true:
		return
	if character.path_follow.unit_offset == 1:
			path_ended = true
			character.shine()
			character.show_health()
			return
	character.path_follow.offset += character.path_follow_speed/4
	character.global_position = character.path_follow.global_position
	character.global_rotation = character.path_follow.global_rotation


func enter(msg: Dictionary = {}) -> void:
	character.trail.visible = false
	character.can_be_damaged = false
	curve2d.add_point(character.point5.global_position)
	curve2d.add_point(character.point6.global_position)
	character.path.curve = curve2d.duplicate()
	character.path_follow.unit_offset = 0
	

func exit() -> void:
	character.add_to_group("enemies")
	character.can_be_damaged = true
	character.trail.visible = true
	curve2d.clear_points()
	character.path.curve.clear_points()
	character.path_follow.unit_offset = 0
	character.can_be_damaged = true
	path_ended = false
	SingletonManager.hero.is_active = true


func _on_timer_timeout() -> void:
	pass


func initialize() -> void:
	character.entrance_animation_player.connect("animation_finished", self, "_on_shine_animation_finished")



func _on_shine_animation_finished(animation_name) -> void:
	if !_state_machine.state == self:
		return
	if animation_name == "ShineEntrance":
		_state_machine.transition_without_delay("Phase1")


