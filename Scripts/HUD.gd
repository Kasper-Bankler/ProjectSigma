extends CanvasLayer

signal place_building
var building_selected = ""
@onready var medal1 = $LevelCompletePopup/CenterContainer/VBoxContainer/HBoxContainer/Medal1
@onready var medal2 = $LevelCompletePopup/CenterContainer/VBoxContainer/HBoxContainer/Medal2
@onready var medal3 = $LevelCompletePopup/CenterContainer/VBoxContainer/HBoxContainer/Medal3
@onready var level=get_parent()

func _ready():
	# Sætter spillet igang
	CurrentLevel.is_playing = true
	# Signal til at fortælle at levelet er klaret
	level.level_is_complete.connect(level_complete)
func _process(_delta):
	# Opdatere balance, energy og buy menu
	update_balance()
	update_energy()
	update_buy_menu()
	# Opdatere vejret
	update_weather(CurrentLevel.currentLevel["sun"], CurrentLevel.currentLevel["wind"])

func level_complete():
	var totalScore = min((level.energy + CurrentLevel.balance) - level.emission*0.1,0)
	if (totalScore <= 100):
		medal1.visible = true
	elif (totalScore >= 500 and totalScore <= 1000):
		medal2.visible = true
	elif (totalScore >= 1000):
		medal3.visible = true
	$LevelCompletePopup/CenterContainer/VBoxContainer/Score.text = str(totalScore)
	$LevelCompletePopup/CenterContainer/VBoxContainer/Energy.text = str(level.energy)
	$LevelCompletePopup/CenterContainer/VBoxContainer/CO2.text = str(level.emission)
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
	$CoinLabel.text = str(round(level.balance))
	
func update_energy():
	$EnergyProgressBar.value = level.energy/(level.energy_required+1)*100
	
func update_buy_menu():
	# Deaktivere knapper til bygninger man ikke har råd til
	var balance = level.balance
	for building in $BuildingPanelContainer/BuildingPanel/HBoxContainer.get_children():
		if balance<BuildingData.BUILDINGS_STATS[building.name.to_lower()]["price"]:
			building.disabled=true
		else:
			building.disabled=false
	

func update_weather(sun, wind):
	# Opdatere vejrikoner dynamisk
	if sun<=0.1:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol1/Cloud.visible = true
	elif sun<=0.5:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol1/CloudSun.visible = true
	elif sun>=0.5:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol1/Sun.visible = true
	
	if wind<=0.1:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol2/NoWind.visible = true
	elif wind<=0.5:
		$WeatherPanelContainer/WeatherPanel/VBoxContainer/WeatherSymbol2/Wind.visible = true
	elif wind>=0.5:
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
	# Sender signal til builder noden
	building_selected=building
	emit_signal("place_building", building_selected)
	$CartButton.visible = true
	$BuildingPanelContainer.visible = false

func _on_exit_button_pressed():
	MusicController.clickSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/LevelSelect.tscn")

func _on_next_button_pressed():
	MusicController.clickSound()
	var current_level = CurrentLevel.currentLevel["level"]
	var next_level_scene = "res://Scenes/Levels/Level" + str(current_level+1) +".tscn"
	get_tree().change_scene_to_file(next_level_scene)

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
