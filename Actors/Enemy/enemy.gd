extends KinematicBody2D
class_name Enemy

signal died
signal damaged
signal moved(enemy_global_position)
signal critical_landed
signal camera_shake_requested
signal death_started(enemy_global_position)
signal enemy_hit_landed


var is_active:bool = true
var hp: int setget set_hp
var bonus_percent_hp: float setget set_bonus_hp
var total_hp: int
var activated: bool = true
export var base_hp: float

onready var hurt_box: = $HurtBoxArea2D
onready var sprite_animator :AnimationPlayer = $AnimatedSprite/AnimationPlayer
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var hero_detector: RayCast2D = $RayCast2D
onready var enemy_area = $EnemyArea
onready var support_control = $SupportControl
onready var all_support_containers: = $SupportControl.get_children()
var support_node: EnemySupport
var wave setget set_wave
var can_see_player: bool = false setget set_can_see_player
var weapon
var is_player_target: bool = false setget set_is_player_target
export var _rotation_speed: float = 2
export var speed = 100
var velocity: Vector2 = Vector2.ZERO
var direction: = Vector2.ZERO
export var is_movement_enemy: bool = false
export var crosshair_scale: float = 0.54
export var max_support: int = 1
export var support_number: int = 0
var dying = false
onready var appear_particle: Particles2D = $AppearNode/Particles2D2
onready var _state_machine: StateMachine = $StateMachine



func _ready():
	visible = false
	connect("critical_landed", SignalManager, "_on_enemy_critical_landed")
	connect("died", SignalManager, "_on_enemy_died")
	connect("death_started", SignalManager, "_on_enemy_death_started")
	connect("camera_shake_requested", SignalManager, "camera_shake_requested")
	connect("enemy_hit_landed", SignalManager, "_on_enemy_hit_landed")
	hurt_box.connect("critical_landed", self, "_on_hurt_box_critical_landed")
	_initialize_sup_node()
	weapon = $Weapon.get_child(0)
	set_total_hp()
	set_hp(total_hp)
	hurt_box.character = self
	set_process(false)
	set_physics_process(false)
	_initialize_sup_node()
	$SupportControl.set_as_toplevel(true)


func set_wave(new_wave) -> void:
	appear_particle.emitting = true
	set_collision_layer_bit(2, true)
	set_collision_mask_bit(1, true)
	set_collision_mask_bit(2, true)
	hurt_box.set_collision_layer_bit(0, true)
	enemy_area.set_collision_layer_bit(2, true)
	add_to_group("enemies")
	wave = new_wave
	set_process(true)
	set_physics_process(true)
	on_wave_ready()
	
	visible = true


func set_hp(value) -> void:
	hp = clamp(value, 0, total_hp)
#	$Label.text = String(hp)
	if hp == 0:
		if dying != true: 
			dying = true
			_die()
	

func set_bonus_hp(value) -> void:
	bonus_percent_hp = value
	set_total_hp()


func set_total_hp() -> void:
	total_hp = base_hp + (base_hp / 100 * bonus_percent_hp) 
	total_hp = round(float(total_hp) * DifficultParameters.enemy_health_factor)
	

func get_hurt(damage) -> void:
	self.hp -= damage
	emit_signal("damaged")
	sprite_animator.play("DamagedAnimation")


func _on_HurtBoxArea2D_hit_landed(damage):
	get_hurt(damage)
	emit_signal("enemy_hit_landed")
	animated_sprite.shake = true


func _die() -> void:
	_state_machine.transition_without_delay("Die")


func _process(delta):
	detect_hero()


func detect_hero() -> void:
	if !activated:
		return
	hero_detector.enabled = true
	hero_detector.force_raycast_update()
	hero_detector.look_at(wave.hero.global_position)
	hero_detector.rotation_degrees -= 90
	var collider = hero_detector.get_collider()
	if hero_detector.is_colliding():
		if !collider.is_in_group("heroes"):
			hero_detector.enabled = false
			self.can_see_player = false
			return
	hero_detector.enabled = false
	self.can_see_player = true
	return 


func set_can_see_player(new_value) -> void:
	can_see_player = new_value


func on_wave_ready() -> void:
#	yield(get_tree().create_timer(1.5), "timeout")
	$StateMachine.set_character(self)
	

func set_is_player_target(value) -> void:
	is_player_target = value


func when_moved() -> void:
	emit_signal("moved", self.global_position)


func _on_hurt_box_critical_landed(critical_damage) -> void:
	emit_signal("critical_landed", critical_damage)


func _initialize_sup_node() -> void:
	if has_node("SupportNode"):
		support_node = $SupportNode
		support_node.character = self


