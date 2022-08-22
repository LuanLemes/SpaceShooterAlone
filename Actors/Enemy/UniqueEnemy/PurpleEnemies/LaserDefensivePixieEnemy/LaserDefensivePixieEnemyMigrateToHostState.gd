extends State


func _ready():
	pass


func unhandled_input(event):
	return


func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	character.support_node._migrate_to_host(character.support_node.host)
	character.support_node.connect("host_migration_finished", self, "on_migration_finished")


func exit() -> void:
	return


func on_migration_finished() -> void:
	_state_machine.transition_to("SupportIdle")


