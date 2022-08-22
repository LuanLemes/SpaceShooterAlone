extends Node2D
signal reward_activated(reward_name)

var path = "res://objects/TriggerObjects/Rewards/"
var spawned_reward: TriggerObject


func _ready():
 pass


func spawn_reward(name_of_the_reward: String, location: Vector2) -> void:
	var scene_to_spawn = load(path + name_of_the_reward + ".tscn")
	spawned_reward = scene_to_spawn.instance()
	add_child(spawned_reward)
	spawned_reward.global_position = location
	spawned_reward.connect("activated", self, "on_object_activated")


func on_object_activated(reward_name) -> void:
	emit_signal("reward_activated", reward_name)
	spawned_reward.queue_free()
	spawned_reward = null

