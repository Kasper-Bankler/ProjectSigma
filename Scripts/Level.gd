extends Node

class_name Level

@export var wind = 0
@export var sun = 0
@export var energy_required = 0
@export var available_buildings = []
@export var max_emission = 0
@export var balance = 0
@export var energy_generated = 0


@onready var weather_multipliers={
	"wind":wind,
	"solar":sun,
	"other_type":1
}

var revenue_per_second=0
var new_building
var buildings_array=[]
var energy = 0


func _ready():
	CurrentLevel.new_building_placed.connect(on_new_building_placed)
	CurrentLevel.building_upgraded.connect(recalculate_revenue)
	var ticker: Timer = Timer.new()
	ticker.autostart = true
	ticker.wait_time = 1.0
	ticker.timeout.connect(tick)
	$".".add_child(ticker)
	
	
func tick():
	if (len(get_tree().get_nodes_in_group("buildings"))==0):
		return
	balance+=revenue_per_second
	energy=balance*0.01
	
	print(new_building)
	print(new_building.stats["productionRate"])
	print(energy*100)
	print(weather_multipliers)

func recalculate_revenue():
	print("upgraded")
	var new_revenue_per_second=0
	for building in get_tree().get_nodes_in_group("buildings"):
		new_revenue_per_second+=building.stats["productionRate"]*weather_multipliers.get(building.Name,1)
		
	revenue_per_second=new_revenue_per_second

func on_new_building_placed():
	var buildings_group=get_tree().get_nodes_in_group("buildings")
	new_building = buildings_group[len(buildings_group)-1]
	recalculate_revenue()
	print (new_building)
