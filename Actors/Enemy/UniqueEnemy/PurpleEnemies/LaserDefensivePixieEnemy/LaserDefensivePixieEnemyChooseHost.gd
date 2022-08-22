extends State


func _ready():
	pass


func unhandled_input(event):
	return


func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	if chosse_host():
		_state_machine.transition_to("MigrateToHost")
	else:
		_state_machine.call_next_action(4)


func chosse_host() -> bool:
	var has_a_host: bool = false
	var all_enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in all_enemies:
		if enemy.support_node != null or enemy.support_number >= enemy.max_support or enemy == character:
			continue
		else:
			character.support_node.host = enemy
			enemy.support_number += 1
			has_a_host = true
			break
	return has_a_host


func	next_action() -> void:
	self.enter()


func exit() -> void:
	return
