extends Node


var hero: Hero
var level: Level
var max_stacks: int = 3
var os_name = OS.get_name()
var array_of_mobile_os: Array = ["Android", "iOS", "HTML5", "UWP"]
var is_mobile: bool = update_os()
var stack_effect_duration: float = 3

func update_os() -> bool:
	var to_return = false
	for os in array_of_mobile_os:
		if os_name == os:
			to_return = true
	return to_return


