extends Button
#class_name UpgradeButton
signal upgrade_button_pressed(button)
signal upgrade_animation_ended
signal upgrade_animation_started
signal upgrade_animation_finished


onready var label_name = $VBoxContainer/Name
onready var ui_effect = $VBoxContainer/Effect
onready var atribute_description = $VBoxContainer/Atribute_descrption
onready var upgrade_description: Label = $VBoxContainer/Upgrade_descrption
onready var label_bonus_1 = $VBoxContainer/LabelVBoxContainer/Bonus1
onready var label_bonus_2 = $VBoxContainer/LabelVBoxContainer/Bonus2
onready var label_bonus_3 = $VBoxContainer/LabelVBoxContainer/Bonus3
onready var animation_player :AnimationPlayer = $AnimationPlayer
onready var _tween = $Tween
#onready var reference: Label = $VBoxContainer/Reference

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
	$AnimationPlayer.play("shine")


func update_fields():
	fill_fields(upgrade)


func _on_Button_focus_entered():
	_get_bigger_animation()


func _on_Button_mouse_entered():
	_get_bigger_animation()


func _get_bigger_animation() -> void:
	_tween.interpolate_property(self, "rect_scale", rect_scale ,Vector2(1.3,1.3), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN )
	_tween.start()
	
	
func _return_to_original_size() -> void:
	_tween.interpolate_property(self, "rect_scale", rect_scale ,Vector2(1, 1), 0., Tween.TRANS_LINEAR, Tween.EASE_IN )
	_tween.start()


func _process(delta):
	print(rect_scale)


func _on_Button_focus_exited():
	_return_to_original_size()


func _on_Button_mouse_exited():
	_return_to_original_size()
