extends CanvasLayer

signal place_building(building)
var building_selected = ""

func _ready():
	update_weather(CurrentLevel.currentLevel["sun"], CurrentLevel.currentLevel["wind"])

func _process(delta):
	update_balance()
	update_energy()
	updata_buy_menu()
	check_level_complete()

func check_level_complete():
	if CurrentLevel.energy_generated >= CurrentLevel.currentLevel["energy_required"]:
		$LevelCompletePopup.visible = true
		$EnergyProgressBar.visible = false
		$CoinLabel.visible = false
		$WeatherPanelContainer.visible = false
		$PausePopup.visible = false
		$CartButton.visible = false
		$PauseButton.visible = false

func update_balance():
	$CoinLabel.text = str(CurrentLevel.balance)
	
func update_energy():
	$EnergyProgressBar.value = CurrentLevel.energy_generated

func updata_buy_menu():
	var balance = CurrentLevel.balance
	if balance < CurrentLevel.coal["price"]:
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Coal.disabled = true
	if balance < CurrentLevel.solar["price"]:
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Solar.disabled = true
	if balance < CurrentLevel.wind["price"]:
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Wind.disabled = true
	if balance < CurrentLevel.water["price"]:
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Water.disabled = true
	if balance < CurrentLevel.bio["price"]:
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Bio.disabled = true
	if balance < CurrentLevel.nuclear["price"]:
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Nuclear.disabled = true
	else:
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Coal.disabled = false
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Solar.disabled = false
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Wind.disabled = false
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Water.disabled = false
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Bio.disabled = false
		$BuildingPanelContainer/BuildingPanel/HBoxContainer/Nuclear.disabled = false

func update_weather(sun, wind):
	if sun==0:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol1/Cloud.visible = true
	elif sun<0.5:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol1/CloudSun.visible = true
	else:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol1/Sun.visible = true
	if wind==0:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol2/NoWind.visible = true
	elif wind<0.5:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol2/Wind.visible = true
	else:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol2/Tornado.visible = true

func _on_pause_button_pressed():
	$PausePopup.visible = true

func _on_cart_button_pressed():
	$CartButton.visible = false
	$BuildingPanelContainer.visible = true

func _on_close_button_pressed():
	$CartButton.visible = true
	$BuildingPanelContainer.visible = false

func _on_coal_pressed():
	select_building("coal")

func _on_solar_pressed():
	select_building("solar")

func _on_wind_pressed():
	select_building("wind")

func _on_water_pressed():
	select_building("water")

func _on_bio_pressed():
	select_building("bio")

func _on_nuclear_pressed():
	select_building("nuclear")

func _on_coal_mouse_entered():
	update_popup(CurrentLevel.coal["name"], CurrentLevel.coal["price"], CurrentLevel.coal["productionRate"], CurrentLevel.coal["emissionRate"])

func _on_coal_mouse_exited():
	$PopupPanel.visible = false

func _on_solar_mouse_entered():
	update_popup(CurrentLevel.solar["name"], CurrentLevel.solar["price"], CurrentLevel.solar["productionRate"], CurrentLevel.solar["emissionRate"])

func _on_solar_mouse_exited():
	$PopupPanel.visible = false

func _on_wind_mouse_entered():
	update_popup(CurrentLevel.wind["name"], CurrentLevel.wind["price"], CurrentLevel.wind["productionRate"], CurrentLevel.wind["emissionRate"])

func _on_wind_mouse_exited():
	$PopupPanel.visible = false

func _on_water_mouse_entered():
	update_popup(CurrentLevel.water["name"], CurrentLevel.water["price"], CurrentLevel.water["productionRate"], CurrentLevel.water["emissionRate"])

func _on_water_mouse_exited():
	$PopupPanel.visible = false

func _on_bio_mouse_entered():
	update_popup(CurrentLevel.bio["name"], CurrentLevel.bio["price"], CurrentLevel.bio["productionRate"], CurrentLevel.bio["emissionRate"])

func _on_bio_mouse_exited():
	$PopupPanel.visible = false

func _on_nuclear_mouse_entered():
	update_popup(CurrentLevel.nuclear["name"], CurrentLevel.nuclear["price"], CurrentLevel.nuclear["productionRate"], CurrentLevel.nuclear["emissionRate"])

func _on_nuclear_mouse_exited():
	$PopupPanel.visible = false

func update_popup(name, price, productionRate, emission):
	$PopupPanel.visible = true
	$PopupPanel.position.x = get_viewport().get_mouse_position().x
	$PopupPanel.position.y = get_viewport().get_mouse_position().y - 300
	$PopupPanel/VBoxContainer/Name.text = name
	$PopupPanel/VBoxContainer/Price.text = str(price)
	$PopupPanel/VBoxContainer/Production.text = str(productionRate)
	$PopupPanel/VBoxContainer/Emission.text = str(emission)

func select_building(building):
	building_selected=building
	emit_signal("place_building", building_selected)
	$CartButton.visible = true
	$BuildingPanelContainer.visible = false

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/LevelSelect.tscn")

func _on_next_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Level2.tscn")

func _on_resume_button_pressed_paused():
	$PausePopup.visible = false

func _on_options_button_pressed_paused():
	get_tree().change_scene_to_file("res://Scenes/Screens/options.tscn")

func _on_exit_pressed_paused():
	get_tree().change_scene_to_file("res://Scenes/Screens/LevelSelect.tscn")
