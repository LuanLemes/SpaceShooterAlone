extends State


var path_ended: bool = false
var shooted: bool = false
export var death_particle: PackedScene



func physics_process(delta):
	if path_ended == true:
		return
	if character.path_follow.unit_offset == 1:
		if character.number_of_charges_left <= 0:
			_state_machine.transition_without_delay("Phase" + String(character.phase))
			return
		else:
			_state_machine.transition_without_delay("Aim")
			return
	character.path_follow.offset += character.path_follow_speed
	character.global_position = character.path_follow.global_position
	character.global_rotation = character.path_follow.global_rotation
	if character.tokens_to_spawn > 0 and character.path_follow.unit_offset >= 0.3:
		SignalManager.emit_signal("_on_collectable_request", character.global_position)
		character.tokens_to_spawn -= 1
	if character.path_follow.unit_offset >= 0.4 and shooted == false:
		shooted = true
		if character._shoot_on_charge:
			for i in character.number_of_shoots:
				character.weapon.shoot()

func enter(msg: Dictionary = {}) -> void:
	shooted = false
	character.number_of_charges_left -= 1
	character.path_follow.unit_offset = 0


func exit() -> void:
	if character._shoot_on_charge:
		for i in character.number_of_shoots:
			character.weapon.shoot()
	character.path_follow.unit_offset = 0


func _on_timer_timeout() -> void:
	pass

