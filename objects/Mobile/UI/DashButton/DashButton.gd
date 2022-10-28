extends TouchScreenButton


signal dash_request

func _ready():
	connect("dash_request", SignalManager, "_dash_requested")

#func _input(event):
#	if event is InputEventScreenTouch or event is InputEventScreenDrag:
#	else:


func _on_DashButton_pressed():
	SingletonManager.hero.hero_movement_handler.mobile_dash_input = true
	pass # Replace with function body.


func _on_DashButton_released():
	SingletonManager.hero.hero_movement_handler.mobile_dash_input = false
