extends Node2D

onready var sprite = $Sprite
var sprite_global_rotation
func _ready():
	set_process(false)
	sprite.global_position = self.global_position

	
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _process(delta):
	sprite.global_position = self.global_position
	sprite.global_rotation = sprite_global_rotation


func set_global_position(value) -> void:
	global_position = value
	sprite_global_rotation = sprite.global_rotation
	sprite.set_as_toplevel(true)
	set_process(true)
	
