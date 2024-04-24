extends Node

class_name Level


signal level_is_complete


@export var balance = 0
@onready var weather_multipliers={
	"wind":CurrentLevel.LEVELS_STATS[int(scene_file_path[25])]["wind"],
	"solar":CurrentLevel.LEVELS_STATS[int(scene_file_path[25])]["sun"],
}
@onready var energy_required = CurrentLevel.LEVELS_STATS[int(scene_file_path[25])]["energy_required"]
var revenue_per_second=0
var new_building
var energy = 0
var emission=0
var popup_container
var old_upgrade_costs=0
var bill
var coal_count=0
var tick_count=0

func _ready():
	add_to_group("level")
	CurrentLevel.currentLevel = CurrentLevel.LEVELS_STATS[int(scene_file_path[25])]
	balance=100
	CurrentLevel.balance=balance
	#signals connection
	CurrentLevel.new_building_placed.connect(on_new_building_placed)


	var popup_container=Control.new()
	$".".add_child(popup_container)
	
	#ticker setup
	var ticker: Timer = Timer.new()
	ticker.autostart = true
	ticker.wait_time = 1.0
	ticker.timeout.connect(tick)
	$".".add_child(ticker)
	
func tick():
	
	if (!CurrentLevel.is_playing):
		return

	if (len(get_tree().get_nodes_in_group("buildings"))==0):
		return

	if (coal_count>0):
		tick_count+=1
		if (fmod(tick_count,10)==0):
			bill=coal_count*50
			emission+=coal_count*10
			change_balance(-bill)
			if (len(get_tree().get_nodes_in_group("popup_message"))>0):
				get_tree().get_nodes_in_group("popup_message")[0].queue_free()
			UserData.popup_message("Du har betalt  "+str(bill) + "$ i CO2-afgifter.",$".")
			
	
	change_balance(revenue_per_second*0.1)
	energy=energy+revenue_per_second*0.1
	
	if (energy>= energy_required):
		emit_signal("level_is_complete")
		CurrentLevel.is_playing=false
	


func change_balance(value):

	balance+=value
	CurrentLevel.balance=balance

func recalculate_revenue():
	var new_revenue_per_second=0

	for building in get_tree().get_nodes_in_group("buildings"):
		

		new_revenue_per_second+=building.stats["productionRate"]*(1+weather_multipliers.get(building.Name,0))

	revenue_per_second=new_revenue_per_second
	
		
	


func on_new_building_placed():
	var buildings_group=get_tree().get_nodes_in_group("buildings")
	new_building = buildings_group[len(buildings_group)-1]
	if (new_building.stats["emissionRate"]>0):
		coal_count+=1
	change_balance(-new_building.stats.price)
	recalculate_revenue()

