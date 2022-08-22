extends Node

var bullet_explosion_particles = preload("res://objects/Particles/Sakura/BulletExplosionParticle.tres")
var bullet_trail_particles = preload("res://objects/Particles/Sakura/BulletTrailParticle.tres")
var bullet = preload("res://objects/projectiles/bullets/Bullet.tscn")

var materials = [
	bullet_explosion_particles,
	bullet_trail_particles,
]

func _ready():
	for material in materials:
		var particle_instance = Particles2D.new()
		particle_instance.set_process_material(material)
		particle_instance.set_one_shot(true)
		particle_instance.set_modulate(Color(1,1,1,1))
		particle_instance.set_emitting(true)
		self.add_child(particle_instance)
	
