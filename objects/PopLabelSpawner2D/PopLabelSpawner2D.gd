extends Position2D
class_name PopLabelSpawner2D

signal spawned(spawn)


export var spawn_scene: PackedScene
export var value_to_display = 200
export var horizontal_variation: int = 50
var spawling: PopLabel
var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()


func generate_random_position() -> Vector2:
	var random_horizontal_variation:float = rng.randi_range(-horizontal_variation, horizontal_variation)
	var random_spawn_location: = self.global_position + Vector2(random_horizontal_variation, 0)
	return random_spawn_location


func spawn(color: Color = Color.white, text_value: String = "100", is_critical: bool = false):
	spawling = spawn_scene.instance()
	get_parent().add_child(spawling)
	spawling.label.text = text_value
	spawling.set_as_toplevel(true)
	spawling.global_position = generate_random_position()
	
	if is_critical:
		spawling.label.text = String(spawling.label.text + "!")
		spawling.modulate = Color.red
		spawling.tween_critical()
		
	else:
		spawling.modulate = color
		spawling.tween_normal()
	emit_signal("spawned", self)



