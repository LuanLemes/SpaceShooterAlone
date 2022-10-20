extends Node2D
class_name LabelUI

var _hero
onready var label: Label = $Label
onready var tween: Tween = $Tween
onready var timer: Timer = $Timer
var label_value: int setget set_label_value
export var duration: float = 2.5
export var value_change_duration: float = 0.5


func _ready():
	timer.connect("timeout", self, "on_timer_time_out")
	timer.wait_time = duration*2


func set_label_value(new_label_value) -> void:
	label_value = new_label_value
	label.text =  String(label_value) + "/" + String(_hero._total_hp)


func tween_label_value(new_value) -> void:
	appear()
	tween.interpolate_property(self, "label_value", self.label_value, new_value, value_change_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT )
	tween.start()


func appear() -> void:
	timer.start()
	tween.interpolate_property(self, "modulate", self.modulate, Color(1,1,1,1), duration/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func disappear() -> void:
	tween.interpolate_property(self, "modulate", self.modulate, Color(1,1,1,0), duration/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func on_timer_time_out() -> void:
	if SingletonManager.hero._hp > SingletonManager.hero._total_hp/2:
		disappear()


