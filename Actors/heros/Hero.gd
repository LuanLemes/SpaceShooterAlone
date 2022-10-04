extends KinematicBody2D
class_name Hero

signal total_hp_changed
signal hp_changed
signal died
signal total_shield_changed
signal shield_changed
signal shield_depleted
signal shield_full
signal stopped
signal started_shooting
signal stopped_shooting


signal heal
signal before_hit(damage)
signal before_hurt(damage)
signal hurt(damage)



var target setget set_target

export var base_hp: float = 1
var bonus_hp: float = 0 setget set_bonus_hp
var bonus_percent_hp: float = 0 setget set_bonus_percent_hp
var _total_hp: int = 0
var _hp : float = 0 setget set_hp

export var base_shield: float = 0 setget set_base_shield
var bonus_shield: float = 0 setget set_bonus_shield
var bonus_percent_shield: float = 0 setget set_bonus_percent_shield
var _total_shield: int = 0
var shield: float = 0 setget set_shield
export var shield_regen_base: float = 0.5
export var shield_recharge_cd: float = 2 setget set_shield_recharge_cd


var can_be_hurt: bool = false
var is_active:bool = true setget _set_is_active
var dash_cooldown: float = 0.63


onready var _hurt_box: HurtBoxArea2D = $HurtBoxArea2D
onready var shield_recharge_action: = $ShieldRechargeAction
onready var hero_weapon: HeroWeapon = $HeroWeapon
onready var status_storage = $StatusStorage
onready var _tween = $Tween
onready var _shield_source : ShieldSource = $ShieldSource
onready var hero_movement_handler : HeroMovementHandler = $HeroMovementHandler
onready var remote_transform : RemoteTransform2D = $RemoteTransform2D
onready var _health_bar: ProgressBar = $UI/Control/HealthProgressBar
onready var _shield_bar: ProgressBar = $UI/Control/ShieldProgressBar
onready var _enemy_detector_raycast: RayCast2D = $RayCast2D
onready var _cross_hair: CrossHair = $CrossHair
onready var _label_ui: LabelUI = $UI/Control/ValueUI
onready var _state_machine : StateMachine = $StateMachine
onready var _sprite: AnimatedSprite = $AnimatedSprite
onready var _collision_shape: CollisionShape2D = $CollisionShape2D2
onready var _damaged_animation: AnimationPlayer = $AnimationPlayer
onready var _dash_particles: Particles2D = $DashParticles2D2
onready var _dash_timer: Timer = $DashTimer
onready var _dash_checker = $DashEndPoint
onready var _inside_wall_checker: RayCast2D = $IndiseWallChecker/RayCast2D
onready var _inside_wall_checker2: RayCast2D = $IndiseWallChecker/RayCast2D2
onready var _foward_wall_checker: RayCast2D = $IndiseWallChecker/FowardDashWallChecker
var saved_global_position
func _ready():
	SingletonManager.hero = self
	connect("total_shield_changed", self, "_on_total_shield_changed")
	connect("shield_changed", self, "_on_shield_changed" )
	connect("total_hp_changed", self, "_on_total_hp_changed")
	connect("hp_changed", self, "_on_hp_changed")
	
	connect("heal", SignalManager, "_on_hero_heal")
	connect("hurt", SignalManager, "_on_hero_hurt")
	connect("hp_changed", SignalManager, "_on_hero_hp_changed")
	connect("total_hp_changed", SignalManager, "_on_hero_total_hp_changed")
	connect("shield_changed", SignalManager, "_on_hero_shield_changed")
	connect("total_shield_changed", SignalManager, "_on_hero_total_shield_changed")
	connect("shield_depleted", SignalManager, "_on_hero_shield_depleted")
	connect("shield_full", SignalManager, "_on_hero_shield_full")
	connect("started_shooting", SignalManager, "_on_hero_started_shooting" )
	connect("stopped_shooting", SignalManager, "_on_hero_stopped_shooting")


	$UI.set_as_toplevel(true)
	update_total_hp()
	set_hp(_total_hp)
	_label_ui._hero = self

	update_total_shield()
	set_shield(_total_shield)
	
	shield_recharge_action.character = self
	hero_weapon.character = self
	_shield_source.character = self
	hero_movement_handler.character = self
	$StateMachine.set_character(self)
	_dash_timer.wait_time = dash_cooldown





func _powered_up() -> void:
	pass


func set_bonus_shield(value) -> void:
	bonus_shield = value
	update_total_shield()


func set_base_shield(value) -> void:
	base_shield = value
	update_total_shield()
	
	
func set_bonus_percent_shield(value) -> void:
	bonus_percent_shield = value
	update_total_shield()


func update_total_shield() -> void:
	var new_total_shield = base_shield + bonus_shield
	var percentage_of_total_shield = (base_shield + bonus_shield)/100 * bonus_percent_shield
	_total_shield = percentage_of_total_shield + new_total_shield
	emit_signal("total_shield_changed")
	self.shield = self.shield


func set_shield(value) -> void:
	var old_shield = shield
	shield = clamp(value, 0, _total_shield)
	
	emit_signal("shield_changed")
	
	if old_shield > 0:
		if shield == 0:
			emit_signal("shield_depleted")
		if shield < old_shield:
#			shield damaged
			_shield_source._emit_shield_reaction()
			
	
		
	if shield == _total_shield and old_shield < _total_shield:
		emit_signal("shield_full")
		
	if shield < _total_shield and shield <= old_shield:
		if shield_recharge_action:
			shield_recharge_action.start()


