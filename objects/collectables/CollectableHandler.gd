extends Node2D
class_name CollectableHandler
signal collectable_collected
signal all_effects_unexecuted
#wiil handler  handler and contain all the effects

onready var all_effects: Node2D = $AllEffects
onready var active_effects: Node2D = $ActiveCollectableEffectsContainer
onready var all_collectables: Node2D = $AllCollectables
onready var active_collectables: Node2D = $ActiveCollectablesContainer
onready var _timer: Timer = $Timer
export var instance_collectable_chance: int = 100
var speed_modifier = 50
var heal_modifier = 1
var cooldown_modifier = 0.10
var effect_duration: int = 3
var is_heal_modifier: bool = true
var is_weapon_cooldown_modifier: bool = true
var max_stacks:int = 9
var current_stacks: int = 0

onready var hero: Hero = HeroManager.hero

func _ready():
	_timer.wait_time = effect_duration
	SignalManager.connect("collectable_picked", self, "_on_collectable_picked")
	SignalManager.connect("enemy_death_started", self, "_on_enemy_death_started")


func stack_effect_start() -> void:
	if current_stacks >= max_stacks:
		_timer.start()
		return
	current_stacks+= 1
	_timer.start()
	if is_heal_modifier:
		hero.get_heal(heal_modifier)
	if is_weapon_cooldown_modifier:
		hero.hero_weapon.bonus_cooldown += cooldown_modifier


func stack_effect_end() -> void:
	if current_stacks >= max_stacks:
		pass
	if current_stacks == 0:
		return
	if current_stacks > 1:
		_timer.start()
	current_stacks -= 1
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
	active_collectables.add_child(collectable_instanced)
	collectable_instanced.initialize()


func _on_enemy_death_started(enemy_global_position) -> void:
	spawn_colectable("Blue", enemy_global_position)


func _unexecute_all() -> void:
	for i in range(current_stacks):
		stack_effect_end()


func _on_Timer_timeout():
	stack_effect_end()
