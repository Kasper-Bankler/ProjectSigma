extends CanvasLayer

signal place_building
var building_selected = ""

@onready var level=get_parent()

func _ready():
	CurrentLevel.is_playing = true
	update_weather(CurrentLevel.currentLevel["sun"], CurrentLevel.currentLevel["wind"])
	level.level_is_complete.connect(level_complete)
func _process(_delta):
	update_balance()
	update_energy()
	updata_buy_menu()
	



func level_complete():
	var totalScore = (level.energy + CurrentLevel.balance) - level.emission
	
	
	$LevelCompletePopup/CenterContainer/VBoxContainer/Score.text = str(totalScore)
	$LevelCompletePopup/CenterContainer/VBoxContainer/Energy.text = str(CurrentLevel.energy_generated)
	$LevelCompletePopup/CenterContainer/VBoxContainer/CO2.text = str(CurrentLevel.co2_emitted)
	CurrentLevel.is_playing = false
	$LevelCompletePopup.visible = true
	$EnergyProgressBar.visible = false
	$CoinLabel.visible = false
	$WeatherPanelContainer.visible = false
	$PausePopup.visible = false
	$CartButton.visible = false
	$PauseButton.visible = false
	UserData.submit_score(str(level.scene_file_path[25]),totalScore)
	

func update_balance():
	$CoinLabel.text = str(level.balance)
	
func update_energy():
	$EnergyProgressBar.value = level.energy

func updata_buy_menu():
	var balance = CurrentLevel.balance
	
	for building in $BuildingPanelContainer/BuildingPanel/HBoxContainer.get_children():
		if balance<BuildingData.BUILDINGS_STATS[building.name.to_lower()]["price"]:
			building.disabled=true
		else:
			building.disabled=false
	

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
	CurrentLevel.is_playing = false
	MusicController.clickSound()
	$PausePopup.visible = true
	$PauseButton.visible = false
	$CartButton.visible = false
	$BuildingPanelContainer.visible = false

func _on_cart_button_pressed():
	MusicController.clickSound()
	$CartButton.visible = false
	$BuildingPanelContainer.visible = true

func _on_close_button_pressed():
	MusicController.clickSound()
	$CartButton.visible = true
	$BuildingPanelContainer.visible = false


func on_building_hover(building_name):
	update_popup(BuildingData.BUILDINGS_STATS[building_name]["name"], BuildingData.BUILDINGS_STATS[building_name]["price"], BuildingData.BUILDINGS_STATS[building_name]["productionRate"], BuildingData.BUILDINGS_STATS[building_name]["emissionRate"])


func on_building_hover_exit():
	$PopupPanel.visible = false


func update_popup(_name, price, productionRate, emission):
	$PopupPanel.visible = true
	$PopupPanel.position.x = get_viewport().get_mouse_position().x
	$PopupPanel.position.y = get_viewport().get_mouse_position().y - 300
	$PopupPanel/VBoxContainer/Name.text = _name
	$PopupPanel/VBoxContainer/Price.text = str(price)
	$PopupPanel/VBoxContainer/Production.text = str(productionRate)
	$PopupPanel/VBoxContainer/Emission.text = str(emission)

func select_building(building):
	building_selected=building
	emit_signal("place_building", building_selected)
	$CartButton.visible = true
	$BuildingPanelContainer.visible = false

func _on_exit_button_pressed():
	MusicController.clickSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/LevelSelect.tscn")

func _on_next_button_pressed():
	MusicController.clickSound()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level2.tscn")

func _on_resume_button_pressed_paused():
	CurrentLevel.is_playing = true
	$PauseButton.visible = true
	MusicController.clickSound()
	$PausePopup.visible = false
	$CartButton.visible = true

func _on_options_button_pressed_paused():
	MusicController.clickSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/options.tscn")

func _on_exit_pressed_paused():
	MusicController.closeSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/LevelSelect.tscn")
