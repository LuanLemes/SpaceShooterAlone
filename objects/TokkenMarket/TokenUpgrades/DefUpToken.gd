extends TokenUpgrade

var bonus_damage_reduction: int = 3


func _ready():
	product_name = "Def Up"


func execute() -> void:
	SingletonManager.hero._hurt_box.damage_reduction += 5


func un_execute() -> void:
	pass
