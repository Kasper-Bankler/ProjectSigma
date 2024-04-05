extends Node2D

var wind = preload("res://Scenes/Buildings/windturbine.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouseLocation = get_global_mouse_position()

	if (Input.is_action_just_pressed("ui_accept")):
		var tileLocation=(Vector2(UserData.tile_posiiton.x,UserData.tile_posiiton.y))
		var building=wind.instantiate()
		$".".add_child(building)
		print(UserData.tile_posiiton)
		print(tileLocation.x*130, ",", tileLocation.y*64)
		
		building.position.x=tileLocation.x
		building.position.y=tileLocation.y
