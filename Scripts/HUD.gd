extends CanvasLayer

signal place_building(building)
var building_selected = ""

func _process(delta):
	update_balance()


func update_balance():
	$CoinLabel.text = str(CurrentLevel.balance)
	
func update_energy(value):
	$EnergyProgressBar.value = value



func update_weather(sun, wind):
	if sun>0.5:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol1/Sun.visible = true
	elif sun<0.5:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol1/CloudSun.visible = true
	else:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol1/Cloud.visible = true
	
	if wind>0.5:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol2/Tornado.visible = true
	elif wind<0.5:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol2/Wind.visible = true
	else:
		pass


func _on_pause_button_pressed():
	$PausePopup.visible = true
	#get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")


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

func _on_coal_mouse_entered():
	update_popup("coal", "12", "10", "8")

func _on_coal_mouse_exited():
	$PopupPanel.visible = false

func _on_solar_mouse_entered():
	update_popup("solar", "12", "10", "8")

func _on_solar_mouse_exited():
	$PopupPanel.visible = false

func _on_wind_mouse_entered():
	update_popup("wind", "12", "10", "8")

func _on_wind_mouse_exited():
	$PopupPanel.visible = false

func _on_water_mouse_entered():
	update_popup("water", "12", "10", "8")

func _on_water_mouse_exited():
	$PopupPanel.visible = false

func _on_bio_mouse_entered():
	update_popup("bio", "12", "10", "8")

func _on_bio_mouse_exited():
	$PopupPanel.visible = false

func update_popup(name, price, productionRate, emission):
	$PopupPanel.visible = true
	$PopupPanel.position.x = get_viewport().get_mouse_position().x
	$PopupPanel.position.y = get_viewport().get_mouse_position().y - 300
	$PopupPanel/VBoxContainer/Name.text = name
	$PopupPanel/VBoxContainer/Price.text = price
	$PopupPanel/VBoxContainer/Production.text = productionRate
	$PopupPanel/VBoxContainer/Emission.text = emission

func select_building(building):
	building_selected=building
	emit_signal("place_building", building_selected)


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
	
