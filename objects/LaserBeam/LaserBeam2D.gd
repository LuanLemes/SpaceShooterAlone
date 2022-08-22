extends RayCast2D

export var cast_speed := 7000.0
export var max_length := 1400
export var growth_time := 0.1

var is_casting := false setget set_is_casting
var cast_point
var is_target_point = false
var target_location: Vector2
export var is_inner_line = false

onready var fill := $FillLine2D
onready var inner_line := $InnerLine
onready var tween := $Tween
onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var beam_particles := $BeamParticles2D

onready var line_width: float = fill.width


func _ready() -> void:
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO
	fill.modulate = self.modulate


func _physics_process(delta: float) -> void:
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	cast_beam()
	update_beam_particle_extent()
	inner_line.points[1] = fill.points[1]


func set_is_casting(cast: bool) -> void:
	is_casting = cast

	if is_casting:
		cast_to = Vector2.ZERO
		fill.points[1] = cast_to
		appear()
	else:
		collision_particles.emitting = false
		disappear()

	set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting


func cast_beam() -> void:
	cast_point = cast_to

	force_raycast_update()
	collision_particles.emitting = is_colliding()
	
	if is_target_point:
		cast_point = to_local(target_location)
		collision_particles.position = cast_point
	

	if is_colliding() and  ! is_target_point:
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point

	fill.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5


func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", 0, line_width, growth_time * 2)
	tween.start()


func disappear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(fill, "width", fill.width, 0, growth_time)
	tween.start()


func update_beam_particle_extent() -> void:
	if is_casting:
		beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5
