extends Wave

onready var token_market: TokenMarket = $TokenMarketa
onready var challenge_market: ChallengeMarket = $ChallengeMarket
onready var warning_node: BossWarning = $WarningNode


func _ready():
	SignalManager.connect("warning_ended", self, "on_warning_ended")
	challenge_market.hide_market()


func _on_wave_entered() -> void:
	pass


func _on_wave_exited() -> void:
	pass


func on_warning_ended() -> void:
	initialize_wave_system()
	_on_wave_entered()
#	_activate_hero()


func on_boss_death() -> void:
	challenge_market.show_market()


func on_transition_ended() -> void:
	SignalManager.player_can_enter()


func _on_hero_entered_level() -> void:
	warning_node.appear()

