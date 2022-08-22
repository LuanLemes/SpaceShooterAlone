extends State

signal hero_death_started
onready var explosion_particle: Particles2D = $SakuraExplosionParticle


func _ready():
	connect("hero_death_started", SignalManager, "_on_hero_death_started")


func unhandled_input(event):
	pass


func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	emit_signal("hero_death_started")
	var this_character: Hero = self.character
	this_character._label_ui.visible = false
	this_character._sprite.visible = false
	this_character._sprite.visible = false
	this_character._hurt_box.set_deferred("monitorable", false)
	this_character._hurt_box.set_deferred("monitoring", false)
	this_character._hurt_box.visible = false
	this_character._collision_shape.disabled = true
	explosion_particle.global_position = character.global_position
	explosion_particle.set_deferred("emitting", true)
	


func exit() -> void:
	pass
#	emit_signal("hero_stopped_moving")


func _on_timer_timeout() -> void:
	return
