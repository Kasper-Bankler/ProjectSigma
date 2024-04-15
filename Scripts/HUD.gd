extends CanvasLayer

var building_selected = false

func update_score(value):
	$CoinLabel.text = str(value)
	
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
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")


func _on_cart_button_pressed():
	$CartButton.visible = false
	$BuildingPanelContainer.visible = true


func _on_close_button_pressed():
	$CartButton.visible = true
	$BuildingPanelContainer.visible = false

func _on_coal_pressed():
	select_building("res://Scenes/Buildings/coalpowerplant.tscn")

func _on_solar_pressed():
	pass

func _on_wind_pressed():
	pass # Replace with function body.

func _on_water_pressed():
	pass # Replace with function body.

func _on_bio_pressed():
	pass # Replace with function body.

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

func select_building(scene: String):
	if not building_selected:
		var preloaded_scene = load(scene)
		var instance = preloaded_scene.instantiate()
		get_parent().add_child(instance)
		building_selected = true
