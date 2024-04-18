extends Control

var player_completed_level_1 = false


@onready var level_container=$ScrollContainer/HBoxContainer/LEVELCONTAINER
@onready var levels_container=$ScrollContainer/HBoxContainer
@onready var seperator=$ScrollContainer/HBoxContainer/sep



func _ready():
	UserData.player_progress_fetched.connect(_on_progress_set)
	UserData.get_player_progress(UserData.logged_in_username)




func _on_progress_set():
	$Label.text="YOU HAVE COMPLETED "+str(UserData.player_progress)+" LEVELS"
	for n in range(UserData.player_progress):
		print(n)
		print(n*2)
		var this_level=levels_container.get_child(n*2)
		this_level.get_child(1).get_child(0).queue_free()
		this_level.get_child(1).disabled=false
		this_level.get_child(1).set_text("Play")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")



func go_to_level(level):
	get_tree().change_scene_to_file("res://Scenes/Levels/Level"+str(level)+".tscn")


func _on_level_1_pressed():
	go_to_level(1)


func _on_level_2_pressed():
	go_to_level(2)


func _on_level_3_pressed():
	go_to_level(3) # Replace with function body.
