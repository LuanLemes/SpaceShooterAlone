extends Node2D
class_name BasicWeapon


onready var bullet_container: Node2D = $bulletcontainer
export var bullet: PackedScene
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
export var aim_error_margin: = 10
export var random_rotation: bool = false
export var rotation_to_cannon:bool = false
export var canons_path: NodePath
var all_cannons: Array
var selected_cannon = -1


func _ready():
	if canons_path:
		all_cannons = get_node(canons_path).get_children()


func shoot() -> void:
	var this_position
	if !all_cannons.empty():
		if selected_cannon == all_cannons.size()-1:
			selected_cannon = 0
		else:
			selected_cannon = selected_cannon + 1
		this_position = all_cannons[selected_cannon].global_position
	else:
		this_position = self.global_position
	
	var instanced_bullet = bullet.instance()
	
	bullet_container.add_child(instanced_bullet)
	instanced_bullet.set_as_toplevel(true)
	instanced_bullet.global_position = this_position
	
	var new_rotation
	if !rotation_to_cannon:
		new_rotation = self.global_rotation
	else:
		new_rotation = all_cannons[selected_cannon].global_rotation
	
	if random_rotation:
		new_rotation = new_rotation + new_rotation/100 * rng.randi_range(-aim_error_margin, aim_error_margin)
	instanced_bullet.global_rotation = new_rotation
	instanced_bullet.direction = Vector2.UP.rotated(new_rotation)


func destroy_all_bullets() -> void:
	for bullet in bullet_container.get_children():
		if bullet.is_in_group("bullet"):
			bullet.explode()
