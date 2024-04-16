extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var old_tile=Vector2i(0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile=local_to_map(get_global_mouse_position())

	CurrentLevel.tile_posiiton=tile
	
	erase_cell(1,old_tile)
	
	
	set_cell(1,tile,25,Vector2i(0,0),0)
	old_tile=tile



