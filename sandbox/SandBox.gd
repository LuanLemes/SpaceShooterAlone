extends Node2D

var wrapednumber :int = wrapi(0, 0, 10)

#func _ready():

func _process(delta):
	wrapednumber = wrapi(wrapednumber + 1, 0, 10)
	print(wrapednumber)
	


