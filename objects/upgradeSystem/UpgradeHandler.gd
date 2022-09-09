extends Node2D


var current_state: int = 0 setget set_current_state
enum {BUY, UPGRADE}

var hero: Hero setget set_hero

onready var cards_animation_player: AnimationPlayer = $AnimationPlayer
onready var button1: = $ColorRect/ButtonsHBoxContainer/Button
onready var all_buttons = $ColorRect/ButtonsHBoxContainer.get_children()
onready var upgrade_container = $UpgradeContainer
onready var color_rect = $ColorRect
onready var unsorted_container = $UpgradeContainer/UnsortedContainer.get_children()
onready var active_upgrades_container = $UpgradeContainer/UpgradesActive
var all_upgrades = []
var non_bought_upgrades: Array
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var upgrade_selected1: Upgrade
var upgrade_selected2: Upgrade
var upgrade_selected3: Upgrade
var all_rarities: Array


func _ready():
	_show_cards_animation()
	SignalManager.connect("upgrade_activated", self, "on_upgrade_activated")
	SignalManager.connect("upgrade_duplicated", self, "_on_upgrade_duplicated")
	rng.randomize()
	all_upgrades.append_array(unsorted_container)
	non_bought_upgrades = all_upgrades
	set_containers()

	for button in $ColorRect/ButtonsHBoxContainer.get_children():
		button.connect("upgrade_button_pressed", self, "upgrade_button_pressed")


func chosse_upgrades_to_buy() -> void:
	set_current_state(BUY)
	for button in all_buttons:
		var this_button: UpgradeButton = button
		this_button.clean_button()
	
	
	var buttons_filled: int = 0
	while buttons_filled < 3:
#		var random_upgrade_index = rng.randi_range(0, 4)
		var this_upgrade = chosse_upgrade()
		if this_upgrade.is_unlocked and !this_upgrade.is_activated:
			if !is_upgrade_in_button(this_upgrade):
				all_buttons[buttons_filled].fill_fields(this_upgrade)
				all_buttons[buttons_filled].index_of_upgrade = buttons_filled
				buttons_filled += 1


func chosse_upgrade_rarity() -> String:
	var rarity_chance = rng.randi_range(1,100)
	var rarity
	if rarity_chance <= 83:
		rarity = "Commom"
	elif rarity_chance >83 and rarity_chance <= 93:
		rarity = "Rare"
	elif rarity_chance > 93 and rarity_chance <=98:
		rarity = "VeryRare"
	elif rarity_chance > 97:
		rarity = "Epic"
	return rarity


func chosse_upgrade() -> Upgrade:
	var rarity_of_the_chossen_upgrade = chosse_upgrade_rarity()
	var index_of_the_given_rarity = all_rarities.find(rarity_of_the_chossen_upgrade)
	var chossen_upgrade: Upgrade
	var rarity_upgrade_container
	while index_of_the_given_rarity >= 0:
		if !upgrade_container.has_node(rarity_of_the_chossen_upgrade):
			index_of_the_given_rarity -= 1
			rarity_of_the_chossen_upgrade = all_rarities[index_of_the_given_rarity]
			continue
		else:
			rarity_upgrade_container = upgrade_container.get_node(rarity_of_the_chossen_upgrade)
			index_of_the_given_rarity -= 1
			rarity_of_the_chossen_upgrade = all_rarities[index_of_the_given_rarity]
		
		if rarity_upgrade_container.get_child_count() == 0:
			continue
		else:
			var all_upgrades_from_this_rarity = rarity_upgrade_container.get_children()
			var index_of_the_given_upgrade = rng.randf_range(0 , all_upgrades_from_this_rarity.size())
			chossen_upgrade = all_upgrades_from_this_rarity[index_of_the_given_upgrade]
			break
	return chossen_upgrade


func is_upgrade_in_button(upgrade) -> bool:
	var upgrade_already_used: bool = false
	for button in all_buttons:
		var this_upgrade_button: UpgradeButton = button
		if upgrade == this_upgrade_button.upgrade:
			upgrade_already_used = true
	return upgrade_already_used



func chosse_upgrades_to_upgrade() -> void:
	set_current_state(UPGRADE)
	var all_puchased_upgrades = active_upgrades_container.get_children()
	
	for button in all_buttons:
		var this_button: UpgradeButton = button
		this_button.clean_button()
	
	var buttons_filled : int = 0
	
	while buttons_filled < 3:
		var this_upgrade: Upgrade
		this_upgrade = all_puchased_upgrades[Rng.rng.randi_range(0, all_puchased_upgrades.size()-1 )]
		if this_upgrade.is_activated and this_upgrade._upgrade_level == 0:
			if !is_upgrade_in_button(this_upgrade):
				all_buttons[buttons_filled].fill_fields_to_upgrade(this_upgrade)
				buttons_filled += 1



func unlock_unique_secondary_upgrades(type: String) -> void:
#	var unique_container = upgrade_container.get_node(upgrade.Rarity.keys()[upgrade.rarity])
	var type_container = upgrade_container.get_node(type)
	var upgrades_to_unlock = type_container.get_children()
	for upgrade in upgrades_to_unlock:
		upgrade.is_unlocked = true


func upgrade_button_pressed(button) -> void:
	match current_state:
		UPGRADE:
			upgrade_the_upgrade_clicked(button)
		BUY:
			buy_upgrade_clicked(button)
	
#	button.fill_camps(button.upgrade)


func upgrade_the_upgrade_clicked(button) -> void:
	button.upgrade.upgrade()
	button._play_upgrade_animation()



func buy_upgrade_clicked(button) -> void:
	button.upgrade.buy()
	button._play_upgrade_animation()

	


func set_hero(new_hero: Hero) -> void:
	hero = new_hero
	for upgrade in all_upgrades:
		upgrade.hero = hero




func set_containers() -> void:
	for upgrade in all_upgrades:
		upgrade.get_parent().remove_child(upgrade)
		if !upgrade_container.has_node(upgrade.Rarity.keys()[upgrade.rarity]):
			var new_unique_container = Node.new()
			new_unique_container.name = upgrade.Rarity.keys()[upgrade.rarity]
			upgrade_container.add_child(new_unique_container)
			new_unique_container.add_child(upgrade)
		else:
			var unique_container = upgrade_container.get_node(upgrade.Rarity.keys()[upgrade.rarity])
			unique_container.add_child(upgrade)
	for types in all_upgrades[0].Rarity:
		all_rarities.append(types)



func _on_upgrade_unlock_secondary(type: String) -> void:
	unlock_unique_secondary_upgrades(type)


func set_current_state(new_value) -> void:
	current_state = new_value
	

func _unhandled_input(event):
	if event.is_action_pressed("test_input_4"):
		chosse_upgrades_to_upgrade()


func _on_upgrade_duplicated(upgrade_duplicated) -> void:
	upgrade_duplicated.hero = hero
	all_upgrades.append(upgrade_duplicated)


func on_upgrade_activated(upgrade: Upgrade) -> void:
	upgrade.get_parent().remove_child(upgrade)
	active_upgrades_container.add_child(upgrade)


func _show_cards_animation() -> void:
	cards_animation_player.play("Show Cards")


func _hide_cards_animation() -> void:
	cards_animation_player.play_backwards("Show Cards")













