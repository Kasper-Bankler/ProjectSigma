extends Control

var player_completed_level_1 = false


@onready var level_container=$ScrollContainer/HBoxContainer/LEVELCONTAINER
@onready var levels_container=$ScrollContainer/HBoxContainer
@onready var seperator=$ScrollContainer/HBoxContainer/sep
func _ready():
	UserData.player_progress_fetched.connect(_on_progress_set)
	UserData.get_player_progress(UserData.logged_in_username)
	for n in range(2,UserData.num_of_levels+1):
		print("creating level "+str(n))
		var new_level_container=level_container.duplicate()
		#new_level_container.get_child(1).pressed.connect(go_to_level)
		levels_container.add_child(seperator.duplicate())
		levels_container.add_child(new_level_container)
	print("getting user progress for "+UserData.logged_in_username)
	


func go_to_level(level):
	get_tree().change_scene_to_file("res://Scenes/Levels/Level"+str(level)+".tscn")

func _on_progress_set():
	$Label.text="YOU HAVE COMPLETED "+str(UserData.player_progress)+" LEVELS"


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")


func _on_button_pressed(level):
	print(level)
	#get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")
