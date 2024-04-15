extends Control

func _on_play_pressed():
	UserData.test_db(1)
	get_tree().change_scene_to_file("res://Scenes/Screens/LevelSelect.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Options.tscn")


func _on_quit_pressed():
	get_tree().quit()
	

func _on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/Leaderboard.tscn")
