extends Control


# Declare member variables here. Examples:
@onready var level_container=$ScrollContainer/HBoxContainer/Level1
@onready var username_row=$ScrollContainer/HBoxContainer/Level1/HBoxContainer/Username/usernameLabel
@onready var first_username_container=$ScrollContainer/HBoxContainer/Level1/HBoxContainer/Username
@onready var first_score_container=$ScrollContainer/HBoxContainer/Level1/HBoxContainer/Score

@onready var score_row=$ScrollContainer/HBoxContainer/Level1/HBoxContainer/Score/scoreLabel


var username_container
var score_container
var level_fetched=0
var fetched_levels=[]

# Called when the node enters the scene tree for the first time.
func _ready():

	UserData.get_level_scores(1)
	UserData.level_scores_fetched.connect(on_level_scores_fetched)

	

func on_level_scores_fetched():
	print(UserData.level_scores)
	#skjul Loading besked
	$Label2.hide()
	for n in range(1,UserData.num_of_levels+1):
		
		create_new_level_container(n)
		populate_leaderboard_level(n)
		
	#fjern den første level template og dens seperator
	$ScrollContainer/HBoxContainer.get_child(0).queue_free()
	$ScrollContainer/HBoxContainer.get_child(1).queue_free()
	

func create_new_level_container(level):
	#kopier level template
	var new_level_container=$ScrollContainer/HBoxContainer/Level1.duplicate()
	
	#sætter det rigtige level nummer
	new_level_container.get_child(0).text="LEVEL "+str(level)
	
	#tilføjer level til levels containeren
	$ScrollContainer/HBoxContainer.add_child(new_level_container)
	
	#seperator mellem levels for bedre adskilning af levels
	$ScrollContainer/HBoxContainer.add_child($ScrollContainer/HBoxContainer/split.duplicate())
	
func populate_leaderboard_level(level):
	#find den rigtige level container frem
	var level_container=$ScrollContainer/HBoxContainer.get_child(level*2)
	
	#find de rigtige containers frem
	var username_container=level_container.get_child(2).get_child(0)
	var score_container=level_container.get_child(2).get_child(2)
	
	#hvis der ikk er noget data så skriv no Data og returner
	if level>len(UserData.level_scores):
		var noDataLabel=username_row.duplicate()
		noDataLabel.text="No Data"
		level_container.get_child(2).queue_free()
		level_container.add_child(noDataLabel)
		return
	
	
	#populer rækkerne ind i levels containeren med data fra DB
	for row in UserData.level_scores[str(level)]:

		var new_user_row=username_row.duplicate()
		var new_score_row=score_row.duplicate()
		new_user_row.text=str(row["username"])
		new_score_row.text=str(row["value"])
		
		username_container.add_child(new_user_row)
		score_container.add_child(new_score_row)

	
			

		

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")



