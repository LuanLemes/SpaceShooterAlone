extends Node2D

export var node_to_spawn: PackedScene


func instance_sound(name_of_sound) -> void:
	var selected_sound: AudioStream = get_node(name_of_sound).stream
	var instanced_scene: AudioStreamPlayer = node_to_spawn.instance()
	instanced_scene.stream = selected_sound
	add_child(instanced_scene)
	instanced_scene.play()
