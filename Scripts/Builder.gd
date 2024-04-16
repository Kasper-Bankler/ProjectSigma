extends Node2D

var selected_building = ""
var building: PackedScene
var occupied_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected_building != "":
		if selected_building == "coal":
			building = preload("res://Scenes/Buildings/coalpowerplant.tscn")
		elif  selected_building == "wind":
			building = preload("res://Scenes/Buildings/windturbine.tscn")
		elif selected_building == "solar":
			building = preload("res://Scenes/Buildings/solarpanel.tscn")
		elif selected_building == "water":
			building = preload("res://Scenes/Buildings/waterturbine.tscn")
		elif selected_building == "bio": 
			building = preload("res://Scenes/Buildings/gaspowerplant.tscn")
		
		var mouseLocation = get_global_mouse_position()
		var tileLocation=(Vector2(UserData.tile_posiiton.x,UserData.tile_posiiton.y))

		if (Input.is_action_just_pressed("ui_leftclick") and not occupied_tiles.has(tileLocation)):
			occupied_tiles.append(tileLocation)
			var building_scene = building.instantiate()
			$".".add_child(building_scene)
			building_scene.position.x=(tileLocation.x*130+65*(fmod(tileLocation.y,2)+1))
			building_scene.position.y=(tileLocation.y+1)*32
			selected_building = ""


func _on_hud_place_building(building):
	selected_building = building
