extends Node2D
class_name ShieldSource

var array_of_status_names: Array
var shield_nova
export var projectile_scene: PackedScene
export var shield_reaction: PackedScene
var character


func add_status(status_name: String) -> void:
	array_of_status_names.append(status_name)


func Nova() -> void:
	shield_nova = projectile_scene.instance() 
	var shield_nova_hitbox = shield_nova.get_node("HitBoxArea2D")
	shield_nova_hitbox.damage_source = self
	shield_nova_hitbox.team = 0
	add_child(shield_nova)
	shield_nova.set_as_toplevel(true)
	shield_nova.global_position = self.global_position


func _input(event):
	if event.is_action("test_input_2"):
#		Nova()
		_emit_shield_reaction()

func _emit_shield_reaction() -> void:
	var instanced_shield_reaction: Node2D = shield_reaction.instance()
	add_child(instanced_shield_reaction)
#	instanced_shield_reaction.look_at(character._hurt_box.last_hit_position)
	instanced_shield_reaction.look_at(get_global_mouse_position())
	instanced_shield_reaction.set_global_position(self.global_position)



