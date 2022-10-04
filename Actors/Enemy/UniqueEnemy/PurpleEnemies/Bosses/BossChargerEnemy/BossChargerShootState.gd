extends State


onready var _animation_player: AnimationPlayer = $AnimationPlayer
var stored_target_position: Vector2
var shoot_animation_name: String = "Shoot"
export var path_bullet: PackedScene
var array_of_points: Array
var curve: Curve2D = Curve2D.new()


func _ready():
	pass


func unhandled_input(event):
	pass


#func physics_process(delta):
#	character.global_position = character.path.global_position
#	character.global_rotation = character.global_rotation


func enter(msg: Dictionary = {}) -> void:
	instance_path_bullet()
#	_animation_player.play(shoot_animation_name)


func exit() -> void:
	curve.clear_points()


func shoot() -> void:
	pass


func instance_path_bullet():
	array_of_points.clear()
	var instanced_bullet = path_bullet.instance()
	instanced_bullet.direction = Vector2.RIGHT.rotated(character.global_rotation)
	instanced_bullet.global_position = character.global_position
	instanced_bullet.connect("point_defined", self, "on_point_defined")
	instanced_bullet.connect("path_ended", self, "on_path_ended")
	add_child(instanced_bullet)


func on_point_defined(point: Vector2) -> void:
	curve.add_point(point)
	character.line2d.add_point(point)


func on_path_ended() -> void:
	character.path.curve = curve.duplicate()
	_state_machine.transition_without_delay("Charge")

