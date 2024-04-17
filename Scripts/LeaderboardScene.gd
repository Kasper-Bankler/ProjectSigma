extends Control


# Declare member variables here. Examples:
@onready var level_container=$HScrollBar/HBoxContainer/Level1
@onready var username_row=$HScrollBar/HBoxContainer/Level1/HBoxContainer/Username/usernameLabel
@onready var first_username_container=$HScrollBar/HBoxContainer/Level1/HBoxContainer/Username
@onready var first_score_container=$HScrollBar/HBoxContainer/Level1/HBoxContainer/Score

@onready var score_row=$HScrollBar/HBoxContainer/Level1/HBoxContainer/Score/scoreLabel


var username_container
var score_container
var level_fetched=0
var fetched_levels=[]

# Called when the node enters the scene tree for the first time.
func _ready():
	UserData.get_level_scores(1)
	pass

func _process(delta):
	if UserData.is_requesting:

		return
	
	if (level_fetched>=UserData.num_of_levels):

		return
	if (level_fetched>len(UserData.level_scores)):
		return
	
	
	level_fetched+=1
	print("doing"+str(level_fetched))
	create_new_level_container()
	populate_leaderboard_level(level_fetched)
	

func create_new_level_container():
	var new_level_container=$HScrollBar/HBoxContainer/Level1.duplicate()
	new_level_container.get_child(0).text="LEVEL"+str(level_fetched+1)
	$HScrollBar/HBoxContainer.add_child(new_level_container)
	
func populate_leaderboard_level(level):
	var level_container=$HScrollBar/HBoxContainer.get_child(level-1)
	var username_container=level_container.get_child(1).get_child(0)
	var score_container=level_container.get_child(1).get_child(1)
	
	print("POPULATIONG LEVEL"+str(level))
	
	
	for row in UserData.level_scores[str(level)]:

		var new_user_row=username_row.duplicate()
		var new_score_row=score_row.duplicate()
		new_user_row.text=str(row["username"])
		new_score_row.text=str(row["value"])
		
		username_container.add_child(new_user_row)
		score_container.add_child(new_score_row)

	UserData.get_level_scores(level_fetched+1)
	
			

		

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")


func _on_button_pressed():
	print(UserData.level_scores)
