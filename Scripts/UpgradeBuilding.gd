extends BuildingClass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_upgrade_popup_menu_id_pressed(id):
	pass # Replace with function body.


func _on_gas_timer_timeout():
	CurrentLevel.energy_generated += 1
	


func _on__solar_timer_timeout():
	CurrentLevel.energy_generated += CurrentLevel.solar["productionRate"]
	CurrentLevel.balance += 0.3*CurrentLevel.solar["productionRate"]

func _on_coal_timer_timeout():
	CurrentLevel.energy_generated += CurrentLevel.coal["productionRate"]


func _on_water_timer_timeout():
	CurrentLevel.energy_generated += CurrentLevel.water["productionRate"]


func _on_wind_timer_timeout():
	CurrentLevel.energy_generated += CurrentLevel.wind["productionRate"]

func energyToMoney():
	var money = productionRate*0.3 
