extends Node2D
class_name HeroWeapon

signal hero_shooted

var array_of_status_names: Array
var spawned_projectile
export var projectile_scene: PackedScene
var character
export var total_cooldown_time: float
var base_cooldown: float = 0.30 setget set_base_cooldown
var bonus_cooldown: float = 0 setget set_bonus_cooldown
export var _base_damage: int = 25
var _total_damage: int = 2
var _bonus_damage = 0 setget set_bonus_damage
var _percent_bonus_damage = 0 setget set_percent_damage

var status_chance: float
var base_status_chance: float = 5
var bonus_status_chance: float = 0 setget set_bonus_status_chance
var percent_status_chance: float = 0 setget set_percent_status_chance

onready var cooldown_timer_node: Timer = $Cooldown
onready var front_cannons = $FrontCannons
onready var diagonal_cannons1 = $DiagonalCannons
onready var diagonal_cannons2 = $DiagonalCannons2
onready var rear_cannon = $RearCannon
onready var side_cannons = $SideCannons
onready var front_cannon = $FrontCannons
export var splash_path: NodePath

var cooldown_modifier = 0.34
var splash_animated_sprite
var max_enemies_bounces : = 0 setget set_max_enemies_bounces
var max_wall_bounces : = 0 setget set_wall_bounces
var max_number_of_hits: = 4
var all_cannons: Array
var last_front_cannon: int = 0
export var base_critical_chance: float = 10
var bonus_critical_chance: float = 0 setget set_bonus_critical
var percent_critical_chance: float = 0 setget set_percent_critical
var total_critical_chance: float 
var is_special_bullet: bool = false

func set_bonus_critical(new_value) -> void:
	bonus_critical_chance = new_value
	update_total_critical_chance()


func set_percent_critical(new_value) -> void:
	percent_critical_chance = new_value
	update_total_critical_chance()


func update_total_critical_chance() -> void:
	var real_percent_critical_chance = percent_critical_chance / 100 * (bonus_critical_chance + base_critical_chance)
	total_critical_chance = bonus_critical_chance + base_critical_chance + real_percent_critical_chance


func _ready():
	update_status_chance()
	splash_animated_sprite = get_node(splash_path)
	update_total_damage()
	update_total_cooldown()
	add_front_cannon()
	self.connect("hero_shooted", SignalManager, "_on_hero_shooted")
	update_total_critical_chance()


func add_front_cannon() -> void:
	var cannons_to_add = front_cannon.get_children()
	for cannon in cannons_to_add:
		all_cannons.append(cannon)


func add_diagonal_cannons1() -> void:
	var cannons_to_add = diagonal_cannons1.get_children()
	for cannon in cannons_to_add:
		all_cannons.append(cannon)


func add_diagonal_cannons2() -> void:
	var cannons_to_add = diagonal_cannons2.get_children()
	for cannon in cannons_to_add:
		all_cannons.append(cannon)


func add_rear_cannon() -> void:
	var cannons_to_add = rear_cannon.get_children()
	for cannon in cannons_to_add:
		all_cannons.append(cannon)


func add_side_cannons() -> void:
	var cannons_to_add = side_cannons.get_children()
	for cannon in cannons_to_add:
		all_cannons.append(cannon)



func add_status(status_name: String) -> void:
	array_of_status_names.append(status_name)


func shoot() -> void:
	var is_status_bullet = Rng.rng.randf_range(0, 100) <= status_chance

	if !cooldown_timer_node.is_stopped():
		return

	for cannon in all_cannons:
		SoundEffects.instance_sound("PlayerShoot1")
		spawned_projectile = projectile_scene.instance() 
		var spawned_projectile_hitbox = spawned_projectile.get_node("HitBoxArea2D")
		if is_status_bullet and self.array_of_status_names.size() > 0:
			spawned_projectile_hitbox.connect("status_setted", spawned_projectile, "_on_hitbox_status_setted")
			spawned_projectile_hitbox.damage_source = self
			var rand_status_index = Rng.rng.randi_range(0, self.array_of_status_names.size()-1)
			spawned_projectile_hitbox.chossen_status = array_of_status_names[rand_status_index]
		spawned_projectile_hitbox.team = 0
		spawned_projectile_hitbox.damage = _total_damage
		spawned_projectile_hitbox.critical_chance = total_critical_chance
		spawned_projectile_hitbox.max_number_of_hits = max_number_of_hits
		spawned_projectile.max_enemies_bounces = max_enemies_bounces
		spawned_projectile.max_wall_bounces = max_wall_bounces
		add_child(spawned_projectile)
		spawned_projectile.set_as_toplevel(true)
		spawned_projectile.is_special_bullet = self.is_special_bullet
		spawned_projectile.global_position = cannon.global_position
		spawned_projectile.global_rotation = cannon.global_rotation
		spawned_projectile.direction = Vector2.RIGHT.rotated(cannon.global_rotation)
		play_splash_sprite()
		cooldown_timer_node.start()
	emit_signal("hero_shooted")


func _input(event):
	if event.is_action_pressed("test_input_4"):
		improve_cooldown()


func update_total_damage() -> void:
	var percent_bonus_damage = _percent_bonus_damage/100 * (_base_damage + _bonus_damage)
	_total_damage = _percent_bonus_damage + _base_damage + _bonus_damage
	_total_damage = max (_total_damage, 7)


func set_percent_damage(value) -> void:
	_percent_bonus_damage = value
	update_total_damage()


func set_bonus_damage(value) -> void:
	_bonus_damage = value
	update_total_damage()


func play_splash_sprite() -> void:
	splash_animated_sprite.frame = 0


func set_max_enemies_bounces(value) -> void:
	max_enemies_bounces = value
	max_number_of_hits = max_enemies_bounces +1


func set_wall_bounces(value) -> void:
	max_wall_bounces = value
	if max_number_of_hits <= max_wall_bounces:
		max_number_of_hits += 1


func update_total_cooldown() -> void:
	total_cooldown_time  = base_cooldown - bonus_cooldown
	if !cooldown_timer_node:
		return
	cooldown_timer_node.wait_time = total_cooldown_time


func set_base_cooldown(value) -> void:
	base_cooldown = value
	update_total_cooldown()


func set_bonus_cooldown(value) -> void:
	bonus_cooldown = value
	update_total_cooldown()
	

func improve_cooldown() -> void:
	self.total_cooldown_time = total_cooldown_time - (total_cooldown_time * cooldown_modifier)
	cooldown_modifier -= cooldown_modifier /100 * 15


func set_percent_status_chance(value) -> void:
	percent_status_chance = value
	update_status_chance()


func set_bonus_status_chance(value) -> void:
	bonus_status_chance = value
	update_status_chance()


func update_status_chance() -> void:
	var raw_status_chance = base_status_chance + bonus_status_chance
	var raw_percent_status_chance = percent_status_chance * raw_status_chance / 100
	status_chance = raw_percent_status_chance + raw_status_chance







