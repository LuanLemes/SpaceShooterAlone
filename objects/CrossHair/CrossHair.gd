extends Node2D
class_name CrossHair

onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
onready var part_one = $Part1
onready var part_two = $Part2
onready var part_three = $Part3
onready var tween = $Tween


export var part_one_rotation_speed = 1
export var part_two_rotation_speed = 0.7
export var part_three_rotation_speed = 0.5

var part_one_virtual_location: Vector2 = Vector2.ZERO
var part_two_virtual_location: Vector2 = Vector2.ZERO
var part_three_virtual_location: Vector2 = Vector2.ZERO

var is_activated = false setget set_activated
var target: Node2D = null setget set_target

var is_seeking = false


func _ready():
	generate_random_virtual_location_one()
	set_as_toplevel(true)
	

func set_activated(value) -> void:
	is_activated = value
	self.visible = is_activated


func set_target(new_target) -> void:
	if new_target == null:
		return
	if !is_instance_valid(new_target):
		return
	if new_target == target:
		return
	is_seeking = false
	target = new_target
	move_to_target()


func move_to_target() -> void:
	tween.interpolate_property(self, "global_position", self.global_position, target.global_position, 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", self.scale, Vector2(target.crosshair_scale, target.crosshair_scale), 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()


func aim_handler(delta, part, part_speed, part_one_virtual_location) -> void:
	var angle_delta = part_one_rotation_speed * delta

	var v = part.global_position - part_one_virtual_location
	var angle = v.angle()
	var r = part.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	part.global_rotation = angle


func _process(delta):
	aim_handler(delta, part_one, part_one_rotation_speed, part_one_virtual_location)
	aim_handler(delta, part_two, part_two_rotation_speed, part_two_virtual_location)
	aim_handler(delta, part_three, part_three_rotation_speed, part_three_virtual_location)
	seek_target()


func seek_target() -> void:
	if target == null or !is_instance_valid(target):
		is_seeking = false
		self.is_activated = false
		return
	if is_seeking == true:
		global_position = target.global_position


func generate_random_virtual_location_one() -> void:
	var random_location = Vector2(rng.randi_range(0,1080), rng.randi_range(0,1920))
	part_one_virtual_location = random_location


func generate_random_virtual_location_two() -> void:
	var random_location = Vector2(rng.randi_range(0,1080), rng.randi_range(0,1920))
	part_two_virtual_location = random_location


func generate_random_virtual_location_three() -> void:
	var random_location = Vector2(rng.randi_range(0,1080), rng.randi_range(0,1920))	
	part_three_virtual_location = random_location
	

func _on_Timer_timeout():
	generate_random_virtual_location_one()
	generate_random_virtual_location_two()
	generate_random_virtual_location_three()


#func _input(event):
#	if event.is_action_pressed("click"):
#		move_to_target()


func _on_Tween_tween_all_completed():
	is_seeking = true
