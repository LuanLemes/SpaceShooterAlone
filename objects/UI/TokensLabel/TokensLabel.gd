extends Node2D


var max_tokens: int setget _set_max_tokens
var current_tokens: int setget _set_current_tokens
onready var _label: Label = $Label


func _set_max_tokens(value) -> void:
	max_tokens = value
	update_tokens()


func _set_current_tokens(value) -> void:
	current_tokens = value
	update_tokens()

func update_tokens() -> void:
	_label.text = String(current_tokens)


func _on_token_count_changed(value) -> void:
	self.current_tokens = value
