extends VBoxContainer


onready var this_state_label: Label = $ThisHBoxContainer/Name
onready var last_state_label: Label = $LastHBoxContainer2/LastName
var this_state_name = "" setget set_this_state_name


func set_this_state_name(value: String) -> void:
	var last_state_name = this_state_name
	last_state_label.text = last_state_name
	
	this_state_name = value
	this_state_label.text = this_state_name


func _on_StateMachine_state_entered(state_name):
	set_this_state_name(state_name)
