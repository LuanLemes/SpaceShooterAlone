extends Node
class_name Upgrade

signal upgrade_duplicated(upgrade)
signal unlock_secondary(secondary_type)
#signal on_hero_left(upgrade)


enum Types {Normal, Poison, Fire, Water, Ice}
export (Types) var type = Types.Normal

enum Unique_Types{Commom, Rare, VeryRare, Epic}
export (Unique_Types) var unique_type = Unique_Types.Commom

#enum Teams{PLAYER, ENEMY}
#export (Teams) var team := Teams.ENEMY

var hero: Hero

var _up_name: String = ""
var _up_effect: String = ""
var _up_effect1: String = ""
export var _number_of_cards: int = 1
#var _atribute_bonus: float = 0

var _bonus_1: String = ""
var _bonus_2: String = ""
var _bonus_3: String = ""
var _scene_path: String = ""
var _atribute_description: String = ""
#var category: = 

var _upgrade_level: = 0

# if is already selected to be shown to the player on ui
export var is_selected: bool = false
# if the upgrade have already been bought by the player
export var is_activated: bool = false
# if the upgrade has be unlocked by the player
export var is_unlocked: bool = true
#export var is_signal_connect: bool = false

var is_bonus_1: bool = false
var is_bonus_2: bool = false
var is_bonus_3: bool = false


func _ready() -> void:
	connect("upgrade_activated", SignalManager, "on_upgrade_activated")


func initialize() -> void:

	
	if _number_of_cards > 1:
		_number_of_cards -= 1
		var duplicate: Upgrade = duplicate()
		duplicate._number_of_cards = self._number_of_cards
		get_parent().add_child(duplicate)
		duplicate.connect("upgrade_duplicated", SignalManager, "_on_upgrade_duplicated")
		duplicate.emit_signal("upgrade_duplicated", duplicate)
		
	is_activated = true
	on_buy_effect()
	emit_signal("upgrade_activated", self)


func on_buy_effect() -> void:
	pass


func on_upgrade_effect1() -> void:
	pass


func execute() -> void:
	_execute()
	
	
func unexecute() -> void:
	_unexecute()


func _execute() ->void:
	pass


func _unexecute() -> void:
	pass


func upgrade_execute():
	_upgrade_level += 1
	_upgrade_execute()


func _upgrade_execute():
	pass


func upgrade_unexecute():
	_upgrade_unexecute()


func _upgrade_unexecute():
	pass


func update_labels() -> void:
	pass


func buy() -> void:
	if !is_activated:
		initialize()



func add_status_on_hero_weapon(status_name: String) -> void:
	hero.hero_weapon.add_status(status_name)
	hero.status_storage.add_status(status_name)
	emit_signal("unlock_secondary", String(Types.keys()[type]) )

#
func upgrade() -> void:
	on_upgrade_effect1()
