extends Node2D


onready var left_button := $ButtonLeft/Button
onready var middle_button := $ButtonMiddle/Button
onready var rightest_button := $ButtonRight/Button


func _ready():
	_button_pivot_offset(left_button, 0)
	_button_pivot_offset(middle_button, 0.5)
	_button_pivot_offset(rightest_button, 1)


func _button_pivot_offset(button: Button, offset: float) -> void:
	button.rect_pivot_offset.x = button.rect_size.x * offset
	button.rect_pivot_offset.y = button.rect_size.y 
