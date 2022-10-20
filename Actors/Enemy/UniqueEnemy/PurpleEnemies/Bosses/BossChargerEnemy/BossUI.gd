extends Control

onready var progress_bar: ProgressBar = $ProgressBar
onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	set_as_toplevel(true)
	rect_position = Vector2.ZERO


func set_boss_max_hp(value) -> void:
	progress_bar.max_value = value


func set_boss_current_hp(value) -> void:
	if progress_bar.value > value:
		_shine()
	progress_bar.value = value


func _on_BossChargerEnemy_total_hp_changed(total_hp):
	set_boss_max_hp(total_hp)


func _on_BossChargerEnemy_hp_changed(hp):
	set_boss_current_hp(hp)
	
func _shine() -> void:
	animation_player.play("shine")
