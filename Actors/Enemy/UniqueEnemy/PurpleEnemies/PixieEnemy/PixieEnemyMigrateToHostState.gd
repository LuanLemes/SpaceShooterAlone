extends State

var migration_faild = true

func _ready():
	pass


func unhandled_input(event):
	return


func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	migration_faild = true
	character.support_node._migrate_to_host(character.support_node.host)
	character.support_node.connect("host_migration_finished", self, "on_migration_finished")


func exit() -> void:
	if migration_faild:
		character.support_node.host.support_number -= 1


func on_migration_finished() -> void:
	migration_faild = false
	_state_machine.transition_without_delay("SupportIdle")


