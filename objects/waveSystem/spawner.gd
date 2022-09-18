extends Node2D


signal wave_ended
signal all_waves_ended
signal object_destroyed
signal hero_left

export var market_scene: PackedScene
export var scene_to_spawn1: PackedScene
export var location_number: int = 1

onready var spawned = $Spawned

var is_special_level = false
var path_to_waves: = ""  
var all_waves
var wave_to_spawn: = 0
var folder_number: = 1
var spawned_wave
var level_label: String

func _ready():
	connect("wave_ended", SignalManager, "_on_wave_spawner_wave_ended")
	connect("all_waves_ended", SignalManager, "_on_wave_spawner_all_waves_ended")
	set_path_to_waves()


func _on_wave_ended() -> void:
	emit_signal("wave_ended")
	if spawned.get_child_count() == 0:
		emit_signal("all_waves_ended")


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			
			files.append(file)
	dir.list_dir_end()

	return files


func set_path_to_waves() -> void:
	path_to_waves = "res://objects/waveSystem/waves/Level" + String(folder_number) + "/"
	all_waves = list_files_in_directory(path_to_waves)
	wave_to_spawn = 0


func instance_next_wave() -> void:
	is_special_level = false
	if !wave_to_spawn < all_waves.size():
		instance_next_wave_folder()
		return
	var scene_to_spawn = load(path_to_waves + all_waves[wave_to_spawn])
	spawned_wave = scene_to_spawn.instance()
	add_child(spawned_wave)
	wave_to_spawn += 1
	_connect_signals()


func instance_next_wave_folder() -> void:
	folder_number += 1
	set_path_to_waves()
	instance_next_wave()


func delete_last_wave() -> void:
	if spawned_wave == null:
		return
	spawned_wave.destroy()
	_disconnect_signals()
	spawned_wave = null


func _input(event):
	if event.is_action_pressed("test_input_2"):
		delete_last_wave()
		instance_next_wave()


func _connect_signals() -> void:
	spawned_wave.connect("wave_ended", self, "_on_wave_ended")
	spawned_wave.connect("hero_left", self, "_on_wave_hero_left")


func _disconnect_signals() -> void:
	spawned_wave.disconnect("wave_ended", self, "_on_wave_ended")
	spawned_wave.disconnect("hero_left", self, "_on_wave_hero_left")


func open_wave_front_door() -> void:
	spawned_wave.open_one_exit_door()


func _on_wave_hero_left() -> void:
	emit_signal("hero_left")


func call_next_wave() -> void:
	delete_last_wave()
	instance_next_wave()


func call_market() -> void:
	level_label = "The Flame"
	is_special_level = true
	delete_last_wave()
	spawned_wave = market_scene.instance()
	add_child(spawned_wave)
	_connect_signals()
	


