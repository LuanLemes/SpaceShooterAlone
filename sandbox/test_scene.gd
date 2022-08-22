extends Node2D

enum Teams{PLAYER, ENEMY}
export (Teams) var team:= Teams.ENEMY



func _ready():
	print(Teams.keys()[team])
