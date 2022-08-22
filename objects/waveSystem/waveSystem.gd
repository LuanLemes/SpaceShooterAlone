extends Node2D

signal wave_ended
signal all_waves_ended

onready var spawner = $Spawner

export var play_on_wave_ended: bool = false
export var play_on_all_waves_ended: bool = false
export var delay_between_waves: int = 1


func _ready():
	spawner.connect("all_waves_ended", self, "_on_spawner_all_waves_ended")
	spawner.connect("wave_ended", self, "_on_spawner_wave_ended")


func _on_spawner_all_waves_ended() -> void:
	emit_signal("all_waves_ended")


func _on_spawner_wave_ended() -> void:
	emit_signal("wave_ended")
