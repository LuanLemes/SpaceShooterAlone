extends AudioStreamPlayer


func _ready():
	connect("finished", self, "_on_finished")
	

func _on_finished() -> void:
	queue_free()
