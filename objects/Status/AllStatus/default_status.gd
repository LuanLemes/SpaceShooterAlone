extends Status


#var hurtbox: HurtBoxArea2D
#var character: Node2D
#var original_status: Status setget set_original_status
#export var duration: = 10
#export var proc_timer: = 5
#export var modifier: = 1

func _ready():
	set_process(false)


func status_execute() -> void:
	pass


func status_cancel() -> void:
	queue_free()


#func initialize() -> void:
#	$Timer.start()
#
#
#func reset() -> void:
#	$Timer.start()
	

func set_original_status(new_original_status: Status) -> void:
	pass


#func create_hit(damage: int = 1, critical_chance: int = 0,color: Color = self.color ,global_position: Vector2 = hurtbox.global_position) -> Hit:
#	var this_hit: Hit = Hit.new()
#	this_hit.constructor(damage, critical_chance, self.color, self.global_position)
#	hurtbox.get_hurt(this_hit)
#	return this_hit
#
#
#func _on_Exaust_Timer_timeout():
#	status_cancel()
#
#
#func _on_Proc_Timer_timeout():
#	status_execute()

