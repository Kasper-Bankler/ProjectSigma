extends Control


# Declare member variables here. Examples:



# Called when the node enters the scene tree for the first time.
func _ready():
	UserData.get_level_scores(1)






func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")


func _on_button_pressed():
	print(UserData.level_scores)
