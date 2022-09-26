extends State



onready var _animation_player: AnimationPlayer = $AnimationPlayer
var stored_target_position: Vector2


func _ready():
	max_wait = 1
	min_wait = 2


func unhandled_input(event):
	return


func physics_process(delta):
	return


func enter(msg: Dictionary = {}) -> void:
	character.weapon.shoot_at_target(character.wave.hero.global_position)
	next_action()
	_state_machine.transition_to("Idle")


func exit() -> void:
	pass
#	_animation_player.stop(true)


func shoot() -> void:
	_state_machine.character.weapon.shoot()


func next_action() -> void:
	_state_machine.transition_to("Idle")
	
