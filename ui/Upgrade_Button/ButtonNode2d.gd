extends Node2D
class_name UpgradeButton
signal upgrade_button_pressed(button)
signal upgrade_animation_ended
signal upgrade_animation_started
signal upgrade_animation_finished


#onready var label_name = $Button/Button/VBoxContainer/Name
onready var label_name = $Button/VBoxContainer/Name
onready var ui_effect = $Button/VBoxContainer/Effect
onready var atribute_description = $Button/VBoxContainer/Atribute_descrption
onready var upgrade_description: Label = $Button/VBoxContainer/Upgrade_descrption
onready var label_bonus_1 = $Button/VBoxContainer/Bonus1
onready var label_bonus_2 = $Button/VBoxContainer/Bonus2
onready var label_bonus_3 = $Button/VBoxContainer/Bonus3
onready var type_label = $Button/Type
onready var animation_player :AnimationPlayer = $Button/AnimationPlayer
onready var _tween = $Button/Tween
onready var _button: Button = $Button
onready var rarity_label: Label = $Button/Rarity
#onready var reference: Label = $Button/VBoxContainer/Reference

var upgrade: Upgrade
var index_of_upgrade: int


func _ready():
	animation_player.connect("animation_finished", self, "upgrade_animation_finished")
	animation_player.connect("animation_started", self, "upgrade_animation_started")
	connect("upgrade_animation_started", SignalManager, "upgrade_animation_finished")
	connect("upgrade_animation_started", SignalManager, "upgrade_animation_started")


func upgrade_animation_finished(animation_name: String) -> void:
	emit_signal("upgrade_animation_finished")


func upgrade_animation_started(animation_name: String) -> void:
	emit_signal("upgrade_animation_started")


func fill_fields(upgrade) -> void:
	upgrade_description.visible = false
	clean_button()
	upgrade.update_labels()
	self.upgrade = upgrade
	label_name.text = String(upgrade._up_name)
	ui_effect.text = "Effect: " + String(upgrade._up_effect)
	atribute_description.text = upgrade._atribute_description
	type_label.text = upgrade.Types.keys()[upgrade.type]
	rarity_label.text = upgrade.Rarity.keys()[upgrade.rarity]
	


func fill_fields_to_upgrade(upgrade) -> void:
	upgrade_description.visible = true
	clean_button()
	upgrade.update_labels()
	self.upgrade = upgrade
	label_name.text = String(upgrade._up_name)
	ui_effect.text = "Effect: " + String(upgrade._up_effect)
	upgrade_description.text = "Upgrade Effect: " + String(upgrade._up_effect1)
	atribute_description.text = upgrade._atribute_description


func clean_button() -> void:
	upgrade = null
	label_name.text = ""
	ui_effect.text = ""
	label_bonus_1.text = ""
	label_bonus_2.text = ""
	label_bonus_3.text = ""  
	atribute_description.text = ""
	upgrade_description.text = ""


func _on_Button_button_up():
	emit_signal("upgrade_button_pressed", self)


func _play_upgrade_animation():
	$Button/AnimationPlayer.play("shine")


func update_fields():
	fill_fields(upgrade)


func _on_Button_focus_entered():
	_get_bigger_animation()


func _on_Button_mouse_entered():
	_get_bigger_animation()


func _get_bigger_animation() -> void:
	z_index = 1
	_tween.interpolate_property(_button, "rect_scale", _button.rect_scale ,Vector2(1.3,1.3), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN )
	_tween.start()
	
	
func _return_to_original_size() -> void:
	z_index = 0
	_tween.interpolate_property(_button, "rect_scale", _button.rect_scale ,Vector2(1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN )
	_tween.start()



func _on_Button_focus_exited():
	_return_to_original_size()


func _on_Button_mouse_exited():
	_return_to_original_size()
	_button.focus_mode
