extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile=local_to_map(get_global_mouse_position())

	UserData.tile_posiiton=tile
	for i in 20:
		for o in 20:
			erase_cell(1,Vector2(i,o))
	
	
	set_cell(1,tile,25,Vector2i(0,0),0)



