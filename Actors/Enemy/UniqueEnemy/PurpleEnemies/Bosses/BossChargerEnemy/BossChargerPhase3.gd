extends State


var path_ended: bool = false
var just_turned: bool = false

export var death_particle: PackedScene





func physics_process(delta):
	aim_handler(delta)


func enter(msg: Dictionary = {}) -> void:
	character.number_of_charges_left = 5
	character.number_of_shoots = 2
	character.aim_time = 0.4
	if just_turned == false:
		character.path_follow_speed *=1.1
		just_turned = true
	character.shine()


func exit() -> void:
	pass


func aim_handler(delta) -> void:
	var angle_delta = _state_machine.character._rotation_speed * delta

	var v = _state_machine.character.wave.hero.global_position - _state_machine.character.global_position
#		var v = character.target.global_position - character.global_position
	var angle = v.angle()
	var r = _state_machine.character.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	_state_machine.character.global_rotation = angle


func initialize() -> void:
	character.entrance_animation_player.connect("animation_finished", self, "_on_shine_animation_finished")


func _on_shine_animation_finished(animation_name) -> void:
	if !_state_machine.state == self:
		return
	if animation_name == "ShineEntrance":
		_state_machine.transition_without_delay("Idle")


