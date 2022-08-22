extends Node
class_name HeroStateMachine

signal state_entered(state_name)


export var initial_state: = NodePath()

onready var state = get_node(initial_state) setget set_state
onready var _state_name = state.name
onready var _timer: Timer = $State_Machine_Timer
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var character 


func set_character(new_character) -> void:
	character = new_character
	insert_properties_on_states()
	state.enter()

func _init() -> void:
	add_to_group("state_machine")


func _ready():
	rng.randomize()
	_timer.connect("timeout", self, "_on_timer_timeout")


func insert_properties_on_states() -> void:
	for state in get_children():
		if ! "_state_machine" in state:
			continue
		state._state_machine = self
		state.character = self.character
		


func set_state(new_state) -> void:
	state = new_state
	_state_name = state.name


func _physics_process(delta):
	state.physics_process(delta)


func transition_to(target_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		return
	var target_state: = get_node(target_state_path)
	
	
	state.exit()
	_timer.stop()
	self.state = target_state
	state.enter(msg)
	emit_signal("state_entered", state.name)
	


func _on_timer_timeout() -> void:
	state._on_timer_timeout()



