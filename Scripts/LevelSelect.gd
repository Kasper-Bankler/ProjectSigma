extends Control

@onready var level_image=$ScrollContainer/HBoxContainer/LEVELCONTAINER/ColorRect/Sprite2D
@onready var levels_container=$ScrollContainer/HBoxContainer

var seen_fact = false

func _ready():
	UserData.player_progress_fetched.connect(_on_progress_set)
	UserData.get_player_progress(UserData.logged_in_username)

func _on_progress_set():
	$Label.text="Du har fuldført "+str(UserData.player_progress)+" levels!"
	
	var this_level=levels_container.get_child(0)
	var weather_container=this_level.get_child(0)
	var new_level_image=level_image.duplicate()
	new_level_image.texture=load("res://Assets/levelScreenshots/level"+str(1)+".png")

	weather_container.get_child(0).get_child(ceil(CurrentLevel.LEVELS_STATS[1]["sun"]*2)).visible=true
	weather_container.get_child(1).get_child(ceil(CurrentLevel.LEVELS_STATS[1]["wind"]*2)).visible=true
	this_level.get_child(1).add_child(new_level_image)
	this_level.get_child(2).get_child(0).queue_free()
	this_level.get_child(2).disabled=false

	this_level.get_child(2).set_text("Spil level 1")
	
	for n in range(2,min(UserData.player_progress+2,7)):
		this_level=levels_container.get_child((n-1)*2)
		weather_container=this_level.get_child(0)
		new_level_image=level_image.duplicate()
		new_level_image.texture=load("res://Assets/levelScreenshots/level"+str(n)+".png")
	
		weather_container.get_child(0).get_child(ceil(CurrentLevel.LEVELS_STATS[n]["sun"]*2)).visible=true
		weather_container.get_child(1).get_child(ceil(CurrentLevel.LEVELS_STATS[n]["wind"]*2)).visible=true
		this_level.get_child(1).add_child(new_level_image)
		this_level.get_child(2).get_child(0).queue_free()
		this_level.get_child(2).disabled=false

		this_level.get_child(2).set_text("Spil level "+str(n))

func _on_back_pressed():
	MusicController.closeSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")

func go_to_level(level):
	if !seen_fact:
		fact_box()
		return
	MusicController.confirmationSound()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level"+str(level)+".tscn")

func fact_box():
	seen_fact=true
	
	if (UserData.player_progress>4):
		return
	$CenterContainer/VBoxContainer/ColorRect/HBoxContainer/CenterContainer.get_child(UserData.player_progress).visible=true
	$CenterContainer.visible=true
	$CenterContainer/VBoxContainer/ColorRect/HBoxContainer/VBoxContainer/RichTextLabel.text=CurrentLevel.FAKTABOKS[str(UserData.player_progress)]


func _on_button_pressed():
	$CenterContainer.visible=false
	
