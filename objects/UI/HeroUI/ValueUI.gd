extends Node2D
class_name LabelUI


onready var label: Label = $Label
onready var tween: Tween = $Tween
onready var timer: Timer = $Timer
var label_value: int setget set_label_value
#var active: bool setget set_active
export var duration: float = 0.3

func _ready():
	timer.connect("timeout", self, "on_timer_time_out")
	timer.wait_time = duration*2


func set_label_value(new_label_value) -> void:
	label_value = new_label_value
	label.text = String(label_value)


func tween_label_value(new_value) -> void:
	appear()
	tween.interpolate_property(self, "label_value", self.label_value, new_value, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT )
	tween.start()


func _input(event):
	if event.is_action_pressed("test_input_1"):
		tween_label_value(label_value + 10)
	if event.is_action_pressed("test_input_2"):
		appear()
	if event.is_action_pressed("test_input_3"):
		disappear()


func appear() -> void:
	timer.start()
	tween.interpolate_property(self, "modulate", self.modulate, Color(1,1,1,1), duration/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func disappear() -> void:
	tween.interpolate_property(self, "modulate", self.modulate, Color(1,1,1,0), duration/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


#func set_active(new_state) -> void:
#	active = new_state
#
#	if active == false:
#		disappear()
#		return
#
#	if active == true:
#		appear()
#		timer.start()
#		return


func on_timer_time_out() -> void:
	disappear()


