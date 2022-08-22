extends Status


func _ready():
	set_process(false)
	
#	remote_transform.set_as_toplevel(true)


func status_execute() -> void:
	create_hit()
	proc_timer_node.start()
	


func status_cancel() -> void:
	queue_free()


func _physics_process(delta):
	$Particles2D.global_rotation = 0


func set_original_status(new_original_status: Status) -> void:
	pass

func on_status_started():
	create_hit()
