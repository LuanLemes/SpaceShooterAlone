extends Node

var x = 0


func counting() -> void:
		while x != 999000:
			x += 1
			yield(get_tree().create_timer(15),"timeout")
