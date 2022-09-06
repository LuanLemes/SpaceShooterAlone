extends Node
class_name CollectableEffect

onready var _timer: Timer = $Timer
export var duration: int = 1
var hero: Hero
# will trigger the collectable effect for some time and then it will queue free


func _ready():
	_timer.wait_time = duration
	SignalManager


func _execute() -> void:
	pass
	
	
func _unexecute() -> void:
	pass


func _on_Timer_timeout():
	pass


func initialize() -> void:
	_execute()
	
