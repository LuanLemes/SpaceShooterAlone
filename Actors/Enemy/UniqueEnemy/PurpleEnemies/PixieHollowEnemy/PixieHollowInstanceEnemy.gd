extends State

export (Array, PackedScene) var scenes_to_stance
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_instanced
func _ready():
	rng.randomize()





func physics_process(delta):
	pass


func enter(msg: Dictionary = {}) -> void:
	character.animation_player1.play("ChargeCenter")
	instance_random_enemy()



func on_pixie_migration_finished() -> void:
	if _state_machine.state != self:
		return
	character.animation_player1.play("Uncharge")
	enemy_instanced.disconnect("death_started", self, "on_pixie_migration_finished")
	enemy_instanced.support_node.disconnect("host_migration_finished", self, "on_pixie_migration_finished")
	_state_machine.transition_without_delay("Idle")


func exit() -> void:
	pass

func _on_timer_timeout() -> void:
	pass


func on_charge_animation_finished(animation_name) -> void:
	pass


func instance_random_enemy() -> void:
	if scenes_to_stance.size() == 0:
		return
	var index_of_enemy_to_instance = rng.randi_range(0, scenes_to_stance.size()-1)
	enemy_instanced = scenes_to_stance[index_of_enemy_to_instance].instance()
	character.get_parent().add_child(enemy_instanced)
	character.wave.add_enemy(enemy_instanced)
	enemy_instanced.global_position = character.center_sprite.global_position
	enemy_instanced.connect("death_started", self, "on_pixie_migration_finished")
	enemy_instanced.support_node.connect("host_migration_finished", self, "on_pixie_migration_finished")
	
	
#	stays until finds host
#  but the pixie can die....
#  on pixie death make another pixie

