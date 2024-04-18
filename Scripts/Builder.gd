extends Node2D

var selected_building = ""
var building: PackedScene
var occupied_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print($"../HUD")
	$"../HUD".place_building.connect(_on_hud_place_building)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if selected_building != "":
		if selected_building == "coal":
			building = preload("res://Scenes/Buildings/coalpowerplant.tscn")
			update_preview("Coal")
		elif  selected_building == "wind":
			building = preload("res://Scenes/Buildings/windturbine.tscn")
			update_preview("Wind")
		elif selected_building == "solar":
			building = preload("res://Scenes/Buildings/solarpanel.tscn")
			update_preview("Solar")
		elif selected_building == "water":
			building = preload("res://Scenes/Buildings/waterturbine.tscn")
			update_preview("Water")
		elif selected_building == "bio": 
			building = preload("res://Scenes/Buildings/gaspowerplant.tscn")
			update_preview("Bio")
		elif selected_building == "nuclear": 
			building = preload("res://Scenes/Buildings/nuclearpowerplant.tscn")
			update_preview("Nuclear")
		
		var mouseLocation = get_global_mouse_position()
		var tileLocation=(Vector2(CurrentLevel.tile_posiiton.x,CurrentLevel.tile_posiiton.y))

		if (Input.is_action_just_pressed("ui_leftclick") and not occupied_tiles.has(tileLocation)):
			occupied_tiles.append(tileLocation)
			var building_scene = building.instantiate()
			$".".add_child(building_scene)
			building_scene.position.x=(tileLocation.x*130+65*(fmod(tileLocation.y,2)+1))
			building_scene.position.y=(tileLocation.y+1)*32
			selected_building = ""
			$Water.visible = false
			$Wind.visible = false
			$Solar.visible = false
			$Bio.visible = false
			$Coal.visible = false
			$Nuclear.visible = false

func update_preview(name):
	$".".get_node(name).visible = true
	$".".get_node(name).position.x = get_viewport().get_mouse_position().x
	$".".get_node(name).position.y = get_viewport().get_mouse_position().y

func _on_hud_place_building(building):
	selected_building = building
