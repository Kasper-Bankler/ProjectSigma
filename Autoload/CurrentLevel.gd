extends Node

var balance = 100
var tile_posiiton
var energy_generated = 0
var tile_hover_type = ""
var is_playing = true

var level1 = {"wind": 0.1, "sun": 0.8, "energy_required": 100, "max_emission": 1000}
var level2 = {"wind": 0, "sun": 0, "energy_required": 100, "max_emission": 1000}
var level3 = {"wind": 0, "sun": 0, "energy_required": 100, "max_emission": 1000}

var currentLevel = level1


func update_balance(value):
	balance+=value
