extends Node2D
class_name TokenMarket

onready var animation_player :AnimationPlayer = $FlameAnimator
onready var control :Control =  $Control
onready var left_button: Button = $Control/Options/LeftOption/outer
onready var right_button: Button = $Control/Options/RightOption/outer 
onready var middle_button: Button = $Control/Options/MiddleOption/outer
onready var all_products = $AllProducts.get_children()
var selected_product_1: TokenUpgrade
var selected_product_2: TokenUpgrade
var selected_product_index_1: int
var selected_product_index_2: int
onready var middle_price: Label = $Control/Options/MiddleOption/Button2/MiddlePrice
onready var left_name: Label = $Control/Options/LeftOption/Button2/Name
onready var left_price: Label = $Control/Options/LeftOption/Button2/LefPrice
onready var right_name: Label = $Control/Options/RightOption/Button2/Name
onready var right_price: Label = $Control/Options/RightOption/Button2/RightPrice
onready var left_animation_player: AnimationPlayer = $LeftButtonAnim
onready var right_animation_player: AnimationPlayer = $RightButtonAnim

var shuffle_price: int = 50



func _ready():
	close_left_button()
	close_right_button()
	left_button.grab_focus()
	control.set_as_toplevel(true)
	left_button.connect("focus_entered", self, "left_focus_entered")
	left_button.connect("mouse_entered", self, "left_mouse_entered")
	left_button.connect("mouse_exited", self, "left_mouse_exited")
	left_button.connect("button_up", self, "on_left_button_up")
	
	
	right_button.connect("focus_entered", self, "right_focus_entered")
	right_button.connect("mouse_entered", self, "right_mouse_entered")
	right_button.connect("mouse_exited", self, "right_mouse_exited")
	right_button.connect("button_up", self, "on_right_button_up")
	
	
	middle_button.connect("focus_entered", self, "middle_focus_entered")
	middle_button.connect("mouse_entered", self, "middle_mouse_entered")
	middle_button.connect("mouse_exited", self, "middle_mouse_exited")
	middle_button.connect("button_up", self, "on_middle_button_up")
	

func left_mouse_exited() -> void:
	left_button.release_focus()


func left_focus_entered() -> void:
	pass


func left_mouse_entered() -> void:
	left_button.grab_focus()


func middle_mouse_exited() -> void:
	middle_button.release_focus()


func middle_focus_entered() -> void:
	pass


func middle_mouse_entered() -> void:
	middle_button.grab_focus()


func right_mouse_exited() -> void:
	right_button.release_focus()


func right_focus_entered() -> void:
	pass


func right_mouse_entered() -> void:
	right_button.grab_focus()


func _play_wavering() -> void:
	animation_player.play("WaveringFlame")


func on_left_button_up() -> void:
	_play_wavering()
	if !player_can_pay(selected_product_1.price):
		return
	close_left_button()
	selected_product_1.execute()


func on_right_button_up() -> void:
	_play_wavering()
	if !player_can_pay(selected_product_2.price):
		return
	close_right_button()
	selected_product_2.execute()


func on_middle_button_up() -> void:
	_play_wavering()
	if !player_can_pay(shuffle_price):
		return
	shuffle_selected_products()
	shuffle_price += 10
	update_shuffle_price()


func update_shuffle_price() -> void:
	middle_price.text = String(shuffle_price)


func shuffle_selected_products() -> void:

	selected_product_1 = null
	selected_product_2 = null
	
	selected_product_index_1 = -1
	selected_product_index_2 = -1
	
	selected_product_index_1 = Rng.rng.randi_range(0, all_products.size()-1)
	selected_product_index_2 = selected_product_index_1
	
	while selected_product_index_1 == selected_product_index_2:
		selected_product_index_2 = Rng.rng.randi_range(0, all_products.size()-1)
		
	selected_product_1 = all_products[selected_product_index_1]
	selected_product_2 = all_products[selected_product_index_2]
	update_labels()
	open_left_button()
	open_right_button()


func update_labels() -> void:
	left_price.text = String(selected_product_1.price)
	right_price.text = String(selected_product_2.price)
	left_name.text = String(selected_product_1.product_name)
	right_name.text = String(selected_product_2.product_name)
	middle_price.text = String(shuffle_price)


func player_can_pay(value) -> bool:
	if SingletonManager.level._tokens_count < value:
		return false
	SingletonManager.level._tokens_count -= value
	return true


func close_left_button() -> void:
	left_animation_player.play("CloseLeftButton")
	left_button.disabled = true


func open_left_button() -> void:
	if left_button.disabled: 
		left_animation_player.play_backwards("CloseLeftButton")
		left_button.disabled = false


func close_right_button() -> void:
	right_animation_player.play("RightButtonClose")
	right_button.disabled = true


func open_right_button() -> void:
	if right_button.disabled:
		right_animation_player.play_backwards("RightButtonClose")
		right_button.disabled = false



	
