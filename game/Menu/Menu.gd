extends Control

export(AudioStream) var theme_music #set through the Inspector
var main_level_path: String = "res://game/levels/level.tscn"
onready var animator: AnimationPlayer = $AnimationPlayer


func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	BackgroundMusic.crossfade_to(theme_music)


func title_shine() -> void:
	animator.play("TitleShine")


func _on_new_game_button_pressed() -> void:
	get_tree().change_scene(main_level_path)


func _on_options_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _input(event):
	if event.is_action_pressed("test_input_1"):
		title_shine()


func _on_Quit_pressed():
	_on_quit_button_pressed()


func _on_NewGameButton_pressed():
	title_shine()
#	_on_new_game_button_pressed()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "TitleShine":
		_on_new_game_button_pressed()
