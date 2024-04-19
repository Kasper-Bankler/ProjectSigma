extends Control

var player_completed_level_1 = false


@onready var level_container=$ScrollContainer/HBoxContainer/LEVELCONTAINER
@onready var levels_container=$ScrollContainer/HBoxContainer
@onready var seperator=$ScrollContainer/HBoxContainer/sep



func _ready():
	UserData.player_progress_fetched.connect(_on_progress_set)
	UserData.get_player_progress(UserData.logged_in_username)
	
	print(UserData.num_of_levels)




func _on_progress_set():
	$Label.text="YOU HAVE COMPLETED "+str(UserData.player_progress)+" LEVELS"
	for n in range(UserData.player_progress+1):
		
		var this_level=levels_container.get_child(n*2)
		var weather_container=this_level.get_child(0)
		
		print(CurrentLevel.LEVELS_STATS[n+1]["sun"])
		print(floor(CurrentLevel.LEVELS_STATS[n+1]["sun"]*2))
		print("***********")
		print(CurrentLevel.LEVELS_STATS[n+1]["wind"])
		print(floor(CurrentLevel.LEVELS_STATS[n+1]["wind"]*2))
		print("***********")
		weather_container.get_child(0).get_child(floor(CurrentLevel.LEVELS_STATS[n+1]["sun"]*2)).visible=true
		weather_container.get_child(1).get_child(floor(CurrentLevel.LEVELS_STATS[n+1]["wind"]*2)).visible=true
		this_level.get_child(2).get_child(0).queue_free()
		this_level.get_child(2).disabled=false
		this_level.get_child(2).set_text("Play")

func _on_back_pressed():
	MusicController.closeSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")



func go_to_level(level):
	MusicController.confirmationSound()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level"+str(level)+".tscn")
