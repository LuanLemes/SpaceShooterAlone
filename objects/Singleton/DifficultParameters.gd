extends Node


var init_enemy_health_factor: float = 1
var enemy_health_factor = init_enemy_health_factor

var init_enemy_damage_factor: float = 1
var enemy_damage_factor: float = init_enemy_damage_factor

var init_wisper_heal: bool = true
var wisper_heal: bool = init_wisper_heal

var init_enemy_bullet_speed: float = 1
var enemy_bullet_speed: float = init_enemy_bullet_speed

var init_enemy_delay_state: float = 1
var enemy_delay_state: float = init_enemy_delay_state

var init_bombs_are_bigger: bool = false
var bombs_are_bigger: bool = init_bombs_are_bigger

#not implemented
var init_reduced_idle_wait: bool = false
var reduced_idle_wait: bool = init_reduced_idle_wait

var init_shoot_more: bool = false
var shoot_more: bool = init_shoot_more

var init_only_one_card_option: bool = false
var only_one_card_option: bool = init_only_one_card_option


func reset() -> void:
	enemy_health_factor = init_enemy_health_factor
	enemy_damage_factor = init_enemy_damage_factor
	wisper_heal = init_wisper_heal
	enemy_bullet_speed = init_enemy_bullet_speed
	enemy_delay_state = init_enemy_delay_state
	bombs_are_bigger = init_bombs_are_bigger
	reduced_idle_wait = init_reduced_idle_wait
	shoot_more = init_shoot_more
	only_one_card_option = init_only_one_card_option
