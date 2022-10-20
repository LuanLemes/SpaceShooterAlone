extends KinematicBody2D
class_name Bullet

export var speed: = 10
var direction = Vector2.RIGHT setget set_direction
var velocity: = Vector2.ZERO
var is_piercing: bool = true
var max_wall_bounces: = 0
var walls_bounced: = 0
var enemies_bounced: = 0
var max_enemies_bounces: = 0
var trail: BulletParticles
var ajusted_color: Color = self_modulate
var is_special_bullet: bool = false setget set_is_a_special_bullet
onready var hitbox: HitBoxArea2D = $HitBoxArea2D
onready var enemy_detector: Area2D = $EnemyDetector
onready var sprite: Node2D = $Sprite
onready var raycast2d: RayCast2D = $RayCast2D
var bonus_scale = 1.5
export var explosion_particle_scene: PackedScene
export var trail_particle_scene: PackedScene



func _ready():
	update_color()
	instance_trail_particle()


func set_is_a_special_bullet(value: bool) -> void:
	is_special_bullet = value
	
	if is_special_bullet:
		addapt_size(bonus_scale)


func _physics_process(delta):
	var collision_info = move_and_collide(velocity)
	if collision_info:
		bounce(collision_info)
	trail.global_position = self.global_position


func find_next_target(last_enemy_hurt_box) -> void:
	if !enemies_bounced < max_enemies_bounces or !is_piercing:
		destroy()
		return
	
	instance_explosion_particle()
	damage_reduction(hitbox.damage/100*77)
	var last_enemy = last_enemy_hurt_box.character
	raycast2d.add_exception(last_enemy)
	var enemies_detected = enemy_detector.get_overlapping_areas()
	if enemies_detected.size() == 1 and !is_piercing:
		destroy()
		return
	for enemy_area in enemies_detected:
		if enemy_area.get_parent() == last_enemy:
			continue
		raycast2d.look_at(enemy_area.global_position)
		raycast2d.rotation_degrees -= 90
		raycast2d.force_raycast_update()
		var collider = raycast2d.get_collider()
		if raycast2d.is_colliding():
#			collider = raycast2d.get_collider()
			if ! collider is Enemy:
				continue
		else:
			continue
		look_at(enemy_area.global_position)
		set_direction(Vector2.RIGHT.rotated(self.global_rotation))
		raycast2d.look_at(enemy_area.global_position)
		raycast2d.rotation_degrees -= 90
		enemies_bounced += 1
		break
	raycast2d.enabled = false


func destroy():
	trail.destroy_after_time()
	instance_explosion_particle()
	queue_free()


func addapt_size(scale_variation) -> void:
	if scale_variation == 1.0:
		$Trail2D.visible = false
	else:
		self.scale *= scale_variation
		$Trail2D.scale /= self.scale
		$Trail2D.lenght = 7
		
		
func separate_explosion_particles(particle: BulletParticles) -> void:
	particle.this_global_position = self.global_position
	remove_child(particle)
	get_parent().add_child(particle)
	particle.destroy_explosion_after_time()


func instance_explosion_particle() -> void:
	var particle = explosion_particle_scene.instance()
	particle.this_global_position = self.global_position
	get_parent().add_child(particle)
	particle.modulate = sprite.modulate
	particle.destroy_explosion_after_time()
	particle.destroy_explosion_after_time()


func instance_trail_particle() -> void:
	var particle: Particles2D = trail_particle_scene.instance()
	particle.modulate = sprite.modulate
	trail = particle
	particle.set_as_toplevel(true)
	get_parent().add_child(particle)
	particle.global_position = self.global_position
	particle.emitting = true


func set_direction(new_direction) -> void:
	direction = new_direction
	velocity = direction * speed


func bounce(collision_info) -> void:
	if walls_bounced < max_wall_bounces:
		walls_bounced += 1
		damage_reduction(hitbox.damage/100*50)
		velocity = velocity.bounce(collision_info.normal)
		global_rotation = velocity.angle()
		instance_explosion_particle()
	else: destroy()


func _on_VisibilityNotifier2D_screen_exited():
	destroy()


func _on_HitBoxArea2D_max_hited():
	destroy()


func _on_HitBoxArea2D_not_last_hit(hurt_box):
	find_next_target(hurt_box)


func damage_reduction(value) -> void:
	hitbox.damage -= int(value)


func _on_hitbox_status_setted(original_status) -> void:
	ajusted_color = original_status.self_modulate


func update_color() -> void:
	if ajusted_color != Color(1,1,1,1):
		sprite.modulate = ajusted_color
