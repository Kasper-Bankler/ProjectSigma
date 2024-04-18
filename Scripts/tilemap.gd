extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var old_tile=Vector2i(0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CurrentLevel.is_playing:
		# Get hover tile name
		var mouse_pos = get_viewport().get_mouse_position()
		var tile_pos = local_to_map(mouse_pos)
		var tile_data = get_cell_tile_data(0, tile_pos)
		if tile_data is TileData:
			CurrentLevel.tile_hover_type = tile_data.get_custom_data("Name")

		var tile=local_to_map(get_global_mouse_position())
		CurrentLevel.tile_posiiton=tile
		erase_cell(1,old_tile)
		# Draw select tile
		if CurrentLevel.tile_hover_type == "ground":
			set_cell(1,tile,25,Vector2i(0,0),0)
			old_tile=tile
