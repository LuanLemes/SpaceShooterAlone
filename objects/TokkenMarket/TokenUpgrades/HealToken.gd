extends TokenUpgrade

var heal_percentage: int = 100


func _ready():
	product_name = "Heal"


func execute() -> void:
	SingletonManager.hero.get_percentage_heal(heal_percentage)


func un_execute() -> void:
	pass
