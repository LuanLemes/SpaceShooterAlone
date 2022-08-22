extends Node
class_name Hero_Action


var character: Hero 

onready var shield_regen_cooldown: Timer = $ShieldRegenCooldown


func _ready():
	set_process(false)


func _process(delta):
	if !shield_regen_cooldown.is_stopped():
		return
	character.shield += character.shield_regen_base
	if character.shield == character._total_shield:
		stop()


func start():
	shield_regen_cooldown.start()


func stop():
	set_process(false)


func _on_ShieldRegenCooldown_timeout():
	if character.shield == character._total_shield:
		return
	set_process(true)


func recover_shield(value) -> void:
	character.shield += value
	

func percentage_recover_shield(value) -> void:
	character.shield += value/100 * character._total_shield









