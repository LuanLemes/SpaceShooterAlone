extends State



onready var _animation_player: AnimationPlayer = $AnimationPlayer
var stored_target_position: Vector2
var shoot_animation_name: String = "Shoot"

func _ready():
	_animation_player.connect("animation_finished", self, "_on_animation_player_animation_finished")
	max_wait = 1
	min_wait = 1
	if DifficultParameters.shoot_more:
		shoot_animation_name = "ShootUpgrade"


func unhandled_input(event):
	return


func physics_process(delta):
	return


func enter(msg: Dictionary = {}) -> void:
	_animation_player.play(shoot_animation_name)


func exit() -> void:
	_animation_player.stop(true)


func shoot() -> void:
	_state_machine.character.weapon.shoot()


func _on_animation_player_animation_finished(anim_name):
	_state_machine.transition_to("Idle")
