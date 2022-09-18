extends Node2D
class_name Collectable


signal collectable_picked(collectable_name)
onready var area_2d: Area2D = $PlayerPickArea
onready var magnetic_area: Area2D = $PlayerMagneticArea
var picked = false
export var duration: float = 2.5
onready var timer: Timer = $Timer
var hero: Hero

func _ready():
	set_physics_process(false)
	connect("collectable_picked", SignalManager, "_on_collectable_picked")



func _physics_process(delta):
	_go_to_player()


func on_pick_() -> void:
	emit_signal("collectable_picked", self.name)
	_destroy()
#	destroy bullets
#	reference the collectable handler


func initialize() -> void:
	hero = SingletonManager.hero
	area_2d.monitoring = true
	area_2d.set_deferred("monitoring", true)
	magnetic_area.set_deferred("monitoring", true)
	visible = true
	timer.wait_time = duration
	timer.start()
	var overlapping_areas = area_2d.get_overlapping_areas()
	if overlapping_areas.size() > 0:
		_on_Area2D_body_shape_entered(overlapping_areas[0])


func _on_Area2D_body_shape_entered(body):
	if picked == true:
		return
	picked = true
	on_pick_()


func _on_Timer_timeout():
	pass # Replace with function body.


func _destroy() -> void:
	queue_free()


func _go_to_player() -> void:
	var direction:Vector2 = hero.global_position - self.global_position  
	direction = direction.normalized()
	translate(direction * 10)


func _on_PlayerMagneticArea_body_entered(body):
	set_physics_process(true)
