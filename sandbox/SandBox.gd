extends Node

enum Unique_Types{Commom, Rare, VeryRare, Epic, Legendary, UltraLegendary, MegaLegendary, CaoticLegendary, OMGThisThinkEverEnds}
export (Unique_Types) var unique_type = Unique_Types.Commom
onready var one = $Sprite



func _input(event):
	if event.is_action_pressed("test_input_1"):
		add_child(one.duplicate(15))
		add_child(one.duplicate(1))
