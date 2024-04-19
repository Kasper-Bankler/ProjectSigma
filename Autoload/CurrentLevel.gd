extends Node

var balance = 100
var tile_posiiton
var energy_generated = 0
var tile_hover_type = ""
var is_playing = true
var co2_emitted = 0

 
signal new_building_placed
signal building_upgraded


var LEVELS_STATS = {1:{"wind": 1, "sun": 0.8, "energy_required": 100},
2:{"wind": 0, "sun": 0, "energy_required": 100000},
3:{"wind": 0, "sun": 0, "energy_required": 100},
4:{"wind": 0, "sun": 0, "energy_required": 100},
5:{"wind": 0, "sun": 0, "energy_required": 100},
6:{"wind": 0, "sun": 0, "energy_required": 100},
} 



var currentLevel = LEVELS_STATS[1]
