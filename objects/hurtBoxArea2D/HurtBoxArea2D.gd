extends Area2D
class_name HurtBoxArea2D

signal hit_landed(damage)
signal healed_by_value(heal_value)
signal healed_by_percent(heal_percent_value)
signal missed
signal critical_landed(critical_value)

enum Teams{PLAYER, ENEMY}
export (Teams) var team:= Teams.ENEMY
#armor
var total_armor:= 0
export var base_armor: = 0
var bonus_armor = 0 setget set_bonus_armor
var bonus_percent_armor = 0 setget set_bonus_percent_armor
var is_miss: bool = false
var miss_chance: int = 0
var rng := RandomNumberGenerator.new()
var character: Node2D 
onready var status = $Status
onready var pop_label_spawner := $PopLabelSpawner2D
var last_hit_position: Vector2 = Vector2.ZERO
var is_active: bool = true setget set_is_active
var damage_reduction:float = 0

func _ready():
	rng.randomize()


func get_hurt(hit: Hit) -> void:
	if damage_reduction != 0:
		hit.damage = hit.damage - (damage_reduction/100 * hit.damage)
	last_hit_position = hit.hit_position
	var is_critical = is_critical(hit.critical_chance)
	if is_critical:
		hit.damage = round(hit.damage * 2.5)
		emit_signal("critical_landed", hit.damage)
	var final_damage := clamp((hit.damage - total_armor),1,10000)
	pop_label_spawner.spawn(hit.color_of_the_pop_label, String(final_damage), is_critical)
	emit_signal("hit_landed", final_damage)


func set_bonus_armor(value) -> void:
	bonus_armor += value
	set_total_armor()


func set_bonus_percent_armor(value) -> void:
	bonus_percent_armor += value
	set_total_armor()


func set_total_armor() -> void:
	var new_total_armor = base_armor + bonus_armor
	new_total_armor = new_total_armor + (new_total_armor/100 * bonus_percent_armor)
	total_armor = new_total_armor


func is_miss(damage: int) -> bool:
#	return false
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randi_range(0, 100) < miss_chance:
		emit_signal("missed")
		return true
	else:
		return false
	
	
func is_critical(critical_chance: int) -> bool:
	if critical_chance > rng.randi_range(0, 99):
		return true
	else:
		return false


func set_is_active(value) -> void:
	is_active = value
	if is_active == true:
		return
	for child in self.get_children():
		child.queue_free()
















