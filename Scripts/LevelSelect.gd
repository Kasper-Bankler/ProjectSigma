extends Control

var player_completed_level_1 = false

func _ready():
	# Load player progress from save file or elsewhere
	# For now, let's assume player has not completed level 1
	# You would replace this with your actual logic to determine if level 1 is completed
	player_completed_level_1 = false

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")

func _on_level_2_pressed():
	if player_completed_level_1:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level2.tscn")
	else:
		# Display message or take appropriate action to inform the player
		print("You need to complete Level 1 first.")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")
