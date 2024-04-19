extends Node

class_name Level



@export var available_buildings = []
@export var max_emission = 0
@export var balance = 0


signal level_is_complete

@onready var weather_multipliers={
	"wind":CurrentLevel.LEVELS_STATS[int(scene_file_path[25])]["wind"],
	"solar":CurrentLevel.LEVELS_STATS[int(scene_file_path[25])]["sun"],
}
@onready var energy_required = CurrentLevel.LEVELS_STATS[int(scene_file_path[25])]["energy_required"]

var revenue_per_second=0
var new_building
var buildings_upgrade_array=[]
var energy = 0
var emission=0
var emission_rate=0
var popup_container
var old_upgrade_costs=0
var bill

func _ready():
	balance=100
	CurrentLevel.balance=100
	#signals connection
	CurrentLevel.new_building_placed.connect(on_new_building_placed)

	CurrentLevel.building_upgraded.connect(_on_building_upgrade)

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
		
	if (emission_rate>0):
		emission+=emission_rate
	
		if (fmod(emission,1000)==0):
			bill=emission/50
			change_balance(-bill)
			if (len(get_tree().get_nodes_in_group("popup_message"))>0):
				get_tree().get_nodes_in_group("popup_message")[0].queue_free()
			UserData.popup_message("You have paid "+str(bill) + "$ in CO2 taxes.",$".")
			
	
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
	
		
	
func _on_building_upgrade():
	var new_upgrade_costs=0
	for building in get_tree().get_nodes_in_group("buildings"):
		
		new_upgrade_costs+=building.stats["upgradePrice"]
	
	if (new_upgrade_costs!=old_upgrade_costs):
		change_balance(old_upgrade_costs-new_upgrade_costs)
		old_upgrade_costs=new_upgrade_costs
	
	recalculate_revenue()
		
	
func on_new_building_placed():
	
	var buildings_group=get_tree().get_nodes_in_group("buildings")
	new_building = buildings_group[len(buildings_group)-1]
	
	

	change_balance(-new_building.stats.price)
	recalculate_revenue()
	if (new_building.stats.has("emissionRate")):
		emission_rate+=new_building.stats["emissionRate"]

