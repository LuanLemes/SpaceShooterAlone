extends Control

signal restart_button_pressed

func _ready():
	SignalManager.connect("hero_death_started", self, "_on_hero_death_started")


func _on_hero_death_started() -> void:
	yield(get_tree().create_timer(1.7), "timeout")
	self.visible = true


func _on_Button2_pressed():
	emit_signal("restart_button_pressed")



