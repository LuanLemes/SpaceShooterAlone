extends Area2D
class_name TriggerObject

signal activated(trigger_object)

var activated: bool = false

func trigger_activate() -> void:
	if activated:
		return
	else:
		activated = true
	emit_signal("activated",self.name)


func _on_TriggerObject_area_entered(area):
	trigger_activate()
