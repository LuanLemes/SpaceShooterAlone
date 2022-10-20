extends Collectable

onready var animation_player: = $AnimationPlayer


func _instant_pick() -> void:
	$PlayerMagneticArea/CollisionShape2D.shape.radius *= 3


func on_pick_() -> void:
	SoundEffects.instance_sound("BassImpact1")
	SoundEffects.instance_sound("ScoreCoin1")
	emit_signal("collectable_picked", "Blue")
	_destroy()


func _on_Area2D_body_entered(body):
	if picked == true:
		return
	picked = true
	on_pick_()


func _vanish() -> void:
	animation_player.play("vanish")
	yield(animation_player,"animation_finished")
	queue_free()
	
	
func _destroy() -> void:
	animation_player.stop()
	animation_player.play("picked")
	yield(animation_player,"animation_finished")
	queue_free()

func _on_Timer_timeout() -> void:
	_vanish()



