extends Wave

onready var token_market: TokenMarket = $TokenMarketa
onready var challenge_market: ChallengeMarket = $ChallengeMarket
onready var warning_node: BossWarning = $WarningNode



func _ready():
	warning_node.connect("warning_ended", self, "on_warning_ended")
	challenge_market.hide_market()



func _on_wave_entered() -> void:
	warning_node.appear()


func _on_wave_exited() -> void:
	pass


func on_warning_ended() -> void:
	pass


func on_boss_death() -> void:
	challenge_market.show_market()
