extends Node2D
class_name Wave

signal wave_ended
signal hero_left
signal wave_entered

onready var thick_walls: TileMap = $ThickWalls
onready var walls: TileMap = $CrateWalls
onready var floor_tilemap: TileMap = $Floor
onready var walkable_tilemap: TileMap = $Navigation2D/WalkableCells
var walkable_cells: Array
onready var border_walls: TileMap = $BorderWalls
onready var navigation_2d: Navigation2D = $Navigation2D
onready var exit_particles = $Particles2D1
onready var exit_particles2 = $Particles2D2
onready var door_animator: AnimationPlayer = $Door/AnimationPlayer
onready var door_tilemap: TileMap = $Door
onready var collectable_handler: CollectableHandler = $CollectableHandler
onready var sub_wave: SubWave = $Enemies/SubWave
var number_of_enemies:int = 0
#var current_sub_wave: int = 0
var next_subwave: SubWave
var standard_tile: int
var hero: Hero = null
onready var all_sub_waves: = $SubWaves.get_children()
onready var number_of_sub_waves = all_sub_waves.size()
onready var _player_start_position: Position2D = $PlayerStartPosition
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
export var is_boss_level: = false
var is_transition_ended: bool = false


func _ready():
	SignalManager.connect("hero_entered_level", self, "_on_hero_entered_level")
	SignalManager.connect("transition_ended", self, "on_transition_ended")
	connect("wave_ended", SignalManager, "_on_wave_ended")
	connect("hero_left", SignalManager, "_on_hero_left")
	rng.randomize()
	hero = SingletonManager.hero
	var all_heroes_nodes = get_tree().get_nodes_in_group("heroes")
	if all_heroes_nodes.size() > 0:
		hero = all_heroes_nodes[0]
	get_floor_without_walls()
	init_walkable_cells()
		


func initialize_enemy(enemy) -> void:
	if !enemy.is_movement_enemy:
		_on_enemy_moved_on_tile(Vector2(-5,-5), enemy.global_position)
	enemy.wave = self


func add_enemy(enemy) -> void:
	number_of_enemies += 1

	if !enemy.is_movement_enemy:
		_on_enemy_moved_on_tile(Vector2(-5,-5), enemy.global_position)
	enemy.wave = self

#	enemy.on_wave_ready()
#	enemy.connect("death_started",self,"_on_enemy_started_to_die")
#	enemy.connect("moved", self, "_on_enemy_moved_on_tile")


func _on_enemy_started_to_die(enemy_global_position):
	number_of_enemies -= 1
	if number_of_enemies == 0:
		emit_signal("wave_ended")
	if number_of_enemies <= -1:
		pass


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
		exit_particles2.emitting = true


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
			var walkable_cells_size = walkable_cells.size()
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


func destroy() -> void:
	collectable_handler._unexecute_all()
	queue_free()


func _on_wave_entered() -> void:
	emit_signal("wave_entered")


func _on_wave_exited() -> void:
	pass


func initialize_wave_system() -> void:
	insert_wave_references()
	define_and_connect_all_enemies()
	define_and_init_current_sub_wave()



func start_sub_wave(sub_wave: SubWave) -> void:
	sub_wave.visible = true
	for enemy in sub_wave.get_children():
		initialize_enemy(enemy)


func define_and_init_current_sub_wave() -> void:
	start_sub_wave(all_sub_waves[0])


func _on_sub_wave_ready_to_start(sub_wave: SubWave):
	start_sub_wave(sub_wave)


func insert_wave_references() -> void:
	for i in all_sub_waves.size():
		all_sub_waves[i].connect("ready_to_start", self, "_on_sub_wave_ready_to_start")
		if i < all_sub_waves.size()-1:
			all_sub_waves[i+1].last_subwave = all_sub_waves[i]
			all_sub_waves[i].next_subwave = all_sub_waves[i+1]


func define_and_connect_all_enemies() -> void:
	for this_sub_wave in all_sub_waves:
		number_of_enemies += this_sub_wave.current_number_of_enemies
		for enemy in this_sub_wave.get_children():
			enemy.connect("death_started",self,"_on_enemy_started_to_die")
			enemy.connect("moved", self, "_on_enemy_moved_on_tile")


func on_transition_ended() -> void:
	SignalManager.player_can_enter()
	is_transition_ended = true


func _on_hero_entered_level() -> void:
		initialize_wave_system()
		_on_wave_entered()
		_activate_hero()


func _activate_hero() -> void:
	SingletonManager.hero.is_active = true

