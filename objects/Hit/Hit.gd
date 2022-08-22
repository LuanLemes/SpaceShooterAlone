extends Node2D
class_name Hit

var damage: float
var critical_chance: float
var color_of_the_pop_label: Color
var hit_position: Vector2

func constructor(damage: int, critical_chance: int, color_of_the_pop_label = Color.white, hit_position: = Vector2.ZERO) -> void:
	self.hit_position = hit_position
	self.damage = damage
	self.critical_chance = critical_chance
	self.color_of_the_pop_label = color_of_the_pop_label
