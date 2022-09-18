extends TokenUpgrade

var bonus_attack: int = 20


func _ready():
	product_name = "Atk Up"


func execute() -> void:
	SingletonManager.hero.hero_weapon._base_damage += bonus_attack


func un_execute() -> void:
	pass
