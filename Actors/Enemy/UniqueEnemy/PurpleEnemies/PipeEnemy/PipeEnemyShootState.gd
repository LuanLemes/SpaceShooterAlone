extends State



onready var _animation_player: AnimationPlayer = $AnimationPlayer
var stored_target_position: Vector2


func _ready():
	_animation_player.connect("animation_finished", self, "_on_animation_player_animation_finished")


func unhandled_input(event):
	return


func physics_process(delta):
	return


func enter(msg: Dictionary = {}) -> void:
	_animation_player.play("Shoot")


func exit() -> void:
	_animation_player.stop()


func _on_timer_timeout() -> void:
	pass

func shoot() -> void:
	_state_machine.character.weapon.shoot()


func _on_animation_player_animation_finished(anim_name):
	_state_machine.transition_to("Idle")
