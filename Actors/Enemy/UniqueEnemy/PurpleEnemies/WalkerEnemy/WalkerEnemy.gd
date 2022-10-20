extends Enemy

onready var walker_weapon: HitBoxArea2D = $Weapon/HitBoxArea2D
onready var timer: Timer = $Weapon/Timer
var weapon_colliding: bool = false  

func _ready():
	weapon.set_collision_mask_bit(0, 0)

func _on_HitBoxArea2D_area_entered(area):
	if area.team != walker_weapon.team:
		self.weapon_colliding = true
		timer.start()


func _on_HitBoxArea2D_area_exited(area):
		if walker_weapon.get_overlapping_areas().size() == 0:
			self.weapon_colliding = false


func _on_Timer_timeout():
	for area in walker_weapon.get_overlapping_areas():
		walker_weapon.apply_hit(area)
	if weapon_colliding:
		timer.start()

func set_wave(new_wave) -> void:
	.set_wave(new_wave)
	weapon.set_collision_mask_bit(0, 1)
	
