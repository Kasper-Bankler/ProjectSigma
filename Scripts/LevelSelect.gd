extends Control

@onready var level_image=$ScrollContainer/HBoxContainer/LEVELCONTAINER/ColorRect/Sprite2D
@onready var levels_container=$ScrollContainer/HBoxContainer


func _ready():
	UserData.player_progress_fetched.connect(_on_progress_set)
	UserData.get_player_progress(UserData.logged_in_username)

func _on_progress_set():
	$Label.text="Du har fuldført "+str(UserData.player_progress)+" levels!"
	for n in range(UserData.player_progress+1):
		var this_level=levels_container.get_child(n*2)
		var weather_container=this_level.get_child(0)
		var new_level_image=level_image.duplicate()
		new_level_image.texture=load("res://Assets/levelScreenshots/level"+str(n+1)+".png")
	
		weather_container.get_child(0).get_child(floor(CurrentLevel.LEVELS_STATS[n+1]["sun"]*2)).visible=true
		weather_container.get_child(1).get_child(floor(CurrentLevel.LEVELS_STATS[n+1]["wind"]*2)).visible=true
		this_level.get_child(1).add_child(new_level_image)
		this_level.get_child(2).get_child(0).queue_free()
		this_level.get_child(2).disabled=false

		this_level.get_child(2).set_text("Spil")

func _on_back_pressed():
	MusicController.closeSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")

func go_to_level(level):
	MusicController.confirmationSound()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level"+str(level)+".tscn")
