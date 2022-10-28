extends Node2D
class_name CollectableHandler
signal collectable_collected
signal all_effects_unexecuted
signal current_stacks_changed(current_stacks)
var is_last_one: bool = false
#wiil handler  handler and contain all the effects

onready var all_effects: Node2D = $AllEffects
onready var active_effects: Node2D = $ActiveCollectableEffectsContainer
onready var all_collectables: Node2D = $AllCollectables
onready var active_collectables: Node2D = $ActiveCollectablesContainer
onready var _timer: Timer = $Timer
export var instance_collectable_chance: int = 100
var speed_modifier = 50
var heal_modifier = 1
var cooldown_modifier: float = 0.07
var effect_duration: int = SingletonManager.stack_effect_duration
var is_heal_modifier: bool = true
var is_weapon_cooldown_modifier: bool = true
var max_stacks:int = SingletonManager.max_stacks
var current_stacks: int = 0 setget set_current_stacks
onready var hero: Hero = SingletonManager.hero


func _ready():
	connect("current_stacks_changed", SignalManager, "_on_current_stacks_changed")
	is_heal_modifier = DifficultParameters.wisper_heal
	_timer.wait_time = effect_duration
	SignalManager.connect("collectable_picked", self, "_on_collectable_picked")
	SignalManager.connect("enemy_death_started", self, "_on_enemy_death_started")
	SignalManager.connect("_on_collectable_request", self, "_on_collectable_request")


func stack_effect_start() -> void:
	_timer.start()
	if is_heal_modifier:
		hero.get_heal(heal_modifier)
	if current_stacks < max_stacks:
		if is_weapon_cooldown_modifier:
			hero.hero_weapon.bonus_cooldown += cooldown_modifier
	self.current_stacks+= 1


func stack_effect_end() -> void:
	if current_stacks >= max_stacks:
		pass
	if current_stacks == 0:
		return
	if current_stacks > 1:
		_timer.start()
	self.current_stacks -= 1
	if is_weapon_cooldown_modifier:
		hero.hero_weapon.bonus_cooldown -= cooldown_modifier


func _on_collectable_picked(collectable_name) -> void:
	stack_effect_start()
	emit_signal("collectable_collected")


func spawn_colectable(collectable_name: String, enemy_global_position) -> void:
	if Rng.rng.randi_range(0,100) > instance_collectable_chance:
		return
	var collectable_instanced = all_collectables.get_node(collectable_name + "Collectable").duplicate()
	all_collectables.remove_child(collectable_instanced)
	collectable_instanced.global_position = enemy_global_position
	if is_last_one:
		collectable_instanced._instant_pick()
	active_collectables.add_child(collectable_instanced)
	collectable_instanced.initialize()


func _on_enemy_death_started(enemy_global_position) -> void:
	spawn_colectable("Blue", enemy_global_position)


func _unexecute_all() -> void:
	for i in range(current_stacks):
		stack_effect_end()
	self.current_stacks = 0


func _on_Timer_timeout():
	stack_effect_end()


func _on_collectable_request(this_position) -> void:
		spawn_colectable("Blue", this_position)


func set_current_stacks(value) -> void:
	current_stacks = min(value, 3)
	emit_signal("current_stacks_changed", current_stacks)


func _input(event):
	if event.is_action_pressed("click"):
		for i in 1:
			spawn_colectable("Blue", get_global_mouse_position())
		


