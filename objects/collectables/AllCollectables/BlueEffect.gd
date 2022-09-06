extends CollectableEffect


var speed_modifier = 50
var heal_modifier = 1
var cooldown_modifier = 0.10
var unexecuted: bool = false


func _execute() -> void:
#	hero.hero_movement_handler.bonus_speed += speed_modifier
	hero.get_heal(heal_modifier)
	hero.hero_weapon.bonus_cooldown += cooldown_modifier
	_timer.start()

func _unexecute() -> void:
	if unexecuted:
		queue_free()
		return
	unexecuted = true
	hero.hero_weapon.bonus_cooldown -= cooldown_modifier
	queue_free()


func _on_Timer_timeout():
	_unexecute()


#func initialize() -> void:
#	_execute()
	
