extends Node

var balance = 100
var tile_posiiton
var energy_generated = 0
var tile_hover_type = ""
var is_playing = true
var co2_emitted = 0

 
signal new_building_placed
signal building_upgraded


var LEVELS_STATS = {1:{"wind": 0.4, "sun": 0.4, "energy_required": 100000},
2:{"wind": 0.2, "sun": 1, "energy_required": 200000},
3:{"wind": 0.2, "sun": 0, "energy_required": 400000},
4:{"wind": 0.7, "sun": 0.3, "energy_required":800000},
5:{"wind": 0, "sun": 0.2, "energy_required": 1000000},
6:{"wind": 0.8, "sun": 0.7, "energy_required": 2000000},
} 



var currentLevel = LEVELS_STATS[1]
