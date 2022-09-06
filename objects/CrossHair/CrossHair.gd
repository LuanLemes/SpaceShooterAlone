extends Node2D
class_name CrossHair

onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
onready var part_one = $Part1
onready var part_two = $Part2
onready var part_three = $Part3
onready var tween: Tween = $Tween
onready var _health_label = $LabelContainer/HealthLabel
onready var _label_tween = $LabelTween
onready var _label_container = $LabelContainer
onready var _label_position_tween = $LabelPosiitionTween
export var part_one_rotation_speed = 1
export var part_two_rotation_speed = 0.7
export var part_three_rotation_speed = 0.5
export var screen_threshold: = 210

onready var right_top: = $PositionContainer/RightTop
onready var right_bottom: = $PositionContainer/RightBottom
onready var left_top: = $PositionContainer/LeftTop
onready var left_bottom: = $PositionContainer/LeftBottom
onready var threshold_containers: Node2D = $ThresholdContainers
onready var right_threshold: = $ThresholdContainers/Right
onready var bottom_threshold: = $ThresholdContainers/Bottom
onready var top_threshold: = $ThresholdContainers/Top
onready var left_threshold: = $ThresholdContainers/Left
onready var animation_player :AnimationPlayer = $AnimationPlayer

var is_top_position: bool = false
var is_left_position: bool = false

var part_one_virtual_location: Vector2 = Vector2.ZERO
var part_two_virtual_location: Vector2 = Vector2.ZERO
var part_three_virtual_location: Vector2 = Vector2.ZERO
var ideal_label_hp_value: int = 0 setget set_ideal_label_hp_value
var label_hp_value: int = 0 setget set_label_hp_value
var label_tween_duration: float = 0.3
var is_activated = false setget set_activated
var target: Node2D = null setget set_target
var is_seeking = false
var screen_size: Vector2


func _ready():
	screen_size.x = get_viewport_rect().size.x 
	generate_random_virtual_location_one()
	threshold_containers.set_as_toplevel(true)
	threshold_containers.global_position = Vector2.ZERO
	threshold_containers.scale = self.scale
	set_as_toplevel(true)
	

func set_activated(value) -> void:
	var old_value = is_activated
	is_activated = value
 
	if old_value == value:
		return
	if is_activated:
		animation_player.play_backwards("FadeOut")
	else:
		animation_player.play("FadeOut")
func set_target(new_target) -> void:
	if new_target == null:
		return
	if !is_instance_valid(new_target):
		return
	if new_target == target:
		return
	if target!= null and is_instance_valid(target):
		target.disconnect("damaged", self, "_update_health_label")
	is_seeking = false
	target = new_target
	target.connect("damaged", self, "_update_health_label")
	move_to_target()


func move_to_target() -> void:
	tween.interpolate_property(self, "global_position", self.global_position, target.global_position, 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", self.scale, Vector2(target.crosshair_scale, target.crosshair_scale), 0.3, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	_update_health_label()


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
#	update_label_position()


func _on_Tween_tween_all_completed():
	is_seeking = true


#func _update_health_label() -> void:
#	if target != null:
#		_health_label.text = ("HP: " + String(target.hp))


func set_ideal_label_hp_value(value) -> void:
	if ideal_label_hp_value == value:
		return
	ideal_label_hp_value = value
	tween_label_value()


func set_label_hp_value(value) -> void:
	label_hp_value = value
	if target != null:
		_health_label.text = ("HP: " + String(label_hp_value))


func tween_label_value() -> void:
	_label_tween.stop_all()
	_label_tween.interpolate_property(self, "label_hp_value", label_hp_value, ideal_label_hp_value, label_tween_duration, Tween.TRANS_LINEAR)
	_label_tween.start()


func _update_health_label () -> void:
	self.ideal_label_hp_value = target.hp


func update_label_position() -> void:
	if is_left_position:
		if is_top_position:
			_tween_label_position(right_bottom.position)
		else:
			_tween_label_position(right_top.position)
	else:
		if is_top_position:
			_tween_label_position(left_bottom.position)
		else:
			_tween_label_position(left_top.position)
			
			


func _tween_label_position(ideal_position: Vector2) -> void:
	_label_position_tween.stop_all()
	_label_position_tween.interpolate_property(_label_container, "position", _label_container.position, ideal_position, 0.14, Tween.TRANS_LINEAR)
	_label_position_tween.start()


func _on_Right_area_entered(area):
	if is_left_position == false:
		return
	is_left_position = false
	update_label_position()


func _on_Left_area_entered(area):
	
	if is_left_position == true:
		return
	is_left_position = true
	update_label_position()


func _on_Top_area_entered(area):
	if is_top_position == true:
		return
	is_top_position = true
	update_label_position()


func _on_Bottom_area_entered(area):
	if is_top_position == false:
		return
	is_top_position = false
	update_label_position()



func _on_Top_area_exited(area):
	is_top_position = false
	update_label_position()
