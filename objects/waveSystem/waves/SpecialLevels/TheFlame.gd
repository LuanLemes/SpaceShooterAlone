extends Wave

onready var token_market: TokenMarket = $TokenMarket



func _on_wave_entered() -> void:
	token_market.shuffle_selected_products()


func _on_wave_exited() -> void:
	pass