func update_total_hp() -> void:
	
	var current_hp_in_percent = -1
	
	if _total_hp != 0 and _hp != 0:
		current_hp_in_percent = _hp / _total_hp
		
	var percentage_of_total_hp = (bonus_hp + base_hp)/100 * bonus_percent_hp
	var old_total_hp = _total_hp
	_total_hp = base_hp + bonus_hp + percentage_of_total_hp
	
	if old_total_hp < _total_hp and current_hp_in_percent != -1:
		set_hp(current_hp_in_percent * _total_hp)
		
	emit_signal("total_hp_changed")
	emit_signal("hp_changed")


func set_hp(value):
	var proportional_current_hp = _hp / _total_hp * 100
	
	_hp = value
	_hp = clamp(_hp, 0, _total_hp)
	_label_ui.tween_label_value(_hp)
	
	
	emit_signal("hp_changed")
	if _hp == 0 or _hp < 0:
		_state_machine.transition_without_delay("Die")


func set_bonus_hp(value):
	bonus_hp = value
	update_total_hp()


func set_bonus_percent_hp(value) -> void:
	bonus_percent_hp = value
	update_total_hp()


func get_hurt(damage) -> void:
	damage_shield(damage)
	emit_signal("hurt", damage)


func damage_shield(damage) -> void:
	var extra_damage: int = 0
	if damage > shield:
		extra_damage = shield - damage
		damage = shield
	
	self.shield = shield - damage


#	remove later
	if shield < 0:
		print("shield is broken")
	if extra_damage != 0:
		damage_health(abs(extra_damage))


func damage_health(damage) -> void:
	self._hp -= damage
	_sprite.shake = true
	_damaged_animation.play("Damaged")


func get_heal(heal_value) -> void:
	self._hp += heal_value
	emit_signal("heal")


func get_percentage_heal(heal_value_percentage) -> void:
	self._hp += heal_value_percentage/100 * self._total_hp
	emit_signal("heal")


func _on_HurtBoxArea2D_hit_landed(damage):
	emit_signal("before_hit")
	get_hurt(damage)


func set_shield_recharge_cd(value):
		shield_recharge_cd = value
		shield_recharge_action.shield_regen_cooldown.wait_time = shield_recharge_cd


func update_target() -> void:
	
	var all_enemies = get_tree().get_nodes_in_group("enemies")
	if all_enemies.empty():
		target = null
		return
	var nearest_enemy_that_can_be_hitted = null
	var nearest_distance_that_can_be_hitted = null
	var can_hit_enemy: bool = false
	var nearest_enemy = all_enemies[0]
	var nearest_distance = self.global_position.distance_to(all_enemies[0].global_position)
	
	for enemy in all_enemies:
		var distance_to_this_enemy = self.global_position.distance_to(enemy.global_position)
		if enemy.can_see_player:
			can_hit_enemy = true
			if nearest_enemy_that_can_be_hitted == null:
				nearest_distance_that_can_be_hitted = distance_to_this_enemy
				nearest_enemy_that_can_be_hitted = enemy
			elif distance_to_this_enemy < nearest_distance_that_can_be_hitted:
				nearest_distance_that_can_be_hitted = distance_to_this_enemy
				nearest_enemy_that_can_be_hitted = enemy
		else:
			if can_hit_enemy:
				continue
			elif distance_to_this_enemy < nearest_distance:
				nearest_distance = distance_to_this_enemy
				nearest_enemy = enemy
				
				
	if nearest_distance_that_can_be_hitted != null:
		self.target = nearest_enemy_that_can_be_hitted
	else:
		self.target = nearest_enemy
		
	_enemy_detector_raycast.look_at(target.global_position)
	_enemy_detector_raycast.rotation_degrees -= 90


func _on_hp_changed() -> void:
	_health_bar.value = self._hp


func _on_total_hp_changed() -> void:
	_health_bar.max_value = self._total_hp


func _on_shield_changed() -> void:
	_shield_bar.value = self.shield


func _on_total_shield_changed() -> void:
	_shield_bar.max_value = self._total_shield


func set_target(value) -> void:
	if target != null and is_instance_valid(target):
		target.is_player_target = false
	target = value
	target.is_player_target = true
	_cross_hair.is_activated = true
	_cross_hair.target = target


func _on_Timer_timeout():
	update_target()


func _set_state_machine_to_idle() -> void:
	_state_machine.transition_without_delay("Idle")


func _set_is_active(value) -> void:
	if value == false:
		_set_state_machine_to_idle()
	is_active = value


#func _input(event):
#	if event.is_action_pressed("test_input_1"):
#		save_global_position()
#	if event.is_action_pressed("ui_accept"):
#		global_position = saved_global_position
		

func save_global_position() -> void:
	saved_global_position = self.global_position

func check_if_can_wall_dash() -> int:
	if !check_foward_wall():
		return -1
	var value_to_return: = -1
	var index = 0
	for checker in _dash_checker.get_children():
		var this_raycast: RayCast2D = checker
		this_raycast.force_raycast_update()
		if !this_raycast.is_colliding():
			value_to_return = index
			break
		index += 1
	return value_to_return


func check_if_is_in_wall() -> bool:
	var to_return = false
	_inside_wall_checker.force_raycast_update()
	_inside_wall_checker2.force_raycast_update()
	if _inside_wall_checker.is_colliding() and _inside_wall_checker2.is_colliding():
		to_return = true
	return to_return


func check_foward_wall() -> bool:
	_foward_wall_checker.force_raycast_update()
	return _foward_wall_checker.is_colliding()
	 
