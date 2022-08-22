extends Node2D
class_name Status

var hurtbox: HurtBoxArea2D
var character: Node2D
var original_status: Status setget set_original_status
export var exaust_wait_time: float = 10.5
export var proc_wait_time: float = 5.5
export var modifier: = 1
export var damage_modifier: float = 1
onready var proc_timer_node: Timer = $ProcTimer
onready var exaust_timer_node: Timer = $ExaustTimer
export var main_particles_path: NodePath
var main_particles


func _ready():
	proc_timer_node.connect("timeout", self, "_on_Proc_Timer_timeout")
	exaust_timer_node.connect("timeout", self, "_on_Exaust_Timer_timeout")
	proc_timer_node.wait_time = proc_wait_time
	exaust_timer_node.wait_time = exaust_wait_time
		


func status_execute() -> void:
	pass


func status_cancel() -> void:
	queue_free()


func initialize() -> void:
	exaust_timer_node.start()
	proc_timer_node.start()
	on_status_started()
	

func on_status_started():
	pass


func reset() -> void:
	exaust_timer_node.start()
	proc_timer_node.start()
	on_status_started()
	pass



func set_original_status(new_original_status: Status) -> void:
	original_status = new_original_status
	exaust_wait_time = original_status.exaust_wait_time
	proc_wait_time = original_status.proc_wait_time
	
	
	modifier = original_status.modifier


func create_hit(damage : int = self.damage_modifier, critical_chance: int = 0,color: Color = self_modulate ,global_position: Vector2 = hurtbox.global_position) -> Hit:
	var this_hit: Hit = Hit.new()
	this_hit.constructor(damage, critical_chance, self_modulate, self.global_position)
	hurtbox.get_hurt(this_hit)
	return this_hit


func _on_Exaust_Timer_timeout():
	status_cancel()


func _on_Proc_Timer_timeout():
	status_execute()
