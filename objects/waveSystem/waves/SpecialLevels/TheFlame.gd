extends Wave

onready var token_market: TokenMarket = $TokenMarket



func _on_wave_entered() -> void:
	token_market.shuffle_selected_products()
	yield(get_tree().create_timer(0.2), "timeout")
	open_one_exit_door()


func _on_wave_exited() -> void:
	pass

