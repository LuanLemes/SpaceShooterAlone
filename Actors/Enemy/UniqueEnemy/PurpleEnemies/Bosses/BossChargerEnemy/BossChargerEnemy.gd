extends Enemy

onready var path_follow: PathFollow2D = $Lines/Path2D/PathFollow2D
onready var path: Path2D = $Lines/Path2D
onready var line2d: Line2D = $Lines/Line2D
export var path_follow_speed = 3


var phase: int = 1
var hp_phase2_threshold: int = 2000
var hp_phase3_threshold: int = 1000
var number_of_charges_left: int = 0
var current_number_of_charges: int = 0
var number_of_shoots: int = 1
var _shoot_on_charge: bool = true
var aim_time: float = 1
var hp_to_next_token = hp
onready var move_positions_container = $move_positions_container
onready var move_location_2d = $move_positions_container/move_location
onready var down_location = $move_positions_container/down


func _ready():
	path_follow.set_as_toplevel(true)
	line2d.set_as_toplevel(true)
#	path.global_position = self.global_position
	path_follow.global_position = self.global_position
	move_positions_container.set_as_toplevel(true)
	move_positions_container.global_position = Vector2.ZERO
	hp_to_next_token = hp -250
	connect("enemy_hit_landed", self, "_on_enemy_hit_landed")


func check_phase() -> void:
	return
	if hp <= hp_phase2_threshold:
		_state_machine.transition_without_delay("Phase2")
	if hp <= hp_phase3_threshold:
		_state_machine.transition_without_delay("Phase3")


func _on_enemy_hit_landed() -> void:
	check_if_token()
#	check_phase()


func _physics_process(delta):
	weapon.global_rotation = hero_detector.global_rotation


func check_if_token() -> void:
	
	if hp <= hp_to_next_token:
		hp_to_next_token -= 280
		SignalManager.emit_signal("_on_collectable_request", global_position)
		
