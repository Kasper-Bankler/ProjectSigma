extends CanvasLayer

func update_score(value):
	$CoinLabel.text = str(value)
	
func update_energy(value):
	$EnergyProgressBar.value = value

func update_weather(sun, wind):
	if sun>0.5:
		$WeatherPanel/Sun.visible = true
	elif sun<0.5:
		$WeatherPanel/CloudSun.visible = true
	else:
		$WeatherPanel/Cloud.visible = true
	
	if wind>0.5:
		$WeatherPanel/Tornado.visible = true
	elif wind<0.5:
		$WeatherPanel/Wind.visible = true
	else:
		pass


func _on_pause_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")
