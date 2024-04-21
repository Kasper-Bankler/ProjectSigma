extends Node

var balance = 100
var tile_posiiton
var energy_generated = 0
var tile_hover_type = ""
var is_playing = true
var co2_emitted = 0

 
signal new_building_placed
signal building_upgraded


var LEVELS_STATS = {1:{"wind": 0.4, "sun": 0.4, "energy_required": 100, "level": 1},
2:{"wind": 0.2, "sun": 1, "energy_required": 5000, "level": 2},
3:{"wind": 0.2, "sun": 0, "energy_required": 1000, "level": 3},
4:{"wind": 0.7, "sun": 0.3, "energy_required":10000, "level": 4},
5:{"wind": 0, "sun": 0.2, "energy_required": 40000, "level": 5},
6:{"wind": 0.8, "sun": 0.7, "energy_required": 50000, "level": 6},
} 

var currentLevel = LEVELS_STATS[1]
