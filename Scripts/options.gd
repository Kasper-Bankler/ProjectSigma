extends Control


func _on_back_button_pressed():
	MusicController.closeSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")
