extends Node

class_name Level

@export var wind = 0
@export var sun = 0
@export var energy_required = 0
@export var available_buildings = []
@export var max_emission = 0
@export var balance = 0
@export var energy_generated = 0


func _ready():
	$HUD.update_weather(0.7,0.4)
	$HUD.update_energy(0)
	

	
func update_emission():
	pass
	

