extends Node2D


var max_tokens: int setget _set_max_tokens
var current_tokens: int setget _set_current_tokens
var max_stacks: int = SingletonManager.max_stacks
onready var _label: Label = $Label
onready var _label2: Label = $Label2


func _ready():
	SignalManager.connect("current_stacks_changed", self, "_set_current_stacks")


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


func _set_current_stacks(value) -> void:
	_label2.text = String(String(value) + "/" + String(max_stacks))







