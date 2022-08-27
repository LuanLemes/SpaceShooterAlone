extends Node2D
class_name Wave

signal wave_ended
signal hero_left

onready var thick_walls: TileMap = $ThickWalls
onready var walls: TileMap = $CrateWalls
onready var floor_tilemap: TileMap = $Floor
onready var walkable_tilemap: TileMap = $Navigation2D/WalkableCells
var walkable_cells: Array
onready var border_walls: TileMap = $BorderWalls
onready var navigation_2d: Navigation2D = $Navigation2D
onready var all_enemies = $Enemies.get_children()
onready var exit_particles = $Particles2D2
onready var door_animator: AnimationPlayer = $Door/AnimationPlayer
onready var door_tilemap: TileMap = $Door
var number_of_enemies = 0
var standard_tile: int
var hero: Hero = null
onready var _player_start_position: Position2D = $PlayerStartPosition
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
export var is_boss_level: = false


func _ready():
	connect("wave_ended", SignalManager, "_on_wave_ended")
	connect("hero_left", SignalManager, "_on_hero_left")
	rng.randomize()
	var all_heroes_nodes = get_tree().get_nodes_in_group("heroes")
	if all_heroes_nodes.size() > 0:
		hero = all_heroes_nodes[0]
	get_floor_without_walls()
	init_walkable_cells()
#	print(walkable_tilemap.world_to_map(Vector2(539,1570)))



	number_of_enemies = all_enemies.size()
	for enemy in all_enemies:
		initialize_enemy(enemy)


func initialize_enemy(enemy) -> void:
	enemy.wave = self

	if !enemy.is_movement_enemy:
		_on_enemy_moved_on_tile(Vector2(-5,-5), enemy.global_position)

	enemy.on_wave_ready()
	enemy.connect("death_started",self,"_on_enemy_died")
#	enemy.connect("died",self,"_on_enemy_died")
	enemy.connect("moved", self, "_on_enemy_moved_on_tile")


func add_enemy(enemy) -> void:
	number_of_enemies += 1
	enemy.wave = self

	if !enemy.is_movement_enemy:
		_on_enemy_moved_on_tile(Vector2(-5,-5), enemy.global_position)

	enemy.on_wave_ready()
	enemy.connect("death_started",self,"_on_enemy_died")
#	enemy.connect("died",self,"_on_enemy_died")
	enemy.connect("moved", self, "_on_enemy_moved_on_tile")


func _on_enemy_died():
	number_of_enemies -= 1
	if number_of_enemies <= 0:
		emit_signal("wave_ended")


func _on_object_destroyed() -> void:
	emit_signal("object_destroyed")


func open_one_exit_door() -> void:
	door_animator.play("DoorGlowing")
	yield(door_animator, "animation_finished")
	SignalManager.camera_shake_requested()
	for x in range(11,16):
#		yield(get_tree().create_timer(0.34), "timeout")
		border_walls.set_cell(x, 0, -1)
		thick_walls.set_cell(x, 0, -1)
		door_tilemap.set_cell(x, 0, -1)
		exit_particles.emitting = true
#		camera_shake_requested
		


func _on_Area2D_area_entered(area):
	player_left()


func player_left() -> void:
	emit_signal("hero_left")


func get_floor_without_walls() -> void:
	var wall_cells = walls.get_used_cells()
	var border_cells = border_walls.get_used_cells()
	var thick_walls_cells = thick_walls.get_used_cells()

	for cell in wall_cells:
		walkable_tilemap.set_cell(cell.x, cell.y, -1)
	for cell in border_cells:
		walkable_tilemap.set_cell(cell.x, cell.y, -1)
	for cell in thick_walls_cells:
		walkable_tilemap.set_cell(cell.x, cell.y, -1)


func init_walkable_cells() -> void:
	var number_of_walkable_cells = walkable_tilemap.get_used_cells().size()
	for i in range(number_of_walkable_cells):
		walkable_cells.append(0)


func _on_enemy_moved_on_tile(last_position: Vector2,new_position: Vector2) -> void:
	if last_position == new_position:
		return
	var last_position_on_tile = walkable_tilemap.world_to_map(last_position)
	var new_position_on_tile = walkable_tilemap.world_to_map(new_position)
	var i: int = 0

	for this_cell in walkable_tilemap.get_used_cells():
		if this_cell == last_position_on_tile:
			walkable_cells[i] -= 1
			if walkable_cells[i] == 0:
				walkable_tilemap.set_cell(last_position_on_tile.x,last_position_on_tile.y, 0)

		if this_cell == new_position_on_tile:
			walkable_cells[i] += 1
			if walkable_cells[i] > 0:
				walkable_tilemap.set_cell(new_position_on_tile.x, new_position_on_tile.y, 1)
		i += 1


func get_random_walkable_cell_location() -> Vector2:
	var random_walkable_cell_position: Vector2
	var random_walkable_cell_number

	var type_of_cell: int = 1
	while type_of_cell == 1:
		random_walkable_cell_number = rng.randi_range(0, walkable_cells.size() -1)
		random_walkable_cell_position =to_global(walkable_tilemap.get_used_cells()[random_walkable_cell_number])
		type_of_cell = walkable_tilemap.get_cell(random_walkable_cell_position.x, random_walkable_cell_position.y)

	random_walkable_cell_position = to_global(walkable_tilemap.map_to_world(random_walkable_cell_position))
	return random_walkable_cell_position


