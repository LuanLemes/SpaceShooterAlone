extends Node2D
class_name PopLabel

onready var _tween := $Node/Tween

export var final_critical_scale: int = 0.5
export var final_scale: int = 0.2
export (Vector2) var fading_position_offset:= Vector2.ZERO
export var critical_fading_position_offset := Vector2.ZERO
export var duration_in_seconds :float = 0.5
onready var label: Label = $Node/Label
onready var remote_transform: RemoteTransform2D = $RemoteTransform2D
onready var reference_node: Node2D = $Node
var position_reference




	


func _physics_process(delta):
	global_rotation = 0
	

func pop() -> void:
	_tween.interpolate_property(self, "scale", scale, scale * final_scale, duration_in_seconds, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	_tween.start()


func move() -> void:
	if Rng.rng.randi_range(0,10) % 2 == 0:
		fading_position_offset.x = fading_position_offset.x * -1
	_tween.interpolate_property(self, "position", position, position + fading_position_offset, duration_in_seconds,Tween.TRANS_BACK, Tween.EASE_IN)
	_tween.start()


func tween_normal() -> void:
	pop()
	move()


func tween_critical() -> void:
	pop_critical()
	move_critical()


func pop_critical() -> void:
	_tween.interpolate_property(self, "scale", scale, scale * final_critical_scale, duration_in_seconds, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	_tween.start()


func move_critical() -> void:
	if self.get_instance_id() % 2 != 0:
		critical_fading_position_offset.x = critical_fading_position_offset.x * -1
	_tween.interpolate_property(self, "position", position, position + critical_fading_position_offset, duration_in_seconds,Tween.TRANS_BACK, Tween.EASE_IN)
	_tween.start()


func _on_Tween_tween_all_completed():
	queue_free()









