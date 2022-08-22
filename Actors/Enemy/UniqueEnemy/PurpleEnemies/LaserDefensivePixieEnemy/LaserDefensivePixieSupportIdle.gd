extends State


export var laser_node_path: NodePath
export var max_number_of_lasers = 3
onready var laser_cooldown: Timer = $LaserCooldown
var laser
var laser_count = 0


func _ready():
	laser_cooldown.connect("timeout", self, "on_cooldown_timeout")


func unhandled_input(event):
	return


func physics_process(delta):
#	aim(delta)
	pass


func enter(msg: Dictionary = {}) -> void:
	pass
#	character.support_node._migrate_to_host(character.support_node.host)
#	character.support_node.connect("host_migration_finished", self, "on_migration_finished")


func exit() -> void:
	return


func on_migration_finished() -> void:
	_state_machine.transition_to("SupportIdle")


func _on_BulletDetector_body_shape_entered(body_id, body, body_shape, local_shape):
	turn_laser_on(body)


func turn_laser_on(body) -> void:
	if _state_machine.state != self:
		return
	if laser.is_casting == true or laser_count >= max_number_of_lasers:
		return
	laser.target_location = body.global_position
	laser.is_casting = true
	body.queue_free()
	laser_count += 1
	start_timer(0.2)
	if laser_count >= max_number_of_lasers:
		laser_cooldown.start()


func initialize() -> void:
	laser = get_node(laser_node_path)
	laser.is_target_point = true
	

func _on_timer_timeout() -> void:
	turn_laser_off()


func turn_laser_off() -> void:
	laser.is_casting = false


func aim(delta) -> void:
#	if !_is_rotating:
#		return
	var angle_delta = 50 * delta

	var v = character.wave.hero.global_position - laser.global_position
	var angle = v.angle() 
	var r = laser.global_rotation
	angle = lerp_angle(r, angle, 1)
	angle = clamp(angle, r - angle_delta, r + angle_delta)
	laser.global_rotation = angle
	
func on_cooldown_timeout() -> void:
	laser_count = 0
