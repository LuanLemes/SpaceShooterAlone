extends Node2D
class_name EnemySupport


signal host_migration_finished


onready var tween: Tween = $Tween
var character 
var host
var first_migrated: bool = false
var second_migrated: bool = false
var support_container = null


func _migrate_to_host(host) -> void:
	update_support_container()
	if support_container == null:
		return
	remove_enemy()
	tween.stop_all()
	tween.interpolate_property(character, "global_position", character.global_position, support_container.global_position, 1, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	first_migrated = true


func _remigrate_to_host(host) -> void:
	tween.stop_all()
	tween.interpolate_property(character, "global_position", character.global_position, support_container.global_position, 0.2, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	second_migrated = true


func _on_Tween_tween_completed(object, key):
	if first_migrated == true and second_migrated == true:
#		character.set_as_toplevel(true)
#		character.remove_from_group("enemies")
#		remove_enemy()

		character.wave._on_enemy_died()
#		character.set_as_toplevel(false)
		character.global_position = support_container.global_position
		character.hurt_box.monitorable = false

		emit_signal("host_migration_finished")
	else:
		_remigrate_to_host(host)


func remove_enemy() -> void:
	character.remove_from_group("enemies")
	character.hurt_box.set_deferred("monitorable", false)


func update_support_container():
	self.support_container = null
	for this_support_container in host.all_support_containers:
		if this_support_container.get_children().size() > 0:
			continue
		else:
			self.support_container = this_support_container
			var old_global_position = character.global_position
			character.get_parent().remove_child(character)
			support_container.add_child(character)
			character.global_position = old_global_position
