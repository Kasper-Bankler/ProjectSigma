extends Node

signal user_updated
signal progression_cleared

var tile_posiiton
var username
var score = []

func update_user(value: int) -> void:
	score.append(value)
	#Update database
	emit_signal("user_updated")
	
func clear_progression() -> void:
	score.clear()
	# Clear user progression in database
	emit_signal("progression_cleared")
